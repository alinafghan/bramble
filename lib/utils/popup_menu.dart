import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:journal_app/utils/constants.dart';

class PopupMenu extends StatefulWidget {
  final String selectedVal;
  final bool isModerator;
  const PopupMenu(
      {super.key, required this.selectedVal, required this.isModerator});

  @override
  PopupMenuState createState() => PopupMenuState();
}

class PopupMenuState extends State<PopupMenu> {
  late String _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.selectedVal;
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
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
      itemBuilder: (context) {
        final List<PopupMenuEntry<String>> menuItems = [
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
              context.push('/home');
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
              context.push('/booklist');
            },
          ),
        ];
        if (widget.isModerator) {
          menuItems.add(
            PopupMenuItem<String>(
              value: 'Reviews',
              onTap: () {
                context.push('/reviews');
              },
              child: Center(
                child: Text(
                  'Reviews',
                  style: TextStyle(
                    fontFamily: 'Dovemayo',
                    color: _selectedValue == 'Reviews'
                        ? Colors.grey
                        : Colors.black, // Change color if selected
                  ),
                ),
              ),
            ),
          );
        }
        return menuItems;
      },
    );
  }
}
