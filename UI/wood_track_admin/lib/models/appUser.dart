import 'package:wood_track_admin/models/base.dart';

class AppUser extends BaseModel {
  late String firstName;
  late String lastName;
  late String userName;
  late String email;
  late String phoneNumber;
  late DateTime birthDate;
  late String address;
  late int gender;
  late String? description;
  String? licenseNumber;
  int? yearsOfExperience;
  String? workingHours;
  String? position;
  String? profilePhoto;
  String? profilePhotoThumbnail;
  late bool isActive;
  late bool isClient;
  late bool isEmployee;
  int? countryId;

  AppUser();

  AppUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    isActive = json['isActive'];
    userName = json['userName'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    birthDate = DateTime.parse(json['birthDate']);
    address = json['address'];
    gender = json['gender'];
    description = json['description'];
    licenseNumber = json['licenseNumber'];
    yearsOfExperience = json['yearsOfExperience'];
    workingHours = json['workingHours'];
    position = json['position'];
    countryId = json['countryId'];

    if (json['profilePhoto'] != null) {
      profilePhoto = apiUrl + json['profilePhoto'];
    }

    if (json['profilePhotoThumbnail'] != null) {
      profilePhotoThumbnail = apiUrl + json['profilePhotoThumbnail'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['userName'] = userName;
    data['email'] = email;
    data['phoneNumber'] = phoneNumber;
    data['birthDate'] = birthDate;
    data['address'] = address;
    data['gender'] = gender;
    data['description'] = description;
    data['profilePhoto'] = profilePhoto;
    data['licenseNumber'] = licenseNumber;
    data['yearsOfExperience'] = yearsOfExperience;
    data['workingHours'] = workingHours;
    data['position'] = position;

    return data;
  }
}
