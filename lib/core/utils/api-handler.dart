import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiHandler {
  static String ngrokLink = "";

  static Future<String> uploadVideo({required String filePath}) async {
    final request = http.MultipartRequest("POST", Uri.parse(ngrokLink));
    // final headers = {"Content-type": "multipart/form-data"};

    request.files.add(await http.MultipartFile.fromPath('video', filePath));

    // print(filePath);
    var response = await request.send();

    // print("Status Code:  ${response.statusCode}");

    if (response.statusCode == 200) {
      String val = await response.stream.bytesToString();
      // print(val);
      return val;
    } else {
      throw Exception('Failed to upload video');
    }
  }
}
