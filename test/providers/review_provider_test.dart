import 'package:flutter_test/flutter_test.dart';
import 'package:journal_app/models/book.dart';
import 'package:journal_app/models/review.dart';
import 'package:journal_app/models/user.dart';
import 'package:journal_app/providers/review_provider/review_provider.dart';
import 'package:journal_app/repositories/review_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockReviewRepository extends Mock implements ReviewRepository {}

void main() {
  late MockReviewRepository mockRepo;
  late ReviewProvider provider;

  late Book testBook;
  late Users testUser;
  late Review testReview;

  setUp(() {
    mockRepo = MockReviewRepository();
    provider = ReviewProvider(repo: mockRepo);

    testBook = Book(bookId: 1, title: 'Sample Book', key: '', author: '');
    testUser = Users(
        userId: 'user123',
        username: 'testuser',
        email: 'test@gmail.com',
        mod: false);
    testReview = Review(
      id: 'user1231',
      user: testUser,
      book: testBook,
      text: 'Great book!',
      numLikes: 0,
      createdAt: '',
    );
  });

  group('ReviewProvider Tests', () {
    test('getReviewsForBook returns list of reviews', () async {
      final reviews = [testReview];

      when(() => mockRepo.getReviewsForBook(testBook))
          .thenAnswer((_) async => reviews);

      final result = await provider.getReviewsForBook(testBook);

      expect(result, equals(reviews));
      verify(() => mockRepo.getReviewsForBook(testBook)).called(1);
    });

    test('getReview returns single review', () async {
      when(() => mockRepo.getReview(testBook, testUser.userId))
          .thenAnswer((_) async => testReview);

      final result = await provider.getReview(testBook, testUser);

      expect(result, equals(testReview));
      verify(() => mockRepo.getReview(testBook, testUser.userId)).called(1);
    });

    test('setReview saves and returns review', () async {
      when(() => mockRepo.setReview(testReview, testBook))
          .thenAnswer((_) async => testReview);

      final result = await provider.setReview(testBook, testReview);

      expect(result, equals(testReview));
      verify(() => mockRepo.setReview(testReview, testBook)).called(1);
    });

    test('likeReview toggles like status and returns updated review', () async {
      when(() => mockRepo.likeReview(testReview))
          .thenAnswer((_) async => testReview);

      final result = await provider.likeReview(testReview);

      expect(result, equals(testReview));
      verify(() => mockRepo.likeReview(testReview)).called(1);
    });
  });
  test('getReportedReviews returns list of reported reviews', () async {
    final reportedReviews = [testReview];

    when(() => mockRepo.getReportedReviews())
        .thenAnswer((_) async => reportedReviews);

    final result = await provider.getReportedReviews();

    expect(result, equals(reportedReviews));
    verify(() => mockRepo.getReportedReviews()).called(1);
  });

  test('reportReview calls repository method', () async {
    when(() =>
            mockRepo.reportReview(review: testReview, reason: 'inappropriate'))
        .thenAnswer((_) async {});

    await provider.reportReview(testReview, 'inappropriate');

    verify(() =>
            mockRepo.reportReview(review: testReview, reason: 'inappropriate'))
        .called(1);
  });

  test('deleteReview calls repository method', () async {
    when(() => mockRepo.deleteReview(testReview)).thenAnswer((_) async {});

    await provider.deleteReview(testReview);

    verify(() => mockRepo.deleteReview(testReview)).called(1);
  });
}
