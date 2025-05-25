import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:journal_app/blocs/get_review_for_book/cubit/task_cubit_cubit.dart';
import 'package:journal_app/blocs/set_journal_bloc/set_journal_bloc.dart';
import 'package:journal_app/utils/constants.dart';

class PopupMenu2 extends StatefulWidget {
  final String date;
  final String selectedVal = 'None'; // Default selected value
  final VoidCallback onEdit;
  const PopupMenu2({super.key, required this.date, required this.onEdit});

  @override
  PopupMenuState2 createState() => PopupMenuState2();
}

class PopupMenuState2 extends State<PopupMenu2> {
  String _selectedValue = 'None'; // To track the selected value

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      color: AppTheme.backgroundColor,
      position: PopupMenuPosition.under,
      popUpAnimationStyle: AnimationStyle.noAnimation,
      child: const HugeIcon(
        icon: HugeIcons.strokeRoundedMoreVertical,
        color: Colors.black,
        size: 18,
      ),
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: 'Edit',
          child: Row(
            spacing: 8,
            children: [
              HugeIcon(
                icon: HugeIcons.strokeRoundedPencilEdit01,
                color: _selectedValue == 'Edit' ? Colors.grey : Colors.black,
              ),
              Text(
                'Edit',
                style: TextStyle(
                  fontFamily: 'Dovemayo',
                  color: _selectedValue == 'Edit'
                      ? Colors.grey
                      : Colors.black, // Change color if selected
                ),
              ),
            ],
          ),
          onTap: () {
            context.read<TaskCubitCubit>().editTextfield();
          },
        ),
        PopupMenuItem<String>(
            value: 'Delete',
            child: Row(
              spacing: 8,
              children: [
                HugeIcon(
                  icon: HugeIcons.strokeRoundedDelete02,
                  color: _selectedValue == 'Delete'
                      ? const Color.fromARGB(255, 165, 64, 64)
                      : const Color.fromARGB(255, 105, 3, 3),
                ),
                Text(
                  'Delete',
                  style: TextStyle(
                    fontFamily: 'Dovemayo',
                    color: _selectedValue == 'Delete'
                        ? const Color.fromARGB(255, 165, 64, 64)
                        : const Color.fromARGB(
                            255, 105, 3, 3), // Change color if selected
                  ),
                ),
              ],
            ),
            onTap: () {
              context.read<SetJournalBloc>().add(
                    DeleteJournal(date: widget.date),
                  );
              context.pop();
            }),
      ],
    );
  }
}
