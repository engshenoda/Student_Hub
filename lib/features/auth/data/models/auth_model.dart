class UserModel {
  final String uid;
  final String email;
  final String? name;
  final String? photoUrl;
  UserModel({
    required this.uid,
    required this.email,
    this.name,
    this.photoUrl
  });

  factory UserModel.fromFirebaseUser(user) {
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      name : user.displayName,
      photoUrl: user.photoUrl,
    );
  }
}