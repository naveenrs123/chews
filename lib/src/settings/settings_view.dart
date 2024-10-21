import 'package:chews/src/form_components/form_text_field.dart';
import 'package:chews/src/pages/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'settings_controller.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatelessWidget {
  const SettingsView({super.key, required this.controller});

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();

                if (!context.mounted) return;

                Navigator.restorablePushReplacement(
                    context,
                    (context, args) => MaterialPageRoute(
                        builder: (context) => const WelcomePage()));
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        // Glue the SettingsController to the theme selection DropdownButton.
        //
        // When a user selects a theme from the dropdown list, the
        // SettingsController is updated, which rebuilds the MaterialApp.
        child: Column(
          children: [
            DropdownButton<ThemeMode>(
              // Read the selected themeMode from the controller
              value: controller.themeMode,
              // Call the updateThemeMode method any time the user selects a theme.
              onChanged: controller.updateThemeMode,
              items: const [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text('System Theme'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text('Light Theme'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text('Dark Theme'),
                )
              ],
            ),
            const UserSettingsForm()
          ],
        ),
      ),
    );
  }
}

class UserSettingsForm extends StatefulWidget {
  const UserSettingsForm({super.key});

  @override
  State<UserSettingsForm> createState() => _UserSettingsFormState();
}

class _UserSettingsFormState extends State<UserSettingsForm> {
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
      const Text('Display Name'),
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
          }
        },
        child: Text(
          'Update User Settings',
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
