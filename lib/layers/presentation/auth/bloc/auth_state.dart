part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthenticationLoading extends AuthState {}

final class Authenticated extends AuthState {
  final int user_id;
  final int yard_id;

  Authenticated({required this.user_id, required this.yard_id});
}

final class Unauthenticated extends AuthState {}
