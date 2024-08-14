import 'dart:developer' as dev;

import 'package:chews/src/pages/route_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../login_and_sign_up/auth_validation_message.dart';
import '../login_and_sign_up/email_text_field.dart';
import '../login_and_sign_up/password_text_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
                      'Log In',
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ),
                  LoginForm(),
                ],
              )),
            ),
          ),
        ));
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  String _authValidationMessage = '';

  @override
  Widget build(BuildContext context) {
    var list = [
      EmailTextField(controller: _usernameController),
      PasswordTextField(controller: _passwordController),
      AuthValidationMessage(message: _authValidationMessage),
      Padding(
        padding: const EdgeInsets.only(top: 32, bottom: 16),
        child: ElevatedButton(
          onPressed: () async {
            // Validate will return true if the form is valid, or false if
            // the form is invalid.
            if (_formKey.currentState!.validate()) {
              try {
                var userCredential = await FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: _usernameController.text.trim(),
                        password: _passwordController.text.trim());

                if (!context.mounted) return;

                var user = userCredential.user;
                if (user != null && (user.displayName?.isNotEmpty ?? false)) {
                  Navigator.pushReplacementNamed(context, RouteConstants.home);
                } else {
                  Navigator.pushReplacementNamed(
                      context, RouteConstants.onboarding);
                }
              } on FirebaseAuthException catch (e) {
                String message = processLoginError(e);

                setState(() {
                  _authValidationMessage = message;
                });
              } catch (e) {
                setState(() {
                  _authValidationMessage =
                      'Sorry, we encountered an unexpected error during login. Please contact support.';
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

  String processLoginError(FirebaseAuthException e) {
    String message = '';

    switch (e.code) {
      case 'too-many-requests':
        message =
            'You have attempted to login too many times. Please wait before trying again.';
      default:
        message = e.message ?? e.code;
    }
    return message;
  }
}
