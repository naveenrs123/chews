import 'package:flutter/material.dart';

class AuthValidationMessage extends StatelessWidget {
  const AuthValidationMessage({
    super.key,
    required String message,
  }) : _message = message;

  final String _message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        _message,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}
