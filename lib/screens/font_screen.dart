import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:journal_app/blocs/font_cubit/font_cubit.dart';

class FontScreen extends StatefulWidget {
  const FontScreen({super.key});

  @override
  State<FontScreen> createState() => _FontScreenState();
}

class _FontScreenState extends State<FontScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Font'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          ListTile(
            title: Text('DoveMayo',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 18,
                )),
            leading: HugeIcon(
              icon: HugeIcons.strokeRoundedTextFont,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onTap: () {
              context.read<FontCubit>().changeFont('DoveMayo');
            },
          ),
          ListTile(
            title: Text('Gaegu',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 18,
                )),
            leading: HugeIcon(
              icon: HugeIcons.strokeRoundedTextFont,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onTap: () {
              context.read<FontCubit>().changeFont('Gaegu');
            },
          ),
          ListTile(
            title: Text('ComingSoon',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 18,
                )),
            leading: HugeIcon(
              icon: HugeIcons.strokeRoundedTextFont,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onTap: () {
              context.read<FontCubit>().changeFont('ComingSoon');
            },
          ),
          ListTile(
            title: Text('Hubballi',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 18,
                )),
            leading: HugeIcon(
              icon: HugeIcons.strokeRoundedTextFont,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onTap: () {
              context.read<FontCubit>().changeFont('Hubballi');
            },
          ),
        ],
      ),
    );
  }
}
