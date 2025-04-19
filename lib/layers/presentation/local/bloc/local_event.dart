part of 'local_bloc.dart';

@immutable
sealed class LocalEvent {}

final class LocalSubmitted extends LocalEvent {
  final Map<String, dynamic> containerImages;

  LocalSubmitted({required this.containerImages});
}

final class LocalLoadEvent extends LocalEvent {}

class UploadToServerEvent extends LocalEvent {
  final Map<String, dynamic> containerImages;

  UploadToServerEvent({required this.containerImages});
}

class RemoveContainerEvent extends LocalEvent {
  final String containernumber;

  RemoveContainerEvent({required this.containernumber});
}
