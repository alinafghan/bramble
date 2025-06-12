import 'package:flutter_test/flutter_test.dart';
import 'package:journal_app/models/book.dart';
import 'package:journal_app/providers/library_provider/library_provider.dart';
import 'package:journal_app/repositories/library_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockLibraryRepository extends Mock implements LibraryRepository {}

void main() {
  late MockLibraryRepository mockRepo;
  late LibraryProvider provider;
  late Book testBook;

  setUp(() {
    mockRepo = MockLibraryRepository();
    provider = LibraryProvider(repo: mockRepo);
    testBook = Book(
      bookId: 1,
      title: '1984',
      author: 'George Orwell',
      key: '12345',
    );
  });

  group('LibraryProvider Tests', () {
    test('getLibrary returns list of books', () async {
      final bookList = [testBook];
      when(() => mockRepo.getLibrary()).thenAnswer((_) async => bookList);

      final result = await provider.getLibrary();

      expect(result, equals(bookList));
      verify(() => mockRepo.getLibrary()).called(1);
    });

    test('searchBook returns matching books', () async {
      final keyword = '1984';
      final bookList = [testBook];
      when(() => mockRepo.searchBook(keyword))
          .thenAnswer((_) async => bookList);

      final result = await provider.searchBook(keyword);

      expect(result, equals(bookList));
      verify(() => mockRepo.searchBook(keyword)).called(1);
    });

    test('getBookDetails returns book with details', () async {
      when(() => mockRepo.getBookDetails(testBook))
          .thenAnswer((_) async => testBook);

      final result = await provider.getBookDetails(testBook);

      expect(result, equals(testBook));
      verify(() => mockRepo.getBookDetails(testBook)).called(1);
    });
  });
}
