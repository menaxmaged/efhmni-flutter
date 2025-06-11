import 'dart:convert';

import 'helper.dart';
import 'package:http/http.dart' as http;

class ApiHandler {
  static String videoEndpoint = "$baseUrl/process_video";
  static String imageEndpoint = "$baseUrl/process_image";

  static Future<String> uploadVideo({required String filePath}) async {
    try {
      final uri = Uri.parse(videoEndpoint.trim());
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

  static Future<String> uploadImage({required String filePath}) async {
    try {
      final uri = Uri.parse(imageEndpoint.trim());
      final request = http.MultipartRequest("POST", uri);
      request.files.add(await http.MultipartFile.fromPath('image', filePath));
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
