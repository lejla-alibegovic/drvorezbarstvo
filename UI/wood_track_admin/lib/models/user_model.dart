class UserModel {
  bool isActive;
  bool isFirstLogin;
  bool verificationSent;
  String? firstName;
  String? lastName;
  String userName;
  String normalizedUserName;
  String email;
  String normalizedEmail;
  bool emailConfirmed;
  String phoneNumber;
  bool phoneNumberConfirmed;
  int accessFailedCount;
  DateTime? birthDate;
  int? gender;
  String? profilePhoto;
  String? profilePhotoThumbnail;
  String address;
  String? companyName;
  String? description;

  UserModel({
    required this.isActive,
    required this.isFirstLogin,
    required this.verificationSent,
    this.firstName,
    this.lastName,
    required this.userName,
    required this.normalizedUserName,
    required this.email,
    required this.normalizedEmail,
    required this.emailConfirmed,
    required this.phoneNumber,
    required this.phoneNumberConfirmed,
    required this.accessFailedCount,
    this.birthDate,
    this.gender,
    this.profilePhoto,
    this.profilePhotoThumbnail,
    required this.address,
    this.companyName,
    this.description,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      isActive: json['isActive'],
      isFirstLogin: json['isFirstLogin'],
      verificationSent: json['verificationSent'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      userName: json['userName'],
      normalizedUserName: json['normalizedUserName'],
      email: json['email'],
      normalizedEmail: json['normalizedEmail'],
      emailConfirmed: json['emailConfirmed'],
      phoneNumber: json['phoneNumber'],
      phoneNumberConfirmed: json['phoneNumberConfirmed'],
      accessFailedCount: json['accessFailedCount'],
      birthDate: json['birthDate'] != null ? DateTime.parse(json['birthDate']) : null,
      gender: json['gender'],
      profilePhoto: json['profilePhoto'],
      profilePhotoThumbnail: json['profilePhotoThumbnail'],
      address: json['address'],
      companyName: json['companyName'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isActive': isActive,
      'isFirstLogin': isFirstLogin,
      'verificationSent': verificationSent,
      'firstName': firstName,
      'lastName': lastName,
      'userName': userName,
      'normalizedUserName': normalizedUserName,
      'email': email,
      'normalizedEmail': normalizedEmail,
      'emailConfirmed': emailConfirmed,
      'phoneNumber': phoneNumber,
      'phoneNumberConfirmed': phoneNumberConfirmed,
      'accessFailedCount': accessFailedCount,
      'birthDate': birthDate?.toIso8601String(),
      'gender': gender,
      'profilePhoto': profilePhoto,
      'profilePhotoThumbnail': profilePhotoThumbnail,
      'address': address,
      'companyName': companyName,
      'description': description,
    };
  }
}
