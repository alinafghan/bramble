import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:journal_app/blocs/get_journal_bloc/get_journal_bloc.dart';
import 'package:journal_app/blocs/set_journal_bloc/set_journal_bloc.dart';
import 'package:journal_app/models/journal.dart';
import 'package:journal_app/models/user.dart';
import 'package:journal_app/providers/user_provider/user_provider.dart';
import '../utils/popup_menu2.dart';
import '../utils/constants.dart';
import 'package:carousel_slider/carousel_slider.dart';

class JournalScreen extends StatefulWidget {
  final DateTime selectedDate;

  const JournalScreen({super.key, required this.selectedDate});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  Journal? journal;
  final TextEditingController journalController = TextEditingController();
  final List<File> _selectedImages = [];

  bool _hasInitializedContent = false;

  @override
  void initState() {
    super.initState();
    // Dispatch the event to fetch the journal content.
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
    journal = Journal(
      content: text,
      date: docId,
      id: '',
      user: Users(userId: '', email: ''),
    );
    context.read<SetJournalBloc>().add(SetJournal(journal: journal!));
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage();

    if (pickedImages.isNotEmpty) {
      setState(() {
        _selectedImages.clear();
        _selectedImages
            .addAll(pickedImages.take(4).map((file) => File(file.path)));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double imageHeight = MediaQuery.of(context).size.height * 0.3;
    double imageWidth = MediaQuery.of(context).size.width * 0.9;

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
                //image carousel will go here
                if (_selectedImages.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: CarouselSlider(
                      options: CarouselOptions(
                        height: imageHeight,
                        enableInfiniteScroll: false,
                        viewportFraction: 1.0,
                      ),
                      items: _selectedImages
                          .map((file) => Image.file(file,
                              width: imageWidth, fit: BoxFit.cover))
                          .toList(),
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
          bottomNavigationBar: bottomNav(journalController),
        ));
  }

  Widget? bottomNav(TextEditingController journalController) {
    final bool isKeyboardVisible =
        KeyboardVisibilityProvider.isKeyboardVisible(context);
    if (isKeyboardVisible == true) {
      return SingleChildScrollView(
        reverse: true,
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.backgroundColor,
            border: Border(
              top: BorderSide(
                color: Colors.grey.withValues(),
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
                top: 2,
                right: 4,
                left: 4,
                bottom: MediaQuery.of(context).viewInsets.bottom * 1),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          DateTime timeStamp = DateTime.now();
                          String formattedTime =
                              DateFormat.jm().format(timeStamp);

                          journalController.text += formattedTime;
                        },
                        icon: const Icon(
                          HugeIcons.strokeRoundedClock01,
                          size: 32,
                        ),
                      ),
                      IconButton(
                          onPressed: () async {
                            _pickImage();
                          },
                          icon: const Icon(
                            HugeIcons.strokeRoundedAlbum02,
                            size: 32,
                          ))
                    ],
                  ),
                  IconButton(
                      onPressed: () {
                        _saveJournalEntry();
                        Navigator.pop(context);
                      },
                      icon: const HugeIcon(
                        icon: HugeIcons.strokeRoundedTick02,
                        color: AppTheme.text,
                        size: 32,
                      ))
                ]),
          ),
        ),
      );
    }
  }
}
