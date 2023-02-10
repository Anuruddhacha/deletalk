import 'package:app1/constants.dart';
import 'package:app1/screens/init_chat/init_chat.dart';
import 'package:app1/screens/messages/message_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../../features/chat/chat_controller.dart';
import '../../models/user_model.dart';
import '../../widgets/loader.dart';

class People extends ConsumerStatefulWidget {
  const People({super.key});

  @override
  ConsumerState<People> createState() => _PeopleState();
}

class _PeopleState extends ConsumerState<People> {





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<User_Model>>(
          stream: ref.read(chatControllerProvider).getAllUsers(),
          builder: (context, snapshot) {

            if(snapshot.connectionState == ConnectionState.waiting){
            return const Loader();
            }

           List<User_Model> userList = snapshot.data!;


            return ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index){

              
                User_Model user = userList[index];

                if(user.uid == FirebaseAuth.instance.currentUser!.uid){
                  return const SizedBox.shrink();
                }

                return ListTile(
                  leading: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(user.proPic),
                  ),
                  title: Text(user.name,style: const TextStyle(color: Colors.white),),
                  trailing: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: kPrimaryColor,
                      ),
                      child:GestureDetector(
                        onTap: () async{
                              
                            bool isFriend = await ref.read(chatControllerProvider).isFriends(user.uid);
                            if(isFriend){
                              Navigator.push(context, MaterialPageRoute(builder: ((context) => MessagesScreen(uid: user.uid,name: user.name,))));
                            }else{
                              Navigator.push(context, MaterialPageRoute(builder: ((context) => InitChatScreen(uid: user.uid,name: user.name,))));
                            }

                        },
                        child:  Center(
                          child: Text("connect".tr,style:const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        ),
    );
  }
  
  
}