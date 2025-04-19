import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/layers/domain/usecase/auth_usecase/auth_usecase.dart';
import 'package:portfolio/layers/presentation/auth/bloc/auth_bloc.dart';
import 'package:portfolio/layers/presentation/home/view/home_page.dart';
import 'package:portfolio/layers/presentation/login/view/login_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthView();
  }
}

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        print(state);
        if (state is Authenticated) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => HomePage(
                user_id: state.user_id,
                yard_id: state.yard_id,
              ),
            ),
            (route) => false,
          );
        } else if (state is Unauthenticated) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => LoginPage(
                authUsecase: context.read<AuthUsecase>(),
              ),
            ),
            (route) => false,
          );
        }
      },
      child: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
