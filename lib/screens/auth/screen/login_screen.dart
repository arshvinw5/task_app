import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_app/components/auth_button.dart';
import 'package:task_app/components/reuseable_text_felid.dart';
import 'package:task_app/features/auth/cubit/auth_cubit.dart';
import 'package:task_app/features/home/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  final void Function()? onTap;
  const LoginScreen({super.key, required this.onTap});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //text editing controller
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() {
    if (formKey.currentState!.validate()) {
      context.read<AuthCubit>().login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                  state.error,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          } else if (state is AuthLoggedIn) {
            Navigator.pushAndRemoveUntil(
              context,
              HomeScreen.route(),
              (_) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //logo
                      Icon(Icons.password, size: 80, color: Colors.black),
                      const SizedBox(height: 25.0),
                      Text(
                        'Task Login',
                        style: GoogleFonts.bebasNeue(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 50.0),
                      //email
                      ReuseableTextFelid(
                        labelText: 'Email',
                        controller: emailController,
                        obscureText: false,
                        validator: (value) {
                          final emailRegex = RegExp(
                            r"^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?$",
                          );

                          if (value!.trim().isEmpty || !value.contains('@')) {
                            return 'Please enter a valid email';
                          } else if (!emailRegex.hasMatch(
                            value.trim().toLowerCase(),
                          )) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      //email
                      const SizedBox(height: 10.0),
                      ReuseableTextFelid(
                        labelText: 'Password',
                        controller: passwordController,
                        obscureText: true,
                        validator: (value) {
                          if (value!.trim().isEmpty ||
                              value.trim().length <= 5) {
                            return 'Password feild is required';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 10.0),
                      GestureDetector(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Forgot Password ?",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      AuthButton(text: 'Login', onTap: login),
                      const SizedBox(height: 25.0),

                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Text('Do not have an account?'),
                      //     const SizedBox(width: 5.0),
                      //     GestureDetector(
                      //       onTap: widget.onTap,
                      //       child: Text(
                      //         'Register here',
                      //         style: TextStyle(fontWeight: FontWeight.bold),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      RichText(
                        text: TextSpan(
                          text: 'Don\'t have an account ?  ',
                          style: Theme.of(context).textTheme.titleMedium,
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Register',
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
          );
        },
      ),
    );
  }
}
