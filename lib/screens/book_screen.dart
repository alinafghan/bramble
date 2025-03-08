import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:journal_app/blocs/get_book_details_cubit/get_book_details_cubit.dart';
import 'package:journal_app/models/book.dart';
import 'package:journal_app/utils/constants.dart';

class BookScreen extends StatefulWidget {
  final Book book;

  const BookScreen({super.key, required this.book});

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  @override
  void initState() {
    context.read<GetBookDetailsCubit>().getBookDetails(widget.book);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<GetBookDetailsCubit, GetBookDetailsState>(
        builder: (context, state) {
          if (state is GetAllBooksLoaded) {
            return SingleChildScrollView(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Image.network(state.book.coverUrl!,
                          fit: BoxFit.cover, height: 300, width: 200),
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.book.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                state.book.author,
                                textAlign: TextAlign.justify,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'First published in: ${state.book.publishYear}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ],
                          ),
                          Column(children: [
                            IconButton(
                                onPressed: () {},
                                icon: const HugeIcon(
                                    icon: HugeIcons.strokeRoundedEye,
                                    color: AppTheme.primary)),
                            IconButton(
                                onPressed: () {},
                                icon: const HugeIcon(
                                    icon:
                                        HugeIcons.strokeRoundedAddCircleHalfDot,
                                    color: AppTheme.primary))
                          ])
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text.rich(
                          textAlign: TextAlign.justify,
                          TextSpan(children: [
                            const TextSpan(
                                text: 'Description: ',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                )),
                            TextSpan(
                              text: state.book.description,
                              style: const TextStyle(fontSize: 20),
                            )
                          ])),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text('----------------------------------------'),
                      const SizedBox(
                        height: 20,
                      ),
                      Text.rich(
                        textAlign: TextAlign.justify,
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Sneak peek: ',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: '${state.book.excerpt}...',
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
