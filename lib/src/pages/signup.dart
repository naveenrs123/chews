import 'package:chews/src/login_and_sign_up/email_text_field.dart';
import 'package:chews/src/pages/route_constants.dart';
import 'package:chews/src/sample_feature/sample_item_list_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;
import 'package:logging/logging.dart';

import '../login_and_sign_up/password_text_field.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

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
                      'Sign Up',
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SignUpForm(),
                ],
              )),
            ),
          ),
        ));
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String _authValidationMessage = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EmailTextField(controller: _usernameController),
          PasswordTextField(controller: _passwordController),
          PasswordTextField(
            controller: _confirmPasswordController,
            confirmController: _passwordController,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              _authValidationMessage,
              style: const TextStyle(color: Colors.red),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 32, bottom: 16),
            child: ElevatedButton(
              onPressed: () async {
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                if (_formKey.currentState!.validate()) {
                  try {
                    var userCredential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: _usernameController.text.trim(),
                            password: _passwordController.text.trim());

                    await userCredential.user?.sendEmailVerification();

                    if (!context.mounted) return;

                    Navigator.restorablePushReplacementNamed(
                        context, SampleItemListView.routeName);
                  } on FirebaseAuthException catch (e) {
                    String message = processSignUpError(e);
                    setState(() {
                      _authValidationMessage = message;
                    });
                  } catch (e) {
                    setState(() {
                      _authValidationMessage =
                          'Sorry, we encountered an unexpected error during sign-up. Please contact support.';
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
        ],
      ),
    );
  }

  String processSignUpError(FirebaseAuthException e) {
    String message = '';

    switch (e.code) {
      case 'operation-not-allowed':
        message =
            'Sorry, we encountered an unexpected error during sign-up. Please contact support.';
        break;
      case 'too-many-requests':
        message =
            'You have attempted to sign-up too many times. Please wait before trying again.';
      default:
        message = e.message ?? e.code;
    }
    return message;
  }
}
