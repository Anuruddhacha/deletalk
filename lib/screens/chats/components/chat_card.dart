import 'package:app1/models/Chat.dart';
import 'package:app1/models/chat_contact.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({
    Key? key,
    required this.chat,
    required this.press,
  }) : super(key: key);

  final ChatContact chat;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Padding(
        padding: const EdgeInsets.symmetric(
        horizontal: kDefaultPadding, vertical: kDefaultPadding * 0.75),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(chat.profilePic),
                ),
               
                  
              ],
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chat.name,
                      style:
                         const TextStyle(fontSize: 16, fontWeight: FontWeight.w500,color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Opacity(
                      opacity: 0.64,
                      child: Text(
                        chat.lastMessage,
                        maxLines: 1,
                        style: const TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Opacity(
              opacity: 0.64,
              child: Text(DateFormat.MMMMEEEEd().format(chat.timeSent),style: const TextStyle(color: Colors.white),),
            ),

            chat.hideByMe ? const Padding(
              padding:  EdgeInsets.all(8.0),
              child:  Icon(Icons.hide_source_sharp,color: Colors.green,),
            ) : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
