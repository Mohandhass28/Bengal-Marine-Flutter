part of 'recent_bloc.dart';

@immutable
sealed class RecentEvent {}

class RoadRecentEvent extends RecentEvent {
  final Map<String, dynamic> params;

  RoadRecentEvent({required this.params});
}
