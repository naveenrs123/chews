import 'dart:developer' as dev;

import 'package:chews/src/form_components/auth_validation_message.dart';
import 'package:chews/src/form_components/form_text_field.dart';
import 'package:chews/src/form_components/password_text_field.dart';
import 'package:chews/src/pages/route_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class ConfirmResetPage extends StatelessWidget {
  const ConfirmResetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.restorablePopAndPushNamed(
                    context, RouteConstants.welcome);
              },
              icon: const Icon(Icons.arrow_back))),
      body: const SafeArea(
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
                  child: Text(
                    'Confirm Reset Code',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ),
                ConfirmResetForm()
              ],
            )),
          ),
        ),
      ),
    );
  }
}

class ConfirmResetForm extends StatefulWidget {
  const ConfirmResetForm({super.key});

  @override
  State<ConfirmResetForm> createState() => _ConfirmResetFormState();
}

class _ConfirmResetFormState extends State<ConfirmResetForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String _authValidationMessage = '';

  @override
  Widget build(BuildContext context) {
    var list = [
      FormTextField(
        controller: _codeController,
        hintText: 'Enter the confirmation code',
        emptyValidationText: 'Code cannot be empty',
      ),
      PasswordTextField(controller: _confirmPasswordController),
      PasswordTextField(
        controller: _passwordController,
        confirmController: _confirmPasswordController,
      ),
      AuthValidationMessage(message: _authValidationMessage),
      Padding(
        padding: const EdgeInsets.only(top: 32, bottom: 16),
        child: ElevatedButton(
          onPressed: () async {
            // Validate will return true if the form is valid, or false if
            // the form is invalid.
            if (_formKey.currentState!.validate()) {
              try {
                await FirebaseAuth.instance.confirmPasswordReset(
                    code: _codeController.text.trim(),
                    newPassword: _passwordController.text.trim());

                if (!context.mounted) return;

                Navigator.restorablePushReplacementNamed(
                    context, RouteConstants.login);
              } on FirebaseAuthException catch (e) {
                setState(() {
                  _authValidationMessage = e.message ?? e.code;
                });
              } catch (e) {
                setState(() {
                  _authValidationMessage =
                      'Sorry, we encountered an unexpected error. Please contact support.';
                });

                if (kDebugMode) {
                  print(e);
                } else {
                  dev.log('Unexpected error!',
                      error: e, level: Level.SEVERE.value);
                }
              }
            }
          },
          child: const Text('Submit'),
        ),
      ),
    ];
    var children = list;
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
