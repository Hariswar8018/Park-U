class UserModel {
  final int id;
  final String name;
  final String phone;
  final String? location;
  final String? bio;
  final String? pic;
  final String? shift;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    this.location,
    this.bio,
    this.pic,
    this.shift,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'] ?? "",
      phone: json['phone'] ?? "",
      location: json['location'],
      bio: json['bio'],
      pic: json['pic'],
      shift: json['shift'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "phone": phone,
      "location": location,
      "bio": bio,
      "pic": pic,
      "shift": shift,
      "created_at": createdAt?.toIso8601String(),
    };
  }
}

