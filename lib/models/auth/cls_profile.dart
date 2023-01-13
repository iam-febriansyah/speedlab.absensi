// To parse this JSON data, do
//
//     final modelProfile = modelProfileFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ModelProfile modelProfileFromJson(dynamic str) =>
    ModelProfile.fromJson(json.decode(str));

dynamic modelProfileToJson(ModelProfile data) => json.encode(data.toJson());

class ModelProfile {
  ModelProfile({
    required this.statusJson,
    required this.remarks,
    required this.profile,
  });

  bool statusJson;
  dynamic remarks;
  Profile profile;

  factory ModelProfile.fromJson(Map<String, dynamic> json) => ModelProfile(
        statusJson: json["status_json"],
        remarks: json["remarks"],
        profile: Profile.fromJson(json["profile"]),
      );

  Map<String, dynamic> toJson() => {
        "status_json": statusJson,
        "remarks": remarks,
        "profile": profile.toJson(),
      };
}

class Profile {
  Profile({
    this.id,
    this.staffId,
    this.firstName,
    this.nik,
    this.email,
    this.dateOfJoining,
    this.fotoProfile,
    this.phone,
    this.address,
    this.addresDomisili,
    this.gender,
    this.birthPlace,
    this.birthDay,
    this.maritalStatus,
    this.blood,
    this.bankBankname,
    this.bankName,
    this.bankAccountno,
    this.noBpjsKesehatan,
    this.noBpjsTk,
    this.noBpjsJp,
    this.noNpwp,
    this.position,
    this.section,
    this.departement,
    this.division,
    this.level,
  });

  dynamic id;
  dynamic staffId;
  dynamic firstName;
  dynamic nik;
  dynamic email;
  dynamic dateOfJoining;
  dynamic fotoProfile;
  dynamic phone;
  dynamic address;
  dynamic addresDomisili;
  dynamic gender;
  dynamic birthPlace;
  dynamic birthDay;
  dynamic maritalStatus;
  dynamic blood;
  dynamic bankBankname;
  dynamic bankName;
  dynamic bankAccountno;
  dynamic noBpjsKesehatan;
  dynamic noBpjsTk;
  dynamic noBpjsJp;
  dynamic noNpwp;
  dynamic position;
  dynamic section;
  dynamic departement;
  dynamic division;
  dynamic level;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        id: json["id"].toString(),
        staffId: json["staff_id"].toString(),
        firstName: json["first_name"].toString(),
        nik: json["nik"].toString(),
        email: json["email"].toString(),
        dateOfJoining: json["date_of_joining"].toString(),
        fotoProfile: json["foto_profile"].toString(),
        phone: json["phone"].toString(),
        address: json["address"].toString(),
        addresDomisili: json["addres_domisili"].toString(),
        gender: json["gender"].toString(),
        birthPlace: json["birth_place"].toString(),
        birthDay: json["birth_day"].toString(),
        maritalStatus: json["marital_status"].toString(),
        blood: json["blood"].toString(),
        bankBankname: json["bank_bankname"].toString(),
        bankName: json["bank_name"].toString(),
        bankAccountno: json["bank_accountno"].toString(),
        noBpjsKesehatan: json["no_bpjs_kesehatan"].toString(),
        noBpjsTk: json["no_bpjs_tk"].toString(),
        noBpjsJp: json["no_bpjs_jp"].toString(),
        noNpwp: json["no_npwp"].toString(),
        position: json["position"].toString(),
        section: json["section"].toString(),
        departement: json["departement"].toString(),
        division: json["division"].toString(),
        level: json["level"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id.toString(),
        "staff_id": staffId.toString(),
        "first_name": firstName.toString(),
        "nik": nik.toString(),
        "email": email.toString(),
        "date_of_joining": dateOfJoining.toString(),
        "foto_profile": fotoProfile.toString(),
        "phone": phone.toString(),
        "address": address.toString(),
        "addres_domisili": addresDomisili.toString(),
        "gender": gender.toString(),
        "birth_place": birthPlace.toString(),
        "birth_day": birthDay.toString(),
        "marital_status": maritalStatus.toString(),
        "blood": blood.toString(),
        "bank_bankname": bankBankname.toString(),
        "bank_name": bankName.toString(),
        "bank_accountno": bankAccountno.toString(),
        "no_bpjs_kesehatan": noBpjsKesehatan.toString(),
        "no_bpjs_tk": noBpjsTk.toString(),
        "no_bpjs_jp": noBpjsJp.toString(),
        "no_npwp": noNpwp.toString(),
        "position": position.toString(),
        "section": section.toString(),
        "departement": departement.toString(),
        "division": division.toString(),
        "level": level.toString(),
      };
}
