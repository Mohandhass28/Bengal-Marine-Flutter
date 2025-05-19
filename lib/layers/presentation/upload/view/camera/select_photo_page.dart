import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Bengal_Marine/layers/presentation/upload/bloc/upload_bloc.dart';
import 'package:Bengal_Marine/layers/presentation/upload/view/upload_page.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class SelectPhotoPage extends StatefulWidget {
  const SelectPhotoPage({
    super.key,
    required this.imagePath,
    required this.containerType,
  });
  final ContainerType containerType;
  final String imagePath;

  @override
  State<SelectPhotoPage> createState() => _SelectPhotoPageState();
}

class _SelectPhotoPageState extends State<SelectPhotoPage> {
  late final UploadBloc _uploadBloc;

  @override
  void initState() {
    _uploadBloc = context.read<UploadBloc>();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void addImage() {
    if (mounted) {
      if (widget.containerType == ContainerType.pre) {
        _uploadBloc.add(PreContainerEvent(imagePath: widget.imagePath));
      }
      if (widget.containerType == ContainerType.post) {
        _uploadBloc.add(PostContainerEvent(imagePath: widget.imagePath));
      }
      if (widget.containerType == ContainerType.AVUR) {
        _uploadBloc.add(AVURContainerEvent(imagePath: widget.imagePath));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          getImage(widget.imagePath),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        addImage();
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Submit",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Retry",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        addImage();
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Add Photo",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getImage(String imagePath) {
    if (kIsWeb && imagePath.startsWith('blob:')) {
      return Image.network(
        imagePath,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.contain,
      );
    }
    return Image.file(
      File(imagePath),
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.contain,
    );
  }
}
