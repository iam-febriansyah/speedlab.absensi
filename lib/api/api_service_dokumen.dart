import 'package:flutter_application_1/models/return_check.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class DokumenService {
  Future<dynamic> postDocument(
      String path, String iddoctype, String accesToken) async {
    var postUri = Uri.parse("https://speedlab.speederp.id/m/staffdocument");

    http.MultipartRequest request = new http.MultipartRequest("POST", postUri);

    Map<String, String> requestHeaders = {
      'Authorization': accesToken,
    };
    request.headers.addAll(requestHeaders);

    http.MultipartFile multipartFile =
        await http.MultipartFile.fromPath('file', path);

    request.files.add(multipartFile);
    request.fields['id_doctype'] = iddoctype;

    http.StreamedResponse streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    return ReturnCheck.fromJson(json.decode(response.body));
  }
}
