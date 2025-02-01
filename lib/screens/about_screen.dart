import 'package:flutter/material.dart';
// import 'package:intl/intl.dart'; // For formatting the date
import '../utils/constants.dart';
import 'package:hugeicons/hugeicons.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
        title: const Text('About Us',
            style: TextStyle(
                color: AppTheme.text, fontFamily: AppTheme.fontFamily)),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Align(
            alignment: Alignment.topCenter,
            child: Text(
              'Hello. We\'re happy to have you here. This is an app made for fun by Alina, inspired by the Haema journalling app. Happy journalling!',
              style: TextStyle(
                fontFamily: AppTheme.fontFamily,
                fontSize: 18,
                color: AppTheme.text,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
