import 'package:app1/app_constants.dart';
import 'package:app1/components/primary_button.dart';
import 'package:app1/constants.dart';
import 'package:app1/screens/signinOrSignUp/signin_or_signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../localization_controller.dart';

class WelcomeScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            Image.asset("assets/images/welcome_image.png"),
            const Spacer(flex: 3),
            Text(
              "welcome".tr,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headline5!
                  .copyWith(fontWeight: FontWeight.bold,color: Colors.white),
            ),
            const Spacer(),
            const Spacer(flex: 3),
            

        GetBuilder<LocalizationController>(builder: ((controller) {
         return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: PrimaryButton(text: "English", press: (() {
                controller.setLanguage(Locale(
                  AppConstants.languages[0].languageCode,
                  AppConstants.languages[0].countryCode,
                ));
              })),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: PrimaryButton(text: "한국인", press: (() {
                controller.setLanguage(Locale(
                  AppConstants.languages[1].languageCode,
                  AppConstants.languages[1].countryCode,
                ));
              })),
            )

          ],
         );


    })),
    const SizedBox(height: 10,),
    FittedBox(
              child: TextButton(
                  onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SigninOrSignupScreen(),
                        ),
                      ),
                  child: Row(
                    children: [
                      Text(
                        'next'.tr,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              color: Colors.white,
                            ),
                      ),
                      const SizedBox(width: kDefaultPadding / 4),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.white,
                      )
                    ],
                  )),
            ),

          ],
        ),
      ),
    );
  }
}
