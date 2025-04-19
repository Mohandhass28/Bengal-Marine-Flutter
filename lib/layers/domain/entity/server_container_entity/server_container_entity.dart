import 'package:equatable/equatable.dart';

class ContainerEntity with EquatableMixin {
  final int container_info_id;
  final String cont_no;
  final int yard_id;
  final String yard_name;
  final int user_id;
  final String user_name;
  final bool status;
  final List<Map<String, dynamic>> container_info_image;

  ContainerEntity({
    required this.container_info_id,
    required this.cont_no,
    required this.yard_id,
    required this.yard_name,
    required this.user_id,
    required this.user_name,
    required this.status,
    required this.container_info_image,
  });

  @override
  List<Object?> get props => [
        container_info_id,
        cont_no,
        yard_id,
        yard_name,
        user_id,
        user_name,
        status,
        container_info_image,
      ];
}
