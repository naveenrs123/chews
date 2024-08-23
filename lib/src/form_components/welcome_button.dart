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
            Navigator.restorablePushNamed(context, _route);
          },
          child: Text(_text)),
    );
  }
}
