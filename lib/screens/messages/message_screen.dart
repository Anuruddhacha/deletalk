import 'package:app1/constants.dart';
import 'package:app1/models/user_model.dart';
import 'package:app1/screens/signinOrSignUp/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      title: StreamBuilder<User_Model>(
        stream: ref.read(authControlerProvider).userDataByID(widget.uid),
        builder: (context, snapshot) {

         

          if(snapshot.connectionState == ConnectionState.waiting){
            return const Loader();
            }

          User_Model user = snapshot.data!;
          return Row(
            children: [
              BackButton(),
              CircleAvatar(
                backgroundImage: NetworkImage(user.proPic),
              ),
              SizedBox(width: kDefaultPadding * 0.75),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    user.isOnline ? 'online' : 'offline',
                    style: TextStyle(fontSize: 12),
                  )
                ],
              )
            ],
          );


        }
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.local_phone),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.videocam),
          onPressed: () {},
        ),
        SizedBox(width: kDefaultPadding / 2),
      ],
    );
  }
}
