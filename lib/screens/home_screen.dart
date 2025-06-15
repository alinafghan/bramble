import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart'; // For formatting the date
import 'package:journal_app/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:journal_app/blocs/calendar_bloc/calendar_bloc.dart';
import 'package:journal_app/blocs/journal_bloc/journal_bloc.dart';
import 'package:journal_app/blocs/mood_bloc/mood_bloc.dart';
import 'package:journal_app/models/journal.dart';
import 'package:journal_app/utils/popup_menu.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:hugeicons/hugeicons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MoodBloc>().add(GetMonthlyMoodEvent(month: DateTime.now()));
    context.read<AuthenticationBloc>().add(GetUserEvent());
  }

  final DateTime now = DateTime.now();
  Map<String, String> moodMap = {};
  final List<Journal> journals = [];
  final bool isModerator = false;

  @override
  Widget build(BuildContext context) {
    void goToJournal(DateTime selectedDay, String mood) {
      final encodedMood = Uri.encodeComponent(mood);
      final encodedDate = Uri.encodeComponent(selectedDay.toIso8601String());
      context.push(
        '/home/journal/$encodedDate/$encodedMood',
      );
    }

    void onMoodSelected(String moodAsset, DateTime selectedDay) {
      final stringDate = DateFormat('yyyy-MM-dd').format(selectedDay);
      context
          .read<MoodBloc>()
          .add(SetMoodEvent(date: stringDate, moodAsset: moodAsset));
      goToJournal(selectedDay, moodAsset);
    }

    void showMoodDialog(DateTime selectedDay) {
      final moods = [
        'assets/moods/sipping_mug.png',
        'assets/moods/cool_guy.png',
        'assets/moods/reading_book.png',
        'assets/moods/listen_music.png',
        'assets/moods/sick.png'
      ]; // Add more moods here
      final moodString = ['cosy', 'chilling', 'study', 'happy', 'sick'];
      final stringDate = DateFormat('yyyy-MM-dd').format(selectedDay);

      if (moodMap.containsKey(stringDate)) {
        goToJournal(selectedDay, moodMap[stringDate]!);
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.surface,
              title: const Text('Select Mood'),
              content: SizedBox(
                height: MediaQuery.of(context).size.width * .45,
                width: MediaQuery.of(context).size.width * .5,
                child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: moods.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                    ),
                    itemBuilder: (context, i) {
                      return GestureDetector(
                        onTap: () {
                          context.pop();
                          onMoodSelected(moods[i], selectedDay);
                        },
                        child: Column(
                          children: [
                            Expanded(
                              child: Image.asset(
                                moods[i],
                                width: 100,
                              ),
                            ),
                            Text(moodString[i]),
                          ],
                        ),
                      );
                    }),
              ),
            );
          },
        );
      }
    }

    return GestureDetector(
      onVerticalDragStart: (_) {
        final focusedMonth = context.read<CalendarBloc>().state.focusedDate;
        context.read<JournalBloc>().add(GetMonthlyJournal(month: focusedMonth));
        context.push('/home/journal_list', extra: moodMap);
      },
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          leadingWidth:
              64, // Ensures alignment of the leading widget with padding
          leading: Padding(
            padding:
                const EdgeInsets.only(left: 12.0), // Add padding to the left
            child: Row(
              mainAxisSize: MainAxisSize
                  .min, // Ensures the Row takes only as much space as needed
              children: [
                BlocBuilder<AuthenticationBloc, AuthenticationState>(
                  builder: (context, state) {
                    if (state is GetUserLoaded) {
                      return PopupMenu(
                        selectedVal: 'Diary',
                        isModerator: state.myUser.mod,
                      );
                    } else {
                      return const PopupMenu(
                        selectedVal: 'Diary',
                        isModerator: false,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            Padding(
              padding:
                  const EdgeInsets.only(right: 8.0), // Add padding to the right
              child: IconButton(
                icon: HugeIcon(
                  color: Theme.of(context).colorScheme.onSurface,
                  icon: HugeIcons.strokeRoundedSettings02,
                ),
                color: Theme.of(context).colorScheme.onSurface,
                onPressed: () {
                  context.push('/home/settings');
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
                              final now = DateTime.now();
                              final normalizedSelectedDay = DateTime(
                                  selectedDay.year,
                                  selectedDay.month,
                                  selectedDay.day);
                              final normalizedNow =
                                  DateTime(now.year, now.month, now.day);

                              if (normalizedSelectedDay
                                  .isAfter(normalizedNow)) {
                                // Do nothing or show a message that future journaling is not allowed
                                return;
                              } else {
                                showMoodDialog(selectedDay);
                              }
                            },
                            onPageChanged: (newFocusedMonth) {
                              context.read<JournalBloc>().add(
                                  GetMonthlyJournal(month: newFocusedMonth));
                              context
                                  .read<CalendarBloc>()
                                  .add(ChangeFocusedMonth(newFocusedMonth));
                              context.read<MoodBloc>().add(GetMonthlyMoodEvent(
                                    month: newFocusedMonth,
                                  ));
                            },
                            calendarStyle: const CalendarStyle(
                              outsideDaysVisible:
                                  false, // Hides prev/next month days
                            ),
                            calendarBuilders: CalendarBuilders(
                              todayBuilder: (context, date, _) {
                                final key =
                                    DateTime(date.year, date.month, date.day);
                                String docId =
                                    DateFormat('yyyy-MM-dd').format(key);
                                final mood = moodMap[docId];
                                if (mood != null) {
                                  //mood exts
                                  return deleteMoodDialog(context, mood, docId);
                                }
                                //no mood
                                return Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      '${date.day}',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                );
                              },
                              defaultBuilder: (context, date, _) {
                                final stringDate =
                                    DateFormat('yyyy-MM-dd').format(date);
                                final mood = moodMap[stringDate];
                                if (mood != null) {
                                  return deleteMoodDialog(
                                      context, mood, stringDate);
                                }
                                if (date.weekday == DateTime.sunday ||
                                    date.weekday == DateTime.saturday) {
                                  return Center(
                                      child: Text(
                                    '${date.day}',
                                    style: TextStyle(
                                      color: date.weekday == DateTime.sunday
                                          ? Theme.of(context).colorScheme.error
                                          : date.weekday == DateTime.saturday
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
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
                                        color: Colors.grey
                                            .shade500, // Lighter color for future dates
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
                    foregroundColor: Theme.of(context).colorScheme.onSurface,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    onPressed: () {
                      showMoodDialog(DateTime.now());
                    },
                    child: const Icon(Icons.add),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

Widget deleteMoodDialog(BuildContext context, String mood, String docId) {
  return GestureDetector(
      onLongPress: () async {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: Theme.of(context).colorScheme.surface,
                title: const Text('Delete Mood?'),
                content: const Text(
                    'This will delete the mood and associated journal entry. Are you sure you want to proceed?'),
                actions: [
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
                    onPressed: () {
                      context
                          .read<MoodBloc>()
                          .add(DeleteMoodEvent(date: docId));
                      context
                          .read<JournalBloc>()
                          .add(DeleteJournal(date: docId));

                      final currentMonth =
                          context.read<CalendarBloc>().state.focusedDate;

                      context
                          .read<MoodBloc>()
                          .add(GetMonthlyMoodEvent(month: currentMonth));

                      context.pop();
                    },
                    child: Text(
                      'Delete Mood',
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  ),
                ],
              );
            });
      },
      child: Center(child: Image.asset(mood, height: 30, width: 30)));
}
