import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:intl/intl.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:journal_app/blocs/get_journal_bloc/get_journal_bloc.dart';
import 'package:journal_app/blocs/set_journal_bloc/set_journal_bloc.dart';
import 'package:journal_app/models/journal.dart';
import 'package:journal_app/models/user.dart';
import 'package:journal_app/providers/user_provider/user_provider.dart';
import 'package:journal_app/utils/bottom_nav.dart';
import '../utils/popup_menu2.dart';
import '../utils/constants.dart';
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
    Users user = await UserProvider().getCurrentUser();
    String docId = DateFormat('yyyy-MM-dd').format(widget.selectedDate);
    String id = user.userId + docId;
    if (mounted) {
      context.read<GetJournalBloc>().add(GetJournal(id: id));
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
        user: Users(userId: '', email: ''),
      );
    }
    context.read<SetJournalBloc>().add(SetJournal(journal: journal!));
  }

  @override
  Widget build(BuildContext context) {
    double imageHeight = MediaQuery.of(context).size.height * 0.3;

    final String currentYear = DateFormat('yyyy').format(widget.selectedDate);
    final String currentMonth = DateFormat('MMMM').format(widget.selectedDate);
    final String currentDate = DateFormat('d').format(widget.selectedDate);
    final String currentDay = DateFormat('EEEE').format(widget.selectedDate);

    return PopScope(
        canPop: true,
        onPopInvokedWithResult: (bool canPop, dynamic result) async {
          await _saveJournalEntry();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const HugeIcon(
                icon: HugeIcons.strokeRoundedArrowLeft02,
                color: AppTheme.text,
              ),
            ),
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 12.0),
                child: PopupMenu2(),
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
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.text,
                  ),
                ),
                Text(
                  currentDay,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
                // Listen for SetJournalLoaded event
                BlocListener<SetJournalBloc, SetJournalState>(
                  listener: (context, setListenerState) {
                    if (setListenerState is SetJournalSuccess) {
                      context
                          .read<GetJournalBloc>()
                          .add(GetJournal(id: setListenerState.journal.id));
                      journal = setListenerState.journal;
                    }
                  },
                  child: BlocListener<GetJournalBloc, GetJournalState>(
                    listener: (context, getListenerState) {
                      if (getListenerState is GetJournalSuccess) {
                        journal = getListenerState.journal;
                      }
                    },
                    child: BlocBuilder<GetJournalBloc, GetJournalState>(
                      builder: (context, state) {
                        if (state is GetJournalSuccess) {
                          // Rebuild the carousel if images are updated
                          if (state.journal.images != null &&
                              state.journal.images!.isNotEmpty) {
                            _selectedImages.clear();
                            _selectedImages.addAll(
                                state.journal.images?.whereType<String>() ??
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
                                    .map((url) =>
                                        Image.network(url!, fit: BoxFit.cover))
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
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 24.0, right: 24.0, bottom: 24.0),
                    child: BlocBuilder<GetJournalBloc, GetJournalState>(
                      builder: (context, state) {
                        if (state is GetJournalLoading) {
                          return const TextField(
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: AppTheme.text,
                            ),
                            decoration: InputDecoration(
                              // The hint will be used only if the controller's text is empty.
                              hintText: 'Loading...',
                              hintStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey,
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
                        return TextField(
                          controller: journalController,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: AppTheme.text,
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
