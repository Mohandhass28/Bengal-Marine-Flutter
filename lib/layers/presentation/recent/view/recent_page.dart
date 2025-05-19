import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Bengal_Marine/layers/presentation/recent/bloc/recent_bloc.dart';

class RecentPage extends StatefulWidget {
  const RecentPage({super.key, required this.user_id, required this.yard_id});

  final int user_id;
  final int yard_id;

  @override
  State<RecentPage> createState() => _RecentPageState();
}

class _RecentPageState extends State<RecentPage> {
  DateTime? selectedDate;
  late final RecentBloc _recentBloc;

  @override
  void initState() {
    super.initState();
    _recentBloc = context.read<RecentBloc>();

    _recentBloc.add(RoadRecentEvent(
      params: {
        "user_id": widget.user_id,
        "yard_id": widget.yard_id,
        "date": selectedDate?.toLocal().toString() ?? DateTime.now().toString(),
      },
    ));
    selectedDate = DateTime.now();
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1960),
      lastDate: DateTime(2026),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        _recentBloc.add(RoadRecentEvent(
          params: {
            "user_id": widget.user_id,
            "yard_id": widget.yard_id,
            "date":
                selectedDate?.toLocal().toString() ?? DateTime.now().toString(),
          },
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<RecentBloc, RecentState>(
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
        ),
      ],
      child: BlocBuilder<RecentBloc, RecentState>(
        builder: (context, state) {
          if (state.status == ImageContainerStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == ImageContainerStatus.failure) {
            return const Center(child: Text('Failed to load images'));
          }

          if (state.container.isEmpty) {
            return Scaffold(
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: double.infinity,
                    height: 50,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(201, 179, 180, 182),
                    ),
                    child: const Text(
                      "Recently Uploaded",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      spacing: 0,
                      children: [
                        Text(
                          "${selectedDate?.toLocal().year}/${selectedDate?.toLocal().month}/${selectedDate?.toLocal().day}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.calendar_today, size: 37),
                          onPressed: _selectDate,
                        ),
                        Center(
                          child: Text(
                            "No Data",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
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
                    "Recently Uploaded",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    spacing: 0,
                    children: [
                      Text(
                        "${selectedDate?.toLocal().year}/${selectedDate?.toLocal().month}/${selectedDate?.toLocal().day}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.calendar_today, size: 37),
                        onPressed: _selectDate,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.container.length,
                    itemBuilder: (context, index) => _serverContainer(
                      containerNumber: state.container[index].cont_no,
                      imageList: state.container[index].container_info_image,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _serverContainer({
    required String containerNumber,
    required List<Map<String, dynamic>> imageList,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10),
          ),
          if (imageList.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  imageList[0]["image_type"] == 1
                      ? "Pre"
                      : imageList[0]["image_type"] == 2
                          ? "Post"
                          : "AV/UR",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          const Padding(
            padding: EdgeInsets.only(top: 16),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.start,
                alignment: WrapAlignment.spaceBetween,
                runSpacing: 10,
                spacing: 10,
                children: [
                  if (imageList.isNotEmpty)
                    ...imageList.map((e) => _getImage(e["image"]))
                  else
                    Center(
                      child: Text(
                        'No images available',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getImage(String imagePath) {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [],
        color: const Color.fromARGB(255, 204, 204, 204),
      ),
      child: Image.network(
        imagePath,
        fit: BoxFit.fill,
      ),
    );
  }
}
