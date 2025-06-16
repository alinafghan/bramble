import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:journal_app/blocs/journal_bloc/journal_bloc.dart';
import 'package:lottie/lottie.dart';

class JournalListScreen extends StatefulWidget {
  final Map<String, String> moodMap;

  const JournalListScreen({super.key, required this.moodMap});

  @override
  State<JournalListScreen> createState() => _JournalListScreenState();
}

class _JournalListScreenState extends State<JournalListScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragDown: (_) {
        context.pop();
      },
      child: Scaffold(
        body: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: BlocBuilder<JournalBloc, JournalState>(
                builder: (context, state) {
              if (state is GetMonthlyJournalSuccess) {
                if (state.journals.isNotEmpty) {
                  return ListView.builder(
                    itemCount: state.journals.length,
                    // ignore: body_might_complete_normally_nullable
                    itemBuilder: (context, index) {
                      final journal = state.journals[index];

                      final DateTime parsedDate = DateTime.parse(journal.date);
                      final String currentMonth =
                          DateFormat('MMMM').format(parsedDate);
                      final String currentDate =
                          DateFormat('d').format(parsedDate);
                      final String currentDay =
                          DateFormat('EEEE').format(parsedDate);
                      if (state.journals.isNotEmpty) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: AssetImage(
                                      widget.moodMap[journal.date]!)),
                              title: Text('$currentMonth $currentDate'),
                              subtitle: Text(currentDay),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(
                                journal.content,
                                textAlign: TextAlign.start,
                              ),
                            ),
                            const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 6.0),
                                child: Text(
                                  maxLines: 1,
                                  '-----------------------------------------------------------',
                                  style: TextStyle(
                                      color: Color.fromARGB(86, 122, 117, 117)),
                                ))
                          ],
                        );
                      }
                    },
                  );
                } else if (state.journals.isEmpty) {
                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset('assets/lottie/typing_laptop.json',
                          height: 200, width: 200),
                      const SizedBox(
                        height: 4,
                      ),
                      const Text('No journals Yet'),
                    ],
                  ));
                }
              }
              if (state is JournalInternetIssue ||
                  state is GetMonthlyJournalError) {
                return Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset('assets/lottie/no_internet.json'),
                    const SizedBox(height: 14),
                    const Text('No Internet.'),
                  ],
                ));
              }
              return Center(
                child: Lottie.asset('assets/plant.json'),
              );
            })),
      ),
    );
  }
}
