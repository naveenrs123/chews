import 'package:chews/src/login.dart';
import 'package:chews/src/signup.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  static const routeName = '/welcome';

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
                      "Welcome to Chews!",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.restorablePushNamed(
                                context, LoginPage.routeName);
                          },
                          child: const Text("Log In")),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.restorablePushNamed(
                                context, SignUpPage.routeName);
                          },
                          child: const Text("Sign Up")),
                    )
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
