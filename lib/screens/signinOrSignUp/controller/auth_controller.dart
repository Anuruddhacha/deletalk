
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/user_model.dart';
import '../repository/auth_repository.dart';

final Provider<AuthController> authControlerProvider = Provider((ref){
  
  final authRepository = ref.watch(authRepositoryProvider);

  return AuthController(
    authRepository:authRepository,
    ref: ref);
});

final userdataAuthProider = FutureProvider((ref){
  final authController = ref.watch(authControlerProvider);
 return authController.getUserData();
}
);


final userStatusProider = FutureProvider((ref){
  final authController = ref.watch(authControlerProvider);
 return authController.getCurrentUserStatus();
}
);

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;

  AuthController({required this.ref, required this.authRepository});
 
 void signInWithPhone(String phoneNumber, BuildContext context){
  authRepository.signInWithPhone(phoneNumber, context);
 }

  
 void verifyOTP(String verificationID, BuildContext context, String userOTP){
  authRepository.verifyOTP(context: context, verificationID: verificationID, userOTP: userOTP);
 }


void saveUserDataToFirebase(BuildContext context, String name, File? proPic){
  authRepository.saveUserDataToFirebase(
    name: name,
    proPic: proPic,
    ref: ref,
    context: context);
}

Future<User_Model?> getUserData() async{
  print("sssssssssssssssssssssssssssss");
User_Model? user = await authRepository.getCurrentUserData();
print("ddddddddddddddddddd");
return user;
}

Future<bool> getCurrentUserStatus() async{
  print("sssssssssssssssssssssssssssss");
bool isSigned = await authRepository.getCurrentUserStatus();
print("ddddddddddddddddddd");
return isSigned;
}

Stream<User_Model> userDataByID(String userID){
return authRepository.getUserDataByID_2(userID);
}




void setUserState(bool isOnline) {
  authRepository.setUserState(isOnline);
}

Future<User_Model> userStaticDataByID(String userID) {
  return authRepository.userStaticDataByID(userID);
}


Future<User_Model?> getLoggedInUserInfo() {
  return authRepository.getLoggedInUserInfo();
}





}