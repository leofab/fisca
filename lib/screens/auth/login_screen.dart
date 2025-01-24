import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Fisca',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          const SizedBox(height: 240),
          const Text('Login',
              style: TextStyle(fontSize: 18, color: Colors.black)),
          const SizedBox(height: 24),
          SignInButton(
            Buttons.google,
            text: "Sign up with Google",
            onPressed: () {},
          )
        ],
      ),
    ));
  }
}
