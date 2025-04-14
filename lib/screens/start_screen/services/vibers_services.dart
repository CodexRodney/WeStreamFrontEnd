// contains services related to rooms

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:westreamfrontend/screens/start_screen/services/base_services.dart';

class VibersService {
  static Future<Map<String, dynamic>> getViberId() async {
    var response = await http.get(
      Uri.parse("${BaseServices.baseUrl}/get-viber"),
      headers: BaseServices.headers,
    );
    if (response.statusCode >= 200 && response.statusCode < 299) {
      return jsonDecode(response.body);
    }
    throw "Something Went Wrong";
  }
}
