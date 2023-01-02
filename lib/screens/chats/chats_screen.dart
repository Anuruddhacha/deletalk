import 'package:app1/constants.dart';
import 'package:app1/features/select_contacts/screen/select_contacts_screen.dart';
import 'package:app1/screens/tabs/calls.dart';
import 'package:app1/screens/tabs/chat.dart';
import 'package:app1/screens/tabs/people.dart';
import 'package:app1/screens/tabs/profile.dart';
import 'package:flutter/material.dart';

class ChatsScreen extends StatefulWidget {
  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  int _selectedIndex = 0;

 



  @override
  Widget build(BuildContext context) {
    List pages = [
  Chats(),
  People(),
  Calls(),
  Profile()
  ];

  List titles = [
  "Chats",
  "Peoples",
  "Calls",
  "Profile"
  ];

    return Scaffold(
      appBar: buildAppBar(titles,_selectedIndex),
      body: pages[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {

            Navigator.push(context, MaterialPageRoute(builder: ((context) => SelectContactScreen())));

        },
        backgroundColor: kPrimaryColor,
        child: const Icon(
          Icons.person_add_alt_1,
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      onTap: (value) {
        setState(() {
          _selectedIndex = value;
        });
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.messenger), label: "Chats"),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: "People"),
        BottomNavigationBarItem(icon: Icon(Icons.call), label: "Calls"),
        BottomNavigationBarItem(
          icon: CircleAvatar(
            radius: 14,
            backgroundImage: AssetImage("assets/images/user_2.png"),
          ),
          label: "Profile",
        ),
      ],
    );
  }

  AppBar buildAppBar(List titles, int selectedIndex) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(titles[_selectedIndex]),
      elevation: 0,
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {},
        ),
      ],
    );
  }
}
