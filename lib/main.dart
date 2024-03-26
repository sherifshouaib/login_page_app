import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_page/firebase_options.dart';
import 'package:login_page/screens/sign_up.dart';
import 'package:login_page/screens/welcome.screen.dart';



void main() async {
WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        SignUp.id: (context) => SignUp(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
      },
      debugShowCheckedModeBanner: false,
      initialRoute: WelcomeScreen.id,
    );
  }
}
