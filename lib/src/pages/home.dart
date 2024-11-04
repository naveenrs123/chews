import 'package:chews/src/pages/route_constants.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, RouteConstants.settings);
            },
            icon: const Icon(Icons.settings)),
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
