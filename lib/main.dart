import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:z_task_manager/screens/EmailVerificationScreen.dart';
import 'package:z_task_manager/screens/ForgetPasswordScreen.dart';
import 'package:z_task_manager/screens/home_screen.dart';
import 'package:z_task_manager/screens/login_screen.dart';
import 'package:z_task_manager/screens/new_task.dart';
import 'package:z_task_manager/screens/redirect.dart';
import 'package:z_task_manager/screens/register_screen.dart';
import 'package:z_task_manager/screens/settings_screen.dart';
import 'package:z_task_manager/services/task_controller_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  ));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => TaskControllerProvider(),
          ),
          //   ChangeNotifierProvider(
          //     create: (context) => GoogleSignInProvider(),
          //   ),
        ],
        child: const TaskManager(),
      ));
}

class TaskManager extends StatelessWidget {
  const TaskManager({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red
      ),
      initialRoute: RedirectScreen.id,
      routes:{
        HomeScreen.id : (context) => const HomeScreen(),
        NewTaskScreen.id : (context) => NewTaskScreen(),
        LoginScreen.id : (context) => const LoginScreen(),
        RegisterScreen.id : (context) => const RegisterScreen(),
        SettingsScreen.id : (context) => const SettingsScreen(),
        RedirectScreen.id : (context) => const RedirectScreen(),
        ForgetPasswordScreen.id : (context) => const ForgetPasswordScreen(),
      }
    );
  }
}
