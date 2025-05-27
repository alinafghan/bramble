import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:journal_app/blocs/library_bloc/get_library_bloc.dart';
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
    context.read<LibraryBloc>().add(GetBookDetails(input: widget.book));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<LibraryBloc, LibraryState>(
        builder: (context, state) {
          if (state is GetAllBooksLoaded) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Image.network(
                      state.book.coverUrl!,
                      fit: BoxFit.cover,
                      height: MediaQuery.of(context).size.height / 4.7,
                      width: MediaQuery.of(context).size.width / 3.2,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              child: Text(
                                state.book.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              state.book.author,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              '${state.book.publishYear}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 10),
                            ),
                          ],
                        ),
                        Column(children: [
                          IconButton(
                              onPressed: () {
                                context.push('/book_review', extra: state.book);
                              },
                              icon: const HugeIcon(
                                  icon: HugeIcons.strokeRoundedEye,
                                  color: AppTheme.palette3)),
                          IconButton(
                              onPressed: () {
                                context.push('/review', extra: state.book);
                              },
                              icon: const HugeIcon(
                                  icon: HugeIcons.strokeRoundedAddCircleHalfDot,
                                  color: AppTheme.palette3))
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
                    const Text('---------------------------------------'),
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
            );
          } else {
            return Center(
              child: Lottie.asset('assets/plant.json'),
            );
          }
        },
      ),
    );
  }
}
