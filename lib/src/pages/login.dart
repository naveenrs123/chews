import 'dart:developer' as dev;

import 'package:chews/src/pages/home.dart';
import 'package:chews/src/pages/onboarding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../form_components/auth_validation_message.dart';
import '../form_components/form_text_field.dart';
import '../form_components/password_text_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
                  child: Text('Log In',
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          fontFamily: 'SunnySpells',
                          fontSize: 72,
                          color: const Color(0xFFFF707C))),
                ),
                const LoginForm(),
              ],
            )),
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
  final TextEditingController _emailController = TextEditingController();

  String _authValidationMessage = '';

  @override
  Widget build(BuildContext context) {
    var list = [
      FormTextField(controller: _emailController),
      PasswordTextField(controller: _passwordController),
      AuthValidationMessage(message: _authValidationMessage),
      ElevatedButton(
        onPressed: () async {
          // Validate will return true if the form is valid, or false if
          // the form is invalid.
          if (_formKey.currentState!.validate()) {
            try {
              var userCredential = await FirebaseAuth.instance
                  .signInWithEmailAndPassword(
                      email: _emailController.text.trim(),
                      password: _passwordController.text.trim());

              if (!context.mounted) return;

              Navigator.popUntil(context, (route) => route.isFirst);

              var user = userCredential.user;
              if (user != null && (user.displayName?.isNotEmpty ?? false)) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const HomePage()));
              } else {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const OnboardingPage()));
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
        child: Text(
          'Submit',
          style: Theme.of(context).textTheme.labelLarge,
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
