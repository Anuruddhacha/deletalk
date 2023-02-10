import 'package:app1/app_constants.dart';
import 'package:app1/constants.dart';
import 'package:app1/firebase_options.dart';
import 'package:app1/localization_controller.dart';
import 'package:app1/messages.dart';
import 'package:app1/screens/chats/chats_screen.dart';
import 'package:app1/screens/signinOrSignUp/controller/auth_controller.dart';
import 'package:app1/screens/welcome/welcome_screen.dart';
import 'package:app1/widgets/error.dart';
import 'package:app1/widgets/loader.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:is_first_run/is_first_run.dart';
import 'dep.dart' as dep;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    name: 'my-do-chatapp'
  );
  Map<String , Map<String,String>>  _languages = await dep.init();

  runApp(ProviderScope(child: MyApp(languages: _languages,)));
}

class MyApp extends ConsumerStatefulWidget {

  final Map<String, Map<String,String>> languages;

  MyApp({required this.languages});
  
  
  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
     bool? _isFirstRun;

  void _checkFirstRun() async {
    bool ifr = await IsFirstRun.isFirstRun();
    setState(() {
      _isFirstRun = ifr;
    });
  }

  @override
  void initState() {
    super.initState();
    print("checking first run");
    _checkFirstRun();
    print(_isFirstRun);
  }
   @override
  Widget build(BuildContext context) {
  
    
    return GetBuilder<LocalizationController>(builder: ((controller) {
      return GetMaterialApp(
      title: 'Deletalk',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: kContentColorLightTheme,
        appBarTheme: const AppBarTheme(
        color: kContentColorLightTheme
        )
      ),
      locale: controller.locale,
      translations: Messages(languages: widget.languages),
      fallbackLocale: Locale(AppConstants.languages[0].languageCode,
                              AppConstants.languages[0].countryCode),
      home: (_isFirstRun == null || _isFirstRun == true) ?  
      WelcomeScreen()
      : ref.watch(userdataAuthProider).when(

        data: (user){
        if(user == null){
          return WelcomeScreen();
        }
        return ChatsScreen();
      },
      error: (error,trace){
      return WelcomeScreen();
      },
      loading: (){
          return const Loader();
      })
    );


    }));

  }
}
