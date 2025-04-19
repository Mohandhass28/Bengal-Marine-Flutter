import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:portfolio/layers/domain/usecase/auth_usecase/auth_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthUsecase _authUsecase;
  AuthBloc({required AuthUsecase authUsecase})
      : _authUsecase = authUsecase,
        super(AuthInitial()) {
    on<CheckAuthenticationStatus>(_onCheckAuthenticationStatus);
    on<AuthenticationStatusChanged>(_onAuthenticationStatusChanged);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onCheckAuthenticationStatus(
    CheckAuthenticationStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthenticationLoading());
    final AuthenticatedData = await _authUsecase.authCheck();
    print(AuthenticatedData);
    add(AuthenticationStatusChanged(
        isAuthenticated: AuthenticatedData.status,
        yard_id: AuthenticatedData?.yardId ?? 0,
        user_id: AuthenticatedData?.id ?? 0));
  }

  void _onAuthenticationStatusChanged(
    AuthenticationStatusChanged event,
    Emitter<AuthState> emit,
  ) {
    if (event.isAuthenticated) {
      emit(Authenticated(user_id: event.user_id!, yard_id: event.yard_id!));
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _authUsecase.logout();
    add(AuthenticationStatusChanged(isAuthenticated: false));
  }
}
