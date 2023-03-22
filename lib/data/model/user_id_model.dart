class UserIdModel {
  final String id;

  UserIdModel({required this.id});

  factory UserIdModel.fromJson(Map<String, dynamic> json) {
    return UserIdModel(
      id: json['id'],
    );
  }
}
