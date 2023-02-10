import 'package:app1/common/message_enum.dart';
import 'package:app1/models/ChatMessage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../constants.dart';
import '../../../models/message.dart';
import '../../../models/user_model.dart';
import '../../../widgets/loader.dart';
import '../../signinOrSignUp/controller/auth_controller.dart';
import 'audio_message.dart';
import 'text_message.dart';
import 'video_message.dart';

class MessageCard extends ConsumerWidget {
  const MessageCard({
    Key? key,
    required this.message,
    required this.uid
  }) : super(key: key);

  final Message message;
  final String uid;

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    Widget messageContaint(Message message) {
      switch (message.type) {
        case MessageEnum.text:
          return TextMessage(message: message);
        case MessageEnum.audio:
          return AudioMessage(message: message);
        case MessageEnum.video:
          return VideoMessage();
        default:
          return const SizedBox();
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: kDefaultPadding),
      child: Row(
        mainAxisAlignment:
            message.senderId == FirebaseAuth.instance.currentUser!.uid ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!(message.senderId == FirebaseAuth.instance.currentUser!.uid)) ...[
            StreamBuilder<User_Model>(
        stream: ref.read(authControlerProvider).userDataByID(uid),
        builder: (context, snapshot) {

         

          if(snapshot.connectionState == ConnectionState.waiting){
            return const Loader();
            }

          User_Model user = snapshot.data!;
          return CircleAvatar(
                backgroundImage: NetworkImage(user.proPic),
                radius: 20,
              );


        }
      ),
           const SizedBox(width: kDefaultPadding / 2),
          ],
          messageContaint(message),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
             const SizedBox(height: 20),
            if(message.senderId == FirebaseAuth.instance.currentUser!.uid)
           (message.isSeen) ? const Icon(Icons.done_all,color: Colors.blue,size: 20,) : const Icon(Icons.done,color: Colors.grey,size: 20,)
            ],
          ),
          
        ],
      ),
    );
  }
}

class MessageStatusDot extends StatelessWidget {
  final MessageStatus? status;

  const MessageStatusDot({Key? key, this.status}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Color dotColor(MessageStatus status) {
      switch (status) {
        case MessageStatus.not_sent:
          return kErrorColor;
        case MessageStatus.not_view:
          return Theme.of(context).textTheme.bodyText1!.color!.withOpacity(0.1);
        case MessageStatus.viewed:
          return kPrimaryColor;
        default:
          return Colors.transparent;
      }
    }

    return Container(
      margin:const EdgeInsets.only(left: kDefaultPadding / 2),
      height: 12,
      width: 12,
      decoration: BoxDecoration(
        color: dotColor(status!),
        shape: BoxShape.circle,
      ),
      child: Icon(
        status == MessageStatus.not_sent ? Icons.close : Icons.done,
        size: 8,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }
}
