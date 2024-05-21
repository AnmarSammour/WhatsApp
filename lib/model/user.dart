class UserModel {
  final String id;
  final String name;
  final String imageUrl;
  final bool active;
  final int lastSeen;
  final String phoneNumber;

  UserModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.active,
    required this.lastSeen,
    required this.phoneNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': id,
      'username': name,
      'profileImageUrl': imageUrl,
      'active': active,
      'lastSeen': lastSeen,
      'phoneNumber': phoneNumber,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['uid'] ?? '',
      name: map['username'] ?? '',
      imageUrl: map['profileImageUrl'] ?? '',
      active: map['active'] ?? false,
      lastSeen: map['lastSeen'] ?? 0,
      phoneNumber: map['phoneNumber'] ?? '',
    );
  }
}
