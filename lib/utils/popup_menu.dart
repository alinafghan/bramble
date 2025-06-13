import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

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
      color: Theme.of(context).colorScheme.surface,
      position: PopupMenuPosition.under,
      popUpAnimationStyle: AnimationStyle.noAnimation,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          HugeIcon(
            icon: _selectedValue == 'Book'
                ? HugeIcons.strokeRoundedBooks01
                : HugeIcons.strokeRoundedHome05,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          HugeIcon(
            icon: HugeIcons.strokeRoundedArrowDown01,
            color: Theme.of(context).colorScheme.onSurface,
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
                        ? Theme.of(context).colorScheme.onSurface
                        : Theme.of(context)
                            .colorScheme
                            .onSurfaceVariant // Change color if selected
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
                        ? Theme.of(context).colorScheme.onSurface
                        : Theme.of(context)
                            .colorScheme
                            .onSurfaceVariant // Change color if selected
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
                          ? Theme.of(context).colorScheme.onSurface
                          : Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant // Change color if selected
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
