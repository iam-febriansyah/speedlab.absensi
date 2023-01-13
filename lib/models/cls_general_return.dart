// To parse this JSON data, do
//
//     final modelGeneralReturn = modelGeneralReturnFromJson(jsonString);

import 'dart:convert';

ModelGeneralReturn modelGeneralReturnFromJson(String str) =>
    ModelGeneralReturn.fromJson(json.decode(str));

String modelGeneralReturnToJson(ModelGeneralReturn data) =>
    json.encode(data.toJson());

class ModelGeneralReturn {
  ModelGeneralReturn({
    required this.statusJson,
    required this.remarks,
  });

  bool statusJson;
  String remarks;

  factory ModelGeneralReturn.fromJson(Map<String, dynamic> json) =>
      ModelGeneralReturn(
        statusJson: json["status_json"] == null ? null : json["status_json"],
        remarks: json["remarks"] == null ? null : json["remarks"],
      );

  Map<String, dynamic> toJson() => {
        // ignore: unnecessary_null_comparison
        "status_json": statusJson == null ? null : statusJson,
        // ignore: unnecessary_null_comparison
        "remarks": remarks == null ? null : remarks,
      };
}
