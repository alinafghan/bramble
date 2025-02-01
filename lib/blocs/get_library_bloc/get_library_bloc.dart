import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:journal_app/models/book.dart';
import 'package:journal_app/models/user.dart';
import 'package:journal_app/providers/book_provider/book_provider.dart';

part 'get_library_event.dart';
part 'get_library_state.dart';

class GetLibraryBloc extends Bloc<GetLibraryEvent, GetLibraryState> {
  BookProvider bookProvider = BookProvider();

  GetLibraryBloc({required BookProvider provider})
      : bookProvider = provider,
        super(GetLibraryInitial()) {
    on<GetUserLibrary>((event, emit) async {
      emit(GetUserLibraryLoading());
      try {
        List<Book> library = await provider.getLibrary(event.user.userId);
        emit(GetUserLibraryLoaded(booklist: library));
      } catch (e) {
        emit(GetUserLibraryFailed());
      }
    });
  }
}
