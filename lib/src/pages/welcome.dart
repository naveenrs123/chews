import 'package:chews/src/pages/onboarding.dart';
import 'package:chews/src/pages/reset_password.dart';
import 'package:chews/src/pages/route_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../form_components/welcome_button.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Chews',
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    fontFamily: 'SunnySpells',
                    fontSize: 128,
                    color: const Color(0xFFFF707C))),
            const WelcomeButton(text: 'Log In', route: RouteConstants.login),
            const WelcomeButton(text: 'Sign Up', route: RouteConstants.signUp),
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                child: ElevatedButton(
                    onPressed: () async {
                      if (kIsWeb) {
                        GoogleAuthProvider googleProvider =
                            GoogleAuthProvider();

                        googleProvider.addScope(
                            'https://www.googleapis.com/auth/contacts.readonly');
                        googleProvider.setCustomParameters(
                            {'login_hint': 'user@example.com'});

                        await FirebaseAuth.instance
                            .signInWithPopup(googleProvider);
                      } else {
                        // Trigger the authentication flow
                        final GoogleSignInAccount? googleUser =
                            await GoogleSignIn().signIn();

                        // Obtain the auth details from the request
                        final GoogleSignInAuthentication? googleAuth =
                            await googleUser?.authentication;

                        // Create a new credential
                        final credential = GoogleAuthProvider.credential(
                          accessToken: googleAuth?.accessToken,
                          idToken: googleAuth?.idToken,
                        );

                        // Once signed in, return the UserCredential
                        await FirebaseAuth.instance
                            .signInWithCredential(credential);
                      }

                      if (!context.mounted) return;

                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const OnboardingPage()));
                    },
                    child: Text(
                      'Sign in with Google',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ))),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ResetPasswordPage()));
                  },
                  child: Text(
                    'Forgot your password?',
                    style: Theme.of(context).textTheme.labelLarge,
                  )),
            ),
          ],
        ),
      ),
    ));
  }
}
