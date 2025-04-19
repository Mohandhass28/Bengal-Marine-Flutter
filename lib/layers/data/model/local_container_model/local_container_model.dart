import 'dart:convert';

import 'package:portfolio/layers/domain/entity/local_container_entity/local_container_entity.dart';

class LocalContainerModel extends ContainerEntity {
  LocalContainerModel({
    required super.containerNumber,
    required super.imageList,
    required super.type,
    required super.dateAndTime,
  });

  factory LocalContainerModel.fromMap(Map<String, dynamic> json) {
    final List<dynamic> rawImageList = json['image_list'] as List<dynamic>;
    final List<Map<String, dynamic>> imageList =
        rawImageList.map((item) => Map<String, dynamic>.from(item)).toList();

    return LocalContainerModel(
      containerNumber: json['container_number'] as String,
      imageList: imageList,
      type: json['type'] as String,
      dateAndTime: DateTime.parse(json['date_and_time'] as String),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'container_number': containerNumber,
      'image_list': imageList,
      'type': type,
      'date_and_time': dateAndTime.toIso8601String(),
    };
  }

  String toRawJson() => json.encode(toMap());

  factory LocalContainerModel.fromRawJson(String str) =>
      LocalContainerModel.fromMap(json.decode(str));
}
