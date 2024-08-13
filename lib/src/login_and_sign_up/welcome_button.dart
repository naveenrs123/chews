import 'package:flutter/material.dart';

class WelcomeButton extends StatelessWidget {
  final String text;
  final String route;

  const WelcomeButton({
    required this.text,
    required this.route,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ElevatedButton(
          onPressed: () {
            Navigator.restorablePushNamed(context, route);
          },
          child: Text(text)),
    );
  }
}
