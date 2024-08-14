import 'package:chews/src/pages/route_constants.dart';
import 'package:flutter/material.dart';
import '../login_and_sign_up/welcome_button.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 64),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 64),
                child: Column(
                  children: [
                    const Text(
                      'Welcome to Chews!',
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    const WelcomeButton(
                        text: 'Log In', route: RouteConstants.login),
                    const WelcomeButton(
                        text: 'Sign Up', route: RouteConstants.signUp),
                    TextButton(
                        onPressed: () {
                          Navigator.restorablePushNamed(
                              context, RouteConstants.resetPassword);
                        },
                        child: const Text('Forgot your password?')),
                  ],
                ),
              ),
            ],
          )),
        ),
      ),
    ));
  }
}
