import 'package:app1/screens/signinOrSignUp/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../colors.dart';
class OTPScreen extends ConsumerWidget {
  static const routeName = "/OTP-screen";
  final String verificationID;

  const OTPScreen({Key? key, required this.verificationID});


 void verifyOTP(WidgetRef ref, BuildContext context, String userOTP){
  ref.read(authControlerProvider).verifyOTP(verificationID, context, userOTP); 
 }

  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
    appBar: AppBar(
      title:Text("Verifying your number"),
      elevation: 0,
      backgroundColor: backgroundColor,
      leading: GestureDetector(
        onTap: (){
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back_ios)),
    ),
    body: Column(
  crossAxisAlignment: CrossAxisAlignment.center,
      children: [
    SizedBox(height: 20,),
     Padding(
       padding: const EdgeInsets.symmetric(horizontal: 100),
       child: SizedBox(
        width: size.width*0.6,
        child: TextField(
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white,),
          decoration: InputDecoration(
            hintText: '_ _ _ _ _ _ ',
            hintStyle: TextStyle(
             fontSize: 30,
             color: Colors.white,
            ),
            labelStyle: TextStyle(
              color: Colors.white
            )
          ),
          keyboardType: TextInputType.number,
          onChanged: (String val){

            if(val.length == 6){
             verifyOTP(ref, context, val);
            }

          },
        ),
       ),
     )


      ],
    ),
    );
  }
}