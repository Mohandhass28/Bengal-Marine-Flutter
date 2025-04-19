import 'package:equatable/equatable.dart';

class ContainerEntity with EquatableMixin {
  final String containerNumber;
  final List<Map<String, dynamic>> imageList;
  final String type;
  final DateTime dateAndTime;

  ContainerEntity({
    required this.containerNumber,
    required this.imageList,
    required this.type,
    required this.dateAndTime,
  });

  @override
  List<Object?> get props => [
        containerNumber,
        imageList,
        type,
        dateAndTime,
      ];
}
