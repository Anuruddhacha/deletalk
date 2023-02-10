import 'package:app1/models/chat_room.dart';
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





Stream<List<ChatContact>> getChatContacts() {


    
 

  

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

          if(!chat_contact.isHide){

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
                lastMessage: chat_contact.lastMessage,
                isHide: false,
                hideByMe: chat_contact.hideByMe));

          }
          
           
            
        }
         
        return contacts;
        
       });

}





Future<void> deleteChat(String uid1,String uid2) {
    return firebaseFirestore.collection("users").
                  doc(uid1).collection("chats")
                  .doc(uid2).get().then((value){
                  print(value.data());
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
      lastMessage: text,
      isHide: false,
      hideByMe: false
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
      lastMessage: text,
      isHide: false,
      hideByMe: false
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


Stream<List<User_Model>> getAllUsers(){



return firebaseFirestore
       .collection("users")
       .snapshots().asyncMap((event) async{
       
       
        List<User_Model> users = [];

        for(var document in event.docs){
          
          var user = User_Model.fromMap(document.data());
           
        

          users.add(user);

                
        }
         
        return users;
        
       });

}


void setChatMessageSeen(
    BuildContext context,
    String recieverUserId,
    String messageId,
  ) async {
    try {
      await firebaseFirestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(recieverUserId)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});

      await firebaseFirestore
          .collection('users')
          .doc(recieverUserId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }




  Future<bool> isFriends(String uid) async{

    bool isFound = false;

 await firebaseFirestore.collection("users")
  .doc(auth.currentUser!.uid).collection("chats")
  .get().then((value){
   value.docs.forEach((element) {
    if(element.id == uid){
      isFound = true;
    }
   });
  });

return isFound;

  }


  void createChatRoom(String receiverId,DateTime deleteDate,BuildContext context,bool delete) async{




    ChatRoom chatRoom = ChatRoom(createrId: auth.currentUser!.uid,
     receiverId: receiverId,
      timeCreated: deleteDate,
      delete: delete,
      hidePhone: false
      );
  

   try {
      await firebaseFirestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chat_rooms')
          .doc(receiverId)
          .set(chatRoom.toMap());

      await firebaseFirestore
          .collection('users')
          .doc(receiverId)
          .collection('chat_rooms')
          .doc(auth.currentUser!.uid)
          .set(chatRoom.toMap());
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
    


  }
  
  void initChatRooms() async{

  


    try {
      await firebaseFirestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chat_rooms')
          .get()
          .then((value){

              value.docs.forEach((element)  async{

                ChatRoom chatRoom = ChatRoom.fromMap(element.data());
                 
                 if(chatRoom.timeCreated.millisecondsSinceEpoch <= DateTime.now().millisecondsSinceEpoch
                    && chatRoom.delete){
                    
                    //delete chat and messages
                   await firebaseFirestore
                  .collection('users')
                  .doc(auth.currentUser!.uid)
                  .collection('chats')
                  .doc(chatRoom.receiverId)
                  .delete();

                   await firebaseFirestore
                  .collection('users')
                  .doc(auth.currentUser!.uid)
                  .collection('chats')
                  .doc(chatRoom.receiverId)
                  .collection("messages")
                  .get()
                  .then((value){
                     value.docs.forEach((element) {
                      element.reference.delete();
                     });
                  });
          
                  


                  await firebaseFirestore
                  .collection('users')
                  .doc(chatRoom.receiverId)
                  .collection('chats')
                  .doc(auth.currentUser!.uid)
                  .delete();


                  await firebaseFirestore
                  .collection('users')
                  .doc(chatRoom.receiverId)
                  .collection('chats')
                  .doc(auth.currentUser!.uid)
                  .collection("messages")
                  .get()
                  .then((value){
                     value.docs.forEach((element) {
                      element.reference.delete();
                     });
                  });

                  //deleting chat room
                  await firebaseFirestore
                  .collection('users')
                  .doc(chatRoom.receiverId)
                  .collection('chat_rooms')
                  .doc(auth.currentUser!.uid)
                  .delete();


                  await firebaseFirestore
                  .collection('users')
                  .doc(auth.currentUser!.uid)
                  .collection('chat_rooms')
                  .doc(chatRoom.receiverId)
                  .delete();

                   
                 }


              });
            
          });

    
    } catch (e) {
      print(e.toString());
    }



  }




Future<void> deleteChatRoom(String receiverId,bool everyone,BuildContext context) async {
  try{

         if(everyone){
     //delete chat and messages
                   await firebaseFirestore
                  .collection('users')
                  .doc(auth.currentUser!.uid)
                  .collection('chats')
                  .doc(receiverId)
                  .delete();

                   await firebaseFirestore
                  .collection('users')
                  .doc(auth.currentUser!.uid)
                  .collection('chats')
                  .doc(receiverId)
                  .collection("messages")
                  .get()
                  .then((value){
                     value.docs.forEach((element) {
                      element.reference.delete();
                     });
                  });
          
                  


                  await firebaseFirestore
                  .collection('users')
                  .doc(receiverId)
                  .collection('chats')
                  .doc(auth.currentUser!.uid)
                  .delete();


                  await firebaseFirestore
                  .collection('users')
                  .doc(receiverId)
                  .collection('chats')
                  .doc(auth.currentUser!.uid)
                  .collection("messages")
                  .get()
                  .then((value){
                     value.docs.forEach((element) {
                      element.reference.delete();
                     });
                  });

                  //deleting chat room
                  await firebaseFirestore
                  .collection('users')
                  .doc(receiverId)
                  .collection('chat_rooms')
                  .doc(auth.currentUser!.uid)
                  .delete();


                  await firebaseFirestore
                  .collection('users')
                  .doc(auth.currentUser!.uid)
                  .collection('chat_rooms')
                  .doc(receiverId)
                  .delete();
         }else{


          //delete chat and messages
                   await firebaseFirestore
                  .collection('users')
                  .doc(auth.currentUser!.uid)
                  .collection('chats')
                  .doc(receiverId)
                  .delete();

                   await firebaseFirestore
                  .collection('users')
                  .doc(auth.currentUser!.uid)
                  .collection('chats')
                  .doc(receiverId)
                  .collection("messages")
                  .get()
                  .then((value){
                     value.docs.forEach((element) {
                      element.reference.delete();
                     });
                  });
          
                  



         }

  }
  catch(e){
   showSnackBar(context: context, content: "Something went wrong");
  }



}



Stream<ChatRoom> getChatRoom(String receiverId){

var chatRoomData =  firebaseFirestore.collection("users").doc(receiverId).collection("chat_rooms")
.doc(auth.currentUser!.uid).snapshots();
  
return chatRoomData.map((event){

return ChatRoom.fromMap(event.data()!);
  
}); 

}



void setPhoneHide(String receiverId,BuildContext context) async {

try {
      await firebaseFirestore.collection("users").doc(auth.currentUser!.uid).collection("chat_rooms")
           .doc(receiverId)
          .update({'hidePhone': true});


      await firebaseFirestore.collection("users").doc(receiverId).collection("chat_rooms")
           .doc(auth.currentUser!.uid)
          .update({'hidePhone': true});

    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }

}


void setPhoneShow(String receiverId,BuildContext context) async {

try {
      await firebaseFirestore.collection("users").doc(auth.currentUser!.uid).collection("chat_rooms")
           .doc(receiverId)
          .update({'hidePhone': false});


      await firebaseFirestore.collection("users").doc(receiverId).collection("chat_rooms")
           .doc(auth.currentUser!.uid)
          .update({'hidePhone': false});

    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }

}


void hideFromUser(String userId,BuildContext context) async{

try {
      
      await firebaseFirestore.collection("users").doc(userId).collection("chats")
      .doc(auth.currentUser!.uid).update({
         "isHide":true,
         "hideByMe":false
      });

      await firebaseFirestore.collection("users").doc(auth.currentUser!.uid).collection("chats")
      .doc(userId).update({
         "isHide":false,
         "hideByMe":true
      });

    } catch (e) {
      showSnackBar(context: context, content: "Something went wrong");
    }

}


void unhideFromUser(String userId,BuildContext context) async{

try {
      
      await firebaseFirestore.collection("users").doc(userId).collection("chats")
      .doc(auth.currentUser!.uid).update({
         "isHide":false,
         "hideByMe":false
      });

      await firebaseFirestore.collection("users").doc(auth.currentUser!.uid).collection("chats")
      .doc(userId).update({
         "isHide":false,
         "hideByMe":false
      });

    } catch (e) {
      showSnackBar(context: context, content: "Something went wrong");
    }

}




}