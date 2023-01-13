///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class ReturnCabangListcabang {
/*
{
  "cabang_id": "1",
  "instansi_id": "3",
  "nama_cabang": "Klinik Glomed21 ",
  "alamat_cabang": "Balikpapan",
  "tipe": "0",
  "latitude": "-6.2295601",
  "longitude": "106.9973988",
  "radius_absen": "100",
  "polygon": "-6.22936588203088, 106.99942896540665#-6.229325886452252, 106.99972937281565#-6.229472536892329, 106.99986616547508-6.229616520920916, 106.99967572863547#-6.229571192619891, 106.99952284272196#-6.22936588203088, 106.99942896540665"
} 
*/

  String? cabangId;
  String? instansiId;
  String? namaCabang;
  String? alamatCabang;
  String? tipe;
  String? latitude;
  String? longitude;
  String? radiusAbsen;
  String? polygon;

  ReturnCabangListcabang({
    this.cabangId,
    this.instansiId,
    this.namaCabang,
    this.alamatCabang,
    this.tipe,
    this.latitude,
    this.longitude,
    this.radiusAbsen,
    this.polygon,
  });
  ReturnCabangListcabang.fromJson(Map<String, dynamic> json) {
    cabangId = json["cabang_id"]?.toString();
    instansiId = json["instansi_id"]?.toString();
    namaCabang = json["nama_cabang"]?.toString();
    alamatCabang = json["alamat_cabang"]?.toString();
    tipe = json["tipe"]?.toString();
    latitude = json["latitude"]?.toString();
    longitude = json["longitude"]?.toString();
    radiusAbsen = json["radius_absen"]?.toString();
    polygon = json["polygon"]?.toString();
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["cabang_id"] = cabangId;
    data["instansi_id"] = instansiId;
    data["nama_cabang"] = namaCabang;
    data["alamat_cabang"] = alamatCabang;
    data["tipe"] = tipe;
    data["latitude"] = latitude;
    data["longitude"] = longitude;
    data["radius_absen"] = radiusAbsen;
    data["polygon"] = polygon;
    return data;
  }
}

class ReturnCabang {
/*
{
  "status_json": true,
  "remarks": "Berhasil",
  "listcabang": [
    {
      "cabang_id": "1",
      "instansi_id": "3",
      "nama_cabang": "Klinik Glomed21 ",
      "alamat_cabang": "Balikpapan",
      "tipe": "0",
      "latitude": "-6.2295601",
      "longitude": "106.9973988",
      "radius_absen": "100",
      "polygon": "-6.22936588203088, 106.99942896540665#-6.229325886452252, 106.99972937281565#-6.229472536892329, 106.99986616547508-6.229616520920916, 106.99967572863547#-6.229571192619891, 106.99952284272196#-6.22936588203088, 106.99942896540665"
    }
  ]
} 
*/

  bool? statusJson;
  String? remarks;
  List<ReturnCabangListcabang?>? listcabang;

  ReturnCabang({
    this.statusJson,
    this.remarks,
    this.listcabang,
  });
  ReturnCabang.fromJson(Map<String, dynamic> json) {
    statusJson = json["status_json"];
    remarks = json["remarks"]?.toString();
    if (json["listcabang"] != null) {
      final v = json["listcabang"];
      final arr0 = <ReturnCabangListcabang>[];
      v.forEach((v) {
        arr0.add(ReturnCabangListcabang.fromJson(v));
      });
      listcabang = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["status_json"] = statusJson;
    data["remarks"] = remarks;
    if (listcabang != null) {
      final v = listcabang;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v!.toJson());
      });
      data["listcabang"] = arr0;
    }
    return data;
  }
}