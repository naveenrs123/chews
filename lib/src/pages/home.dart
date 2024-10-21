import 'package:chews/src/pages/route_constants.dart';
import 'package:chews/src/pages/welcome.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
              Navigator.restorablePushReplacement(
                  context,
                  (context, args) => MaterialPageRoute(
                      builder: (context) => const WelcomePage()));
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 64),
              child: Text('Home Page',
                  style: Theme.of(context).textTheme.displaySmall)),
        ),
      ),
    );
  }
}
