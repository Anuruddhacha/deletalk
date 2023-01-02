import 'package:app1/components/primary_button.dart';
import 'package:app1/constants.dart';
import 'package:app1/screens/chats/chats_screen.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../colors.dart';
import 'controller/auth_controller.dart';

class SigninOrSignupScreen extends ConsumerStatefulWidget {




  @override
  ConsumerState<SigninOrSignupScreen> createState() => _SigninOrSignupScreenState();
}

class _SigninOrSignupScreenState extends ConsumerState<SigninOrSignupScreen> {


  final phoneController = TextEditingController();
  Country? country;




  @override
  Widget build(BuildContext context) {
    final size   = MediaQuery.of(context).size;

    
    return Scaffold(
      backgroundColor: kContentColorLightTheme,
      appBar: AppBar(title: const Text("Enter your phone number"),
      elevation: 0,
      backgroundColor: kContentColorLightTheme,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
      
              Column(
                children: [  Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: const Text("Deletalk will need to verify your phone number",
                  style: TextStyle(
                    color: Colors.white
                  ),),
                ),
      
                SizedBox(height: 10,),
      
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: GestureDetector(
                    onTap: (){
                  pickCountry(context);
                    },
                    child: const Text("Pick country",
                    style: TextStyle(
                      color: Colors.blue
                    ),),
                  ),
                ),
      
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
      
          (country != null) ?  Text('+${country!.phoneCode}',style: TextStyle(color: Colors.white),):
          Text(""),
      
           SizedBox(width: 4,),
           SizedBox(width: size.width * 0.7,
           child: TextField(
            controller: phoneController,
            style: TextStyle(color: Colors.white,),
            
            decoration: InputDecoration(
              hintText: 'phone number',
              hintStyle: TextStyle(color: Colors.white)
            ),
           ),
           ),
          
           
           ])],
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 70),
                child: PrimaryButton(
                color: kPrimaryColor,
                text: "Send",
                press: () {
                    sendPhoneNumber();
                },
              ),
              )
      
      
      
            ],
          ),
        ),
      ),
    );
  }




  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

  void pickCountry(BuildContext context){
    
showCountryPicker(
  context: context,
  showPhoneCode: true,
   onSelect: (Country _country){
  setState(() {
    country = _country;
  });
  print(country);
   },
   
   countryListTheme: CountryListThemeData(
    backgroundColor: backgroundColor,
    
    textStyle: TextStyle(
      color: Colors.white,
      
    ),
    searchTextStyle: TextStyle(
      color: Colors.white,
      
    ),
    inputDecoration: InputDecoration(
      fillColor: Colors.white,
      focusColor: Colors.white,
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.white)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.white)),
      
    ),
    
   )
   );




  }

  void sendPhoneNumber(){
    String phoneNumber = phoneController.text.trim();

    if(country != null && phoneNumber.isNotEmpty){
      print("verfying----");
      ref.read(authControlerProvider).signInWithPhone('+${country!.phoneCode}${phoneNumber}', context);
    }

  }







}


