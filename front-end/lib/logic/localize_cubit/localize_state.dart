part of 'localize_cubit.dart';

@immutable
sealed class LocalizeState {
  int index;
  LocalizeState({required this.index});
}

final class English extends LocalizeState {
  English() : super(index: 0);
}

final class Telugu extends LocalizeState {
  Telugu() : super(index: 1);
}
