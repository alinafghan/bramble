import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:journal_app/blocs/theme_cubit/theme_cubit.dart';
import 'package:journal_app/providers/auth_provider/auth_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft02,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
            // child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              ListTile(
                // tileColor: Theme.of(context).colorScheme.surface,
                title: Text('Reminder',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 18,
                    )),
                leading: HugeIcon(
                  icon: HugeIcons.strokeRoundedNotification01,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              ListTile(
                title: Text('Font',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 18,
                    )),
                leading: HugeIcon(
                  icon: HugeIcons.strokeRoundedText,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              BlocBuilder<ThemeCubit, ThemeMode>(
                builder: (context, themeMode) {
                  final isDarkMode = themeMode == ThemeMode.dark;
                  return ListTile(
                    title: Text('Dark Mode',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 18,
                        )),
                    leading: HugeIcon(
                      icon: HugeIcons.strokeRoundedMoon02,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    trailing: Switch(
                      value: isDarkMode,
                      onChanged: (val) {
                        context.read<ThemeCubit>().toggleTheme();
                      },
                      activeColor: Theme.of(context).colorScheme.primary,
                    ),
                  );
                },
              ),
              ListTile(
                title: Text('Export Data',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 18,
                    )),
                leading: HugeIcon(
                  icon: HugeIcons.strokeRoundedFolder01,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              ListTile(
                title: Text('About Us',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 18,
                    )),
                leading: HugeIcon(
                  icon: HugeIcons.strokeRoundedInformationCircle,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                onTap: () {
                  context.push('/home/settings/about');
                },
              ),
              ListTile(
                title: Text('Edit Profile',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 18,
                    )),
                leading: HugeIcon(
                  icon: HugeIcons.strokeRoundedUser,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                onTap: () {
                  context.push('/home/settings/profile');
                },
              ),
              ListTile(
                title: Text('Sign Out',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 18,
                    )),
                leading: HugeIcon(
                  icon: HugeIcons.strokeRoundedLogout01,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        title: (const Text('Sign Out')),
                        content:
                            const Text('Are you sure you want to sign out?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              context.pop();
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              await MyAuthProvider().signOut();
                              if (context.mounted) {
                                context.go('/');
                              }
                            },
                            child: Text(
                              'Sign Out',
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.error),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              ListTile(
                title: Text('Delete Account',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 18,
                    )),
                leading: HugeIcon(
                  icon: HugeIcons.strokeRoundedDelete01,
                  color: Theme.of(context).colorScheme.error,
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        title: (const Text('Delete Account')),
                        content: const Text(
                            'Are you sure you want to delete your account? This action cannot be undone.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              context.pop();
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              //delete account logic
                              context.read<MyAuthProvider>().deleteUser();
                              if (context.mounted) {
                                context.go('/');
                              }
                            },
                            child: Text(
                              'Delete',
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.error),
                            ),
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
