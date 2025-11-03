import 'package:flutter_dotenv/flutter_dotenv.dart';

class BaseModel {
  late int id;
  late DateTime dateCreated;
  late DateTime? dateUpdated;
  late String apiUrl;

  BaseModel(){
    apiUrl = dotenv.env['API_URL_DOCKER']!;
  }
}