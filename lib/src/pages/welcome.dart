import 'package:chews/src/pages/reset_password.dart';
import 'package:chews/src/pages/route_constants.dart';
import 'package:flutter/material.dart';
import '../form_components/welcome_button.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Chews',
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    fontFamily: 'SunnySpells',
                    fontSize: 128,
                    color: const Color(0xFFFF707C))),
            const WelcomeButton(text: 'Log In', route: RouteConstants.login),
            const WelcomeButton(text: 'Sign Up', route: RouteConstants.signUp),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ResetPasswordPage()));
                  },
                  child: Text(
                    'Forgot your password?',
                    style: Theme.of(context).textTheme.labelLarge,
                  )),
            ),
          ],
        ),
      ),
    ));
  }
}
