import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:intl/intl.dart'; // For formatting the date
import 'package:journal_app/blocs/calendar_bloc/calendar_bloc.dart';
import 'package:journal_app/blocs/get_journal_bloc/get_journal_bloc.dart';
import 'package:journal_app/blocs/mood_bloc/mood_bloc.dart';
import 'package:journal_app/blocs/set_journal_bloc/set_journal_bloc.dart';
import 'package:journal_app/models/mood.dart';
import 'package:journal_app/providers/journal_provider/journal_provider.dart';
import 'package:journal_app/utils/popup_menu.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:hugeicons/hugeicons.dart';
import '../utils/constants.dart';
import 'journal_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MoodBloc>().add(GetMonthlyMoodEvent(DateTime.now()));
    // context.read<CalendarBloc>().add(ChangeFocusedMonth(DateTime.now()));
  }

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    Map<DateTime, String> moodMap = {};

    void moodDialog(DateTime selectedDay, Map<DateTime, String> moodMap) {
      final normalizedDate =
          DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
      if (moodMap.containsKey(normalizedDate)) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
                providers: [
                  BlocProvider<SetJournalBloc>(
                    create: (context) => SetJournalBloc(
                      provider: JournalProvider(),
                    ),
                  ),
                  BlocProvider<GetJournalBloc>(
                    create: (context) => GetJournalBloc(
                      provider: JournalProvider(),
                    ),
                  ),
                ],
                child: KeyboardVisibilityProvider(
                  child: JournalScreen(selectedDate: selectedDay),
                )),
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Select Mood'),
              content: SingleChildScrollView(
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.read<MoodBloc>().add(SetMoodEvent(Mood(
                              date: selectedDay,
                              mood: 'assets/moods/sipping_mug.png',
                            )));
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MultiBlocProvider(
                                providers: [
                                  BlocProvider<SetJournalBloc>(
                                    create: (context) => SetJournalBloc(
                                      provider: JournalProvider(),
                                    ),
                                  ),
                                  BlocProvider<GetJournalBloc>(
                                    create: (context) => GetJournalBloc(
                                      provider: JournalProvider(),
                                    ),
                                  ),
                                ],
                                child: KeyboardVisibilityProvider(
                                  child:
                                      JournalScreen(selectedDate: selectedDay),
                                )),
                          ),
                        );
                      },
                      child: Image.asset(
                        'assets/moods/sipping_mug.png',
                        height: 100,
                        width: 100,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.read<MoodBloc>().add(SetMoodEvent(Mood(
                              date: selectedDay,
                              mood: 'assets/moods/sipping_mug.png',
                            )));
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MultiBlocProvider(
                                providers: [
                                  BlocProvider<SetJournalBloc>(
                                    create: (context) => SetJournalBloc(
                                      provider: JournalProvider(),
                                    ),
                                  ),
                                  BlocProvider<GetJournalBloc>(
                                    create: (context) => GetJournalBloc(
                                      provider: JournalProvider(),
                                    ),
                                  ),
                                ],
                                child: KeyboardVisibilityProvider(
                                  child:
                                      JournalScreen(selectedDate: selectedDay),
                                )),
                          ),
                        );
                      },
                      child: Image.asset(
                        'assets/moods/cool_guy.png',
                        height: 100,
                        width: 100,
                      ),
                    ),
                    // Add more moods as needed
                  ],
                ),
              ),
            );
          },
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0, // Ensures alignment of the leading widget with padding
        leading: const Padding(
          padding: EdgeInsets.only(left: 12.0), // Add padding to the left
          child: Row(
            mainAxisSize: MainAxisSize
                .min, // Ensures the Row takes only as much space as needed
            children: [
              Padding(
                padding: EdgeInsets.only(left: 2.0), // Add padding to the right
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedHome05,
                  color: AppTheme.text,
                ),
              ), // Add spacing between the icon and the arrow
              PopupMenu(selectedVal: 'Diary'),
            ],
          ),
        ),
        actions: [
          Padding(
            padding:
                const EdgeInsets.only(right: 8.0), // Add padding to the right
            child: IconButton(
              icon: const HugeIcon(
                color: AppTheme.text,
                icon: HugeIcons.strokeRoundedSettings02,
              ),
              color: AppTheme.text,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsScreen()));
              },
            ),
          ),
        ],
      ),
      body: BlocBuilder<CalendarBloc, CalendarState>(
        builder: (context, state) {
          DateTime focusedDate = state.focusedDate;

          final String currentYear = DateFormat('yyyy').format(focusedDate);
          final String currentMonth = DateFormat('MMMM').format(focusedDate);

          return Center(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        currentYear,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        currentMonth.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: BlocBuilder<MoodBloc, MoodBlocState>(
                      builder: (context, moodState) {
                        if (moodState is GetMonthlyMoodsLoaded) {
                          moodMap = {
                            for (var entry in moodState.moods!.entries)
                              entry.key: entry.value.mood
                          };
                        }
                        return TableCalendar(
                          firstDay: DateTime.utc(2010, 10, 16),
                          lastDay: DateTime.utc(2030, 3, 14),
                          focusedDay: focusedDate,
                          headerVisible: false,
                          daysOfWeekVisible: false,
                          onDaySelected: (selectedDay, focusedDay) {
                            moodDialog(selectedDay, moodMap);
                          },
                          onPageChanged: (newFocusedMonth) {
                            context
                                .read<CalendarBloc>()
                                .add(ChangeFocusedMonth(newFocusedMonth));
                            context.read<MoodBloc>().add(GetMonthlyMoodEvent(
                                  newFocusedMonth,
                                ));
                          },
                          calendarStyle: const CalendarStyle(
                            todayDecoration: BoxDecoration(
                              color: AppTheme.primary,
                              shape: BoxShape.circle,
                            ),
                            outsideDaysVisible:
                                false, // Hides prev/next month days
                            // defaultTextStyle: TextStyle(),
                          ),
                          calendarBuilders: CalendarBuilders(
                            defaultBuilder: (context, date, _) {
                              final normalizedDate =
                                  DateTime(date.year, date.month, date.day);
                              final mood = moodMap[normalizedDate];

                              if (mood != null) {
                                print('Mood for $normalizedDate: $mood');
                                return Center(
                                  child:
                                      Image.asset(mood, height: 30, width: 30),
                                );
                              }
                              if (date.weekday == DateTime.sunday ||
                                  date.weekday == DateTime.saturday) {
                                return Center(
                                    child: Text(
                                  '${date.day}',
                                  style: TextStyle(
                                    color: date.weekday == DateTime.sunday
                                        ? AppTheme.red
                                        : date.weekday == DateTime.saturday
                                            ? AppTheme.blue
                                            : null,
                                  ),
                                ));
                              }
                              if (date.isAfter(now)) {
                                return Center(
                                  //we overriding default, default wraps in center
                                  child: Text(
                                    '${date.day}',
                                    style: TextStyle(
                                      color: AppTheme
                                          .text2, // Lighter color for future dates
                                    ),
                                  ),
                                );
                              }
                              return null;
                            },
                          ),
                        );
                      },
                    ),
                  )
                ]),
                FloatingActionButton(
                  foregroundColor: AppTheme.text,
                  backgroundColor: AppTheme.primary,
                  onPressed: () {
                    moodDialog(DateTime.now(), moodMap);
                  },
                  child: const Icon(Icons.add),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
