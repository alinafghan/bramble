import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:journal_app/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:journal_app/blocs/review_cubit/review_cubit.dart';
import 'package:journal_app/models/review.dart';
import 'package:journal_app/utils/popup_menu.dart';
import 'package:lottie/lottie.dart';
import 'package:toastification/toastification.dart';

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
        if (state is DeleteReviewLoaded) {
          showSnackBar('Review deleted successfully!');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 64,
          centerTitle: true,
          leading: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
                final isModerator =
                    state is GetUserLoaded ? state.myUser.mod : false;
                return PopupMenu(
                    selectedVal: 'Reviews', isModerator: isModerator);
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
                if (state.reportedReviews.isEmpty) {
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
                final grouped = <String, List<Review>>{};
                for (var review in reviews) {
                  final title = review.book.title;
                  grouped.putIfAbsent(title, () => []).add(review);
                }
                return ListView(
                  children: grouped.entries.map((entry) {
                    final title = entry.key;
                    final bookReviews = entry.value;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            title,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...bookReviews.map((review) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  leading: Icon(Icons.report,
                                      color:
                                          Theme.of(context).colorScheme.error),
                                  title: Text(
                                    '${review.user.username} • ${format(review.createdAt)}',
                                  ),
                                  subtitle: Text(review.text),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Text(
                                    '${review.reports?.length ?? 0} report(s)',
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 6.0),
                                  child: Text(
                                    maxLines: 1,
                                    '-----------------------------------------------------------',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(86, 122, 117, 117)),
                                  ),
                                ),
                              ],
                            )),
                      ],
                    );
                  }).toList(),
                );
              }
              return Center(
                key: const Key('plantcenter'),
                child: Lottie.asset('assets/plant.json'),
              );
            },
          ),
        ),
      ),
    );
  }

  String format(String createdAt) {
    final now = DateTime.now();
    final created = DateTime.tryParse(createdAt)?.toLocal() ?? now;
    final diff = now.difference(created);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 24 && now.day == created.day) return 'Today';
    if (diff.inHours < 48 && now.day == created.day + 1) return 'Yesterday';

    return DateFormat('MMM dd, yyyy').format(created);
  }
}
