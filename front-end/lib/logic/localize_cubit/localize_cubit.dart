import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'localize_state.dart';

class LocalizeCubit extends Cubit<LocalizeState> {
  LocalizeCubit() : super(English());

  void change_lang() {
    if (state.index == 0)
      emit(Telugu());
    else
      emit(English());
  }
}
