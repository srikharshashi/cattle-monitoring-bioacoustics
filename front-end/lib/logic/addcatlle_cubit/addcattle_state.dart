part of 'addcattle_cubit.dart';

@immutable
sealed class AddcattleState {}

final class AddcattleInitial extends AddcattleState {}


class AddCattleLoad extends AddcattleState{}

class AddCattleError extends AddcattleState{}

class AddCattleSuccess extends AddcattleState{}