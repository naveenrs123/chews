import 'package:flutter/material.dart';

class PasswordTextField extends StatelessWidget {
  const PasswordTextField({
    super.key,
    required TextEditingController controller,
    TextEditingController? confirmController,
  })  : _controller = controller,
        _confirmController = confirmController;

  final TextEditingController _controller;
  final TextEditingController? _confirmController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextFormField(
        controller: _controller,
        obscureText: true,
        decoration: const InputDecoration(
          hintText: 'Enter your password',
        ),
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return 'Password cannot be empty';
          }

          if (_confirmController != null && _confirmController.text != value) {
            return 'Passwords must match';
          }
          return null;
        },
      ),
    );
  }
}
