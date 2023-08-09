import 'dart:io';

import 'package:flutter/material.dart';
import 'package:z_task_manager/constants/constants.dart';
import 'package:z_task_manager/screens/home_screen.dart';
import 'package:z_task_manager/screens/redirect.dart';
import 'package:z_task_manager/screens/register_screen.dart';
import 'package:z_task_manager/structure/TextFieldHandler.dart';
import '../constants/reusable_ui.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String id = "Login_Screen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = true;

  Future<bool> signInWithEmailAndPassword() async{
    try{
      showDialog(
        context: context,
        builder: (_) => CustomLoadingIndicator()
      );
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailField.controller.text, password: _passwordField.controller.text);
      return true;
    }on FirebaseAuthException catch(e){
      setState(() {
        _passwordField.errorText = e.toString();
        Navigator.pop(context);
      });
      return false;
    }
  }

  final _emailField = TextFieldHandler();
  final _passwordField = TextFieldHandler();
  bool isPasswordVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Flexible(
                        child: Padding(
                          padding: EdgeInsets.all(30.0),
                          child: Image(
                              image: AssetImage("assets/logos/backcaps.png")),
                        ),
                      ),
                      const Text(
                        "Login",
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TextField(
                            controller: _emailField.controller,
                            keyboardType: TextInputType.emailAddress,
                            decoration: kTaskManagerDecoration.copyWith(
                              hintText: "Enter email address",
                              prefixIcon: const Icon(Icons.email),
                              errorText: _emailField.errorText,
                            ),
                          ),
                          TextField(
                            controller: _passwordField.controller,
                            obscureText: isPasswordVisible,
                            decoration: kTaskManagerDecoration.copyWith(
                              hintText: "Enter password",
                              prefixIcon: const Icon(Icons.lock),
                              errorText: _passwordField.errorText,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isPasswordVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isPasswordVisible = !isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => setState(
                              () {
                                //TODO implement Forget password here
                              },
                            ),
                            child: const Text("Forget Password?"),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: MaterialButton(
                              height: 50,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              color: Colors.red,
                              child: const Text(
                                "Login",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async{
                                if (await signInWithEmailAndPassword()){
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
                                }
                                else{
                                  return;
                                }
                              },
                            ),
                          ),
                          //TODO add fingerprint login button
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text("Or Login with"),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 1,
                        decoration: const BoxDecoration(
                          gradient: RadialGradient(radius: 150, colors: [
                            Colors.black,
                            Colors.white,
                          ]),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RoundIconButton(
                            backgroundColor: Colors.white,
                            image: const AssetImage("assets/logos/google.png"),
                            onPressed: () {
                              //TODO Implement Google Login
                            },
                          ),
                          Platform.isIOS ? RoundIconButton(
                            backgroundColor: Colors.black,
                            image: const AssetImage("assets/logos/apple.png"),
                            onPressed: () {
                              //TODO implement Apple Login
                            },
                          ): Container(),
                          RoundIconButton(
                            backgroundColor: const Color(0xff3c5a9a),
                            image:
                                const AssetImage("assets/logos/facebook.png"),
                            onPressed: () {
                              //TODO Implement Facebook Login
                            },
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account?"),
                          TextButton(
                            child: const Text("Signup"),
                            onPressed: () {
                              Navigator.pushNamed(context, RegisterScreen.id);
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}