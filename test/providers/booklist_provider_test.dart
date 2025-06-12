import 'package:flutter_test/flutter_test.dart';
import 'package:journal_app/models/book.dart';
import 'package:journal_app/providers/book_provider/book_provider.dart';
import 'package:journal_app/repositories/book_list_repository.dart';
import 'package:mocktail/mocktail.dart';

// Mock class
class MockBookListRepository extends Mock implements BookListRepository {}

void main() {
  late BookListProvider bookListProvider;
  late MockBookListRepository mockRepository;
  late Book testBook;

  setUp(() {
    mockRepository = MockBookListRepository();
    bookListProvider = BookListProvider(repo: mockRepository);
    testBook = Book(bookId: 1, title: 'Test Book', key: '', author: '');
  });

  group('BookListProvider', () {
    test('setBook calls saveBook and returns the book', () async {
      when(() => mockRepository.saveBook(testBook))
          .thenAnswer((_) => Future.value());

      final result = await bookListProvider.setBook(testBook);

      expect(result, testBook);
      verify(() => mockRepository.saveBook(testBook)).called(1);
    });

    test('deleteBook calls removeBook', () async {
      when(() => mockRepository.removeBook(testBook))
          .thenAnswer((_) => Future.value());

      await bookListProvider.deleteBook(testBook);

      verify(() => mockRepository.removeBook(testBook)).called(1);
    });

    test('returnBookList calls returnBookList and returns book list', () async {
      final books = [testBook];
      when(() => mockRepository.returnBookList())
          .thenAnswer((_) async => books);

      final result = await bookListProvider.returnBookList();

      expect(result, books);
      verify(() => mockRepository.returnBookList()).called(1);
    });
  });
}
