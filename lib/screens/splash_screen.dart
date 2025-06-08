import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:journal_app/models/user.dart';
import 'package:journal_app/providers/auth_provider/auth_provider.dart';
import 'package:journal_app/utils/constants.dart';
import 'package:toastification/toastification.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final MyAuthProvider _provider = MyAuthProvider();

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

    Users? user2 = await _provider.emailSignUp(user, password);

    if (user2 != null && mounted) {
      //TODO//add toast message
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
      primaryColor: AppTheme.backgroundColor,
      foregroundColor: AppTheme.backgroundColor,
      icon: const Icon(HugeIcons.strokeRoundedAlert01),
      backgroundColor: AppTheme.palette2,
      borderRadius: BorderRadius.circular(20.0),
    );
  }

  void signUpWithGoogle() async {
    UserCredential user = await _provider.signUpWithGoogle();
    if (user.user != null) {
      Users user2 = Users(
        userId: user.user!.uid,
        username: user.user!.displayName,
        email: user.user!.email!,
        profileUrl: user.user!.photoURL,
        mod: false,
      );

      await _provider.saveUserToFirestore(user2);

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

    Users? user2 = await _provider.emailSignUp(user, password);

    if (user2 != null && mounted) {
      //TODO//add toast message
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

    User? user = await _provider.emailLogin(emailOrusername, password);

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
                padding: const EdgeInsets.only(top: 80.0),
                child: Image.asset(
                  'assets/bramble_icon.png',
                  height: MediaQuery.of(context).size.height / 5,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 2.5),
                child: Text('Bramble', style: TextStyle(fontSize: 36)),
              ),
              TabBar(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                indicatorColor: AppTheme.palette3,
                dividerColor: Colors.transparent,
                dividerHeight: 0,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorPadding:
                    const EdgeInsets.symmetric(horizontal: 60.0, vertical: 4.0),
                indicator: BoxDecoration(
                    color: AppTheme.palette3,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(20.0)),
                labelColor: AppTheme.white,
                unselectedLabelColor: AppTheme.text,
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
                              controller: emailOrUsernameController,
                              decoration: const InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                    borderSide: BorderSide(
                                      color: AppTheme.palette3,
                                    )),
                                floatingLabelStyle:
                                    TextStyle(color: AppTheme.palette3),
                                label: Text('Email/Username'),
                                hintText: 'Awesome Possum',
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                                border: OutlineInputBorder(
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
                              decoration: const InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                    borderSide: BorderSide(
                                      color: AppTheme.palette3,
                                    )),
                                floatingLabelStyle:
                                    TextStyle(color: AppTheme.palette3),
                                label: Text('Password'),
                                hintText: '',
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                ),
                              ),
                            ),
                          ),
                          TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor: AppTheme.palette3),
                              onPressed: () {
                                logIn();
                              },
                              child: const Text(
                                'Log In',
                                style:
                                    TextStyle(color: AppTheme.backgroundColor),
                              ))
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
                              decoration: const InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                    borderSide: BorderSide(
                                      color: AppTheme.palette3,
                                    )),
                                floatingLabelStyle:
                                    TextStyle(color: AppTheme.palette3),
                                label: Text('Username'),
                                hintText: 'Awesome Possum',
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                                border: OutlineInputBorder(
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
                              controller: emailController,
                              decoration: const InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                    borderSide: BorderSide(
                                      color: AppTheme.palette3,
                                    )),
                                floatingLabelStyle:
                                    TextStyle(color: AppTheme.palette3),
                                label: Text('Email'),
                                hintText: 'abc@xyz.com',
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                                border: OutlineInputBorder(
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
                              decoration: const InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                    borderSide: BorderSide(
                                      color: AppTheme.palette3,
                                    )),
                                floatingLabelStyle:
                                    TextStyle(color: AppTheme.palette3),
                                label: Text('Password'),
                                hintText: '',
                                helperText: 'Must have atleast six characters',
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                                border: OutlineInputBorder(
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
                                      backgroundColor: AppTheme.palette3),
                                  onPressed: () {
                                    signUp();
                                  },
                                  child: const Text(
                                    'Sign Up',
                                    style: TextStyle(
                                        color: AppTheme.backgroundColor),
                                  )),
                              OutlinedButton(
                                  // style: TextButton.styleFrom(
                                  //     tapTargetSize:
                                  //         MaterialTapTargetSize.shrinkWrap,
                                  //     backgroundColor: AppTheme.palette3),
                                  onPressed: () {
                                    signUpAsModerator();
                                  },
                                  child: const Text(
                                    'Sign Up As Moderator',
                                    style: TextStyle(color: AppTheme.text),
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
                              label: const Text(
                                'Continue With Google',
                                style: TextStyle(color: AppTheme.text),
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
