import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/utils.dart';
import 'controller/auth_controller.dart';

class UserInfoScreen extends ConsumerStatefulWidget {
  const UserInfoScreen({Key? key}) : super(key: key);

   static const routeName = 'user-info';

  @override
  ConsumerState<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends ConsumerState<UserInfoScreen> {

  final TextEditingController nameController = TextEditingController();
  File? image;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
    body: SafeArea(
      child: Center(
        child: Column(
          children: [

              Stack(
                children: [
                 image == null ? const CircleAvatar(
                  backgroundImage:  NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTUpxlLh1NQUktvRqkFruY7FTUCvYvlid3ptQ&usqp=CAU"),
                  radius: 64,):
                  CircleAvatar(
                  backgroundImage:  FileImage(image!),
                  radius: 64,),

                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                    onPressed: (){
                       selectImage();
                     }, icon: Icon(Icons.add_a_photo,color: Colors.white,)),
                  )
                ],
              ),

              Row(
                children: [
                Container(
                  width: size.width * 0.85,
                  padding: EdgeInsets.all(20),
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    controller: nameController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your name',
                      hintStyle: TextStyle(color: Colors.white)
                    ),
                  ),
                ),

                IconButton(
                  onPressed: (){
                    storeUSerData();
                }, icon: Icon(Icons.done,
                color: Colors.white,))


                ],
              )

          ],
        ),
      ),
    ),
    );
  }

  void selectImage() async{
 image = await pickImageFromGallery(context);
 setState(() {
   
 });
  }

  void storeUSerData() async{

    String name = nameController.text.trim();

    if(name.isNotEmpty){
      
      ref.read(authControlerProvider).saveUserDataToFirebase(context, name, image);
    }
    

  }
}