import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:journal_app/blocs/review_cubit/review_cubit.dart';
import 'package:journal_app/models/book.dart';
import 'package:journal_app/models/review.dart';
import 'package:journal_app/models/user.dart';
import 'package:journal_app/providers/review_provider/review_provider.dart';
import 'package:mocktail/mocktail.dart';

class MockReviewProvider extends Mock implements ReviewProvider {}

void main() {
  group('review cubit tests', () {
    final mockProvider = MockReviewProvider();
    final review = Review(
      id: '1',
      text: 'Great book!',
      numLikes: 5,
      createdAt: 'just now',
      user: Users(userId: '1', email: 'test@gmail.com', mod: false),
      book: Book(
          key: '1',
          bookId: 1,
          author: 'Jane Austen',
          title: 'Pride and Prejudice',
          coverUrl: 'https://example.com/cover.jpg'),
    );
    List<Review> reviews = [];

    blocTest<ReviewCubit, ReviewState>(
      'set review successfully',
      build: () => ReviewCubit(reviewProvider: mockProvider),
      setUp: () => when(() => mockProvider.setReview(review.book, review))
          .thenAnswer((_) async => review),
      act: (cubit) => cubit.setReview(review, review.book),
      skip: 1, //skip loading
      expect: () => <ReviewState>[SetReviewSuccess(review)],
    );
    blocTest<ReviewCubit, ReviewState>(
      'set review fails',
      build: () => ReviewCubit(reviewProvider: mockProvider),
      setUp: () => when(() => mockProvider.setReview(review.book, review))
          .thenThrow(Exception('Failed to set review')),
      act: (cubit) => cubit.setReview(review, review.book),
      skip: 1, //skip loading
      expect: () => <ReviewState>[
        const SetReviewFailure('Exception: Failed to set review')
      ],
    );
    blocTest<ReviewCubit, ReviewState>(
      'like review successfully',
      build: () => ReviewCubit(reviewProvider: mockProvider),
      setUp: () => when(() => mockProvider.likeReview(review))
          .thenAnswer((_) async => review),
      act: (cubit) => cubit.likeReview(review),
      skip: 1,
      expect: () => <ReviewState>[GetReviewForBookSuccess(reviews)],
    );
    blocTest<ReviewCubit, ReviewState>(
      'like review fails',
      build: () => ReviewCubit(reviewProvider: mockProvider),
      setUp: () => when(() => mockProvider.likeReview(review))
          .thenThrow(Exception('Failed to like review')),
      act: (cubit) => cubit.likeReview(review),
      skip: 1, //skip loading
      expect: () => <ReviewState>[
        const LikeReviewFailure('Exception: Failed to like review')
      ],
    );
    blocTest<ReviewCubit, ReviewState>(
      'get review for book successfully',
      build: () => ReviewCubit(reviewProvider: mockProvider),
      setUp: () => when(() => mockProvider.getReviewsForBook(review.book))
          .thenAnswer((_) async => [review]),
      act: (cubit) => cubit.getReviewForBook(review.book),
      skip: 1, //skip loading
      expect: () => <ReviewState>[
        GetReviewForBookSuccess([review])
      ],
    );
    blocTest<ReviewCubit, ReviewState>(
      'get review for book fails',
      build: () => ReviewCubit(reviewProvider: mockProvider),
      setUp: () => when(() => mockProvider.getReviewsForBook(review.book))
          .thenThrow(Exception('Failed to get reviews')),
      act: (cubit) => cubit.getReviewForBook(review.book),
      skip: 1, //skip loading
      expect: () => <ReviewState>[
        const GetReviewForBookFailure('Exception: Failed to get reviews')
      ],
    );
  });
  group('review cubit tests', () {
    final mockProvider = MockReviewProvider();
    final review = Review(
      id: '1',
      text: 'Great book!',
      numLikes: 5,
      createdAt: 'just now',
      user: Users(userId: '1', email: 'test@gmail.com', mod: false),
      book: Book(
        key: '1',
        bookId: 1,
        author: 'Jane Austen',
        title: 'Pride and Prejudice',
        coverUrl: 'https://example.com/cover.jpg',
      ),
    );

    group('getReportedReviews', () {
      blocTest<ReviewCubit, ReviewState>(
        'emits [Loading, Loaded] when successful',
        build: () => ReviewCubit(reviewProvider: mockProvider),
        setUp: () => when(() => mockProvider.getReportedReviews())
            .thenAnswer((_) async => [review]),
        act: (cubit) => cubit.getReportedReviews(),
        expect: () => [
          GetReportedReviewsLoading(),
          GetReportedReviewsLoaded(reportedReviews: [review]),
        ],
      );

      blocTest<ReviewCubit, ReviewState>(
        'emits [Loading, Failure] when error occurs',
        build: () => ReviewCubit(reviewProvider: mockProvider),
        setUp: () => when(() => mockProvider.getReportedReviews())
            .thenThrow(Exception('Failed to fetch')),
        act: (cubit) => cubit.getReportedReviews(),
        expect: () => [
          GetReportedReviewsLoading(),
          const GetReportedReviewsFailure(
              message: 'Exception: Failed to fetch'),
        ],
      );
    });

    group('reportReview', () {
      blocTest<ReviewCubit, ReviewState>(
        'emits [Loading, Loaded] when successful',
        build: () => ReviewCubit(reviewProvider: mockProvider),
        setUp: () => when(() => mockProvider.reportReview(review, 'spam'))
            .thenAnswer((_) async {}),
        act: (cubit) => cubit.reportReview(review, 'spam'),
        expect: () => [
          ReportReviewLoading(),
          ReportedReviewLoaded(review: review),
        ],
      );

      blocTest<ReviewCubit, ReviewState>(
        'emits [Loading, Failure] when error occurs',
        build: () => ReviewCubit(reviewProvider: mockProvider),
        setUp: () => when(() => mockProvider.reportReview(review, 'spam'))
            .thenThrow(Exception('Report failed')),
        act: (cubit) => cubit.reportReview(review, 'spam'),
        expect: () => [
          ReportReviewLoading(),
          const ReportedReviewFailure(message: 'Exception: Report failed'),
        ],
      );
    });

    group('deleteReview', () {
      blocTest<ReviewCubit, ReviewState>(
        'emits [Loading, Loaded] when successful',
        build: () => ReviewCubit(reviewProvider: mockProvider),
        setUp: () => when(() => mockProvider.deleteReview(review))
            .thenAnswer((_) async {}),
        act: (cubit) => cubit.deleteReview(review),
        expect: () => [
          DeleteReviewLoading(),
          DeleteReviewLoaded(),
        ],
      );

      blocTest<ReviewCubit, ReviewState>(
        'emits [Loading, Failure] when error occurs',
        build: () => ReviewCubit(reviewProvider: mockProvider),
        setUp: () => when(() => mockProvider.deleteReview(review))
            .thenThrow(Exception('Delete failed')),
        act: (cubit) => cubit.deleteReview(review),
        expect: () => [
          DeleteReviewLoading(),
          const DeleteReviewFailure(message: 'Exception: Delete failed'),
        ],
      );
    });
  });
}
