import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:journal_app/blocs/review_cubit/review_cubit.dart';
import 'package:journal_app/models/book.dart';
import 'package:journal_app/models/review.dart';
import 'package:journal_app/models/user.dart';
import 'package:journal_app/utils/bottom_nav.dart';

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
      body: BlocBuilder<ReviewCubit, ReviewState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Stack(children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).colorScheme.primary),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height / 3),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                '$currentDay, $currentDate  $currentMonth  $currentYear'),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 3.6,
                              child: SingleChildScrollView(
                                child: TextField(
                                  key: const Key('textfield'),
                                  maxLines: null,
                                  controller: reviewTextController,
                                  cursorColor:
                                      Theme.of(context).colorScheme.onSurface,
                                  maxLength: 500,
                                  decoration: InputDecoration(
                                    counterText: '', // hides built-in counter
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    hintText: 'Typing...',
                                    focusColor:
                                        Theme.of(context).colorScheme.secondary,
                                    hoverColor:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: ValueListenableBuilder<TextEditingValue>(
                      valueListenable: reviewTextController,
                      builder: (context, value, _) {
                        return Text(
                          '${value.text.length}/500',
                          style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onSurface),
                        );
                      },
                    ),
                  ),
                ]),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: TextButton(
                      style: TextButton.styleFrom(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary),
                      onPressed: () {
                        setReview(context, widget.book);
                      },
                      child: Text('Publish Review',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.surface))),
                )
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: bottomNav(),
    );
  }

  void setReview(BuildContext context, Book book) {
    context.read<ReviewCubit>().setReview(
          Review(
            id: '',
            user: Users(userId: '', email: '', mod: false), //current user,
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
        allowImagePick: false,
        onSave: () {
          setReview(context, widget.book);
          context.pop(); // Navigate back after posting the review
        },
      ),
    );
  }
}
