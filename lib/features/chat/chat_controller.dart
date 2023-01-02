import 'package:app1/features/chat/chat_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/chat_contact.dart';
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



}