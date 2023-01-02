import 'package:app1/features/chat/chat_controller.dart';
import 'package:app1/models/chat_contact.dart';
import 'package:app1/screens/active/active_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../components/filled_outline_button.dart';
import '../../constants.dart';
import '../../models/Chat.dart';
import '../../widgets/loader.dart';
import '../chats/components/chat_card.dart';
import '../messages/message_screen.dart';

class Chats extends ConsumerStatefulWidget {
  const Chats({super.key});

  @override
  ConsumerState<Chats> createState() => _ChatsState();
}

class _ChatsState extends ConsumerState<Chats> {
  @override
  Widget build(BuildContext context) {
     return Column(
      children: [
       /* Container(
          padding: EdgeInsets.fromLTRB(
              kDefaultPadding, 0, kDefaultPadding, kDefaultPadding),
          color: kPrimaryColor,
          child: Row(
            children: [
              FillOutlinedButton(press: () {}, text: "Recent Message"),
              SizedBox(width: kDefaultPadding),
              FillOutlinedButton(
                press: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ActiveUsers()));
                },
                text: "Active",
                isFilled: false,
              ),
            ],
          ),
        ), */
        StreamBuilder<List<ChatContact>>(
          stream: ref.read(chatControllerProvider).getChatContacts(),
          builder: (context, snapshot) {

            if(snapshot.connectionState == ConnectionState.waiting){
            return Loader();
            }

           List<ChatContact> chatList = snapshot.data!;


            return Expanded(
              child: ListView.builder(
                itemCount: chatList.length,
                itemBuilder: (context, index) => ChatCard(
                  chat: chatList[index],
                  press: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MessagesScreen(
                        uid: chatList[index].contactID,
                        name: chatList[index].name,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        ),
      ],
    );
  }
}