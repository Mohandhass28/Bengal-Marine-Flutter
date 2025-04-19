import 'package:portfolio/layers/data/model/local_container_model/local_container_model.dart';
import 'package:portfolio/layers/data/model/server_container_model/server_container_model.dart';

abstract class ImageContainerRepo {
  Future<void> saveImagesTolocal(
      {required LocalContainerModel containerImages});
  Future<List<LocalContainerModel>> loadFromLocalImages();
  Future<bool> saveImagesToServer(
      {required Map<String, dynamic> containerImages});
  Future<List<ServerContainerModel>> loadFromServerImages(
      {required Map<String, dynamic> params});
}
