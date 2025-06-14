import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'font_state.dart';

class FontCubit extends Cubit<String> {
  FontCubit() : super('Dovemayo');

  void changeFont(String fontFamily) {
    emit(fontFamily);
  }
}
