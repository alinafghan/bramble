import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journal_app/blocs/get_review_for_book/get_review_for_book_cubit.dart';
import 'package:journal_app/blocs/set_review_cubit/set_review_cubit.dart';
import 'package:journal_app/models/book.dart';
import 'package:journal_app/utils/constants.dart';
import 'package:lottie/lottie.dart';

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
    context.read<GetReviewForBookCubit>().getReviewForBook(widget.book);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.book.title} Reviews'),
      ),
      body: BlocBuilder<GetReviewForBookCubit, GetReviewForBookState>(
        builder: (context, state) {
          if (state is GetReviewForBookLoading) {
            return Center(child: Lottie.asset('assets/lottie/loading.json'));
          } else if (state is GetReviewForBookSuccess) {
            final reviews = state.reviews;
            if (reviews.isEmpty) {
              return const Center(child: Text('No reviews yet.'));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: reviews.length,
              separatorBuilder: (_, __) => const Divider(thickness: 0.5),
              itemBuilder: (context, index) {
                final review = reviews[index];
                if (review == null) return const SizedBox.shrink();
                final user = review.user;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: AppTheme.white,
                      radius: 20,
                      backgroundImage: (user.profileUrl != null &&
                              user.profileUrl!.isNotEmpty)
                          ? NetworkImage(user.profileUrl!)
                          : null,
                      child:
                          (user.profileUrl == null || user.profileUrl!.isEmpty)
                              ? const Icon(
                                  Icons.person,
                                  color: AppTheme.primary,
                                )
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
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            review.text,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      icon: Icon(
                        review.isLikedByCurrentUser
                            ? CupertinoIcons.heart_fill // red heart
                            : CupertinoIcons.heart, // outlined heart
                        color: review.isLikedByCurrentUser
                            ? Colors.red
                            : Colors.grey,
                      ),
                      onPressed: () {
                        context.read<SetReviewCubit>().likeReview(review);
                      },
                    ),
                    BlocListener<SetReviewCubit, SetReviewState>(
                      listener: (context, state) {
                        if (state is SetReviewSuccess) {
                          // Update the review list after liking a review
                          context
                              .read<GetReviewForBookCubit>()
                              .getReviewForBook(widget.book);
                        }
                      },
                      child: Text(
                        '${review.numLikes}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color.fromARGB(255, 68, 68, 68),
                        ),
                      ),
                    ),
                  ],
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
    );
  }
}
