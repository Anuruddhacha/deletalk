import 'package:app1/constants.dart';
import 'package:app1/features/chat/chat_controller.dart';
import 'package:app1/models/chat_room.dart';
import 'package:app1/models/user_model.dart';
import 'package:app1/screens/chats/chats_screen.dart';
import 'package:app1/screens/signinOrSignUp/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../../widgets/loader.dart';
import 'components/body.dart';

class MessagesScreen extends ConsumerStatefulWidget {

  final String name;
  final String uid;


   MessagesScreen({required this.name,required this.uid});

  @override
  ConsumerState<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends ConsumerState<MessagesScreen> {

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Body(uid: widget.uid,),
      backgroundColor: kContentColorLightTheme,
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      title: StreamBuilder<User_Model>(
        stream: ref.read(authControlerProvider).userDataByID(widget.uid),
        builder: (context, snapshot) {

         

          if(snapshot.connectionState == ConnectionState.waiting){
            return const Loader();
            }

          User_Model user = snapshot.data!;
          return Row(
            children: [
              const BackButton(),
              CircleAvatar(
                backgroundImage: NetworkImage(user.proPic),
              ),
             const SizedBox(width: kDefaultPadding * 0.75),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                    Text(
                    widget.name,
                    style:const TextStyle(fontSize: 16),
                  ),
                 const Text(
                    "  ",
                    style: TextStyle(fontSize: 16),
                  ),
                  StreamBuilder<ChatRoom>(
                    stream: ref.read(chatControllerProvider).getChatRoom(widget.uid),
                    builder: (context, snapshot) {

                      if(snapshot.connectionState == ConnectionState.waiting){
                                 return const Loader();
                                 }

                      return  snapshot.data!.hidePhone ? const Text(
                        "",
                        style: TextStyle(fontSize: 16),
                      ) : Text(
                        user.phoneNumber,
                        style:const TextStyle(fontSize: 16),
                      );
                    }
                  )
                  ],),
                  Text(
                    user.isOnline ? 'online'.tr : 'offline'.tr,
                    style:const TextStyle(fontSize: 12),
                  )
                ],
              )
            ],
          );


        }
      ),
      actions: [

        PopupMenuButton(
          color: kContentColorLightTheme,
          itemBuilder: (context){
            return [
                  PopupMenuItem<int>(
                      value: 0,
                      child: Text("delete_chat_me".tr,style:const TextStyle(color: Colors.white),),
                  ),
                   PopupMenuItem<int>(
                      value: 1,
                      child: Text("delete_chat_everyone".tr,style:const TextStyle(color: Colors.white),),
                  ),

                  PopupMenuItem<int>(
                      value: 2,
                      child: Text("hide_phone".tr,style:const TextStyle(color: Colors.white),),
                  ),

                  PopupMenuItem<int>(
                      value: 3,
                      child: Text("show_phone".tr,style:const TextStyle(color: Colors.white),),
                  ),

                  PopupMenuItem<int>(
                      value: 4,
                      child: Text("hide_me".tr,style:const TextStyle(color: Colors.white),),
                  ),

                  PopupMenuItem<int>(
                      value: 5,
                      child: Text("unhide_me".tr,style:const TextStyle(color: Colors.white),),
                  ),
              ];
          },
          onSelected:(value){
            if(value == 0){
                _showAlertDialogForMe();
            }else if(value == 1){
                _showAlertDialogForEveryone();
            }else if(value == 2){
                _hidePhone();
            }
            else if(value == 3){
                _showPhoneNumber();
            }
            else if(value == 4){
                _hideMe();
            }
            else if(value == 5){
                _unhideMe();
            }
          }
        ),

       
        
       const SizedBox(width: kDefaultPadding / 2),
      ],
    );
  }


  Future<void> _showAlertDialogForMe() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: kContentColorLightTheme, 
        title:  Text('delete_chat_me'.tr,style:const TextStyle(color: Colors.white),),
        content: SingleChildScrollView(
          child: ListBody(
            children:  <Widget>[
              Text('delete_confirm'.tr,style:const TextStyle(color: Colors.white),),
            ],
          ),
        ),
        actions: <Widget>[
         !_isLoading ?  TextButton(
            child:  Text('no'.tr,style:const TextStyle(color: Colors.green),),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ):const SizedBox.shrink(),
          !_isLoading ? TextButton(
            child:  Text('yes'.tr,style:const TextStyle(color: Colors.green),),
            onPressed: () {
              _deleteChat();
           
            },
          ):const SizedBox.shrink(),
         _isLoading ?const CircularProgressIndicator(color: kPrimaryColor,) :const SizedBox.shrink()
        ],
      );
    },
  );
}

Future<void> _showAlertDialogForEveryone() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: kContentColorLightTheme, 
        title:  Text('delete_chat_everyone'.tr,style:const TextStyle(color: Colors.white),),
        content: SingleChildScrollView(
          child: ListBody(
            children:  <Widget>[
              Text('delete_confirm'.tr,style:const TextStyle(color: Colors.white),),
            ],
          ),
        ),
        actions: <Widget>[
         !_isLoading ?  TextButton(
            child:  Text('no'.tr,style:const TextStyle(color: Colors.green),),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ):const SizedBox.shrink(),
          !_isLoading ? TextButton(
            child:  Text('yes'.tr,style:const TextStyle(color: Colors.green),),
            onPressed: () {
              _deleteChatEveryone();
           
            },
          ):const SizedBox.shrink(),
         _isLoading ?const CircularProgressIndicator(color: kPrimaryColor,) :const SizedBox.shrink()
        ],
      );
    },
  );
}

  void _deleteChat() {
    setState(() {
      _isLoading = true;
    });
    ref.read(chatControllerProvider).deleteChatRoom(widget.uid,false,context);
    Navigator.push(context, MaterialPageRoute(builder: ((context) => ChatsScreen())));
  }
  
  void _hidePhone() {
   ref.read(chatControllerProvider).setPhoneHide(widget.uid,context);
}
  
  void _showPhoneNumber() {
    ref.read(chatControllerProvider).setPhoneShow(widget.uid,context);
  }
  
  void _deleteChatEveryone() {
    setState(() {
      _isLoading = true;
    });
    ref.read(chatControllerProvider).deleteChatRoom(widget.uid,true,context);
    Navigator.push(context, MaterialPageRoute(builder: ((context) => ChatsScreen())));
  }
  
  void _hideMe() {
  setState(() {
      _isLoading = true;
    });
    ref.read(chatControllerProvider).hideFromUser(widget.uid,context);
    Navigator.push(context, MaterialPageRoute(builder: ((context) => ChatsScreen())));

  }
  
  void _unhideMe() {
    setState(() {
      _isLoading = true;
    });
    ref.read(chatControllerProvider).unhideFromUser(widget.uid,context);
    Navigator.push(context, MaterialPageRoute(builder: ((context) => ChatsScreen())));
  }






}
