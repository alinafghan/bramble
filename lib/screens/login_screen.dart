import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:journal_app/providers/auth_provider/auth_provider.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final MyAuthProvider _auth = MyAuthProvider();

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailOrUsernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    emailOrUsernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void logIn() async {
    String emailOrusername = emailOrUsernameController.text;
    String password = passwordController.text;

    User? user = await _auth.emailLogin(emailOrusername, password);

    if (user != null && mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const Text('Log In'),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: emailOrUsernameController,
                decoration: const InputDecoration(
                  label: Text('Email/Username'),
                  hintText: 'Awesome Possum',
                  hintStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  label: Text('Password'),
                  hintText: '',
                  hintStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
            ),
            TextButton(
                onPressed: () {
                  logIn();
                },
                child: const Text('Log In'))
          ],
        ),
      )),
    );
  }
}
