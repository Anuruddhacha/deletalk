import 'package:app1/constants.dart';
import 'package:app1/models/ChatMessage.dart';
import 'package:app1/models/message.dart';
import 'package:app1/models/user_model.dart';
import 'package:app1/screens/messages/components/message.dart';
import 'package:app1/widgets/loader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/chat/chat_controller.dart';
import '../../signinOrSignUp/controller/auth_controller.dart';
import 'chat_input_field.dart';


class Body extends ConsumerStatefulWidget {
  final String uid;

  const Body({super.key, required this.uid});

  @override
  ConsumerState<Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<Body> {

  String? profilePic;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

_getUserData() async{
User_Model user = await ref.read(authControlerProvider).userStaticDataByID(widget.uid);
profilePic = user.proPic;
}


  @override
  Widget build(BuildContext context) {


   



    return StreamBuilder<List<Message>>(
      stream: ref.read(chatControllerProvider).chatStream(widget.uid),
      builder: (context, snapshot) {

        if(snapshot.connectionState == ConnectionState.waiting){
          return const Loader();
        }

        List<Message> messages = snapshot.data!;

        return Column(
          children: [
            Expanded(
              child:  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    child: ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) =>
                          MessageCard(message: messages[index],profilePic: profilePic!,),
                    ),
                  )
            ),
            ChatInputField(receiverUserID: widget.uid,),
          ],
        );


      }
    );
  }
}
