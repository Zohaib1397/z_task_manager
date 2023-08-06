import 'package:flutter/material.dart';
import 'package:z_task_manager/constants/constants.dart';
import 'package:z_task_manager/screens/home_screen.dart';
import 'package:z_task_manager/screens/register_screen.dart';
import '../constants/reusable_ui.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String id = "Login_Screen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  String password = "";
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
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: kTaskManagerDecoration.copyWith(
                              hintText: "Enter email address",
                              prefixIcon: const Icon(Icons.email),
                              suffixText: ".com",
                              errorText: "",
                            ),
                          ),
                          TextField(
                            obscureText: isPasswordVisible,
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
                            onChanged: (value) => password = value,
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
                              onPressed: () {

                                //TODO implement login authentication logic here
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
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