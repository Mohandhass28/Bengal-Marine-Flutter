import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:Bengal_Marine/layers/data/model/local_container_model/local_container_model.dart';
import 'package:Bengal_Marine/layers/domain/usecase/image_container_usecase/image_container_usecase.dart';

part 'local_event.dart';
part 'local_state.dart';

class LocalBloc extends Bloc<LocalEvent, LocalState> {
  final ImageContainerUsecase _imageContainerUsecase;
  LocalBloc({required ImageContainerUsecase imageContainerUsecase})
      : _imageContainerUsecase = imageContainerUsecase,
        super(LocalState()) {
    on<LocalSubmitted>(_onLocalSubmitted);
    on<LocalLoadEvent>(_onLocalLoadEvent);
    on<UploadToServerEvent>(uploadToServer);
    on<RemoveContainerEvent>(_removeContainer);
  }

  Future<void> _onLocalSubmitted(
    LocalSubmitted event,
    Emitter<LocalState> emit,
  ) async {
    emit(state.copyWith(status: ImageContainerStatus.loading));
    try {
      await _imageContainerUsecase.saveImagesTolocal(
          containerImages: event.containerImages);
      emit(state.copyWith(
        status: ImageContainerStatus.success,
      ));
      add(LocalLoadEvent());
    } catch (e) {
      emit(state.copyWith(
        status: ImageContainerStatus.failure,
      ));
    }
  }

  Future<void> _onLocalLoadEvent(
    LocalLoadEvent event,
    Emitter<LocalState> emit,
  ) async {
    emit(state.copyWith(status: ImageContainerStatus.loading));
    try {
      final result = await _imageContainerUsecase.loadFromLocalImages();
      emit(state.copyWith(
          status: ImageContainerStatus.success, container: result));
    } catch (e) {
      emit(state.copyWith(
        status: ImageContainerStatus.failure,
      ));
    }
  }

  Future<void> uploadToServer(
    UploadToServerEvent event,
    Emitter<LocalState> emit,
  ) async {
    emit(state.copyWith(status: ImageContainerStatus.loading));
    try {
      await _imageContainerUsecase.saveImagesToServer(
          containerImages: event.containerImages);
      emit(state.copyWith(
        status: ImageContainerStatus.success,
      ));
      add(RemoveContainerEvent(
          containernumber: event.containerImages['number']));
    } catch (e) {
      emit(state.copyWith(
        status: ImageContainerStatus.failure,
      ));
    }
  }

  Future<void> _removeContainer(
    RemoveContainerEvent event,
    Emitter<LocalState> emit,
  ) async {
    emit(state.copyWith(status: ImageContainerStatus.loading));
    try {
      await _imageContainerUsecase.removeContainer(
          containernumber: event.containernumber);
      emit(state.copyWith(
        status: ImageContainerStatus.success,
      ));
      add(LocalLoadEvent());
    } catch (e) {
      emit(state.copyWith(
        status: ImageContainerStatus.failure,
      ));
    }
  }
}
