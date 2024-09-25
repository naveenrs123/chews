import 'package:flutter/material.dart';

class FormTextField extends StatelessWidget {
  const FormTextField(
      {super.key,
      required TextEditingController controller,
      String hintText = 'Enter your email',
      String emptyValidationText = 'Email cannot be empty',
      String? initialValue})
      : _controller = controller,
        _hintText = hintText,
        _emptyValidationText = emptyValidationText,
        _initialValue = initialValue;

  final TextEditingController _controller;
  final String _hintText;
  final String _emptyValidationText;
  final String? _initialValue;

  @override
  Widget build(BuildContext context) {
    _controller.text = _initialValue ?? '';

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: _hintText,
        ),
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return _emptyValidationText;
          }
          return null;
        },
      ),
    );
  }
}
