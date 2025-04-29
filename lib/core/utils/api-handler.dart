import 'dart:convert';

import 'helper.dart';
import 'package:http/http.dart' as http;

class ApiHandler {
  static String Endpoint = "$baseUrl/process_video";

  static Future<String> uploadVideo({required String filePath}) async {
    try {
      final uri = Uri.parse(Endpoint.trim());
      final request = http.MultipartRequest("POST", uri);
      request.files.add(await http.MultipartFile.fromPath('video', filePath));
      final response = await request.send();

      if (response.statusCode == 200) {
        return await response.stream.bytesToString();
      } else {
        throw 'Failed with status: ${response.statusCode}';
      }
    } catch (e) {
      print('Upload Error: $e');
      rethrow;
    }
  }
}
