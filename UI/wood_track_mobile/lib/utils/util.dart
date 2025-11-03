import 'dart:convert';
import 'dart:typed_data';

class Authorization {
  static String? username;
  static String? password;
}

String base64String(Uint8List data) {
  return base64Encode(data);
}