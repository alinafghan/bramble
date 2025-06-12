import 'package:journal_app/models/book.dart';
import 'package:journal_app/repositories/library_repository.dart';

class LibraryProvider {
  final LibraryRepository libraryRepository;

  LibraryProvider({LibraryRepository? repo})
      : libraryRepository = repo ?? LibraryRepository();

  Future<List<Book>> getLibrary() async {
    return await libraryRepository.getLibrary();
  }

  Future<List<Book>> searchBook(String keyword) async {
    return await libraryRepository.searchBook(keyword);
  }

  Future<Book> getBookDetails(Book book) async {
    return await libraryRepository.getBookDetails(book);
  }
}
