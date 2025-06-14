import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:intl/intl.dart';
import 'package:journal_app/blocs/cubit/task_cubit_cubit.dart';
import 'package:journal_app/blocs/journal_bloc/journal_bloc.dart';
import 'package:journal_app/blocs/mood_bloc/mood_bloc.dart';
import 'package:journal_app/models/journal.dart';
import 'package:journal_app/models/user.dart';
import 'package:journal_app/providers/auth_provider/auth_provider.dart';
import 'package:journal_app/utils/bottom_nav.dart';
import '../utils/popup_menu2.dart';
import 'package:carousel_slider/carousel_slider.dart';

class JournalScreen extends StatefulWidget {
  final DateTime selectedDate;
  final String mood;

  const JournalScreen(
      {super.key, required this.selectedDate, required this.mood});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  bool _isEditable = false;
  Journal? journal;
  final TextEditingController journalController = TextEditingController();
  final List<String> _selectedImages = [];

  bool _hasInitializedContent = false;

  @override
  void initState() {
    super.initState();
    _fetchJournal();
  }

  @override
  void dispose() {
    journalController.dispose();
    super.dispose();
  }

  // Fetch the journal content from the backend via the GetJournalBloc.
  void _fetchJournal() async {
    Users user = await MyAuthProvider().getCurrentUser();
    String docId = DateFormat('yyyy-MM-dd').format(widget.selectedDate);
    String id = user.userId + docId;
    _hasInitializedContent = false;
    if (mounted) {
      context.read<JournalBloc>().add(GetJournal(id: id));
    }
  }

  /// Save the journal entry.
  Future<void> _saveJournalEntry() async {
    String text = journalController.text.trim();
    String docId = DateFormat('yyyy-MM-dd').format(widget.selectedDate);

    if (journal != null) {
      journal = journal!.copyWith(
        content: text,
        date: docId,
      );
    } else {
      journal = Journal(
        content: text,
        date: docId,
        id: '',
        user: Users(userId: '', email: '', mod: false),
      );
    }
    context.read<JournalBloc>().add(SetJournal(journal: journal!));
  }

  @override
  Widget build(BuildContext context) {
    double imageHeight = MediaQuery.of(context).size.height * 0.25;

    final String currentYear = DateFormat('yyyy').format(widget.selectedDate);
    final String currentMonth = DateFormat('MMMM').format(widget.selectedDate);
    final String currentDate = DateFormat('d').format(widget.selectedDate);
    final String currentDay = DateFormat('EEEE').format(widget.selectedDate);

    return PopScope(
        canPop: true,
        onPopInvoked: (didPop) {
          if (didPop) {
            context
                .read<MoodBloc>()
                .add(GetMonthlyMoodEvent(month: DateTime.now()));
            context.read<TaskCubitCubit>().closeTextfield();
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: PopupMenu2(
                    onEdit: () {
                      _isEditable = true;
                    },
                    date: DateFormat('yyyy-MM-dd').format(widget.selectedDate)),
              )
            ],
          ),
          body: Center(
            child: Column(
              children: <Widget>[
                Image.asset(
                  widget.mood,
                  height: 100,
                  width: 100,
                ),
                Text(
                  '$currentMonth $currentDate, $currentYear',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  currentDay,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                // Listen for SetJournalLoaded event
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Column(
                      children: [
                        BlocListener<JournalBloc, JournalState>(
                          listener: (context, setListenerState) {
                            if (setListenerState is SetJournalSuccess) {
                              //for seeing the added image
                              context.read<JournalBloc>().add(
                                  GetJournal(id: setListenerState.journal.id));
                              journal = setListenerState.journal;
                            }
                          },
                          child: BlocListener<JournalBloc, JournalState>(
                            listener: (context, getListenerState) {
                              if (getListenerState is GetJournalSuccess) {
                                journal = getListenerState.journal;
                              }
                            },
                            child: BlocBuilder<JournalBloc, JournalState>(
                              builder: (context, state) {
                                if (state is GetJournalSuccess) {
                                  // Rebuild the carousel if images are updated
                                  if (state.journal.images != null &&
                                      state.journal.images!.isNotEmpty) {
                                    _selectedImages.clear();
                                    _selectedImages.addAll(state.journal.images
                                            ?.whereType<String>() ??
                                        []);
                                    return Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: CarouselSlider(
                                        options: CarouselOptions(
                                          height: imageHeight,
                                          enableInfiniteScroll: false,
                                          viewportFraction: 1.0,
                                        ),
                                        items: state.journal.images!
                                            .map((url) => Image.network(url!,
                                                fit: BoxFit.cover))
                                            .toList(),
                                      ),
                                    );
                                  }
                                }
                                return const SizedBox
                                    .shrink(); // Return an empty widget if no images are present
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 24.0, right: 24.0, bottom: 24.0),
                          child: BlocBuilder<JournalBloc, JournalState>(
                            builder: (context, state) {
                              if (state is GetJournalLoading) {
                                return TextField(
                                  readOnly: !_isEditable,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                  decoration: InputDecoration(
                                    // The hint will be used only if the controller's text is empty.
                                    hintText: 'Loading...',
                                    hintStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  maxLines: null, // Allows multiline input
                                  textInputAction: TextInputAction.done,
                                );
                              }
                              if (state is GetJournalSuccess) {
                                journal = state.journal;
                              }
                              // When the journal is loaded, set the text controller only once.
                              if (!_hasInitializedContent && journal != null) {
                                journalController.text = journal!.content;
                                _hasInitializedContent = true;
                              }
                              return BlocBuilder<TaskCubitCubit,
                                  TaskCubitState>(
                                builder: (context, taskState) {
                                  bool isEditable =
                                      taskState is EditTextfieldOn ||
                                          state is GetJournalFailure ||
                                          (state is SetJournalSuccess &&
                                              state.journal.content == '') ||
                                          (state is GetJournalSuccess &&
                                              state.journal.content == '');
                                  return TextField(
                                    readOnly: !isEditable,
                                    controller: journalController,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                    decoration: const InputDecoration(
                                      // The hint will be used only if the controller's text is empty.
                                      hintText: 'What\'s on your mind?',
                                      hintStyle: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                    maxLines: null, // Allows multiline input
                                    textInputAction: TextInputAction.done,
                                    onSubmitted: (value) {
                                      _saveJournalEntry(); // Save on Enter key
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: bottomNav(),
        ));
  }

  Widget bottomNav() {
    final bool isKeyboardVisible =
        KeyboardVisibilityProvider.isKeyboardVisible(context);

    journal ??= Journal(
      content: '',
      date: DateFormat('yyyy-MM-dd').format(widget.selectedDate),
      id: '',
      user: Users(userId: '', email: '', mod: false),
    );

    return Offstage(
      offstage: !isKeyboardVisible, // visually hide when false…
      child: BottomNav(
        textController: journalController,
        onSave: _saveJournalEntry,
        journal: journal,
      ),
    );
  }
}
