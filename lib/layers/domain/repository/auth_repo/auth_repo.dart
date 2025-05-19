import 'package:Bengal_Marine/layers/data/model/auth_user_model/auth_user_model.dart';
import 'package:Bengal_Marine/layers/domain/entity/auth_user_entity/auth_user_entity.dart';

abstract class AuthRepo {
  Future<void> login({required String email, required String password});
  Future<void> logout();
  Future<UserData> authCheck();
}
