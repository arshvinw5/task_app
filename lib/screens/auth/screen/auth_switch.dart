import 'package:flutter/material.dart';
import 'package:task_app/screens/auth/screen/login_screen.dart';
import 'package:task_app/screens/auth/screen/registration_screen.dart';

class AuthSwitch extends StatefulWidget {
  const AuthSwitch({super.key});

  @override
  _AuthSwitchState createState() => _AuthSwitchState();
}

class _AuthSwitchState extends State<AuthSwitch> {
  //initially, show login screen
  bool showLoginScreen = true;

  //toggle between login and registration screen

  void toggleScreen() {
    setState(() {
      //when toggle to make it false
      showLoginScreen = !showLoginScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginScreen) {
      return LoginScreen(onTap: toggleScreen);
    } else {
      return RegistrationScreen(onTap: toggleScreen);
    }
  }
}
