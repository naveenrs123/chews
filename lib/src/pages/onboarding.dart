import 'package:chews/src/form_components/form_text_field.dart';
import 'package:chews/src/pages/route_constants.dart';
import 'package:chews/src/pages/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
                  const OnboardingForm(),
                ],
              ),
            )),
      ),
    );
  }
}

class OnboardingForm extends StatefulWidget {
  const OnboardingForm({super.key});

  @override
  State<OnboardingForm> createState() => _OnboardingFormState();
}

class _OnboardingFormState extends State<OnboardingForm> {
  getUserDisplayName() {
    final user = FirebaseAuth.instance.currentUser;

    if (user?.displayName != null) {
      return user!.displayName;
    } else if (user != null && user.providerData.isNotEmpty) {
      return user.providerData.first.displayName;
    } else {
      return null;
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _displayTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var list = [
      FormTextField(
        controller: _displayTextController,
        hintText: 'Enter your display name',
        emptyValidationText: 'Display name cannot be empty',
        initialValue: getUserDisplayName(),
      ),
      ElevatedButton(
        onPressed: () async {
          // Validate will return true if the form is valid, or false if
          // the form is invalid.
          if (_formKey.currentState!.validate()) {
            await FirebaseAuth.instance.currentUser!
                .updateDisplayName(_displayTextController.text.trim());

            if (!context.mounted) return;
          }
        },
        child: Text(
          'Update Display Name',
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
