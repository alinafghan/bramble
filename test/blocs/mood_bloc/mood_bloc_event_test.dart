import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:journal_app/blocs/mood_bloc/mood_bloc.dart';
import 'package:journal_app/models/mood.dart';
import 'package:journal_app/models/user.dart';
import 'package:journal_app/providers/mood_provider/mood_provider.dart';
import 'package:mocktail/mocktail.dart';

class MockMoodProvider extends Mock implements MoodProvider {}

void main() {
  group(('mood bloc tests'), () {
    final mockProvider = MockMoodProvider();
    final sampleMonth = DateTime(2024, 10);
    Mood mood = Mood(
        date: '2024-10-01',
        mood: 'happy',
        user: Users(userId: '1', email: 'test@gmail.com', mod: false));

    Map<String, Mood>? moodList = {
      '1-1-1': Mood(
          date: '2024-10-01',
          mood: 'happy',
          user: Users(userId: '1', email: 'test@gmail.com', mod: false)),
    };

    blocTest<MoodBloc, MoodBlocState>(
      'getmonthlymoods succesfully',
      build: () => MoodBloc(moodProvider: mockProvider),
      setUp: () => when(() => mockProvider.getMood(sampleMonth))
          .thenAnswer((_) async => moodList),
      act: (bloc) => bloc.add(GetMonthlyMoodEvent(month: sampleMonth)),
      skip: 1, //skip loading
      expect: () => <MoodBlocState>[GetMonthlyMoodsLoaded(moodList)],
    );
    blocTest<MoodBloc, MoodBlocState>(
      'getmonthlymoods fails',
      build: () => MoodBloc(moodProvider: mockProvider),
      setUp: () => when(() => mockProvider.getMood(sampleMonth))
          .thenThrow(Exception('Failed to get moods')),
      act: (bloc) => bloc.add(GetMonthlyMoodEvent(month: sampleMonth)),
      skip: 1, //skip loading
      expect: () => <MoodBlocState>[
        const GetMonthlyMoodsFailed('Exception: Failed to get moods')
      ],
    );
    blocTest<MoodBloc, MoodBlocState>(
      'set mood successfully',
      build: () => MoodBloc(moodProvider: mockProvider),
      setUp: () =>
          when(() => mockProvider.setMood('happy', '2024-10-01')).thenAnswer(
        (_) async => mood,
      ),
      act: (bloc) =>
          bloc.add(const SetMoodEvent(moodAsset: 'happy', date: '2024-10-01')),
      skip: 1, //skip loading
      expect: () => <MoodBlocState>[SetMoodLoaded(mood)],
    );
    blocTest<MoodBloc, MoodBlocState>(
      'set mood fails',
      build: () => MoodBloc(moodProvider: mockProvider),
      setUp: () => when(() => mockProvider.setMood('happy', '2024-10-01'))
          .thenThrow(Exception('Failed to set mood')),
      act: (bloc) =>
          bloc.add(const SetMoodEvent(moodAsset: 'happy', date: '2024-10-01')),
      skip: 1, //skip loading
      expect: () =>
          <MoodBlocState>[const SetMoodFailed('Exception: Failed to set mood')],
    );
    blocTest<MoodBloc, MoodBlocState>(
      'delete mood successfully',
      build: () => MoodBloc(moodProvider: mockProvider),
      setUp: () => when(() => mockProvider.deleteMood('2024-10-01'))
          .thenAnswer((_) async {}),
      act: (bloc) => bloc.add(const DeleteMoodEvent(date: '2024-10-01')),
      skip: 1, //skip loading
      expect: () => <MoodBlocState>[const DeleteMoodLoaded('2024-10-01')],
    );
    blocTest<MoodBloc, MoodBlocState>(
      'delete mood fails',
      build: () => MoodBloc(moodProvider: mockProvider),
      setUp: () => when(() => mockProvider.deleteMood('2024-10-01'))
          .thenThrow(Exception('Failed to delete mood')),
      act: (bloc) => bloc.add(const DeleteMoodEvent(date: '2024-10-01')),
      skip: 1, //skip loading
      expect: () => <MoodBlocState>[
        const DeleteMoodFailed('Exception: Failed to delete mood')
      ],
    );
  });
}
