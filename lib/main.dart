import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:z_task_manager/screens/EmailVerificationScreen.dart';
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
      initialRoute: LoginScreen.id,
      routes:{
        HomeScreen.id : (context) => HomeScreen(),
        NewTaskScreen.id : (context) => NewTaskScreen(),
        LoginScreen.id : (context) => LoginScreen(),
        RegisterScreen.id : (context) => RegisterScreen(),
        SettingsScreen.id : (context) => SettingsScreen(),
        RedirectScreen.id : (context) => const RedirectScreen(),
      }
    );
  }
}
