import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:journal_app/models/user.dart';
import 'package:journal_app/providers/auth_provider/auth_provider.dart';
import 'package:toastification/toastification.dart';

class SplashScreen extends StatefulWidget {
  final MyAuthProvider _provider;

  SplashScreen({
    super.key,
    MyAuthProvider? provider,
  }) : _provider = provider ?? MyAuthProvider();

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  TextEditingController emailOrUsernameController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();
  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    emailOrUsernameController.dispose();
    loginPasswordController.dispose();
    super.dispose();
  }

  void signUp() async {
    String username = usernameController.text;
    String email = emailController.text;
    String password = passwordController.text;

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      showSnackBar('Please fill all fields');
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      showSnackBar('Please enter a valid email address');
      return;
    }

    if (password.length < 6) {
      showSnackBar('Password must be at least 6 characters');
      return;
    }

    Users user = Users(
        userId: '',
        mod: false,
        username: username,
        email: email,
        savedBooks: []);

    Users? user2 = await widget._provider.emailSignUp(user, password);

    if (user2 != null && mounted) {
      context.go('/home');
    }
  }

  void showSnackBar(String message) {
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text(message)),
    // );
    toastification.show(
      context: context,
      type: ToastificationType.warning,
      style: ToastificationStyle.flat,
      title: const Text("Warning"),
      description: Text(message),
      alignment: Alignment.bottomCenter,
      autoCloseDuration: const Duration(seconds: 3),
      primaryColor: Theme.of(context).colorScheme.surface,
      foregroundColor: Theme.of(context).colorScheme.surface,
      icon: const Icon(HugeIcons.strokeRoundedAlert01),
      backgroundColor: Theme.of(context).colorScheme.secondary,
      borderRadius: BorderRadius.circular(20.0),
    );
  }

  void signUpWithGoogle() async {
    UserCredential user = await widget._provider.signUpWithGoogle();
    if (user.user != null) {
      Users user2 = Users(
        userId: user.user!.uid,
        username: user.user!.displayName,
        email: user.user!.email!,
        profileUrl: user.user!.photoURL,
        mod: false,
      );

      await widget._provider.saveUserToFirestore(user2);

      if (mounted) {
        context.go('/home');
      }
    }
  }

  void signUpAsModerator() async {
    String username = usernameController.text;
    String email = emailController.text;
    String password = passwordController.text;

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      showSnackBar('Please fill all fields');
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      showSnackBar('Please enter a valid email address');
      return;
    }

    if (password.length < 6) {
      showSnackBar('Password must be at least 6 characters');
      return;
    }

    Users user = Users(
        userId: '',
        mod: true,
        username: username,
        email: email,
        savedBooks: []);

    Users? user2 = await widget._provider.emailSignUp(user, password);

    if (user2 != null && mounted) {
      context.go('/home');
    }
  }

  void logIn() async {
    String emailOrusername = emailOrUsernameController.text;
    String password = loginPasswordController.text;

    if (emailOrusername.isEmpty || password.isEmpty) {
      showSnackBar('Please fill all fields');
      return;
    }

    if (password.length < 6) {
      showSnackBar('Password must be at least 6 characters');
      return;
    }

    User? user = await widget._provider.emailLogin(emailOrusername, password);

    if (user != null && mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 80.0,
                ),
                child: Image.asset(
                  'assets/bramble_icon.png',
                  height: MediaQuery.of(context).size.height / 5,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 3),
                child: Text('Bramble', style: TextStyle(fontSize: 36)),
              ),
              TabBar(
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                indicatorColor: Theme.of(context).colorScheme.primary,
                dividerColor: Colors.transparent,
                dividerHeight: 0,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorPadding:
                    const EdgeInsets.symmetric(horizontal: 60.0, vertical: 4.0),
                indicator: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(20.0)),
                labelColor: Colors.white,
                unselectedLabelColor: Theme.of(context).colorScheme.onSurface,
                tabs: const [
                  Tab(
                    text: 'Log In',
                  ),
                  Tab(
                    text: 'Sign Up',
                  )
                ],
              ),
              Expanded(
                child: TabBarView(children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: TextField(
                              key: const Key('email/username'),
                              controller: emailOrUsernameController,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12)),
                                    borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    )),
                                floatingLabelStyle: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                                label: const Text('Email/Username'),
                                hintText: 'Awesome Possum',
                                hintStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                                bottom: 20.0,
                                top: 10.0),
                            child: TextField(
                              controller: loginPasswordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12)),
                                    borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    )),
                                floatingLabelStyle: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                                label: const Text('Password'),
                                hintText: '',
                                hintStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                ),
                              ),
                            ),
                          ),
                          TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary),
                              onPressed: () {
                                logIn();
                              },
                              child: Text(
                                'Log In',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.surface),
                              )),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 15.0),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Divider(
                                  indent: 20,
                                )),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text('OR'),
                                ),
                                Expanded(
                                    child: Divider(
                                  endIndent: 20,
                                )),
                              ],
                            ),
                          ),
                          OutlinedButton.icon(
                              icon: Image.asset('assets/google_icon.png',
                                  height: 24, width: 24),
                              onPressed: () {
                                signUpWithGoogle();
                              },
                              label: Text(
                                'Continue With Google',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                              )),
                        ],
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: TextField(
                              controller: usernameController,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12)),
                                    borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    )),
                                floatingLabelStyle: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                                label: const Text('Username'),
                                hintText: 'Awesome Possum',
                                hintStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, right: 20.0, bottom: 20.0),
                            child: TextField(
                              key: const Key('email textfield'),
                              controller: emailController,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12)),
                                    borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    )),
                                floatingLabelStyle: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                                label: const Text('Email'),
                                hintText: 'abc@xyz.com',
                                hintStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, right: 20.0, bottom: 20.0),
                            child: TextField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12)),
                                    borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    )),
                                floatingLabelStyle: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                                label: const Text('Password'),
                                hintText: '',
                                helperText: 'Must have atleast six characters',
                                hintStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                  style: TextButton.styleFrom(
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                  onPressed: () {
                                    signUp();
                                  },
                                  child: Text(
                                    'Sign Up',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface),
                                  )),
                              OutlinedButton(
                                  // style: TextButton.styleFrom(
                                  //     tapTargetSize:
                                  //         MaterialTapTargetSize.shrinkWrap,
                                  //     backgroundColor: Theme.of(context).colorScheme.primary),
                                  onPressed: () {
                                    signUpAsModerator();
                                  },
                                  child: Text(
                                    'Sign Up As Moderator',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface),
                                  )),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 15.0),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Divider(
                                  indent: 20,
                                )),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text('OR'),
                                ),
                                Expanded(
                                    child: Divider(
                                  endIndent: 20,
                                )),
                              ],
                            ),
                          ),
                          OutlinedButton.icon(
                              icon: Image.asset('assets/google_icon.png',
                                  height: 24, width: 24),
                              onPressed: () {
                                signUpWithGoogle();
                              },
                              label: Text(
                                'Continue With Google',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                              )),
                        ],
                      ),
                    ),
                  ),
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
