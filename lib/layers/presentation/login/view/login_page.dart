import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Bengal_Marine/layers/domain/usecase/auth_usecase/auth_usecase.dart';
import 'package:Bengal_Marine/layers/presentation/auth/bloc/auth_bloc.dart';
import 'package:Bengal_Marine/core/components/ButtomComponent/Button.dart';
import 'package:Bengal_Marine/layers/presentation/login/components/InputComponent/input_comp.dart';
import 'package:Bengal_Marine/layers/presentation/login/bloc/login_bloc.dart';

class LoginPage extends StatefulWidget {
  final AuthUsecase authUsecase;
  const LoginPage({super.key, required this.authUsecase});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late final LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc(authUsecase: widget.authUsecase);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _loginBloc,
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            context.read<AuthBloc>().add(CheckAuthenticationStatus());
          } else if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Login failed: ${state.error}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Scaffold(
          body: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              return Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 0.3, 1.0],
                    colors: [
                      Color(0xfffdfdfd),
                      Color(0xff5AECEB),
                      Color(0xff131f28),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 30),
                                child: Image(
                                  image: AssetImage(
                                      'assets/images/NoBackGround.png'),
                                  height: 210,
                                ),
                              ),
                              const Text(
                                "Log In",
                                style: TextStyle(
                                    fontSize: 27, fontWeight: FontWeight.w500),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 10),
                              ),
                              const Text(
                                "Log into your account",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w400),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 20),
                              ),
                              InputComponent(
                                text: "Email ID",
                                textInputControl: _emailController,
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 20),
                              ),
                              InputComponent(
                                text: "Password",
                                textInputControl: _passwordController,
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 50),
                              ),
                              ButtonComp(
                                buttonText: "Log In",
                                onPressFun: () {
                                  _loginBloc.add(
                                    LoginSubmitted(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        if (state is LoginLoading)
                          Container(
                            color: Colors.black.withOpacity(0.5),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _loginBloc.close();
    super.dispose();
  }
}
