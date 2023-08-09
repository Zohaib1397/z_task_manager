import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:z_task_manager/screens/EmailVerificationScreen.dart';
import 'login_screen.dart';

class RedirectScreen extends StatelessWidget {
  const RedirectScreen({super.key});

  static const String id = "Redirect_screen";

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          return EmailVerificationScreen();
        }
        else{
          return const LoginScreen();
        }
      },
    );
  }
}
