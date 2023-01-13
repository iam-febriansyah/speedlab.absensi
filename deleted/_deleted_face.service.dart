import 'package:flutter_application_1/models/return_face_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class FaceService {
  Future<dynamic> postFace(String path, String iduser) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var baseUrl = preferences.getString("PREF_URLFACE");
    if (baseUrl == null) {
      baseUrl = "http://eazynotif.id:8082";
    }

    var postUri = Uri.parse(baseUrl + "/post-face");

    http.MultipartRequest request = new http.MultipartRequest("POST", postUri);

    http.MultipartFile multipartFile =
        await http.MultipartFile.fromPath('facedata', path);

    request.files.add(multipartFile);
    request.fields['iduser'] = iduser;

    http.StreamedResponse streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    return ReturnFaceData.fromJson(json.decode(response.body));
  }

  Future<dynamic> checkFace(String path, String iduser) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var baseUrl = preferences.getString("PREF_URLFACE");
    if (baseUrl == null) {
      baseUrl = "http://eazynotif.id:8082";
    }
    var postUri = Uri.parse(baseUrl + "/check-face");

    http.MultipartRequest request = new http.MultipartRequest("POST", postUri);

    http.MultipartFile multipartFile =
        await http.MultipartFile.fromPath('facedata', path);

    request.files.add(multipartFile);
    request.fields['iduser'] = iduser;

    http.StreamedResponse streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    return ReturnFaceData.fromJson(json.decode(response.body));
  }
}
