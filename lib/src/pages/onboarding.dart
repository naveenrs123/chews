import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 64),
              child: Text('Onboarding Page')),
        ),
      ),
    );
  }
}
