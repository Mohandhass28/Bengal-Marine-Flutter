import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:portfolio/layers/data/model/local_container_model/local_container_model.dart';
import 'package:portfolio/layers/data/model/server_container_model/server_container_model.dart';
import 'package:portfolio/layers/data/source/local/local_storage.dart';
import 'package:portfolio/layers/data/source/network/api.dart';
import 'package:portfolio/layers/domain/repository/image_container_repo/image_container.dart';
import 'package:http_parser/http_parser.dart';

class ImageContainerRepoImpl implements ImageContainerRepo {
  final Api _api;
  final LocalStorage _localStorage;

  ImageContainerRepoImpl({
    required Api api,
    required LocalStorage localStorage,
  })  : _api = api,
        _localStorage = localStorage;

  @override
  Future<void> saveImagesTolocal({
    required LocalContainerModel containerImages,
  }) async {
    try {
      final result = await _localStorage.loadImages();
      if (result.isNotEmpty) {
        final List<dynamic> decodedData = json.decode(result);
        final List<Map<String, dynamic>> existingImages =
            decodedData.map((item) => Map<String, dynamic>.from(item)).toList();

        final newContainer = [containerImages.toMap()];
        newContainer.addAll(existingImages);
        final String updatedResult = json.encode(newContainer);
        await _localStorage.saveImages(containerImages: updatedResult);
        print('Images saved successfully');
      } else {
        final List<Map<String, dynamic>> images = [containerImages.toMap()];
        final String updatedResult = json.encode(images);
        await _localStorage.saveImages(containerImages: updatedResult);
      }
    } catch (e) {
      print('Error saving images: $e');
      rethrow;
    }
  }

  @override
  Future<List<LocalContainerModel>> loadFromLocalImages() async {
    try {
      final result = await _localStorage.loadImages();
      final List<dynamic> decodedData = json.decode(result);
      final List<Map<String, dynamic>> data =
          decodedData.map((item) => Map<String, dynamic>.from(item)).toList();

      final List<LocalContainerModel> finalData =
          data.map((e) => LocalContainerModel.fromMap(e)).toList();
      print('Images Load successfully');
      return finalData;
    } catch (e) {
      print('Error loading images: $e');
      return [];
    }
  }

  @override
  Future<bool> saveImagesToServer({
    required Map<String, dynamic> containerImages,
  }) async {
    try {
      // Create form data
      final formData = FormData();

      // Add text fields
      formData.fields.addAll([
        MapEntry('user_id', containerImages['user_id'].toString()),
        MapEntry('container_no', containerImages['number']),
        MapEntry('yard_id', containerImages['yard_id'].toString()),
        MapEntry('container_image_type', containerImages['type'].toString()),
      ]);

      // Add images
      final imageList = containerImages['image_list'] as List;
      for (int i = 0; i < imageList.length; i++) {
        final imagePath = imageList[i]['image'];
        if (imagePath.startsWith('http')) {
          // Handle network images
          formData.fields.add(MapEntry('file[$i]', imagePath));
        } else {
          // Handle local file images
          final file = File(imagePath);
          if (await file.exists()) {
            formData.files.add(MapEntry(
              'file[$i]',
              await MultipartFile.fromFile(
                file.path,
                filename: 'image_$i.jpg',
                contentType: MediaType.parse('image/jpeg'),
              ),
            ));
          }
        }
      }

      await _api.getData(
        endpoint: "auth/upload_container_image",
        data: formData,
        method: 'POST',
      );

      return true;
    } catch (e) {
      print('Error saving images: $e');
      rethrow;
    }
  }

  @override
  Future<List<ServerContainerModel>> loadFromServerImages(
      {required Map<String, dynamic> params}) async {
    try {
      final result = await _api.getData<Map<String, dynamic>>(
        endpoint: "auth/userwise_container_image_list",
        params: params,
        method: 'POST',
      );
      final List<dynamic> decodedData = result['data'];
      final List<Map<String, dynamic>> data =
          decodedData.map((item) => Map<String, dynamic>.from(item)).toList();

      final List<ServerContainerModel> finalData =
          data.map((e) => ServerContainerModel.fromJson(e)).toList();
      print('Images Load successfully');
      return finalData;
    } catch (e) {
      print('Error loading images: $e');
      rethrow;
    }
  }

  @override
  Future<void> removeContainer({required String containernumber}) async {
    try {
      final result = await _localStorage.loadImages();
      final List<dynamic> decodedData = json.decode(result);
      final List<Map<String, dynamic>> data =
          decodedData.map((item) => Map<String, dynamic>.from(item)).toList();

      final List<Map<String, dynamic>> filteredData = data
          .where((element) => element['container_number'] != containernumber)
          .toList();

      final String updatedResult = json.encode(filteredData);
      await _localStorage.saveImages(containerImages: updatedResult);
    } catch (e) {
      print('Error removing container: $e');
      rethrow;
    }
  }
}
