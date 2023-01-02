import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../common/message_enum.dart';
import '../../models/chat_contact.dart';
import '../../models/message.dart';
import '../../models/user_model.dart';
import '../../utils/utils.dart';

final chatRepoProvider = Provider((ref) => ChatRepository(
  firebaseFirestore: FirebaseFirestore.instance,
  auth: FirebaseAuth.instance
));

class ChatRepository{

  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth auth;

  ChatRepository({required this.firebaseFirestore, required this.auth});



Stream<List<ChatContact>> getChatContacts(){

  

return firebaseFirestore
       .collection("users")
       .doc(auth.currentUser!.uid)
       .collection("chats")
       .snapshots().asyncMap((event) async{
       
       
        List<ChatContact> contacts = [];
         print(auth.currentUser!.uid);

        for(var document in event.docs){
           print(document.data());
          var chat_contact = ChatContact.fromMap(document.data());
           
          var userData = await firebaseFirestore
          .collection("users")
          .doc(chat_contact.contactID.replaceAll(' ', ''))
          .get();

          var user = User_Model.fromMap(userData.data()!);
        

          contacts.add(
            ChatContact(name: user.name,
             profilePic: user.proPic,
              contactID: chat_contact.contactID,
               timeSent: chat_contact.timeSent,
                lastMessage: chat_contact.lastMessage));

                
        }
         
        return contacts;
        
       });

}


void sendTextMessage({
required BuildContext context,
required String text,
required String receiverUserID,
required User_Model senderUSer,
}) async{


try{ 
var timeSent = DateTime.now();
User_Model receiverUserData;

var userDataMap = await firebaseFirestore.collection("users").doc(receiverUserID).get();
receiverUserData = User_Model.fromMap(userDataMap.data()!);

_saveDataToContactSubCollection(
  senderUserData: senderUSer,
  receiverUserData: receiverUserData,
  text: text,
  timeSent: DateTime.now(),
   receiverUserID: receiverUserID
);
var messageId = const Uuid().v4();

_saveDataToMessageSubCollection(
  receiverUserID: receiverUserID,
  text: text,
  timeSent: timeSent,
  type: MessageEnum.text,
  messageId: messageId,
  receiverUsername: receiverUserData.name,
  username: senderUSer.name
);

}
catch(e){
showSnackBar(context: context, content: "err=="+e.toString());
}


}

void _saveDataToContactSubCollection(
    {required User_Model senderUserData,
    required User_Model receiverUserData,
    required String text,
    required DateTime timeSent,
    required String receiverUserID}
  ) async{

    
  var receiverChatContact = ChatContact(
    name: senderUserData.name,
   profilePic: senderUserData.proPic,
    contactID: senderUserData.uid,
     timeSent: timeSent,
      lastMessage: text
      );

      await firebaseFirestore.collection("users").doc(receiverUserID).collection("chats")
      .doc(auth.currentUser!.uid).set(
        receiverChatContact.toMap()
      );


       var senderChatContact = ChatContact(
    name: receiverUserData.name,
   profilePic: receiverUserData.proPic,
    contactID: receiverUserData.uid,
     timeSent: timeSent,
      lastMessage: text
      );

      await firebaseFirestore.collection("users").doc(auth.currentUser!.uid).collection("chats")
      .doc(receiverUserID).set(
        senderChatContact.toMap()
      );



  }
  
  void _saveDataToMessageSubCollection(
    {
      required String receiverUserID,
      required String text,
      required DateTime timeSent,
      required String messageId,
      required String username,
      required String receiverUsername,
      required MessageEnum type
    }
  ) async{

final message = Message(
  senderId: auth.currentUser!.uid,
   receiverId: receiverUserID,
    text: text,
     type: type,
      timeSent: timeSent,
       messageId: messageId,
        isSeen: false);

  await firebaseFirestore.collection("users").
  doc(auth.currentUser!.uid).collection("chats")
  .doc(receiverUserID).collection("messages")
  .doc(messageId).set(
    message.toMap()
  );



  await firebaseFirestore.collection("users").
  doc(receiverUserID).collection("chats")
  .doc(auth.currentUser!.uid).collection("messages")
  .doc(messageId).set(
    message.toMap()
  );

  }




  Stream<List<Message>> getChatStream(
  String receiverUserId
){
 
return firebaseFirestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId.replaceAll(' ', ''))
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .map((event){

         List<Message> messages = [];
        
         for(var document in event.docs){

        messages.add(Message.fromMap(document.data()));
                  
         }

         return messages;
        });




}



Stream<List<User_Model>> getActiveUsers(){



return firebaseFirestore
       .collection("users")
        .where("online", isEqualTo: true)
       .snapshots().asyncMap((event) async{
       
       
        List<User_Model> users = [];

        for(var document in event.docs){
          
          var user = User_Model.fromMap(document.data());
           
        

          users.add(user);

                
        }
         
        return users;
        
       });

}






}