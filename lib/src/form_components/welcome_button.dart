import 'package:chews/src/pages/login.dart';
import 'package:chews/src/pages/route_constants.dart';
import 'package:chews/src/pages/signup.dart';
import 'package:flutter/material.dart';

class WelcomeButton extends StatelessWidget {
  final String _text;
  final String _route;

  const WelcomeButton({
    super.key,
    required String text,
    required String route,
  })  : _text = text,
        _route = route;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ElevatedButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => _route == RouteConstants.login
                        ? const LoginPage()
                        : const SignUpPage()));
          },
          child: Text(
            _text,
            style: Theme.of(context).textTheme.bodyLarge,
          )),
    );
  }
}
