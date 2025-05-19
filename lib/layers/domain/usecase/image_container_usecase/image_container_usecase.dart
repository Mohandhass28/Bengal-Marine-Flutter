import 'package:Bengal_Marine/layers/data/model/local_container_model/local_container_model.dart';
import 'package:Bengal_Marine/layers/data/model/server_container_model/server_container_model.dart';
import 'package:Bengal_Marine/layers/domain/repository/image_container_repo/image_container.dart';

class ImageContainerUsecase {
  final ImageContainerRepo imageContainerRepo;

  ImageContainerUsecase({required this.imageContainerRepo});

  Future<void> saveImagesTolocal(
      {required Map<String, dynamic> containerImages}) async {
    final newcontainerImage = LocalContainerModel.fromMap(containerImages);
    await imageContainerRepo.saveImagesTolocal(
        containerImages: newcontainerImage);
  }

  Future<void> removeContainer({required String containernumber}) async {
    await imageContainerRepo.removeContainer(containernumber: containernumber);
  }

  Future<List<LocalContainerModel>> loadFromLocalImages() async {
    return await imageContainerRepo.loadFromLocalImages();
  }

  Future<bool> saveImagesToServer(
      {required Map<String, dynamic> containerImages}) async {
    return await imageContainerRepo.saveImagesToServer(
        containerImages: containerImages);
  }

  Future<List<ServerContainerModel>> loadFromServerImages(
      {required Map<String, dynamic> params}) async {
    return await imageContainerRepo.loadFromServerImages(params: params);
  }
}
