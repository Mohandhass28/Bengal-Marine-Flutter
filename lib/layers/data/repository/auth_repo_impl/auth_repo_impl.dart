import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:portfolio/layers/data/model/auth_user_model/auth_user_model.dart';
import 'package:portfolio/layers/data/source/local/local_storage.dart';
import 'package:portfolio/layers/data/source/network/api.dart';
import 'package:portfolio/layers/domain/entity/auth_user_entity/auth_user_entity.dart';
import 'package:portfolio/layers/domain/repository/auth_repo/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final Api api;
  final LocalStorage localStorage;

  AuthRepoImpl({required this.api, required this.localStorage});

  @override
  Future<UserData> authCheck() async {
    try {
      final token = await localStorage.getData(Key: 'user');
      if (token.isNotEmpty) {
        try {
          final Map<String, dynamic> jsonData = json.decode(token);
          return UserData.fromJson(jsonData);
        } catch (e) {
          print('JSON parsing error: $e');
          return _getDefaultUser();
        }
      } else {
        return _getDefaultUser();
      }
    } catch (e) {
      print('Error in authCheck: $e');
      return _getDefaultUser();
    }
  }

  @override
  Future<void> login({required String email, required String password}) async {
    try {
      final result = await api.getData<Map<String, dynamic>>(
        endpoint: "/auth/yard_user_login",
        params: {
          'email': email,
          'password': password,
        },
        method: 'POST',
      );

      if (result['user_data'] != null) {
        final userData = UserData.fromJson(result['user_data']);
        // Store the JSON directly without toString()
        await localStorage.setData(
          Key: 'user',
          Value: json.encode(userData.toJson()),
        );
      } else {
        throw Exception('Login failed: No user data in response');
      }
    } catch (e) {
      print('Login error in repo: $e');
      rethrow;
    }
  }

  @override
  Future<void> logout() {
    return localStorage.setData(Key: 'user', Value: '');
  }

  // Helper method to create default user
  UserData _getDefaultUser() {
    return UserData(
      id: 0,
      name: '',
      photo: '',
      email: '',
      status: false,
      yardId: 0,
      password: '',
    );
  }
}
