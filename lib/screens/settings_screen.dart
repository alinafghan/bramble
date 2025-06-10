import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:journal_app/providers/auth_provider/auth_provider.dart';
import '../utils/constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.pop();
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
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
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
                  context.push('/home/settings/about');
                },
              ),
              ListTile(
                title: const Text('Edit Profile',
                    style: TextStyle(
                        color: AppTheme.text,
                        fontSize: 18,
                        fontFamily: AppTheme.fontFamily)),
                leading: const HugeIcon(
                  icon: HugeIcons.strokeRoundedInformationCircle,
                  color: AppTheme.text,
                ),
                onTap: () {
                  context.push('/home/settings/profile');
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
                              context.pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              await MyAuthProvider().signOut();
                              if (context.mounted) {
                                context.go('/');
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
              ListTile(
                title: const Text('Delete Account',
                    style: TextStyle(
                      color: AppTheme.red,
                      fontSize: 18,
                    )),
                leading: const HugeIcon(
                  icon: HugeIcons.strokeRoundedInformationCircle,
                  color: AppTheme.red,
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: (const Text('Delete Account')),
                        content: const Text(
                            'Are you sure you want to delete your account? This action cannot be undone.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              context.pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              //delete account logic
                              context.read<MyAuthProvider>().deleteUser();
                              if (context.mounted) {
                                context.go('/');
                              }
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );
                  // Add your delete account logic here
                },
              ),
            ]),
      ),
    );
  }
}
