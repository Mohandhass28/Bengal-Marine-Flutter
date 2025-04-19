part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class CheckAuthenticationStatus extends AuthEvent {}

class AuthenticationStatusChanged extends AuthEvent {
  final bool isAuthenticated;
  final int? user_id;
  final int? yard_id;

  AuthenticationStatusChanged({
    required this.isAuthenticated,
    this.user_id,
    this.yard_id,
  });
}

class LogoutRequested extends AuthEvent {}
