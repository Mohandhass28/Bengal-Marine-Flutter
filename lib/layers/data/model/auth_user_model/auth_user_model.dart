import 'dart:convert';

import 'package:Bengal_Marine/layers/domain/entity/auth_user_entity/auth_user_entity.dart';

class AuthUserModel extends AuthUserEntity {
  AuthUserModel({
    super.message,
    super.status,
    super.userData,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      message: json['msg']
          as String?, // Changed from 'message' to 'msg' to match API
      status: json['status'] as bool?, // Keep as int? to match parent class
      userData: json['user_data'] != null
          ? UserData.fromJson(json['user_data'] as Map<String, dynamic>)
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'msg': message,
      'status': status, // Keep as int
      'user_data': userData?.toJson(),
    };
  }

  String toRawJson() => json.encode(toJson());

  factory AuthUserModel.fromRawJson(String str) =>
      AuthUserModel.fromJson(json.decode(str));
}
