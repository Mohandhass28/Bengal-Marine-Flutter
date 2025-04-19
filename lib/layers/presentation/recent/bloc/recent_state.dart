part of 'recent_bloc.dart';

enum ImageContainerStatus { initial, loading, success, failure }

@immutable
class RecentState {
  final ImageContainerStatus status;
  final List<ServerContainerModel> container;

  const RecentState({
    this.status = ImageContainerStatus.initial,
    this.container = const [],
  });

  RecentState copyWith({
    ImageContainerStatus? status,
    List<ServerContainerModel>? container,
  }) {
    return RecentState(
      status: status ?? this.status,
      container: container ?? this.container,
    );
  }
}
