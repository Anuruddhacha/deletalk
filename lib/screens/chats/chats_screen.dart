import 'package:app1/constants.dart';
import 'package:app1/features/select_contacts/screen/select_contacts_screen.dart';
import 'package:app1/models/user_model.dart';
import 'package:app1/screens/tabs/chat.dart';
import 'package:app1/screens/tabs/people.dart';
import 'package:app1/screens/tabs/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../signinOrSignUp/controller/auth_controller.dart';

class ChatsScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends ConsumerState<ChatsScreen> with WidgetsBindingObserver {

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }


   @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch(state){
      case AppLifecycleState.resumed:
        ref.read(authControlerProvider).setUserState(true);
        break;
      
      case AppLifecycleState.inactive: 
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        ref.read(authControlerProvider).setUserState(false);
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

 



  @override
  Widget build(BuildContext context) {
    List pages = [
  Chats(),
  People(),
  Profile()
  ];

  List titles = [
  "chats".tr,
  "people".tr,
  "profile".tr
  ];

    return SafeArea(
      child: Scaffold(
        appBar: buildAppBar(titles,_selectedIndex),
        body: pages[_selectedIndex],
        bottomNavigationBar: buildBottomNavigationBar(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: kContentColorLightTheme,
          child: const Icon(Icons.person,color: Colors.greenAccent,),
          onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: ((context) => SelectContactScreen())));
        },),
      ),
    );
  }


  User_Model? userModel;

  BottomNavigationBar buildBottomNavigationBar() {
   

    return BottomNavigationBar(
      selectedItemColor: kPrimaryColor,
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.black.withOpacity(0.1),
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      onTap: (value) {
        setState(() {
          _selectedIndex = value;
        });
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.messenger), label: "chats".tr),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: "people".tr),
        BottomNavigationBarItem(icon:  Icon(Icons.person), label: "profile".tr),
      ],
    );
  }

  AppBar buildAppBar(List titles, int selectedIndex) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(titles[_selectedIndex]),
      elevation: 0,
    );
  }
  
  
}
