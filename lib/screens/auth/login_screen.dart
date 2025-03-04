import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
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
          authProvider.isLoading
              ? const CircularProgressIndicator()
              : SignInButton(
                  Buttons.google,
                  text: "Sign up with Google",
                  onPressed: () async {
                    try {
                      await authProvider.signInWithGoogle();
                      if (context.mounted) {
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/home', (_) => false);
                      }
                    } catch (e) {
                      if (context.mounted) {
                        Logger().e(e);
                      }
                    }
                  },
                )
        ],
      ),
    ));
  }
}
