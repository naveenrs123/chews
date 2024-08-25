import 'package:chews/src/pages/route_constants.dart';
import 'package:chews/src/pages/welcome.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, RouteConstants.settings);
            },
            icon: const Icon(Icons.settings)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const WelcomePage()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 64),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Let\'s get you set up!',
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        fontFamily: 'SunnySpells',
                        color: const Color(0xFFFF707C)),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
