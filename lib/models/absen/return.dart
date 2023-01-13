///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class ReturnAbsen {
/*
{
  "status_json": true,
  "remarks": "Successfully submit attendance"
} 
*/

  bool? status_json;
  String? remarks;

  ReturnAbsen({
    this.status_json,
    this.remarks,
  });
  ReturnAbsen.fromJson(Map<String, dynamic> json) {
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

class TanggalCuti {
  String? id;
  String? value;
  String? delete;

  TanggalCuti({
    this.id,
    this.value,
    this.delete,
  });
  TanggalCuti.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    value = json["value"];
    delete = json["delete"];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["value"] = value;
    data["id"] = id;
    data["delete"] = delete;
    return data;
  }
}

class TipeLembur {
  String? selected;
  String? value;

  TipeLembur({
    this.selected,
    this.value,
  });
  TipeLembur.fromJson(Map<String, dynamic> json) {
    selected = json["selected"];
    value = json["value"];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["value"] = value;
    data["selected"] = selected;
    return data;
  }
}