import 'dart:convert';

class AuthResponse {
  int userId;
  int id;
  String token;
  final String? username;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phoneNumber;
  final String? address;
  final String? profilePhoto;
  final DateTime? birthDate;
  final String? profilePhotoThumbnail;
  final bool? isClient;

  AuthResponse({
      required this.id,
      required this.userId,
      required this.token,
      required this.username,
      required this.firstName,
      required this.address,
      required this.lastName,
      required this.email,
      required this.phoneNumber,
      required this.birthDate,
      required this.profilePhoto,
      required this.profilePhotoThumbnail,
      required this.isClient
  });

  factory AuthResponse.fromJson(Map<String, dynamic> data) {
    late String profilePhoto = data['profilePhoto'] ?? '';
    late String profilePhotoThumbnail = data['profilePhotoThumbnail'] ?? '';
    return AuthResponse(
        id: data['id'],
        userId: data['userId'],
        token: data['token'],
        username: data['username'],
        firstName: data['firstName'],
        lastName: data['lastName'],
        address: data['address'],
        email: data['email'],
        birthDate: data['birthDate'] != null ? DateTime.parse(data['birthDate']) : null,
        phoneNumber: data['phoneNumber'],
        profilePhoto: profilePhoto,
        profilePhotoThumbnail: profilePhotoThumbnail,
        isClient: data['isClient']);
  }

  static AuthResponse authResultFromJson(String json) {
    final data = const JsonDecoder().convert(json);
    return AuthResponse.fromJson(data);
  }
}
