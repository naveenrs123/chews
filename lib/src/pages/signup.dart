import 'dart:developer' as dev;

import 'package:chews/src/form_components/auth_validation_message.dart';
import 'package:chews/src/form_components/form_text_field.dart';
import 'package:chews/src/pages/onboarding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../form_components/password_text_field.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back))),
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 64),
                  child: Text(
                    'Sign Up',
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        fontFamily: 'SunnySpells',
                        fontSize: 72,
                        color: const Color(0xFFFF707C)),
                  ),
                ),
                const SignUpForm(),
              ],
            )),
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
          FormTextField(controller: _usernameController),
          PasswordTextField(controller: _passwordController),
          PasswordTextField(
            controller: _confirmPasswordController,
            confirmController: _passwordController,
          ),
          AuthValidationMessage(message: _authValidationMessage),
          ElevatedButton(
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

                  Navigator.popUntil(context, (route) => route.isFirst);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const OnboardingPage()));
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
            child: Text(
              'Submit',
              style: Theme.of(context).textTheme.labelLarge,
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
