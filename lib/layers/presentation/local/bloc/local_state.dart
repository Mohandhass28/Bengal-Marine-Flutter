part of 'local_bloc.dart';

enum ImageContainerStatus { initial, loading, success, failure }

@immutable
class LocalState {
  final ImageContainerStatus status;
  final List<LocalContainerModel> container;

  const LocalState({
    this.status = ImageContainerStatus.initial,
    this.container = const [],
  });

  LocalState copyWith({
    ImageContainerStatus? status,
    List<LocalContainerModel>? container,
  }) {
    return LocalState(
      status: status ?? this.status,
      container: container ?? this.container,
    );
  }
}
