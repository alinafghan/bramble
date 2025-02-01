import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class PopupMenu2 extends StatefulWidget {
  const PopupMenu2({super.key});

  @override
  PopupMenuState2 createState() => PopupMenuState2();
}

class PopupMenuState2 extends State<PopupMenu2> {
  String _selectedValue = 'Edit'; // To track the selected value

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      position: PopupMenuPosition.under,
      popUpAnimationStyle: AnimationStyle.noAnimation,
      child: const HugeIcon(
        icon: HugeIcons.strokeRoundedMoreVertical,
        color: Colors.black,
        size: 18,
      ),
      onSelected: (value) {
        setState(() {
          _selectedValue = value; // Update the selected value
        });
      },
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
        ),
        PopupMenuItem<String>(
          value: 'Share',
          child: Row(
            spacing: 8,
            children: [
              HugeIcon(
                icon: HugeIcons.strokeRoundedShare08,
                color: _selectedValue == 'Share' ? Colors.grey : Colors.black,
              ),
              Text(
                'Share',
                style: TextStyle(
                  fontFamily: 'Dovemayo',
                  color: _selectedValue == 'Share'
                      ? Colors.grey
                      : Colors.black, // Change color if selected
                ),
              ),
            ],
          ),
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
        ),
      ],
    );
  }
}
