import 'package:flutter/material.dart';

class EmailTextField extends StatelessWidget {
  const EmailTextField({
    super.key,
    required TextEditingController controller,
  }) : _controller = controller;

  final TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: _controller,
        decoration: const InputDecoration(
          hintText: 'Enter your email',
        ),
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return 'Email cannot be empty';
          }
          return null;
        },
      ),
    );
  }
}
