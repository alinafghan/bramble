import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:journal_app/blocs/review_cubit/review_cubit.dart';
import 'package:journal_app/models/book.dart';
import 'package:journal_app/models/review.dart';
import 'package:lottie/lottie.dart';
import 'package:toastification/toastification.dart';

class BookReviewsScreen extends StatefulWidget {
  final Book book;
  const BookReviewsScreen({super.key, required this.book});

  @override
  State<BookReviewsScreen> createState() => _BookReviewsScreenState();
}

class _BookReviewsScreenState extends State<BookReviewsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ReviewCubit>().getReviewForBook(widget.book);
  }

  void _onReportPressed(review) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text("Report Review"),
        content: const Text("Are you sure you want to report this review?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<ReviewCubit>().reportReview(
                    review,
                    "Inappropriate content",
                  );
              Navigator.pop(context);
            },
            child: Text(
              "Report",
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  void showSnackBar(String message) {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.flat,
      title: const Text("Success"),
      description: Text(message),
      alignment: Alignment.bottomCenter,
      autoCloseDuration: const Duration(seconds: 3),
      primaryColor: Theme.of(context).colorScheme.surface,
      foregroundColor: Theme.of(context).colorScheme.surface,
      icon: const Icon(HugeIcons.strokeRoundedTick02),
      backgroundColor: Theme.of(context).colorScheme.secondary,
      borderRadius: BorderRadius.circular(20.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReviewCubit, ReviewState>(
      listener: (context, state) {
        if (state is ReportedReviewLoaded) {
          showSnackBar('Report sent');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('${widget.book.title} Reviews'),
        ),
        body: BlocBuilder<ReviewCubit, ReviewState>(
          buildWhen: (previous, current) {
            return current is GetReviewForBookSuccess ||
                current is GetReviewForBookLoading ||
                current is GetReviewForBookFailure;
          },
          builder: (context, state) {
            final List<Review?> reviews;
            if (state is GetReviewForBookLoading) {
              return Center(
                child: Lottie.asset('assets/plant.json'),
              );
            } else if (state is GetReviewForBookSuccess) {
              reviews = state.reviews;
              if (reviews.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset('assets/lottie/watch_film.json',
                          height: 200, width: 200),
                      const Text('No reviews yet.'),
                    ],
                  ),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: reviews.length,
                separatorBuilder: (_, __) => const Divider(thickness: 0.5),
                itemBuilder: (context, index) {
                  final review = reviews[index];
                  if (review == null) return const SizedBox.shrink();
                  final user = review.user;
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).colorScheme.surface,
                              radius: 20,
                              backgroundImage: (user.profileUrl != null &&
                                      user.profileUrl!.isNotEmpty)
                                  ? NetworkImage(user.profileUrl!)
                                  : null,
                              child: (user.profileUrl == null ||
                                      user.profileUrl!.isEmpty)
                                  ? Icon(Icons.person,
                                      color:
                                          Theme.of(context).colorScheme.primary)
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.username ?? 'Anonymous',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    format(review.createdAt),
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          review.text,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.flag_outlined,
                                  color: Colors.grey),
                              onPressed: () => _onReportPressed(review),
                              tooltip: 'Report Review',
                            ),
                            IconButton(
                              icon: Icon(
                                HugeIcons.strokeRoundedFavourite,
                                color: review.isLikedByCurrentUser
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                              onPressed: () {
                                context.read<ReviewCubit>().likeReview(review);
                              },
                            ),
                            Text(
                              '${review.numLikes}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color.fromARGB(255, 68, 68, 68),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (state is GetReviewForBookFailure) {
              return Center(child: Text(state.message));
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  String format(String createdAt) {
    final DateTime now = DateTime.now();
    final DateTime created = DateTime.tryParse(createdAt)?.toLocal() ?? now;
    final difference = now.difference(created);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inHours < 24 && now.day == created.day) return 'Today';
    if (difference.inHours < 48 && now.day == created.day + 1) {
      return 'Yesterday';
    }

    return DateFormat('MMM dd, yyyy').format(created); // e.g. Jun 13, 2025
  }
}
