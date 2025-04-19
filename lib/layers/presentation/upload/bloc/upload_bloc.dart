import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:portfolio/layers/domain/usecase/image_container_usecase/image_container_usecase.dart';
import 'package:portfolio/layers/presentation/upload/view/upload_page.dart';

part 'upload_event.dart';
part 'upload_state.dart';

class UploadBloc extends Bloc<UploadEvent, UploadState> {
  final ImageContainerUsecase _imageContainerUsecase;
  UploadBloc({required ImageContainerUsecase imageContainerUsecase})
      : _imageContainerUsecase = imageContainerUsecase,
        super(UploadState()) {
    on<PreContainerEvent>((event, emit) {
      if (state.type == ContainerType.pre) {
        final currentState = state;
        final newImages = List<Map<String, dynamic>>.from(currentState.images)
          ..add(
              {"id": currentState.images.length + 1, "image": event.imagePath});
        emit(state.copyWith(
          status: ImageContainerSubmitStatus.success,
          type: ContainerType.pre,
          images: newImages,
        ));
      } else {
        emit(state.copyWith(
          status: ImageContainerSubmitStatus.success,
          type: ContainerType.pre,
          images: [
            {"id": 1, "image": event.imagePath}
          ],
        ));
      }
    });
    on<PostContainerEvent>((event, emit) {
      if (state.type == ContainerType.post) {
        final currentState = state;
        final newImages = List<Map<String, dynamic>>.from(currentState.images)
          ..add(
              {"id": currentState.images.length + 1, "image": event.imagePath});
        emit(state.copyWith(
          status: ImageContainerSubmitStatus.success,
          type: ContainerType.post,
          images: newImages,
        ));
      } else {
        emit(state.copyWith(
          status: ImageContainerSubmitStatus.success,
          type: ContainerType.post,
          images: [
            {"id": 1, "image": event.imagePath}
          ],
        ));
      }
    });
    on<AVURContainerEvent>((event, emit) {
      if (state.type == ContainerType.AVUR) {
        final currentState = state;
        final newImages = List<Map<String, dynamic>>.from(currentState.images)
          ..add(
              {"id": currentState.images.length + 1, "image": event.imagePath});
        emit(state.copyWith(
          status: ImageContainerSubmitStatus.success,
          type: ContainerType.AVUR,
          images: newImages,
        ));
      } else {
        emit(state.copyWith(
          status: ImageContainerSubmitStatus.success,
          type: ContainerType.AVUR,
          images: [
            {"id": 1, "image": event.imagePath}
          ],
        ));
      }
    });
    on<RemoveImageEvent>((event, emit) {
      if (state.type == ContainerType.pre) {
        final currentState = state;
        final newImages = currentState.images
            .where((image) => image["id"] != event.imageId)
            .toList();
        if (newImages.isEmpty) {
          emit(state.copyWith(
            status: ImageContainerSubmitStatus.success,
            type: ContainerType.none,
            images: [],
          ));
          return;
        }
        emit(state.copyWith(
          status: ImageContainerSubmitStatus.success,
          type: ContainerType.pre,
          images: newImages,
        ));
      } else if (state.type == ContainerType.post) {
        final currentState = state;
        final newImages = currentState.images
            .where((image) => image["id"] != event.imageId)
            .toList();
        if (newImages.isEmpty) {
          emit(
            state.copyWith(
              status: ImageContainerSubmitStatus.success,
              type: ContainerType.none,
              images: [],
            ),
          );
          return;
        }
        emit(state.copyWith(
          status: ImageContainerSubmitStatus.success,
          type: ContainerType.post,
          images: newImages,
        ));
      } else if (state.type == ContainerType.AVUR) {
        final currentState = state;
        final newImages = currentState.images
            .where((image) => image["id"] != event.imageId)
            .toList();
        if (newImages.isEmpty) {
          emit(
            state.copyWith(
              status: ImageContainerSubmitStatus.success,
              type: ContainerType.none,
              images: [],
            ),
          );
          return;
        }
        emit(
          state.copyWith(
            status: ImageContainerSubmitStatus.success,
            type: ContainerType.AVUR,
            images: newImages,
          ),
        );
      }
    });
    on<RemoveAllvent>((event, emit) {
      emit(state.copyWith(
        status: ImageContainerSubmitStatus.success,
        type: ContainerType.none,
        images: [],
      ));
    });

    on<UploadSubmitted>((event, emit) async {});
  }
}
