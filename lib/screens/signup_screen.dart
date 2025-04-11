import 'package:flutter/material.dart';
import 'package:journal_app/models/user.dart';
import 'package:journal_app/providers/auth_provider/auth_provider.dart';
import 'package:journal_app/screens/login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final MyAuthProvider _provider = MyAuthProvider();

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void signUp() async {
    String username = usernameController.text;
    String email = emailController.text;
    String password = passwordController.text;

    Users user =
        Users(userId: '', username: username, email: email, savedBooks: []);

    Users? user2 = await _provider.emailSignUp(user, password);

    if (user2 != null && mounted) {
      //TODO//add toast message
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
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
            const Text('Sign Up'),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  label: Text('Username'),
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
                controller: emailController,
                decoration: const InputDecoration(
                  label: Text('Email'),
                  hintText: 'abc@xyz.com',
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
                  helperText: 'Must have atleast six characters',
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
                  signUp();
                },
                child: const Text('Sign Up')),
            TextButton(
                onPressed: () {
                  signUp();
                },
                child: const Text('Sign Up With Google')),
          ],
        ),
      )),
    );
  }
}
