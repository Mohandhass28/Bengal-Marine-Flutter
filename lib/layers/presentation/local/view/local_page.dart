import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/core/components/ButtomComponent/Button.dart';
import 'package:portfolio/layers/presentation/local/bloc/local_bloc.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class LocalPage extends StatefulWidget {
  const LocalPage({super.key});

  @override
  State<LocalPage> createState() => _LocalPageState();
}

class _LocalPageState extends State<LocalPage> {
  late final LocalBloc _localBloc;

  @override
  void initState() {
    super.initState();
    _localBloc = context.read<LocalBloc>();
    _localBloc.add(LocalLoadEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LocalBloc, LocalState>(
      listener: (context, state) {
        if (state.status == ImageContainerStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to load images: ${state.status}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.status == ImageContainerStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Scaffold(
          body: Column(
            children: [
              Container(
                width: double.infinity,
                height: 50,
                alignment: Alignment.center,
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(201, 179, 180, 182),
                ),
                child: const Text(
                  "Local Server",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: state.container.length,
                  itemBuilder: (context, index) => _localContainer(
                    containerNumber: state.container[index].containerNumber,
                    imageList: state.container[index].imageList,
                    type: state.container[index].type,
                    dateAndTime: state.container[index].dateAndTime,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} seconds ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks weeks ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months months ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years years ago';
    }
  }

  Widget _localContainer({
    required String containerNumber,
    required List<Map<String, dynamic>> imageList,
    required String type,
    required DateTime dateAndTime,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 20),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                containerNumber,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 35,
                child: TextButton.icon(
                  label: Text(
                    "Upload to server",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  icon: Icon(
                    Icons.upload,
                    size: 24, // Reduced icon size to fit smaller height
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  onPressed: () {},
                  style: ButtonStyle(
                    alignment: Alignment.center,
                    backgroundColor: WidgetStateProperty.all<Color>(
                        Color.fromARGB(231, 8, 8, 41)),
                    padding: WidgetStateProperty.all<EdgeInsets>(
                      EdgeInsets.zero, // Remove default padding
                    ),
                    minimumSize: WidgetStateProperty.all<Size>(
                      const Size(200, 35),
                    ),
                    shape: WidgetStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(top: 16),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                type,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                getTimeAgo(dateAndTime),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20),
          ),
          Column(
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.start,
                alignment: WrapAlignment.start,
                runSpacing: 10,
                spacing: 10,
                children: [
                  ...imageList.map((e) => _getImage(e["image"])),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getImage(String imagePath) {
    if (kIsWeb && imagePath.startsWith('blob:')) {
      return Container(
        width: 110,
        height: 110,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [],
          color: const Color.fromARGB(255, 204, 204, 204),
        ),
        child: const Center(
          child: Icon(
            Icons.image_not_supported,
            size: 40,
            color: Colors.grey,
          ),
        ),
      );
    }
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [],
        color: const Color.fromARGB(255, 204, 204, 204),
      ),
      child: Image.file(
        File(imagePath),
        fit: BoxFit.fill,
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Icon(
              Icons.image_not_supported,
              size: 40,
              color: Colors.grey,
            ),
          );
        },
      ),
    );
  }
}
