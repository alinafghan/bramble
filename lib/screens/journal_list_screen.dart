import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:journal_app/blocs/get_journal_bloc/get_journal_bloc.dart';
import 'package:journal_app/models/journal.dart';

class JournalListScreen extends StatefulWidget {
  final Map<String, String> moodMap;

  const JournalListScreen({super.key, required this.moodMap});

  @override
  State<JournalListScreen> createState() => _JournalListScreenState();
}

class _JournalListScreenState extends State<JournalListScreen> {
  final List<Journal> journals = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragDown: (_) {
        Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(),
        body: BlocBuilder<GetJournalBloc, GetJournalState>(
          builder: (context, state) {
            if (state is GetMonthlyJournalSuccess) {
              journals.clear();
              journals.addAll(state.journals);
              return ListView.builder(
                itemCount: journals.length,
                itemBuilder: (context, index) {
                  final journal = journals[index];

                  final DateTime parsedDate = DateTime.parse(journal.date);
                  final String currentMonth =
                      DateFormat('MMMM').format(parsedDate); // e.g., "May"
                  final String currentDate =
                      DateFormat('d').format(parsedDate); // e.g., "1"
                  final String currentDay = DateFormat('EEEE')
                      .format(parsedDate); // e.g., "Wednesday"

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage:
                                AssetImage(widget.moodMap[journal.date]!)),
                        title: Text('$currentMonth $currentDate'),
                        subtitle: Text(currentDay),
                        onTap: () {
                          // Handle journal tap
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                },
              );
            } else {
              return const Center();
            }
          },
        ),
      ),
    );
  }
}
