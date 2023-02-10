import 'package:app1/colors.dart';
import 'package:app1/features/chat/chat_controller.dart';
import 'package:app1/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:get/get.dart';
import '../../components/primary_button.dart';
import '../../constants.dart';
import '../messages/message_screen.dart';

class InitChatScreen extends ConsumerStatefulWidget {
  const InitChatScreen({super.key,required this.uid,required this.name});

  final String uid;
  final String name;

  @override
  ConsumerState<InitChatScreen> createState() => _InitChatScreenState();
}

class _InitChatScreenState extends ConsumerState<InitChatScreen> {
  DateTime? _selectedDate;
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';

  bool delete = false;

  bool loading = false;


  
  @override
  Widget build(BuildContext context) {


    
   
    

    return Scaffold(
      appBar: AppBar(title: Text("create_chat_room".tr),
      elevation: 0,),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
                 SizedBox(height: 30,),

                
             InkWell(
              onTap: () {
                 setState(() {
                   delete = false;
                 });
                
              },
               child: Padding(
                 padding:  EdgeInsets.only(left: 20),
                 child: Row(
                  children: [
                    Container(
                      width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                            width: 2,
                            color: !delete ?  Colors.blue : Colors.black54
                            )
                          ),
                      child: Center(
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: !delete ?  Colors.blue : Colors.transparent
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text("do_not_delete".tr,
                   style:const TextStyle(color: Colors.white,
                   fontSize: 18,
                   fontWeight: FontWeight.bold
                   ),)
                  ],
                 ),
               ),
             ),
            const SizedBox(height: 30,),

             InkWell(
              onTap: (() {
                 setState(() {
                   delete = true;
                 });
                 print(delete);
              }),
               child: Padding(
                 padding: const EdgeInsets.only(left: 20),
                 child: Row(
                  children: [
                    Container(
                      width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                            width: 2,
                            color: delete ?  Colors.blue : Colors.black54
                            )
                          ),
                      child: Center(
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: delete ?  Colors.blue : Colors.transparent
                          ),
                        ),
                      ),
                    ),
             
                   const SizedBox(width: 10),
                      Text("delete_after".tr,
                     style: const TextStyle(color: Colors.white,
                     fontSize: 18,
                     fontWeight: FontWeight.bold
                     ),)
             
             
                  ],
                 ),
               ),
             ),


           delete ?   Padding(
               padding: const EdgeInsets.all(8.0),
               child: SfDateRangePicker(
                      onSelectionChanged: _onSelectionChanged,
                      selectionColor: tabColor,
                      todayHighlightColor: tabColor,
                      backgroundColor: Colors.white,
                      selectionMode: DateRangePickerSelectionMode.single,
                      initialSelectedRange: PickerDateRange(
                          DateTime.now().subtract(const Duration(days: 4)),
                          DateTime.now().add(const Duration(days: 3))),
                    ),
             ) : const SizedBox.shrink(),
              
             const SizedBox(height: 30,),
             !loading ?  Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: PrimaryButton(
                  color: kPrimaryColor,
                  text: "create".tr,
                  press: () {
                      setState(() {
                        loading = true;
                      });

                      _createChatRoom();
                  },
                ),
              ) : const CircularProgressIndicator(
                color: Colors.purple,
              )
              
          ],
        ),
      ),
    );
  }

   void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
      } else if (args.value is DateTime) {
        _selectedDate = args.value;
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
  }
  
  void _createChatRoom() async{

if(_selectedDate == null && delete){
  setState(() {
    loading = false;
  });
  showSnackBar(context: context, content: "select_a_date".tr);
  return;
}
   
   if(delete){
  ref.read(chatControllerProvider).createChatRoom(widget.uid, _selectedDate!, context,true);
setState(() {
    loading = false;
  });
   }else{
    ref.read(chatControllerProvider).createChatRoom(widget.uid, DateTime.now(), context,false);
setState(() {
    loading = false;
  });
   }


Navigator.push(context, MaterialPageRoute(builder: ((context) => MessagesScreen(uid: widget.uid,name: widget.name,))));

  }


}


