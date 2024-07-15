import 'package:chews/src/sample_feature/sample_item_list_view.dart';
import 'package:chews/src/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static const routeName = '/login';

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
                      "Log In",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ),
                  LoginForm(),
                ],
              )),
            ),
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
              controller: _passwordController,
              obscureText: true,
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
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () async {
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                if (_formKey.currentState!.validate()) {
                  try {
                    final _ = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: _usernameController.text.trim(),
                            password: _passwordController.text.trim());

                    if (!context.mounted) return;

                    Navigator.pushReplacementNamed(
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
