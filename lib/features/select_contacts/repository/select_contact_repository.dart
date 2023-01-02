import 'package:app1/screens/messages/message_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/user_model.dart';
import '../../../utils/utils.dart';

final selectContactRepositoryProvider = Provider(
  (ref) => SelectContactRepository(
    firebaseFirestore: FirebaseFirestore.instance
    ),
);




class SelectContactRepository{
  final FirebaseFirestore firebaseFirestore;

  SelectContactRepository({required this.firebaseFirestore});


Future<List<Contact>> getContacts() async{

  List<Contact> contacts = [];

try{
  if(await FlutterContacts.requestPermission()){
   contacts = await FlutterContacts.getContacts(withProperties: true);
  }

} catch(e){
  print(e.toString());

}

return contacts;

}



void selectContact(Contact selectedContact, BuildContext context) async{

try{
var userCollection = await firebaseFirestore.collection("users").get();
bool isFound = false;

for(var doc in userCollection.docs){
  var userData = User_Model.fromMap(doc.data());
  print(userData.phoneNumber);
  
  String selectedPhoneNumber = selectedContact.phones[0].number.replaceAll(' ', '');
   print("no country code"+selectedPhoneNumber);
  if(selectedPhoneNumber == userData.phoneNumber){
    print("uid selected  "+userData.uid);
    isFound  =true;
       Navigator.push(context, MaterialPageRoute(builder: ((context) => MessagesScreen(
        name: userData.name,
         uid: userData.uid))));

  }

}

if(!isFound){
  showSnackBar(context: context, content: 'This number does not exist on this app');
}


} catch(e){
showSnackBar(context: context, content: e.toString());
}




}

}