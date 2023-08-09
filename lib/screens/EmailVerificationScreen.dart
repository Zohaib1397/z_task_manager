import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool isEmailVerified = false;
  final _auth = FirebaseAuth.instance;
  Timer? timer;
  @override
  void initState() {
    super.initState();

    isEmailVerified = _auth.currentUser!.emailVerified;

    if(!isEmailVerified){
      sendVerificationEmail();

      timer = Timer.periodic(Duration(seconds:3), (timer) => checkEmailVerification());
    }
  }

  @override
  void dispose() {
    timer!.cancel();

    super.dispose();
  }


  void checkEmailVerification() {}
  Future<void> sendVerificationEmail() async{
    try{
      await _auth.currentUser!.sendEmailVerification();
    }catch(e){
      print(e.toString());
    }
  }


  @override
  Widget build(BuildContext context) {
    return isEmailVerified? const HomeScreen() : Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Email Verification"),
      ),
    );
  }


}
