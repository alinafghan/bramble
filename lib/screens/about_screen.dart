import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
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
        title: Text(
          'About Us',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Align(
            alignment: Alignment.topCenter,
            child: Text(
              'Hello. We\'re happy to have you here. This is an app made for fun by Alina, inspired by the Haema journalling app. Happy journalling!',
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
