import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ConnToApi {
  static Future<String?> UploadImage(File file) async {
    var uri = Uri.parse("http://10.0.2.2:8000/api/upload-image");

    var request = http.MultipartRequest("POST", uri);
    request.files.add(await http.MultipartFile.fromPath("image", file.path));

    var response = await request.send();
    print("Upload response status: ${response.statusCode}");
    // print("Upload response body: ${await response.stream.bytesToString()}");

    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);
      return data['url']; // URL yang dikembalikan API
    } else {
      return null;
    }
  }
}