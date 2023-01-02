import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants.dart';
import '../../../features/chat/chat_controller.dart';

class ChatInputField extends ConsumerStatefulWidget {
  
 final String receiverUserID;

  const ChatInputField({
    required this.receiverUserID
  });

  @override
  ConsumerState<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends ConsumerState<ChatInputField> {

  bool isShowSendButton = true;
  final TextEditingController _messageController = TextEditingController();
  FocusNode focusNode = FocusNode();

void sendTextMEssage() async{
  if(isShowSendButton){

ref.read(chatControllerProvider).sendTextMessage(
  context: context,
  text: _messageController.text.trim(),
  receiverUserID: widget.receiverUserID);

_messageController.clear();
}else{
  
}


}

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kDefaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 32,
            color: Color(0xFF087949).withOpacity(0.08),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Icon(Icons.mic, color: kPrimaryColor),
            SizedBox(width: kDefaultPadding),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: kDefaultPadding * 0.75,
                ),
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.sentiment_satisfied_alt_outlined,
                      color: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .color!
                          .withOpacity(0.64),
                    ),
                    const SizedBox(width: kDefaultPadding / 4),
                     Expanded(
                      child: TextField(
                        focusNode: focusNode,
                        controller: _messageController,
                        style:const  TextStyle(color: Colors.white),
                        decoration:const InputDecoration(
                          hintText: "Type message",
                          hintStyle: TextStyle(color: Colors.white),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.attach_file,
                      color: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .color!
                          .withOpacity(0.64),
                    ),
                    SizedBox(width: kDefaultPadding / 4),
                    Icon(
                      Icons.camera_alt_outlined,
                      color: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .color!
                          .withOpacity(0.64),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 5),
            IconButton(onPressed: (){
              sendTextMEssage();
            }, icon: const Icon(Icons.send,color: Colors.green,))
            
          ],
        ),
      ),
    );
  }
}
