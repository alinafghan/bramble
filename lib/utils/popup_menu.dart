import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:journal_app/blocs/add_book_bloc/add_book_bloc.dart';
import 'package:journal_app/blocs/add_book_cubit/add_book_cubit.dart';
import 'package:journal_app/blocs/remove_book_cubit/remove_book_cubit.dart';
import 'package:journal_app/blocs/get_library_bloc/get_library_bloc.dart';
import 'package:journal_app/providers/book_provider/book_provider.dart';
import 'package:journal_app/providers/library_provider/library_provider.dart';
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
        child: const HugeIcon(
          icon: HugeIcons.strokeRoundedArrowDown01,
          color: Colors.black,
          size: 24,
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
                  builder: (context) => MultiBlocProvider(
                    providers: [
                      BlocProvider<GetLibraryBloc>(
                        create: (context) => GetLibraryBloc(
                          provider: LibraryProvider(),
                        ),
                      ),
                      BlocProvider(
                        create: (context) =>
                            AddBookCubit(provider: BookListProvider()),
                      ),
                      BlocProvider(
                          create: (context) =>
                              RemoveBookCubit(provider: BookListProvider()))
                    ],
                    child: const BooklistScreen(),
                  ),
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
