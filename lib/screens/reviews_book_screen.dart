// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hugeicons/hugeicons.dart';
// import 'package:journal_app/blocs/review_cubit/review_cubit.dart';
// import 'package:journal_app/models/book.dart';
// import 'package:journal_app/utils/constants.dart';
// import 'package:lottie/lottie.dart';

// class BookReviewsScreen extends StatefulWidget {
//   final Book book;
//   const BookReviewsScreen({super.key, required this.book});

//   @override
//   State<BookReviewsScreen> createState() => _BookReviewsScreenState();
// }

// class _BookReviewsScreenState extends State<BookReviewsScreen> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<ReviewCubit>().getReviewForBook(widget.book);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('${widget.book.title} Reviews'),
//       ),
//       body: BlocBuilder<ReviewCubit, ReviewState>(
//         builder: (context, state) {
//           if (state is GetReviewForBookLoading) {
//             return const SizedBox.shrink();
//           } else if (state is GetReviewForBookSuccess) {
//             final reviews = state.reviews;
//             if (reviews.isEmpty) {
//               return Center(
//                   child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Lottie.asset('assets/lottie/watch_film.json',
//                       height: 200, width: 200),
//                   const Text('No reviews Yet.'),
//                 ],
//               ));
//             }
//             return ListView.separated(
//               padding: const EdgeInsets.all(12),
//               itemCount: reviews.length,
//               separatorBuilder: (_, __) => const Divider(thickness: 0.5),
//               itemBuilder: (context, index) {
//                 final review = reviews[index];
//                 if (review == null) return const SizedBox.shrink();
//                 final user = review.user;
//                 return Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     CircleAvatar(
//                       backgroundColor: AppTheme.white,
//                       radius: 20,
//                       backgroundImage: (user.profileUrl != null &&
//                               user.profileUrl!.isNotEmpty)
//                           ? NetworkImage(user.profileUrl!)
//                           : null,
//                       child:
//                           (user.profileUrl == null || user.profileUrl!.isEmpty)
//                               ? const Icon(
//                                   Icons.person,
//                                   color: AppTheme.palette3,
//                                 )
//                               : null,
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             user.username ?? 'Anonymous',
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             review.text,
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     IconButton(
//                       icon: Icon(
//                         HugeIcons
//                             .strokeRoundedFavourite, // red heart // outlined heart
//                         color: review.isLikedByCurrentUser
//                             ? Colors.red
//                             : Colors.grey,
//                       ),
//                       onPressed: () {
//                         context.read<ReviewCubit>().likeReview(review);
//                       },
//                     ),
//                     BlocListener<ReviewCubit, ReviewState>(
//                       listener: (context, state) {
//                         if (state is SetReviewSuccess) {
//                           // Update the review list after liking a review
//                           context
//                               .read<ReviewCubit>()
//                               .getReviewForBook(widget.book);
//                         }
//                       },
//                       child: Text(
//                         '${review.numLikes}',
//                         style: const TextStyle(
//                           fontSize: 12,
//                           color: Color.fromARGB(255, 68, 68, 68),
//                         ),
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             );
//           } else if (state is GetReviewForBookFailure) {
//             return Center(child: Text(state.message));
//           } else {
//             return const SizedBox.shrink();
//           }
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:journal_app/blocs/review_cubit/review_cubit.dart';
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
    context.read<ReviewCubit>().getReviewForBook(widget.book);
  }

  void _onReportPressed(review) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.backgroundColor,
        title: const Text("Report Review"),
        content: const Text("Are you sure you want to report this review?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancel",
              style: TextStyle(color: AppTheme.palette2),
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
            child: const Text(
              "Report",
              style: TextStyle(color: AppTheme.palette5),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.book.title} Reviews'),
      ),
      body: BlocBuilder<ReviewCubit, ReviewState>(
        builder: (context, state) {
          if (state is GetReviewForBookLoading) {
            return Center(
              child: Lottie.asset('assets/plant.json'),
            );
          } else if (state is GetReviewForBookSuccess) {
            final reviews = state.reviews;
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
                    color: AppTheme.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header: User Info
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: AppTheme.white,
                            radius: 20,
                            backgroundImage: (user.profileUrl != null &&
                                    user.profileUrl!.isNotEmpty)
                                ? NetworkImage(user.profileUrl!)
                                : null,
                            child: (user.profileUrl == null ||
                                    user.profileUrl!.isEmpty)
                                ? const Icon(Icons.person,
                                    color: AppTheme.palette3)
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
                                  review.createdAt,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.flag_outlined,
                                color: Colors.grey),
                            onPressed: () => _onReportPressed(review),
                            tooltip: 'Report Review',
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Review Text
                      Text(
                        review.text,
                        style: const TextStyle(fontSize: 14),
                      ),

                      const SizedBox(height: 10),

                      // Like Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
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
                          BlocListener<ReviewCubit, ReviewState>(
                            listener: (context, state) {
                              if (state is SetReviewSuccess) {
                                context
                                    .read<ReviewCubit>()
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
    );
  }
}
