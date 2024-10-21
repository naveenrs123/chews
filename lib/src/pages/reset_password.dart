import 'dart:developer' as dev;

import 'package:chews/src/form_components/auth_validation_message.dart';
import 'package:chews/src/form_components/form_text_field.dart';
import 'package:chews/src/pages/login.dart';
import 'package:chews/src/pages/route_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logging/logging.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

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
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Reset Password?',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    fontFamily: 'SunnySpells',
                    fontSize: 72,
                    color: const Color(0xFFFF707C)),
              ),
              Text('A link will be sent to your email.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .merge(GoogleFonts.quicksand())),
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: ResetPasswordForm(),
              )
            ],
          )),
        ),
      ),
    );
  }
}

class ResetPasswordForm extends StatefulWidget {
  const ResetPasswordForm({super.key});

  @override
  State<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  String _authValidationMessage = '';

  @override
  Widget build(BuildContext context) {
    var list = [
      FormTextField(controller: _emailController),
      AuthValidationMessage(message: _authValidationMessage),
      ElevatedButton(
        onPressed: () async {
          // Validate will return true if the form is valid, or false if
          // the form is invalid.
          if (_formKey.currentState!.validate()) {
            try {
              await FirebaseAuth.instance
                  .sendPasswordResetEmail(email: _emailController.text.trim());

              if (!context.mounted) return;

              Navigator.restorablePushReplacement(
                  context,
                  (context, args) => MaterialPageRoute(
                      builder: (context) => const LoginPage()));
            } on FirebaseAuthException catch (e) {
              setState(() {
                _authValidationMessage = e.message ?? e.code;
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
}
