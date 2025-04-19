part of 'upload_bloc.dart';

@immutable
sealed class UploadEvent {}

class PreContainerEvent extends UploadEvent {
  final String imagePath;

  PreContainerEvent({required this.imagePath});
}

class PostContainerEvent extends UploadEvent {
  final String imagePath;

  PostContainerEvent({required this.imagePath});
}

class AVURContainerEvent extends UploadEvent {
  final String imagePath;

  AVURContainerEvent({required this.imagePath});
}

class RemoveImageEvent extends UploadEvent {
  final int imageId;

  RemoveImageEvent({required this.imageId});
}

class RemoveAllvent extends UploadEvent {}

class UploadSubmitted extends UploadEvent {
  final Map<String, dynamic> containerImages;

  UploadSubmitted({required this.containerImages});
}
