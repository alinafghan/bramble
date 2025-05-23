import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:journal_app/screens/booklist_screen.dart';
import 'package:journal_app/screens/home_screen.dart';
import 'package:journal_app/utils/constants.dart';

class PopupMenu extends StatefulWidget {
  final String selectedVal;
  const PopupMenu({super.key, required this.selectedVal});

  @override
  PopupMenuState createState() => PopupMenuState();
}

class PopupMenuState extends State<PopupMenu> {
  late String _selectedValue; // To track the selected value

  @override
  void initState() {
    super.initState();
    _selectedValue =
        widget.selectedVal; // Initialize _selectedValue with widget.selectedVal
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PopupMenuButton<String>(
        color: AppTheme.backgroundColor,
        position: PopupMenuPosition.under,
        popUpAnimationStyle: AnimationStyle.noAnimation,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            HugeIcon(
              icon: _selectedValue == 'Book'
                  ? HugeIcons.strokeRoundedBooks01
                  : HugeIcons.strokeRoundedHome05,
              color: AppTheme.text,
            ),
            const HugeIcon(
              icon: HugeIcons.strokeRoundedArrowDown01,
              color: Colors.black,
              size: 24,
            ),
          ],
        ),
        itemBuilder: (context) => [
          PopupMenuItem<String>(
            value: 'Diary',
            child: Center(
              child: Text(
                'Diary',
                style: TextStyle(
                  fontFamily: 'Dovemayo',
                  color: _selectedValue == 'Diary'
                      ? Colors.grey
                      : Colors.black, // Change color if selected
                ),
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              );
            },
          ),
          PopupMenuItem<String>(
            value: 'Book',
            child: Center(
              child: Text(
                'Book',
                style: TextStyle(
                  fontFamily: 'Dovemayo',
                  color: _selectedValue == 'Book'
                      ? Colors.grey
                      : Colors.black, // Change color if selected
                ),
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BooklistScreen(),
                ),
              );
            },
          ),
          PopupMenuItem<String>(
            value: 'Movie',
            child: Center(
              child: Text(
                'Movie',
                style: TextStyle(
                  fontFamily: 'Dovemayo',
                  color: _selectedValue == 'Movie'
                      ? Colors.grey
                      : Colors.black, // Change color if selected
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
