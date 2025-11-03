import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants{
  static String apiUrl = String.fromEnvironment('API_URL_DOCKER', defaultValue: dotenv.env['API_URL_DOCKER']!);
  static String appTitle = 'Wood Track';
}


