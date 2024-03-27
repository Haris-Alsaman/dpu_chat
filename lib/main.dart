import 'package:dpu_chat/screens/chat_screen.dart';
import 'package:dpu_chat/screens/registration_screen.dart';
import 'package:dpu_chat/screens/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

import 'screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyB8JnJ5V4d7aWu_bvd0btIFAAghDzmWMAg", 
      appId: "742968602833:android:a906a16e946ff2a0d7d5f0", 
      messagingSenderId: "742968602833", 
      projectId: "dpu-chat-66c34")
      // check if the firebase connection is successful
  );
    Gemini.init(apiKey: 'AIzaSyAwZoDjcbXf9-4Q9jPJiMFzcwkeMd2JK4g');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'DPU Chat',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: ChatScreen(),
        initialRoute: WelcomeScreen.screenRoute,
        routes: {
          WelcomeScreen.screenRoute: (context) => WelcomeScreen(),
          SignInScreen.screenRoute: (context) => SignInScreen(),
          RegistrationScreen.screenRoute: (context) => RegistrationScreen(),
          ChatScreen.screenRoute: (context) => ChatScreen(),
        });
  }
}
