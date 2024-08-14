import 'package:chews/src/pages/route_constants.dart';
import 'package:flutter/material.dart';

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
      body: const SafeArea(
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 64),
              child: Text('Reset Password Page')),
        ),
      ),
    );
  }
}
