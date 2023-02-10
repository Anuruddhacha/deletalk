import 'package:app1/features/chat/chat_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/chat_contact.dart';
import '../../models/chat_room.dart';
import '../../models/message.dart';
import '../../models/user_model.dart';
import '../../screens/signinOrSignUp/controller/auth_controller.dart';

final chatControllerProvider = Provider((ref){
final chatRepository = ref.watch(chatRepoProvider);


return ChatController(
  chatRepository: chatRepository,
   ref: ref);

});

class ChatController{

  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({required this.chatRepository, required this.ref});

  void sendTextMessage(
    {
required BuildContext context,
required String text,
required String receiverUserID,
}
  ){
ref.watch(userdataAuthProider).whenData((value){

  chatRepository.sendTextMessage(context: context,
  text: text,
  receiverUserID: receiverUserID,
  senderUSer: value!);
}
 );
    
  }


   Stream<List<ChatContact>> getChatContacts(){
    return chatRepository.getChatContacts();
  }


  Stream<List<Message>> chatStream(String receiverUserId){
    return chatRepository.getChatStream(receiverUserId);
  }

  Stream<List<User_Model>> getActiveUsers(){
    return chatRepository.getActiveUsers();
  }

  Stream<List<User_Model>> getAllUsers(){
    return chatRepository.getAllUsers();
  }

  void setChatMessageSeen(
    BuildContext context,
    String recieverUserId,
    String messageId,
  ) {
    chatRepository.setChatMessageSeen(
      context,
      recieverUserId,
      messageId,
    );
  }


  Future<bool> isFriends(String uid){
   return chatRepository.isFriends(uid);
  }


  void createChatRoom(String receiverId,DateTime deleteDate,BuildContext context,bool delete) {
    chatRepository.createChatRoom(receiverId, deleteDate, context,delete);
  }

  void initChatRooms(){
    chatRepository.initChatRooms();
  }


   void deleteChatRoom(String receiverUserID,bool everyone,BuildContext context){
    chatRepository.deleteChatRoom(receiverUserID,everyone,context);
  }


  Stream<ChatRoom> getChatRoom(String receiverId){
    return chatRepository.getChatRoom(receiverId);
  }

  void setPhoneHide(String receiverId,BuildContext context) async {
    chatRepository.setPhoneHide(receiverId, context);
  }

  void setPhoneShow(String receiverId,BuildContext context) async {
    chatRepository.setPhoneShow(receiverId, context);
  }


  void hideFromUser(String userId,BuildContext context) async{
    chatRepository.hideFromUser(userId, context);
  }


  void unhideFromUser(String userId,BuildContext context) async{
    chatRepository.unhideFromUser(userId, context);
  }



}