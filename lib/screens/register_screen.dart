import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:z_task_manager/screens/home_screen.dart';
import 'package:z_task_manager/screens/redirect.dart';
import '../constants/constants.dart';
import '../structure/TextFieldHandler.dart';
import 'login_screen.dart';
import '../constants/reusable_ui.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  static const String id = "Register_Screen";

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailField = TextFieldHandler();
  final _passwordField = TextFieldHandler();
  final _confirmPasswordField = TextFieldHandler();
  final _username = TextFieldHandler();
  bool isPasswordVisible = true;
  bool isConfirmPasswordVisible = true;

  final _auth = FirebaseAuth.instance;

  Future<bool> createAccountWithEmailAndPassword() async {
    try {
      showDialog(
        context: context,
        builder: (_) => const CustomLoadingIndicator(),
      );
      await _auth.createUserWithEmailAndPassword(
          email: _emailField.controller.text,
          password: _passwordField.controller.text);
      await _auth.currentUser?.updateDisplayName(_username.controller.text);
      return true;
    } on FirebaseAuthException catch (e) {
      setState(() {
        _emailField.errorText = e.toString();
        Navigator.pop(context);
      });
      return false;
    }
  }

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
                        "Signup",
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
                            controller: _username.controller,
                            decoration: kTaskManagerDecoration.copyWith(
                              hintText: "Enter full name",
                              prefixIcon: const Icon(Icons.person),
                              errorText: "",
                            ),
                          ),
                          TextField(
                            controller: _emailField.controller,
                            keyboardType: TextInputType.emailAddress,
                            decoration: kTaskManagerDecoration.copyWith(
                              hintText: "Enter email address",
                              prefixIcon: const Icon(Icons.email),
                              errorText: "",
                            ),
                          ),
                          TextField(
                            obscureText: isPasswordVisible,
                            controller: _passwordField.controller,
                            decoration: kTaskManagerDecoration.copyWith(
                              hintText: "Enter password",
                              prefixIcon: const Icon(Icons.lock),
                              errorText: "",
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
                          TextField(
                            obscureText: isConfirmPasswordVisible,
                            controller: _confirmPasswordField.controller,
                            decoration: kTaskManagerDecoration.copyWith(
                              hintText: "Confirm password",
                              prefixIcon: const Icon(Icons.password),
                              errorText: _passwordField.controller.text ==
                                      _confirmPasswordField.controller.text
                                  ? ""
                                  : "Password doesn't match",
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isConfirmPasswordVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isConfirmPasswordVisible =
                                        !isConfirmPasswordVisible;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
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
                                "Signup",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                if(await createAccountWithEmailAndPassword()){
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => const RedirectScreen()));

                                }else {
                                  return;
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text("Or Signup with"),
                      const SizedBox(
                        height: 10,
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
                        height: 10,
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
                          RoundIconButton(
                            backgroundColor: Colors.black,
                            image: const AssetImage("assets/logos/apple.png"),
                            onPressed: () {
                              //TODO implement Apple Login
                            },
                          ),
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
                          const Text("Already have an account?"),
                          TextButton(
                            child: const Text("Login"),
                            onPressed: () {
                              Navigator.pushNamed(context, LoginScreen.id);
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
