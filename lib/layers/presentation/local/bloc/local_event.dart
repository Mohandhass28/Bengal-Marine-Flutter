part of 'local_bloc.dart';

@immutable
sealed class LocalEvent {}

final class LocalSubmitted extends LocalEvent {
  final Map<String, dynamic> containerImages;

  LocalSubmitted({required this.containerImages});
}

final class LocalLoadEvent extends LocalEvent {}
