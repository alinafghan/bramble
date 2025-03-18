import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:journal_app/models/book.dart';
import 'package:journal_app/providers/library_provider/library_provider.dart';

part 'get_library_event.dart';
part 'get_library_state.dart';

class GetLibraryBloc extends Bloc<GetLibraryEvent, GetLibraryState> {
  LibraryProvider libraryProvider = LibraryProvider();

  GetLibraryBloc({required LibraryProvider provider})
      : libraryProvider = provider,
        super(GetLibraryInitial()) {
    on<GetLibrary>((event, emit) async {
      emit(GetLibraryLoading());
      try {
        List<Book> library = await provider.getLibrary();
        emit(GetLibraryLoaded(booklist: library));
      } catch (e) {
        emit(GetLibraryFailed());
      }
    });
  }
}
