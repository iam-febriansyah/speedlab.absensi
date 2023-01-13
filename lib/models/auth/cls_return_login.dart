import 'dart:convert';

ModelReturnLogin modelReturnLoginFromJson(String? str) =>
    ModelReturnLogin.fromJson(json.decode(str!));

String? modelReturnLoginToJson(ModelReturnLogin data) =>
    json.encode(data.toJson());

class ModelReturnLogin {
  ModelReturnLogin({
    this.statusJson,
    this.remarks,
    this.token,
    this.dataUser,
  });

  bool? statusJson;
  String? remarks;
  String? token;
  DataUser? dataUser;

  factory ModelReturnLogin.fromJson(Map<String, dynamic> json) =>
      ModelReturnLogin(
        statusJson: json["status_json"],
        remarks: json["remarks"],
        token: json["token"],
        dataUser: DataUser.fromJson(json["data_user"]),
      );

  Map<String, dynamic> toJson() => {
        "status_json": statusJson,
        "remarks": remarks,
        "token": token,
        "data_user": dataUser!.toJson(),
      };
}

class DataUser {
  DataUser({
    this.id,
    this.username,
    this.email,
    this.nip,
    this.nik,
    this.nama,
    this.jenisKelamin,
    this.tempatLahir,
    this.tanggalLahir,
    this.alamat,
    this.rt,
    this.rw,
    this.desa,
    this.kecamatan,
    this.kota,
    this.provinsi,
    this.departemen,
    this.posisi,
    this.date,
    this.facedata,
  });

  String? id;
  String? username;
  String? email;
  String? nip;
  String? nik;
  String? nama;
  String? jenisKelamin;
  String? tempatLahir;
  String? tanggalLahir;
  String? alamat;
  String? rt;
  String? rw;
  String? desa;
  String? kecamatan;
  String? kota;
  String? provinsi;
  String? departemen;
  String? posisi;
  String? date;
  String? facedata;

  factory DataUser.fromJson(Map<String, dynamic> json) => DataUser(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        nip: json["nip"],
        nik: json["nik"],
        nama: json["nama"],
        jenisKelamin: json["jenis_kelamin"],
        tempatLahir: json["tempat_lahir"],
        tanggalLahir: json["tanggal_lahir"],
        alamat: json["alamat"],
        rt: json["rt"],
        rw: json["rw"],
        desa: json["desa"],
        kecamatan: json["kecamatan"],
        kota: json["kota"],
        provinsi: json["provinsi"],
        departemen: json["departemen"],
        posisi: json["posisi"],
        date: json["date"],
        facedata: json["facedata"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "nip": nip,
        "nik": nik,
        "nama": nama,
        "jenis_kelamin": jenisKelamin,
        "tempat_lahir": tempatLahir,
        "tanggal_lahir": tanggalLahir,
        "alamat": alamat,
        "rt": rt,
        "rw": rw,
        "desa": desa,
        "kecamatan": kecamatan,
        "kota": kota,
        "provinsi": provinsi,
        "departemen": departemen,
        "posisi": posisi,
        "date": date,
        "facedata": facedata
      };
}
