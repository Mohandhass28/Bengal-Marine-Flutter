class AuthUserEntity {
  final bool? status;
  final String? message;
  final UserData? userData;

  AuthUserEntity({
    this.status,
    this.message,
    this.userData,
  });
}

class UserData {
  final int id;
  final String name;
  final String photo;
  final String email;
  final bool status;
  final int yardId;
  final String password;

  UserData({
    required this.id,
    required this.name,
    required this.photo,
    required this.email,
    required this.status,
    required this.yardId,
    required this.password,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] as int,
      name: json['name'] as String,
      photo: json['photo'] as String,
      email: json['email'] as String,
      status: json['status'] as bool,
      yardId: json['yard_id'] as int, // Changed from yardId to yard_id
      password: json['password'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'photo': photo,
      'email': email,
      'status': status,
      'yard_id': yardId, // Changed from yardId to yard_id
      'password': password,
    };
  }

  @override
  String toString() {
    return 'UserData(id: $id, name: $name, photo: $photo, email: $email, status: $status, yardId: $yardId)';
  }
}
