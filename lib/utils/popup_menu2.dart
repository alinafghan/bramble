import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:journal_app/blocs/cubit/task_cubit_cubit.dart';
import 'package:journal_app/blocs/journal_bloc/journal_bloc.dart';

class PopupMenu2 extends StatefulWidget {
  final String date;
  final String selectedVal = 'None'; // Default selected value
  final VoidCallback onEdit;
  const PopupMenu2({super.key, required this.date, required this.onEdit});

  @override
  PopupMenuState2 createState() => PopupMenuState2();
}

class PopupMenuState2 extends State<PopupMenu2> {
  final String _selectedValue = 'None'; // To track the selected value

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      color: Theme.of(context).colorScheme.surface,
      position: PopupMenuPosition.under,
      popUpAnimationStyle: AnimationStyle.noAnimation,
      child: HugeIcon(
        icon: HugeIcons.strokeRoundedMoreVertical,
        color: Theme.of(context).colorScheme.onSurface,
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
                  color: _selectedValue == 'Edit'
                      ? Theme.of(context).colorScheme.onSurface
                      : Theme.of(context).colorScheme.onSurfaceVariant),
              Text(
                'Edit',
                style: TextStyle(
                    color: _selectedValue == 'Edit'
                        ? Theme.of(context).colorScheme.onSurface
                        : Theme.of(context)
                            .colorScheme
                            .onSurfaceVariant // Change color if selected
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
                    color: _selectedValue == 'Delete'
                        ? const Color.fromARGB(255, 165, 64, 64)
                        : const Color.fromARGB(
                            255, 105, 3, 3), // Change color if selected
                  ),
                ),
              ],
            ),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      title: (const Text('Delete Journal')),
                      content: const Text(
                          'Are you sure you want to delete this journal entry? This action cannot be undone.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            context.pop();
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            context.read<JournalBloc>().add(
                                  DeleteJournal(date: widget.date),
                                );
                            context.pop();
                          },
                          child: Text(
                            'Delete',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.error),
                          ),
                        ),
                      ],
                    );
                  });
            }),
      ],
    );
  }
}
