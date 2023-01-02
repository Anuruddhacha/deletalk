import 'package:app1/constants.dart';
import 'package:app1/firebase_options.dart';
import 'package:app1/screens/chats/chats_screen.dart';
import 'package:app1/screens/signinOrSignUp/controller/auth_controller.dart';
import 'package:app1/screens/welcome/welcome_screen.dart';
import 'package:app1/widgets/error.dart';
import 'package:app1/widgets/loader.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    name: 'my-do-chatapp'
  );
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  
  
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

 

    
   
    
    return MaterialApp(
      title: 'Deletalk',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: kContentColorLightTheme,
        appBarTheme: const AppBarTheme(
        color: kContentColorLightTheme
        )
      ),
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
      return ErrorScreen(error: error.toString());
      },
      loading: (){
          return const Loader();
      })
    );
  }
}
