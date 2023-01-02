import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../widgets/error.dart';
import '../../../widgets/loader.dart';
import '../controller/select_contact_controller.dart';

class SelectContactScreen extends ConsumerWidget {

  static const routeName = '/slect-contact';
  const SelectContactScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select contact"),
        elevation: 0,
        actions: [
          IconButton(onPressed: (){
            
          },
           icon: Icon(Icons.search)),

           IconButton(onPressed: (){

           },
           icon: Icon(Icons.more_vert)),
        ],
      ),
      body: ref.watch(getContactsProvider).when(
        data: (contactList){

           return ListView.builder(
            itemCount: contactList.length,
            itemBuilder: (context,indx){

                final contact = contactList[indx];

               return InkWell(
                onTap: ()=> selectContact(ref, contact, context),
                 child: ListTile(
                  title: Text(contact.displayName,
                  style: TextStyle(color: Colors.white,
                  fontSize: 18),),
                  leading: contact.photo == null? null:CircleAvatar(
                    backgroundImage: MemoryImage(contact.photo!),
                  ),
                 ),
               );

               
           });


        },
        error: (err,trace)=>ErrorScreen(error: err.toString()),
        loading: ()=>const Loader()),
    );
  }

  void selectContact(WidgetRef ref, Contact selectedContact,BuildContext context){
   ref.read(selectContactController).slectContact(selectedContact, context);
  } 
}