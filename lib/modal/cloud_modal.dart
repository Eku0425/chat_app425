import 'package:cloud_firestore/cloud_firestore.dart';

class UserModal {
  String? name, email, image, phone, token;

  UserModal({
    required this.name,
    required this.email,
    required this.image,
    required this.phone,
    required this.token,
  });

  factory UserModal.fromMap(Map m1) {
    return UserModal(
        name: m1['name'],
        email: m1['email'],
        image: m1['image'],
        phone: m1['phone'],
        token: m1['token']);
  }

  Map<String, String?> toMap(UserModal user) {
    return {
      'name': user.name,
      'email': user.email,
      'image': user.image,
      'phone': user.phone,
      'token': user.token,
    };
  }
}
