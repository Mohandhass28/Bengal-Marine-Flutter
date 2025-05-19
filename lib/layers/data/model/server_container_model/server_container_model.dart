import 'dart:convert';

import 'package:Bengal_Marine/layers/domain/entity/server_container_entity/server_container_entity.dart';

class ServerContainerModel extends ContainerEntity {
  ServerContainerModel({
    required super.container_info_id,
    required super.cont_no,
    required super.yard_id,
    required super.yard_name,
    required super.user_id,
    required super.user_name,
    required super.status,
    required super.container_info_image,
  });

  factory ServerContainerModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawImageList =
        json['container_info_image'] as List<dynamic>;
    final List<Map<String, dynamic>> imageList =
        rawImageList.map((item) => Map<String, dynamic>.from(item)).toList();

    return ServerContainerModel(
      container_info_id: json['container_info_id'] as int,
      cont_no: json['cont_no'] as String,
      yard_id: json['yard_id'] as int,
      yard_name: json['yard_name'] as String,
      user_id: json['user_id'] as int,
      user_name: json['user_name'] as String,
      status: json['status'] as bool,
      container_info_image: imageList,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'container_info_id': container_info_id,
      'cont_no': cont_no,
      'yard_id': yard_id,
      'yard_name': yard_name,
      'user_id': user_id,
      'user_name': user_name,
      'status': status,
      'container_info_image': container_info_image,
    };
  }

  String toRawJson() => json.encode(toMap());

  factory ServerContainerModel.fromRawJson(String str) =>
      ServerContainerModel.fromJson(json.decode(str));
}
