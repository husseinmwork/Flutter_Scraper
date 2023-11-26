
import 'package:http/http.dart' as http;


import 'dart:developer';


const String baseUri = 'https://pub.dev/packages';

class HttpService {
  static Future<String?> get() async {
    try {
      final response = await http.get(Uri.parse(baseUri));
      if (response.statusCode == 200) return response.body;
    } catch (e) {
      print("here error $e");
      log('HttpService $e');
    }
    return null;
  }
}
