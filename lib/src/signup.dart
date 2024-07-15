import 'package:chews/src/sample_feature/sample_item_list_view.dart';
import 'package:chews/src/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  static const routeName = '/signup';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.restorablePopAndPushNamed(
                      context, WelcomePage.routeName);
                },
                icon: const Icon(Icons.arrow_back))),
        body: const SafeArea(
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 64),
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 64),
                    child: Text(
                      "Sign Up",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SignUpForm(),
                ],
              )),
            ),
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                hintText: 'Enter your email',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Email cannot be empty';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: TextFormField(
              obscureText: true,
              controller: _passwordController,
              decoration: const InputDecoration(
                hintText: 'Enter your password',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Password cannot be empty';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Confirm your password',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Password cannot be empty';
                }

                if (_passwordController.text != value) {
                  return 'Passwords must match';
                }

                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () async {
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                if (_formKey.currentState!.validate()) {
                  try {
                    final credential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: _usernameController.text.trim(),
                            password: _passwordController.text.trim());

                    if (!context.mounted) return;

                    Navigator.restorablePushReplacementNamed(
                        context, SampleItemListView.routeName);
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'invalid-email') {
                      print('Invalid email');
                    } else {
                      print(e);
                    }
                  } catch (e) {
                    print(e);
                  }
                }
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
