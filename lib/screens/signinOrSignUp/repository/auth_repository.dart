import 'dart:io';
import 'package:app1/screens/chats/chats_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/common_firebase.dart';
import '../../../models/user_model.dart';
import '../../../utils/utils.dart';
import '../otp_screen.dart';
import '../user_info.dart';


//user this in global
final authRepositoryProvider = Provider((ref) => AuthRepository(
  auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance));

class AuthRepository{
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepository({
    required this.auth,
    required this.firestore
    });


void signInWithPhone(String phoneNumber, BuildContext context) async{

try{

await auth.verifyPhoneNumber(
  phoneNumber: phoneNumber,
  verificationCompleted: (PhoneAuthCredential credential) async{
    print("compliting");
    await auth.signInWithCredential(credential); //after verifying OTP
    print("complited");
  },
 verificationFailed: (e){
  
 showSnackBar(context: context, content: "Phone verification failed");
 throw Exception(e.message);

 },
  codeSent: ((String verificationId, int? resendToken){
   Navigator.push(context, MaterialPageRoute(builder: ((context) => OTPScreen(verificationID: verificationId))));
  }),
   codeAutoRetrievalTimeout: (String verificationID){}   
   );


}on FirebaseAuthException catch(e){
  showSnackBar(context: context, content: e.message!);
}


}

void verifyOTP({
  required BuildContext context,
  required String verificationID,
  required String userOTP
}) async{

try{
  PhoneAuthCredential credential = PhoneAuthProvider.credential(
    verificationId: verificationID, smsCode: userOTP);
    await auth.signInWithCredential(credential);
    
    Navigator.push(context, MaterialPageRoute(builder: ((context) => UserInfoScreen())));



} on FirebaseAuthException catch(e){
  showSnackBar(context: context, content: e.message!);
}




}

void saveUserDataToFirebase({
  required String name,
  required File? proPic,
  required ProviderRef ref,
  required BuildContext context,
}) async{

try{

String uid = auth.currentUser!.uid;
String photoUrl  = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTUpxlLh1NQUktvRqkFruY7FTUCvYvlid3ptQ&usqp=CAU';

if(proPic != null){
photoUrl = await  ref.read(commonFirabaseStorageProvider).storeFileToFirebase('profilePic/$uid', proPic);
}

var user = User_Model(
uid: uid,
name: name,
proPic: photoUrl,
isOnline: true,
phoneNumber: auth.currentUser!.phoneNumber!,
groupIds: []);

await firestore.collection("users").doc(uid).set(user.toMap());

Navigator.pushAndRemoveUntil(context,
 MaterialPageRoute(builder: (context)
  =>  ChatsScreen()), (route) => false);

}
catch (e) {
showSnackBar(context: context, content: "err"+ e.toString());
}


}




Future<User_Model?> getCurrentUserData() async{


auth
  .authStateChanges()
  .listen((User? user) {
    if (user == null) {
      print('User is currently signed out!');
      
    } else {
      print('User is signed in!');
    }
  });

var userData  = await firestore.collection('users').doc(auth.currentUser!.uid)
.get();

User_Model? userModel;


if(userData.data() != null){
  print("data="+userData.data().toString());
  userModel = User_Model.fromMap(userData.data()!);
}

return userModel;

}


Future<bool> getCurrentUserStatus() async{


auth
  .authStateChanges()
  .listen((User? user) {
    if (user == null) {
      print('User is currently signed out!');

      
    } else {
      print('User is signed in!');
    }
  });

var userData  = await firestore.collection('users').doc(auth.currentUser!.uid)
.get();

bool isSigned = false;


if(userData.data() != null){
 isSigned = true;
}

return isSigned;

}





Stream<DocumentSnapshot> userDataByID(String userID) {
  
 /* print(userID);
return firestore.collection("users").doc(userID).snapshots()
.map((event){

  print("data ======= "+ event.data().toString());
  return User_Model.fromMap(event.data()!);
  
});  */

print(userID.replaceAll(' ', ''));

var userData  =  firestore.collection('users').doc(userID.replaceAll(' ', ''))
.snapshots();
userData.map((event){
  print(event.data());
});

return userData;
}

Future<User_Model> userStaticDataByID(String userID) {


return firestore.collection('users').doc(userID.replaceAll(' ', ''))
.get().then((value){
 return User_Model.fromMap(value.data()!);
});

}




Stream<User_Model> getUserDataByID_2(String userID){
var userData =  firestore.collection("users").doc(userID.replaceAll(' ', '')).snapshots();
  
return userData.map((event){

return User_Model.fromMap(event.data()!);
  
}); 
}

void setUserState(bool isOnline) async{

await firestore.collection('users')
.doc(auth.currentUser!.uid)
.update(
  {
'isOnline':isOnline
  }
);

}






  
}

