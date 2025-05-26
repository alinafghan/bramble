import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:journal_app/blocs/set_review_cubit/set_review_cubit.dart';
import 'package:journal_app/models/book.dart';
import 'package:journal_app/models/review.dart';
import 'package:journal_app/models/user.dart';
import 'package:journal_app/utils/bottom_nav.dart';
import 'package:journal_app/utils/constants.dart';

class SetReviewScreen extends StatefulWidget {
  final Book book;
  const SetReviewScreen({super.key, required this.book});

  @override
  State<SetReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<SetReviewScreen> {
  @override
  void initState() {
    super.initState();
  }

  TextEditingController reviewTextController = TextEditingController();
  DateTime currentTime = DateTime.now();
  final String currentDate = DateFormat('dd').format(DateTime.now());
  final String currentDay = DateFormat('EEEE').format(DateTime.now());
  final String currentMonth = DateFormat('MMMM').format(DateTime.now());
  final String currentYear = DateFormat('yyyy').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<SetReviewCubit, SetReviewState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.palette3),
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height / 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              '$currentDay, $currentDate  $currentMonth  $currentYear'),
                          TextField(
                            maxLines: null,
                            controller: reviewTextController,
                            cursorColor: AppTheme.text,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: 'Typing...',
                                focusColor: AppTheme.palette2,
                                hoverColor: AppTheme.palette2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: bottomNav(),
    );
  }

  void setReview(BuildContext context, Book book) {
    context.read<SetReviewCubit>().setReview(
          Review(
            id: '',
            user: Users(userId: '', email: ''), //current user,
            book: book,
            text: reviewTextController.text,
            numLikes: 0,
            createdAt:
                DateTime.now().toString(), //current time // Example rating
          ),
          book,
        );
  }

  Widget bottomNav() {
    final bool isKeyboardVisible =
        KeyboardVisibilityProvider.isKeyboardVisible(context);

    return Offstage(
      offstage: !isKeyboardVisible, // visually hide when false…
      child: BottomNav(
        textController: reviewTextController,
        onSave: () {
          setReview(context, widget.book);
          context.pop(); // Navigate back after posting the review
        },
      ),
    );
  }
}
