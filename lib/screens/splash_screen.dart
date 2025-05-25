import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 12,
        children: [
          const Text('Bramble', style: TextStyle(fontSize: 36)),
          TextButton(
              onPressed: () {
                context.go('/login');
              },
              child: const Text(
                'Log In',
                style: TextStyle(fontSize: 24),
              )),
          TextButton(
            onPressed: () {
              context.go('/signup');
            },
            child: const Text(
              'Sign up',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
          )
        ],
      )),
    );
  }
}
