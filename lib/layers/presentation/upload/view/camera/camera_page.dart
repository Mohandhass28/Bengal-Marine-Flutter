import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/layers/presentation/upload/bloc/upload_bloc.dart';
import 'package:portfolio/layers/presentation/upload/view/camera/select_photo_page.dart';
import 'package:portfolio/layers/presentation/upload/view/upload_page.dart';

class CameraPage extends StatefulWidget {
  final ContainerType containerType;
  const CameraPage({super.key, required this.containerType});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  bool _isLoading = true;
  late final UploadBloc _uploadBloc;

  @override
  void initState() {
    super.initState();
    _uploadBloc = context.read<UploadBloc>();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No cameras found')),
          );
        }
        return;
      }

      final firstCamera = cameras.first;
      final controller = CameraController(
        firstCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      _initializeControllerFuture = controller.initialize();
      await _initializeControllerFuture;

      if (mounted) {
        setState(() {
          _controller = controller;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error initializing camera: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      return;
    }

    try {
      setState(() => _isLoading = true);
      final image = await _controller!.takePicture();
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider.value(
              value: _uploadBloc,
              child: SelectPhotoPage(
                  imagePath: image.path, containerType: widget.containerType),
            ),
          ),
        ).then((_) {
          // Re-initialize camera when returning from SelectPhotoPage
          if (mounted) {
            _initializeCamera();
          }
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error taking picture: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : Stack(
              fit: StackFit.expand,
              children: [
                if (_controller?.value.isInitialized ?? false)
                  CameraPreview(_controller!),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 46.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FloatingActionButton(
                              heroTag: 'capture',
                              backgroundColor: Colors.white,
                              onPressed: _takePicture,
                              child: const Icon(
                                Icons.camera,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
