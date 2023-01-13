///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class ReturnUpdateFace {
/*
{
  "status_json": true,
  "remarks": "Successfully Update Your Face Data"
} 
*/

  bool? status_json;
  String? remarks;

  ReturnUpdateFace({
    this.status_json,
    this.remarks,
  });
  ReturnUpdateFace.fromJson(Map<String, dynamic> json) {
    status_json = json["status_json"];
    remarks = json["remarks"]?.toString();
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["status_json"] = status_json;
    data["remarks"] = remarks;
    return data;
  }
}