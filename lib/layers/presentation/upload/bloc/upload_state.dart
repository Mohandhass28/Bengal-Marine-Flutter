part of 'upload_bloc.dart';

enum ImageContainerSubmitStatus { initial, loading, success, failure }

class UploadState {
  final List<Map<String, dynamic>> images;
  final ContainerType type;
  final ImageContainerSubmitStatus status;

  UploadState({
    this.images = const [],
    this.type = ContainerType.none,
    this.status = ImageContainerSubmitStatus.initial,
  });

  UploadState copyWith({
    List<Map<String, dynamic>>? images,
    ContainerType? type,
    ImageContainerSubmitStatus? status,
  }) {
    return UploadState(
      images: images ?? this.images,
      type: type ?? this.type,
      status: status ?? this.status,
    );
  }
}
