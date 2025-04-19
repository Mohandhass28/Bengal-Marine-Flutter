import 'package:portfolio/layers/data/model/auth_user_model/auth_user_model.dart';
import 'package:portfolio/layers/domain/entity/auth_user_entity/auth_user_entity.dart';
import 'package:portfolio/layers/domain/repository/auth_repo/auth_repo.dart';

class AuthUsecase {
  final AuthRepo authRepo;

  AuthUsecase({required this.authRepo});

  Future<void> login({required String email, required String password}) async {
    await authRepo.login(email: email, password: password);
  }

  Future<void> logout() async {
    await authRepo.logout();
  }

  Future<UserData> authCheck() async {
    return await authRepo.authCheck();
  }
}
