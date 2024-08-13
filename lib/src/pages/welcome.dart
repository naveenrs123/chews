import 'package:chews/src/pages/route_constants.dart';
import 'package:flutter/material.dart';
import '../login_and_sign_up/welcome_button.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 64),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 64),
                child: Column(
                  children: [
                    Text(
                      "Welcome to Chews!",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    WelcomeButton(text: "Log In", route: RouteConstants.login),
                    WelcomeButton(text: "Sign Up", route: RouteConstants.signUp)
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
