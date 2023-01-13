import 'dart:convert';

import 'package:flutter_application_1/models/menu/cls_absen_hari_ini.dart';

ModelListAbsen modelListAbsenFromJson(String? str) =>
    ModelListAbsen.fromJson(json.decode(str!));

class ModelListAbsen {
  ModelListAbsen(
      {required this.statusJson,
      required this.remarks,
      required this.listabsen});

  bool? statusJson;
  String? remarks;
  List<Absen> listabsen;

  factory ModelListAbsen.fromJson(Map<String, dynamic> json) => ModelListAbsen(
        statusJson: json["status_json"],
        remarks: json["remarks"],
        listabsen:
            List<Absen>.from(json["listabsen"].map((x) => Absen.fromJson(x))),
      );
}
