part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

class HomeLoad extends HomeState {}

class HomeError extends HomeState {}

class HomeLoaded extends HomeState {
  List<Map<String, dynamic>> cattle_list;
  HomeLoaded({required this.cattle_list});
}
