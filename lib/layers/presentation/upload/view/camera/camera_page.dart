import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Bengal_Marine/layers/presentation/upload/bloc/upload_bloc.dart';
import 'package:Bengal_Marine/layers/presentation/upload/view/camera/select_photo_page.dart';
import 'package:Bengal_Marine/layers/presentation/upload/view/upload_page.dart';

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
  double _currentZoomLevel = 1.0;
  double _minZoomLevel = 1.0;
  double _maxZoomLevel = 1.0;
  FlashMode _flashMode = FlashMode.off;
  double _baseScale = 1.0;

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

      _currentZoomLevel = 1.0;

      final firstCamera = cameras.first;
      final controller = CameraController(
        firstCamera,
        ResolutionPreset.low,
        enableAudio: false,
      );

      _initializeControllerFuture = controller.initialize();
      await _initializeControllerFuture;

      _minZoomLevel = await controller.getMinZoomLevel();
      _maxZoomLevel = await controller.getMaxZoomLevel();
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

  Future<void> _setFlashMode(FlashMode mode) async {
    if (_controller == null || !_controller!.value.isInitialized) {
      return;
    }
    try {
      await _controller!.setFlashMode(mode);
      setState(() {
        _flashMode = mode;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error changing flash mode: $e')),
        );
      }
    }
  }

  Future<void> _setZoomLevel(double zoom) async {
    if (_controller == null || !_controller!.value.isInitialized) {
      return;
    }
    try {
      await _controller!.setZoomLevel(zoom);
      setState(() {
        _currentZoomLevel = zoom;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error changing zoom level: $e')),
        );
      }
    }
  }

  // Handle scale gesture for zoom
  void _handleScaleStart(ScaleStartDetails details) {
    _baseScale = _currentZoomLevel;
  }

  Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {
    // When there are two fingers on screen, scale using the pinch gesture
    if (details.scale != 1.0) {
      // Calculate the new zoom level
      double newZoomLevel =
          (_baseScale * details.scale).clamp(_minZoomLevel, _maxZoomLevel);

      // Only update if the change is significant enough
      if ((newZoomLevel - _currentZoomLevel).abs() > 0.05) {
        await _setZoomLevel(newZoomLevel);
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
                  GestureDetector(
                    onScaleStart: _handleScaleStart,
                    onScaleUpdate: _handleScaleUpdate,
                    child: CameraPreview(_controller!),
                  ),

                // Zoom level indicator
                Positioned(
                  top: 100,
                  left: 20,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${_currentZoomLevel.toStringAsFixed(1)}x',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),

                // Flash control at the top
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(
                            _flashMode == FlashMode.off
                                ? Icons.flash_off
                                : _flashMode == FlashMode.auto
                                    ? Icons.flash_auto
                                    : Icons.flash_on,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: () {
                            // Cycle through flash modes
                            if (_flashMode == FlashMode.off) {
                              _setFlashMode(FlashMode.auto);
                            } else if (_flashMode == FlashMode.auto) {
                              _setFlashMode(FlashMode.always);
                            } else {
                              _setFlashMode(FlashMode.off);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // Camera controls remain the same
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
