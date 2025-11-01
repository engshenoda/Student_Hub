class UserModel {
  final String id;
  final String name;
  final String jobTitle;
  final String profileImage;

  UserModel({
    required this.id,
    required this.name,
    required this.jobTitle,
    required this.profileImage,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'jobTitle': jobTitle,
      'profileImage': profileImage,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      jobTitle: map['jobTitle'] ?? '',
      profileImage: map['profileImage'] ?? '',
    );
  }
}
