import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_app/components/auth_button.dart';
import 'package:task_app/components/reuseable_text_felid.dart';

class RegistrationScreen extends StatefulWidget {
  final void Function()? onTap;
  const RegistrationScreen({super.key, required this.onTap});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  //text editing controller
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  String? confirmPasswordValidator(
    String? confirmPassword,
    String originalPassword,
  ) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Please confirm your password';
    } else if (confirmPassword != originalPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void register() {
    if (formKey.currentState!.validate()) {
      print('valid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //logo
                  Icon(Icons.person, size: 80, color: Colors.black),
                  const SizedBox(height: 25.0),
                  Text(
                    'Task Registration',
                    style: GoogleFonts.bebasNeue(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(height: 50.0),
                  //email
                  ReuseableTextFelid(
                    labelText: 'Name',
                    controller: nameController,
                    obscureText: false,

                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  //email
                  const SizedBox(height: 25.0),
                  ReuseableTextFelid(
                    labelText: 'Email',
                    controller: emailController,
                    obscureText: false,
                    validator: (value) {
                      final emailRegex = RegExp(
                        r"^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?$",
                      );
                      if (value!.trim().isEmpty || !value.contains('@')) {
                        return 'Please enter an email';
                      } else if (!emailRegex.hasMatch(
                        value.trim().toLowerCase(),
                      )) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  //email
                  const SizedBox(height: 25.0),
                  ReuseableTextFelid(
                    labelText: 'Password',
                    controller: passwordController,
                    obscureText: true,
                    validator: (value) {
                      if (value!.trim().isEmpty || value.trim().length <= 6) {
                        return 'Password feild is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 25.0),
                  ReuseableTextFelid(
                    labelText: 'Confirm Password',
                    controller: confirmPasswordController,
                    obscureText: true,
                    validator:
                        (value) => confirmPasswordValidator(
                          value,
                          passwordController.text,
                        ),
                  ),
                  //email
                  const SizedBox(height: 25.0),
                  AuthButton(text: 'Register', onTap: register),
                  const SizedBox(height: 25.0),

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Text('You have an account?'),
                  //     const SizedBox(width: 5.0),
                  //     GestureDetector(
                  //       onTap: widget.onTap,
                  //       child: Text(
                  //         'Login',
                  //         style: TextStyle(fontWeight: FontWeight.bold),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  RichText(
                    text: TextSpan(
                      text: 'You have an account ?  ',
                      style: Theme.of(context).textTheme.titleMedium,
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Login',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          recognizer:
                              TapGestureRecognizer()..onTap = widget.onTap,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
