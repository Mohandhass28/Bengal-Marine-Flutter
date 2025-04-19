import 'package:flutter/material.dart';
import 'package:flutter/src/services/message_codec.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:portfolio/core/components/ButtomComponent/Button.dart';
import 'package:portfolio/layers/domain/usecase/image_container_usecase/image_container_usecase.dart';
import 'package:portfolio/layers/presentation/auth/bloc/auth_bloc.dart';
import 'package:portfolio/layers/presentation/local/bloc/local_bloc.dart';
import 'package:portfolio/layers/presentation/recent/bloc/recent_bloc.dart';
import 'package:portfolio/layers/presentation/upload/bloc/upload_bloc.dart';
import 'package:portfolio/layers/presentation/upload/view/camera/camera_page.dart';
import 'package:portfolio/layers/presentation/local/view/local_page.dart';
import 'package:portfolio/layers/presentation/recent/view/recent_page.dart';
import 'package:portfolio/layers/presentation/upload/view/upload_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.user_id, required this.yard_id});

  final int user_id;
  final int yard_id;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final UploadBloc _uploadBloc;
  late final LocalBloc _localBloc;
  late final RecentBloc _recentBloc;
  late final ImageContainerUsecase _imageContainerUsecase;
  late final AuthBloc _authBloc;

  late List<Widget> _pages;
  @override
  void initState() {
    super.initState();
    _imageContainerUsecase = context.read<ImageContainerUsecase>();
    _uploadBloc = UploadBloc(
      imageContainerUsecase: _imageContainerUsecase,
    );
    _authBloc = context.read<AuthBloc>();
    _localBloc = context.read<LocalBloc>();
    _recentBloc = context.read<RecentBloc>();
    _pages = [
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _uploadBloc),
          BlocProvider.value(value: _localBloc),
        ],
        child: UploadPage(
          user_id: widget.user_id,
          yard_id: widget.yard_id,
        ),
      ),
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _localBloc),
        ],
        child: LocalPage(
          user_id: widget.user_id,
          yard_id: widget.yard_id,
        ),
      ),
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _recentBloc),
          BlocProvider.value(value: _uploadBloc),
        ],
        child: RecentPage(
          user_id: widget.user_id,
          yard_id: widget.yard_id,
        ),
      ),
    ];
  }

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.document_scanner,
                  fill: 1,
                ),
                label: 'Upload',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.upload,
                  fill: 1,
                ),
                label: 'Local',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.recent_actors,
                  fill: 1,
                ),
                label: 'Recent',
              ),
            ],
          ),
          appBar: AppBar(
            scrolledUnderElevation: 0,
            backgroundColor: Colors.white,
            toolbarHeight: 100,
            leadingWidth: 120,
            leading: Image(
              image: AssetImage("assets/images/NoBackGround.png"),
            ),
            actionsIconTheme: IconThemeData(
              color: Colors.black,
              size: 34,
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    _dialogBuilder(context);
                  },
                ),
              )
            ],
          ),
          body: _pages[_selectedIndex],
        );
      },
    );
  }

  void _dialogBuilder(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Logout'),
            onPressed: () {
              _authBloc.add(LogoutRequested());
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _uploadBloc.close();
  }
}
