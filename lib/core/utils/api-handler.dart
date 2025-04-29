import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiHandler {
  static String ngrokLink =
      "https://tender-sculpin-badly.ngrok-free.app/process_video";

  static Future<String> uploadVideo({required String filePath}) async {
    try {
      final uri = Uri.parse(ngrokLink.trim());
      final request = http.MultipartRequest("POST", uri);
      request.files.add(await http.MultipartFile.fromPath('video', filePath));
      final response = await request.send();

      if (response.statusCode == 200) {
        return await response.stream.bytesToString();
      } else {
        throw Exception('Failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Upload Error: $e');
      rethrow;
    }
  }
}
