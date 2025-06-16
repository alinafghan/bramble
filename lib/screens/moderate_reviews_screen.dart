import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:journal_app/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:journal_app/blocs/review_cubit/review_cubit.dart';
import 'package:journal_app/utils/popup_menu.dart';
import 'package:lottie/lottie.dart';

class ModerateReviewsScreen extends StatefulWidget {
  const ModerateReviewsScreen({super.key});

  @override
  State<ModerateReviewsScreen> createState() => _ModerateReviewsScreenState();
}

class _ModerateReviewsScreenState extends State<ModerateReviewsScreen> {
  @override
  void initState() {
    context.read<ReviewCubit>().getReportedReviews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // titleSpacing: 0,
        leadingWidth: 64,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              if (state is GetUserLoaded) {
                return PopupMenu(
                  selectedVal: 'Reviews',
                  isModerator: state.myUser.mod,
                );
              } else {
                return const PopupMenu(
                  selectedVal: 'Reviews',
                  isModerator: false,
                );
              }
            },
          ),
        ),
        title: const Text('Moderate Reviews'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: BlocBuilder<ReviewCubit, ReviewState>(
          builder: (context, state) {
            if (state is GetReportedReviewsLoaded) {
              final reviews = state.reportedReviews;
              if (reviews.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset('assets/lottie/typing_laptop.json',
                          height: 200, width: 200),
                      const SizedBox(height: 4),
                      const Text('No reports yet'),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: state.reportedReviews.length,
                itemBuilder: (context, i) {
                  final bookTitle = state.reportedReviews[i].book.title;
                  final reviews = state.reportedReviews;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          bookTitle,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...reviews.map((review) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              leading: Icon(
                                Icons.report,
                                color: Theme.of(context).colorScheme.error,
                              ),
                              title: Text(
                                  '${review.user.username} • ${format(review.createdAt)}'),
                              subtitle: Text(
                                review.text,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () {
                                  context
                                      .read<ReviewCubit>()
                                      .deleteReview(review);
                                },
                                color: Colors.red.shade300,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(
                                '${review.reports?.length ?? 0} report(s)}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
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
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  );
                },
              );
            } else {
              return Center(
                key: const Key('plantcenter'),
                child: Lottie.asset('assets/plant.json'),
              );
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
