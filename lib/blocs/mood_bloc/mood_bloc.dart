import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:journal_app/models/mood.dart';
import 'package:journal_app/providers/mood_provider/mood_provider.dart';

part 'mood_bloc_event.dart';
part 'mood_bloc_state.dart';

class MoodBloc extends Bloc<MoodBlocEvent, MoodBlocState> {
  MoodProvider moodProvider = MoodProvider();

  MoodBloc({required MoodProvider provider})
      : moodProvider = provider,
        super(MoodBlocInitial()) {
    on<GetMonthlyMoodEvent>((event, emit) async {
      emit(GetMonthlyMoodsLoading());
      try {
        final mood = await moodProvider.getMood(event.month);
        emit(GetMonthlyMoodsLoaded(mood));
      } catch (e) {
        emit(GetMonthlyMoodsFailed(e.toString()));
      }
    });
    on<SetMoodEvent>((event, emit) async {
      emit(SetMoodLoading());
      try {
        await moodProvider.setMood(event.mood);
        emit(SetMoodLoaded(event.mood));
      } catch (e) {
        emit(SetMoodFailed(e.toString()));
      }
    });
  }
}
