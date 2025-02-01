import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:journal_app/providers/auth_provider/auth_provider.dart';
import 'package:journal_app/screens/splash_screen.dart';
import '../utils/constants.dart';
import 'about_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft02,
            color: AppTheme.text,
          ),
        ),
        centerTitle: true,
        title: const Text('Settings',
            style: TextStyle(
                color: AppTheme.text, fontFamily: AppTheme.fontFamily)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
            // child: Column(
            children: [
              Container(
                width: 360,
                height: 140,
                padding: const EdgeInsets.all(50),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppTheme.backgroundColor,
                ),
                child: const Text(
                  'Hey, there!',
                  style: TextStyle(
                      color: Color.fromARGB(255, 225, 225, 225),
                      fontSize: 18,
                      fontFamily: AppTheme.fontFamily),
                ),
              ),
              const ListTile(
                title: Text('Reminder',
                    style: TextStyle(
                        color: AppTheme.text,
                        fontSize: 18,
                        fontFamily: AppTheme.fontFamily)),
                leading: HugeIcon(
                  icon: HugeIcons.strokeRoundedNotification01,
                  color: AppTheme.text,
                ),
              ),
              const ListTile(
                title: Text('Font',
                    style: TextStyle(
                        color: AppTheme.text,
                        fontSize: 18,
                        fontFamily: AppTheme.fontFamily)),
                leading: HugeIcon(
                  icon: HugeIcons.strokeRoundedText,
                  color: AppTheme.text,
                ),
              ),
              const ListTile(
                title: Text('Dark Mode',
                    style: TextStyle(
                        color: AppTheme.text,
                        fontSize: 18,
                        fontFamily: AppTheme.fontFamily)),
                leading: HugeIcon(
                  icon: HugeIcons.strokeRoundedMoon02,
                  color: AppTheme.text,
                ),
              ),
              const ListTile(
                title: Text('Export Data',
                    style: TextStyle(
                        color: AppTheme.text,
                        fontSize: 18,
                        fontFamily: AppTheme.fontFamily)),
                leading: HugeIcon(
                  icon: HugeIcons.strokeRoundedFolder01,
                  color: AppTheme.text,
                ),
              ),
              ListTile(
                title: const Text('About Us',
                    style: TextStyle(
                        color: AppTheme.text,
                        fontSize: 18,
                        fontFamily: AppTheme.fontFamily)),
                leading: const HugeIcon(
                  icon: HugeIcons.strokeRoundedInformationCircle,
                  color: AppTheme.text,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AboutScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text('Sign Out',
                    style: TextStyle(
                      color: AppTheme.text,
                      fontSize: 18,
                    )),
                leading: const HugeIcon(
                  icon: HugeIcons.strokeRoundedInformationCircle,
                  color: AppTheme.text,
                ),
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: (const Text('Sign Out')),
                        content:
                            const Text('Are you sure you want to sign out?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              await MyAuthProvider().signOut();
                              if (context.mounted) {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SplashScreen()),
                                  (Route<dynamic> route) => false,
                                );
                              }
                            },
                            child: const Text('Sign Out'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ]),
      ),
    );
  }
}
