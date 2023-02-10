import 'dart:io';
import 'package:app1/models/user_model.dart';
import 'package:app1/screens/signinOrSignUp/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/utils.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  ConsumerState<Profile> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {

  final TextEditingController nameController = TextEditingController();
  File? image;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

User_Model? user_model;

@override
  void initState() {
    _initUserData();
    super.initState();
    
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
                 user_model == null ? const CircleAvatar(
                  backgroundImage:  NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTUpxlLh1NQUktvRqkFruY7FTUCvYvlid3ptQ&usqp=CAU"),
                  radius: 64,):
                  CircleAvatar(
                  backgroundImage:  NetworkImage(user_model!.proPic),
                  radius: 64,),

                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                    onPressed: (){
                       selectImage();
                     }, icon:const Icon(Icons.add_a_photo,color: Colors.white,)),
                  ),

                   

                  
                ],
              ),


              Row(
                children: [
                Container(
                  width: size.width * 0.85,
                  padding:const EdgeInsets.all(20),
                  child: TextField(
                    
                    style:const TextStyle(color: Colors.white),
                    controller: nameController,
                    decoration: const InputDecoration(
                      hintStyle: TextStyle(color: Colors.white)
                    ),
                  ),
                ),

                IconButton(
                  onPressed: (){
                    storeUSerData();
                }, icon:const Icon(Icons.done,
                color: Colors.white,))


                ],
              )

           

          ],
        ),
      ),
    ),
    );
  }
  
  Future<void> _initUserData() async{
    user_model = await ref.read(authControlerProvider).getLoggedInUserInfo();
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