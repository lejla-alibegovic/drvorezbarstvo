import 'dart:convert';
import 'package:wood_track_mobile/models/registration_model.dart';
import '../helpers/constants.dart';
import 'package:http/http.dart' as http;
import '../utils/authorization.dart';
import 'package:flutter/material.dart';

class RegistrationProvider with ChangeNotifier {
  RegistrationProvider();

  Future<bool> registration(RegistrationModel resource) async {
    var uri = Uri.parse('${Constants.apiUrl}/Access/Registration');
    Map<String, String> headers = Authorization.createHeaders();
    try {
      var jsonRequest = jsonEncode(resource);

      var response = await http.post(uri, headers: headers, body: jsonRequest);
      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Neuspješan odgovor: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print('Greška prilikom slanja zahtjeva: $error');
      return false;
    }
  }
}
