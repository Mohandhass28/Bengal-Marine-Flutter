import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Bengal_Marine/layers/data/repository/auth_repo_impl/auth_repo_impl.dart';
import 'package:Bengal_Marine/layers/data/repository/image_container_repo_impl/image_container_impl.dart';
import 'package:Bengal_Marine/layers/data/source/local/local_storage.dart';
import 'package:Bengal_Marine/layers/data/source/network/api.dart';
import 'package:Bengal_Marine/layers/domain/usecase/auth_usecase/auth_usecase.dart';
import 'package:Bengal_Marine/layers/domain/usecase/image_container_usecase/image_container_usecase.dart';
import 'package:Bengal_Marine/layers/presentation/auth/bloc/auth_bloc.dart';
import 'package:Bengal_Marine/layers/presentation/auth/view/auth_page.dart';
import 'package:Bengal_Marine/layers/presentation/home/view/home_page.dart';
import 'package:Bengal_Marine/layers/presentation/local/bloc/local_bloc.dart';
import 'package:Bengal_Marine/layers/presentation/login/view/login_page.dart';
import 'package:Bengal_Marine/layers/presentation/recent/bloc/recent_bloc.dart';
import 'package:Bengal_Marine/main.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  late AuthUsecase authusecase;
  late AuthBloc authBloc;

  late ImageContainerUsecase localusecase;
  late LocalBloc localBloc;

  late RecentBloc recentBloc;

  @override
  void initState() {
    super.initState();
    final api = ApiImpl();
    final localStorage = LocalStorageImpl(
      sharedPreferences: sharedPref,
    );
    final authrepo = AuthRepoImpl(
      api: api,
      localStorage: localStorage,
    );
    authusecase = AuthUsecase(
      authRepo: authrepo,
    );
    final localRepo = ImageContainerRepoImpl(
      api: api,
      localStorage: localStorage,
    );

    localusecase = ImageContainerUsecase(
      imageContainerRepo: localRepo,
    );

    localBloc = LocalBloc(
      imageContainerUsecase: localusecase,
    );

    authBloc = AuthBloc(
      authUsecase: authusecase,
    );

    recentBloc = RecentBloc(
      imageContainerUsecase: localusecase,
    );

    authBloc.add(CheckAuthenticationStatus());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: authBloc),
        RepositoryProvider<AuthUsecase>.value(value: authusecase),
        BlocProvider<LocalBloc>.value(value: localBloc),
        BlocProvider<RecentBloc>.value(value: recentBloc),
        RepositoryProvider<ImageContainerUsecase>.value(value: localusecase),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {},
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthenticationLoading) {
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (state is Authenticated) {
                return HomePage(
                  user_id: state.user_id,
                  yard_id: state.yard_id,
                );
              }
              return LoginPage(authUsecase: authusecase);
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    authBloc.close();
    super.dispose();
  }
}
