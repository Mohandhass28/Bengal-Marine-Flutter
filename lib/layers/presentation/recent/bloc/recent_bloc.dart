import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:portfolio/layers/data/model/server_container_model/server_container_model.dart';
import 'package:portfolio/layers/domain/usecase/image_container_usecase/image_container_usecase.dart';

part 'recent_event.dart';
part 'recent_state.dart';

class RecentBloc extends Bloc<RecentEvent, RecentState> {
  final ImageContainerUsecase _imageContainerUsecase;
  RecentBloc({required ImageContainerUsecase imageContainerUsecase})
      : _imageContainerUsecase = imageContainerUsecase,
        super(RecentState()) {
    on<RoadRecentEvent>(_onRoadRecentEvent);
  }

  Future<void> _onRoadRecentEvent(
    RoadRecentEvent event,
    Emitter<RecentState> emit,
  ) async {
    emit(state.copyWith(status: ImageContainerStatus.loading));
    try {
      final result = await _imageContainerUsecase.loadFromServerImages(
          params: event.params);
      if (!emit.isDone) {
        emit(state.copyWith(
          status: ImageContainerStatus.success,
          container: result,
        ));
      }
    } catch (e) {
      if (!emit.isDone) {
        emit(state.copyWith(
          status: ImageContainerStatus.failure,
        ));
      }
      print(e);
    }
  }
}
