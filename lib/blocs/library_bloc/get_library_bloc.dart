import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journal_app/models/book.dart';
import 'package:journal_app/providers/library_provider/library_provider.dart';

part 'get_library_event.dart';
part 'get_library_state.dart';

class LibraryBloc extends Bloc<GetLibraryEvent, LibraryState> {
  final LibraryProvider libraryProvider;

  LibraryBloc({required this.libraryProvider}) : super(GetLibraryInitial()) {
    on<GetLibrary>((event, emit) async {
      emit(GetLibraryLoading());
      try {
        List<Book> library = await libraryProvider.getLibrary();
        emit(GetLibraryLoaded(booklist: library));
      } on SocketException {
        emit(const LibraryError(message: 'No Internet'));
      } catch (e) {
        emit(GetLibraryFailed());
      }
    });
    on<SearchBook>((event, emit) async {
      emit(SearchBookLoading());
      try {
        List<Book> books = await libraryProvider.searchBook(event.keyword);
        emit(SearchBookLoaded(books: books));
      } catch (e) {
        emit(SearchBookError(error: e.toString()));
      }
    });
    on<ClearSearch>((event, emit) async {
      emit(SearchCleared(libraryBooks: event.books));
    });
  }
}
