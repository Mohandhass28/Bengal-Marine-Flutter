import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/core/components/ButtomComponent/Button.dart';
import 'package:portfolio/layers/presentation/local/bloc/local_bloc.dart';
import 'package:portfolio/layers/presentation/upload/bloc/upload_bloc.dart';
import 'package:portfolio/layers/presentation/upload/view/camera/camera_page.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class UploadPage extends StatefulWidget {
  const UploadPage({
    super.key,
    required this.user_id,
    required this.yard_id,
  });

  final int user_id;
  final int yard_id;

  @override
  State<UploadPage> createState() => _UploadPageState();
}

enum ContainerType { pre, post, AVUR, none }

class _UploadPageState extends State<UploadPage> {
  late final UploadBloc _uploadBloc;
  late final LocalBloc _localBloc;

  final _textEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _uploadBloc = context.read<UploadBloc>();
    _localBloc = context.read<LocalBloc>();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> openGallery(BuildContext context,
      {required ContainerType containerType}) async {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: _uploadBloc,
            child: CameraPage(containerType: containerType),
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  Widget buildImageWidget(String imagePath) {
    if (kIsWeb && imagePath.startsWith('blob:')) {
      return Image.network(
        imagePath,
        width: 120,
        height: 120,
        fit: BoxFit.fill,
      );
    }
    return Image.file(
      File(imagePath),
      width: 100,
      height: 100,
      fit: BoxFit.fill,
    );
  }

  Widget imageWidget(Widget imageWidget, int imageId) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [],
        color: const Color.fromARGB(255, 204, 204, 204),
      ),
      child: Stack(
        children: [
          imageWidget,
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              color: Colors.red,
              icon: Icon(Icons.delete),
              onPressed: () {
                _uploadBloc.add(RemoveImageEvent(imageId: imageId));
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _uploadBloc),
        BlocProvider.value(value: _localBloc),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<UploadBloc, UploadState>(
            listener: (context, state) {},
          ),
          BlocListener<LocalBloc, LocalState>(
            listener: (context, state) {
              if (state.status == ImageContainerStatus.success) {
                _uploadBloc.add(RemoveAllvent());
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    duration: Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                    content: Text(
                      'Images saved successfully',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<UploadBloc, UploadState>(
          builder: (context, uploadState) {
            return BlocBuilder<LocalBloc, LocalState>(
              builder: (context, localState) {
                if (localState.status == ImageContainerStatus.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Scaffold(
                  body: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Container Number",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 7),
                          ),
                          Center(
                            child: TextFormField(
                              controller: _textEditingController,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.characters,
                              maxLength: 11,
                              onChanged: (text) {
                                // Only allow uppercase letters and numbers
                                final filteredText = text
                                    .toUpperCase()
                                    .replaceAll(RegExp(r'[^A-Z0-9]'), '');
                                if (text != filteredText) {
                                  _textEditingController.value =
                                      TextEditingValue(
                                    text: filteredText,
                                    selection: TextSelection.collapsed(
                                        offset: filteredText.length),
                                  );
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Container Number is required';
                                }
                                if (value.length != 11) {
                                  return 'Container Number must be 11 characters';
                                }
                                if (!RegExp(r'^[A-Z]{4}[0-9]{7}$')
                                    .hasMatch(value)) {
                                  return 'Container Number must be 4 letters followed by 7 numbers';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                alignLabelWithHint: true,
                                labelText: "Enter Container Number",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                labelStyle: const TextStyle(
                                  color: Colors.black,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    color: _textEditingController.text.isEmpty
                                        ? Colors.red
                                        : Colors.grey,
                                  ),
                                ),
                                counterText: '', // Hides the character counter
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 10),
                          ),
                          Expanded(
                            child: Flex(
                              direction: Axis.vertical,
                              spacing: 7,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  spacing: 10,
                                  children: [
                                    ButtonComp(
                                      isEnabled: uploadState.type ==
                                              ContainerType.none ||
                                          uploadState.type == ContainerType.pre,
                                      icon: Icon(
                                        Icons.camera_enhance,
                                        size: 30,
                                        color: Colors.white,
                                      ),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      buttonText: "Upload Pre Container Image",
                                      onPressFun: () {
                                        openGallery(
                                          context,
                                          containerType: ContainerType.pre,
                                        );
                                      },
                                    ),
                                    ButtonComp(
                                      isEnabled: uploadState.type ==
                                              ContainerType.none ||
                                          uploadState.type ==
                                              ContainerType.post,
                                      icon: Icon(
                                        Icons.camera_enhance,
                                        size: 30,
                                        color: Colors.white,
                                      ),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      buttonText: "Upload Post Container Image",
                                      onPressFun: () {
                                        openGallery(
                                          context,
                                          containerType: ContainerType.post,
                                        );
                                      },
                                    ),
                                    ButtonComp(
                                      isEnabled: uploadState.type ==
                                              ContainerType.none ||
                                          uploadState.type ==
                                              ContainerType.AVUR,
                                      icon: Icon(
                                        Icons.camera_enhance,
                                        size: 30,
                                        color: Colors.white,
                                      ),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      buttonText:
                                          "Upload AV/UR Container Image",
                                      onPressFun: () {
                                        openGallery(
                                          context,
                                          containerType: ContainerType.AVUR,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: ListView(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    children: [
                                      Wrap(
                                        spacing: 10,
                                        runSpacing: 10,
                                        alignment: WrapAlignment.start,
                                        children: [
                                          ...(uploadState.type ==
                                                          ContainerType.pre ||
                                                      uploadState.type ==
                                                          ContainerType.post ||
                                                      uploadState.type ==
                                                          ContainerType.AVUR
                                                  ? (uploadState).images
                                                  : [])
                                              .map(
                                            (e) => imageWidget(
                                              buildImageWidget(e["image"]),
                                              e["id"],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  spacing: 14,
                                  children: [
                                    ButtonComp(
                                        icon: Icon(
                                          Icons.save,
                                          size: 30,
                                          color: Colors.white,
                                        ),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        buttonText: "Save to Local",
                                        onPressFun: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            if (uploadState.type ==
                                                    ContainerType.pre ||
                                                uploadState.type ==
                                                    ContainerType.post ||
                                                uploadState.type ==
                                                    ContainerType.AVUR) {
                                              final containerImages = {
                                                'container_number':
                                                    _textEditingController.text,
                                                'image_list':
                                                    uploadState.images,
                                                'type': uploadState.type ==
                                                        ContainerType.pre
                                                    ? 'pre'
                                                    : uploadState.type ==
                                                            ContainerType.post
                                                        ? 'post'
                                                        : 'avur',
                                                'date_and_time': DateTime.now()
                                                    .toIso8601String(),
                                              };
                                              _localBloc.add(
                                                LocalSubmitted(
                                                  containerImages:
                                                      containerImages,
                                                ),
                                              );
                                            }
                                          }
                                        }),
                                    ButtonComp(
                                      icon: Icon(
                                        Icons.upload,
                                        size: 30,
                                        color: Colors.white,
                                      ),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      buttonText: "Upload to server",
                                      onPressFun: () {},
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _showBottomSheet() {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.camera, size: 30),
                ),
              ),
              Container(
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.file_copy, size: 30),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
