import 'package:app1/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/filled_outline_button.dart';
import '../../constants.dart';
import '../../features/chat/chat_controller.dart';
import '../../models/chat_contact.dart';
import '../../widgets/loader.dart';
import '../chats/components/chat_card.dart';
import '../messages/message_screen.dart';

class ActiveUsers extends ConsumerStatefulWidget {
  const ActiveUsers({super.key});

  @override
  ConsumerState<ActiveUsers> createState() => _ActiveUsersState();
}

class _ActiveUsersState extends ConsumerState<ActiveUsers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(
              kDefaultPadding, 0, kDefaultPadding, kDefaultPadding),
          color: kPrimaryColor,
          child: Row(
            children: [
              FillOutlinedButton(press: () {}, text: "Recent Message"),
              SizedBox(width: kDefaultPadding),
              FillOutlinedButton(
                press: () {},
                text: "Active",
                isFilled: false,
              ),
            ],
          ),
        ),
        StreamBuilder<List<User_Model>>(
          stream: ref.read(chatControllerProvider).getActiveUsers(),
          builder: (context, snapshot) {

            if(snapshot.connectionState == ConnectionState.waiting){
            return Loader();
            }

           List<User_Model> userList = snapshot.data!;


            return ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index){
                User_Model user = userList[index];

                return ListTile(
                  title: Text(user.name,style: const TextStyle(color: Colors.white),),
                );
              },
            );
          }
        ),
      ],
    ),
    );
  }
}