import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:journal_app/blocs/cubit/task_cubit_cubit.dart';
import 'package:journal_app/blocs/get_book_details_cubit/get_book_details_cubit.dart';
import 'package:journal_app/models/book.dart';
import 'package:journal_app/utils/constants.dart';
import 'package:lottie/lottie.dart';

class BookScreen extends StatefulWidget {
  final Book book;

  const BookScreen({super.key, required this.book});

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GetBookDetailsCubit>().getBookDetails(widget.book);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(),
      body: BlocBuilder<GetBookDetailsCubit, GetBookDetailsState>(
        builder: (context, state) {
          if (state is GetAllBooksLoaded) {
            final book = state.book;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Book Cover
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        book.coverUrl!,
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.height / 4,
                        width: MediaQuery.of(context).size.width / 3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundColor,
                      border: Border.all(color: AppTheme.palette3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                book.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Author: ${book.author}',
                                style: const TextStyle(fontSize: 15),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Published: ${book.publishYear}',
                                style: const TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () =>
                                  context.push('/book_review', extra: book),
                              icon: const HugeIcon(
                                icon: HugeIcons.strokeRoundedComment01,
                                color: AppTheme.palette3,
                              ),
                            ),
                            IconButton(
                              onPressed: () =>
                                  context.push('/review', extra: book),
                              icon: const HugeIcon(
                                icon: HugeIcons.strokeRoundedEdit01,
                                color: AppTheme.palette3,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (book.description != null)
                    BlocBuilder<TaskCubitCubit, TaskCubitState>(
                      buildWhen: (previous, current) =>
                          current is ToggleExpandState,
                      builder: (context, state) {
                        final expanded =
                            context.read<TaskCubitCubit>().isExpanded('desc');
                        final expandedExcerpt = context
                            .read<TaskCubitCubit>()
                            .isExpanded('excerpt');

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Description:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (book.description != null)
                              Text.rich(
                                TextSpan(
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontFamily: AppTheme
                                        .fontFamily, // Don't forget this!
                                  ),
                                  children: [
                                    TextSpan(
                                      text: expanded
                                          ? book.description
                                          : (book.description!.length > 150
                                              ? '${book.description!.substring(0, 150)}... '
                                              : '${book.description!} '),
                                    ),
                                    TextSpan(
                                      text: expanded ? 'See less' : 'See more',
                                      style: const TextStyle(
                                        color: AppTheme.palette2,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () => context
                                            .read<TaskCubitCubit>()
                                            .toggleExpand('desc'),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            const SizedBox(height: 24),
                            const Divider(thickness: 1.5),
                            const SizedBox(height: 16),
                            // Excerpt
                            if (book.excerpt != null)
                              Text.rich(
                                TextSpan(
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontFamily: AppTheme.fontFamily,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: expandedExcerpt
                                          ? book.excerpt
                                          : (book.excerpt!.length > 150
                                              ? '${book.excerpt!.substring(0, 150)}... '
                                              : '${book.excerpt!} '),
                                    ),
                                    TextSpan(
                                      text: expandedExcerpt
                                          ? 'See less'
                                          : 'See more',
                                      style: const TextStyle(
                                        color: AppTheme.palette2,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () => context
                                            .read<TaskCubitCubit>()
                                            .toggleExpand('excerpt'),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.justify,
                              ),
                          ],
                        );
                      },
                    ),
                ],
              ),
            );
          }

          // Loading state
          return Center(
            child: Lottie.asset('assets/plant.json'),
          );
        },
      ),
    );
  }
}
