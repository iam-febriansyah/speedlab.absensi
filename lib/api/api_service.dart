import 'dart:async';
import 'dart:convert';

import 'package:flutter_application_1/models/absen/post.dart';
import 'package:flutter_application_1/models/bankaccount/bankaccount.dart';
import 'package:flutter_application_1/models/cabang/return.dart';
import 'package:flutter_application_1/models/login/post.dart';
import 'package:flutter_application_1/models/personalprofil/get.dart';
import 'package:flutter_application_1/models/return_check.dart';
import 'package:http/http.dart' as http;

import '../models/absen/return.dart';

class DevService {
  // static final String _baseUrl = 'http://erp.glomed21.id/';
  static final String _baseUrl = 'https://smarterp.speedlab.id/';

  static final String _login = "m/login";
  static final String _absenhariini = "m/absen/harini";
  static final String _getHome = "m/getHome";
  static final String _listabsen = "m/absen/list";
  static final String _listabsennew = "m/absen/listnew";
  static final String _updatefacedata = "m/updatefacedata";
  static final String _absen = "m/newabsen";
  static final String _absenNewV2 = "m/newabsenv2";

  static final String _profil = "m/profile";
  static final String _myovertime = "m/myovertime";
  static final String _myleave = "m/myleave";
  static final String _overtime = "m/overtime";
  static final String _leave = "m/leave";
  static final String _allcabang = "m/allcabang";
  static final String _myprofile = "m/myprofile";
  static final String _shift = "m/absen/staff_shift";
  static final String _telat = "m/absen/telat";
  static final String _leaveType = "m/leavetype";

  static final String _documentType = "m/documenttype";
  static final String _personalInfo = "m/personalinfo";
  static final String _mypersonalInfo = "m/mypersonalinfo";

  static final String _mybankaccount = "m/mybankaccount";
  static final String _bankaccount = "m/bankaccount";

  static final String _perjalanandinas = "m/perjalanandinas";
  static final String _updateDeviceId = "m/updateDeviceId";

  static final String _tipeCuti = "m/cuti/tipe";
  static final String _listCuti = "m/cuti/riwayat";
  static final String _simpanCuti = "m/cuti/simpan";
  static final String _appRejCuti = "m/cuti/aproveReject";
  static final String _singleCuti = "m/cuti/singleCuti";

  static final String _listOvertime = "m/overtime/riwayat";
  static final String _listOvertimeApproval = "m/overtime/approvallist";
  static final String _simpanOvertime = "m/overtime/simpan";
  static final String _appRejOvertime = "m/overtime/aproveRejectNew";
  static final String _appDelOvertime = "m/overtime/hapus";
  static final String _singleOvertime = "m/overtime/singleCuti";

  static final String _tipeIzin = "m/izin/type";
  static final String _listIzin = "m/izin";
  static final String _simpanIzin = "m/izin/simpan";
  static final String _appRejIzin = "m/izin/appreject";
  static final String _singleIzin = "m/izin/single";

  static final String _listShift = "m/shift/list";

  static final String _profileSingle = "m/profile/single";
  static final String _singleDocument = "m/profile/singleDocument";
  static final String _updateProfile = "m/profile/updateProfile";
  static final String _updateBpjs = "m/profile/updateBpjs";
  static final String _updateBank = "m/profile/updateBank";
  static final String _uploadDocument = "m/profile/uploadDocument";
  static final String _uploadPhoto = "m/profile/uploadPhoto";
  static final String _updatePassword = "m/profile/updatePassword";

  static final String _tokenFirebase = "m/updateTokenFirebase";

  Future bankAccount(
      String accesToken, String bankName, String bankAccount) async {
    Map data = {
      "bank_name": bankName,
      "bank_accountno": bankAccount,
    };

    var body = jsonEncode(data);

    final response = await http
        .post(
          Uri.parse(_baseUrl + _bankaccount),
          headers: <String, String>{
            'Authorization': accesToken,
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body,
        )
        .timeout(Duration(seconds: 30));

    if (response.statusCode == 200) {
      return ReturnCheck.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to post');
    }
  }

  Future perjalanDinas(String accesToken, String tgl_dari, String tgl_sampai,
      String kegiatan) async {
    Map data = {
      "tgl_dari": tgl_dari,
      "tgl_sampai": tgl_sampai,
      "kegiatan": kegiatan
    };

    var body = jsonEncode(data);

    final response = await http
        .post(
          Uri.parse(_baseUrl + _perjalanandinas),
          headers: <String, String>{
            'Authorization': accesToken,
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body,
        )
        .timeout(Duration(seconds: 30));

    if (response.statusCode == 200) {
      return ReturnCheck.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to post');
    }
  }

  Future<dynamic> myBankAccount(String accesToken) async {
    final response = await http.get(
      Uri.parse(_baseUrl + _mybankaccount),
      headers: <String, String>{
        'Authorization': accesToken,
      },
    );
    if (response.statusCode == 200) {
      return BankAccount.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<dynamic> myPersonalInfo(String accesToken) async {
    final response = await http.get(
      Uri.parse(_baseUrl + _mypersonalInfo),
      headers: <String, String>{
        'Authorization': accesToken,
      },
    );
    if (response.statusCode == 200) {
      return ReturnMyPersonalProfil.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load');
    }
  }

  Future personalProfil(
      String accesToken,
      String nik,
      String first_name,
      String phone,
      String address,
      String gender,
      String birth_place,
      String birth_day,
      String blood) async {
    Map data = {
      "nik": nik,
      "first_name": first_name,
      "phone": phone,
      "address": address,
      "gender": gender,
      "birth_place": birth_place,
      "birth_day": birth_day,
      "blood": blood
    };

    var body = jsonEncode(data);

    final response = await http
        .post(
          Uri.parse(_baseUrl + _personalInfo),
          headers: <String, String>{
            'Authorization': accesToken,
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body,
        )
        .timeout(Duration(seconds: 30));

    if (response.statusCode == 200) {
      return ReturnCheck.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to post');
    }
  }

  Future telat(String accesToken, String idStaff, String jamMasuk,
      String jamKeluar, String tanggal, String alasan) async {
    Map data = {
      "staff_id": idStaff,
      "jam_masuk": jamMasuk,
      "jam_keluar": jamKeluar,
      "tanggal": "",
      "alasan": alasan
    };

    var body = jsonEncode(data);

    final response = await http
        .post(
          Uri.parse(_baseUrl + _telat),
          headers: <String, String>{
            'Authorization': accesToken,
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body,
        )
        .timeout(Duration(seconds: 30));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to post');
    }
  }

  Future shift(
    String accesToken,
    String idStaff,
  ) async {
    Map data = {
      "staff_id": idStaff,
    };

    var body = jsonEncode(data);

    final response = await http
        .post(
          Uri.parse(_baseUrl + _shift),
          headers: <String, String>{
            'Authorization': accesToken,
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body,
        )
        .timeout(Duration(seconds: 30));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to post');
    }
  }

  Future<dynamic> documentType(String accesToken) async {
    final response = await http.get(
      Uri.parse(_baseUrl + _documentType),
      headers: <String, String>{
        'Authorization': accesToken,
      },
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<dynamic> allcabang(String accesToken) async {
    final response = await http.get(
      Uri.parse(_baseUrl + _allcabang),
      headers: <String, String>{
        'Authorization': accesToken,
      },
    );
    if (response.statusCode == 200) {
      return ReturnCabang.fromJson(json.decode(response.body));
    }
  }

  Future<dynamic> allcabangNew(String accesToken) async {
    final response = await http.get(
      Uri.parse(_baseUrl + _allcabang),
      headers: <String, String>{
        'Authorization': accesToken,
      },
    );
    if (response.statusCode == 200) {
      return response.body;
    }
  }

  Future myprofile(
    String accesToken,
    String phone,
  ) async {
    Map data = {
      "phone": phone,
    };

    var body = jsonEncode(data);

    final response = await http
        .post(
          Uri.parse(_baseUrl + _myprofile),
          headers: <String, String>{
            'Authorization': accesToken,
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body,
        )
        .timeout(Duration(seconds: 15));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to post');
    }
  }

  Future leave(
    String accesToken,
    String idstaff,
    String tanggal,
    String ket,
    String tipe,
    String mulai,
    String akhir,
    String jammulai,
    String jamakhir,
    //String pdfbase64
  ) async {
    Map data = {
      "idstaff": idstaff,
      "tanggal": tanggal,
      "ket": ket,
      "tipe": tipe,
      "mulai": mulai,
      "akhir": akhir,
      "jam_mulai": jammulai,
      "jam_akhir": jamakhir,
      //"pdf_base64": pdfbase64
    };

    var body = jsonEncode(data);

    final response = await http
        .post(
          Uri.parse(_baseUrl + _leave),
          headers: <String, String>{
            'Authorization': accesToken,
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body,
        )
        .timeout(Duration(seconds: 30));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to post');
    }
  }

  Future overtime(String accesToken, String idstaff, String tanggal, String ket,
      String tgllembur, String jammulai, String jamakhir) async {
    Map data = {
      "idstaff": idstaff,
      "tanggal": tanggal,
      "ket": ket,
      "tgl_lembur": tgllembur,
      "jam_mulai": jammulai,
      "jam_akhir": jamakhir
    };

    var body = jsonEncode(data);

    final response = await http
        .post(
          Uri.parse(_baseUrl + _overtime),
          headers: <String, String>{
            'Authorization': accesToken,
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body,
        )
        .timeout(Duration(seconds: 30));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to post');
    }
  }

  Future<dynamic> myovertime(String accesToken) async {
    final response = await http.get(
      Uri.parse(_baseUrl + _myovertime),
      headers: <String, String>{
        'Authorization': accesToken,
      },
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<dynamic> leaveType(String accesToken) async {
    final response = await http.get(
      Uri.parse(_baseUrl + _leaveType),
      headers: <String, String>{
        'Authorization': accesToken,
      },
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<dynamic> myleave(String accesToken) async {
    final response = await http.get(
      Uri.parse(_baseUrl + _myleave),
      headers: <String, String>{
        'Authorization': accesToken,
      },
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<dynamic> profil(String accesToken) async {
    final response = await http.get(
      Uri.parse(_baseUrl + _profil),
      headers: <String, String>{
        'Authorization': accesToken,
      },
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load');
    }
  }

  Future absen(String accesToken, PostAbsen postAbsen) async {
    var body = jsonEncode(postAbsen);

    final response = await http
        .post(
          Uri.parse(_baseUrl + _absen),
          headers: <String, String>{
            'Authorization': accesToken,
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body,
        )
        .timeout(Duration(seconds: 30));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to post');
    }
  }

  Future absenNewV2(String accesToken, PostAbsen postAbsen) async {
    var body = jsonEncode(postAbsen);

    final response = await http
        .post(
          Uri.parse(_baseUrl + _absenNewV2),
          headers: <String, String>{
            'Authorization': accesToken,
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body,
        )
        .timeout(Duration(seconds: 30));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to post');
    }
  }

  Future updatefacedata(String accesToken, List<dynamic> facedata) async {
    Map data = {"facedata": facedata};

    var body = jsonEncode(data);

    final response = await http
        .post(
          Uri.parse(_baseUrl + _updatefacedata),
          headers: <String, String>{
            'Authorization': accesToken,
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body,
        )
        .timeout(Duration(seconds: 30));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to post');
    }
  }

  Future<dynamic> listabsen(String accesToken) async {
    final response = await http.get(
      Uri.parse(_baseUrl + _listabsen),
      headers: <String, String>{
        'Authorization': accesToken,
      },
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<dynamic> absenhariini(String accesToken) async {
    final response = await http.get(
      Uri.parse(_baseUrl + _absenhariini),
      headers: <String, String>{
        'Authorization': accesToken,
      },
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load');
    }
  }

  Future login(String username, String password) async {
    Map data = {
      "username": username,
      "password": password,
    };

    var body = jsonEncode(data);

    final response = await http
        .post(
          Uri.parse(_baseUrl + _login),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body,
        )
        .timeout(Duration(seconds: 30));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to post');
    }
  }

  Future<dynamic> updateDeviceId(
      String accesToken, PostDeviceId postBody) async {
    var body = jsonEncode(postBody);

    final response = await http
        .post(
          Uri.parse(_baseUrl + _updateDeviceId),
          headers: <String, String>{
            'Authorization': accesToken,
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body,
        )
        .timeout(
          Duration(seconds: 30),
          onTimeout: () =>
              throw TimeoutException('Can\'t connect in 30 seconds.'),
        );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to post');
    }
  }

  Future<dynamic> tipeCuti(String accesToken) async {
    final response = await http.get(
      Uri.parse(_baseUrl + _tipeCuti),
      headers: <String, String>{
        'Authorization': accesToken,
      },
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<dynamic> listCuti(String accesToken) async {
    final response = await http.get(
      Uri.parse(_baseUrl + _listCuti),
      headers: <String, String>{
        'Authorization': accesToken,
      },
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<dynamic> simpanCuti(String accesToken, int tipe, String keterangan,
      List<String> itemTanggal) async {
    Map data = {
      "tipe": tipe,
      "keterangan": keterangan,
      "itemTanggal": itemTanggal
    };
    var body = jsonEncode(data);
    final response = await http
        .post(
          Uri.parse(_baseUrl + _simpanCuti),
          headers: <String, String>{
            'Authorization': accesToken,
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body,
        )
        .timeout(
          Duration(seconds: 30),
          onTimeout: () =>
              throw TimeoutException('Can\'t connect in 30 seconds.'),
        );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to post');
    }
  }

  Future<dynamic> singleCuti(String accesToken, int id, String staffId) async {
    Map data = {"id": id, "staff_id": staffId};
    var body = jsonEncode(data);
    final response = await http
        .post(
          Uri.parse(_baseUrl + _singleCuti),
          headers: <String, String>{
            'Authorization': accesToken,
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body,
        )
        .timeout(
          Duration(seconds: 30),
          onTimeout: () =>
              throw TimeoutException('Can\'t connect in 30 seconds.'),
        );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to post');
    }
  }

  Future<dynamic> appRejCuti(String accesToken, int id, int status,
      List<TanggalCuti> tanggalPost, String catatan) async {
    Map data = {
      "id": id,
      "status": status,
      "id_details": tanggalPost,
      "catatan": catatan
    };
    var body = jsonEncode(data);
    final response = await http
        .post(
          Uri.parse(_baseUrl + _appRejCuti),
          headers: <String, String>{
            'Authorization': accesToken,
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body,
        )
        .timeout(
          Duration(seconds: 30),
          onTimeout: () =>
              throw TimeoutException('Can\'t connect in 30 seconds.'),
        );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to post');
    }
  }

  Future<dynamic> listabsennew(
    String accesToken,
    String tahunbulan,
  ) async {
    Map data = {"tahunbulan": tahunbulan};
    var body = jsonEncode(data);
    final response = await http
        .post(
          Uri.parse(_baseUrl + _listabsennew),
          headers: <String, String>{
            'Authorization': accesToken,
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body,
        )
        .timeout(
          Duration(seconds: 30),
          onTimeout: () =>
              throw TimeoutException('Can\'t connect in 30 seconds.'),
        );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to post');
    }
  }

  Future<dynamic> listOvertime(String accesToken) async {
    final response = await http.get(
      Uri.parse(_baseUrl + _listOvertime),
      headers: <String, String>{
        'Authorization': accesToken,
      },
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<dynamic> listOvertimeApproval(
    String accesToken,
    String tahunbulan,
    String status,
  ) async {
    Map data = {"tahunbulan": tahunbulan, "status": status};
    var body = jsonEncode(data);
    final response = await http
        .post(
          Uri.parse(_baseUrl + _listOvertimeApproval),
          headers: <String, String>{
            'Authorization': accesToken,
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body,
        )
        .timeout(
          Duration(seconds: 30),
          onTimeout: () =>
              throw TimeoutException('Can\'t connect in 30 seconds.'),
        );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to post');
    }
  }

  Future<dynamic> simpanOvertime(
    String accesToken,
    String tipe_lembur,
    String tanggal,
    String ket,
    String jam_mulai,
    String jam_akhir,
  ) async {
    Map data = {
      "tipe_lembur": tipe_lembur,
      "tanggal": tanggal,
      "ket": ket,
      "jam_mulai": jam_mulai,
      "jam_akhir": jam_akhir
    };
    var body = jsonEncode(data);
    final response = await http
        .post(
          Uri.parse(_baseUrl + _simpanOvertime),
          headers: <String, String>{
            'Authorization': accesToken,
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body,
        )
        .timeout(
          Duration(seconds: 30),
          onTimeout: () =>
              throw TimeoutException('Can\'t connect in 30 seconds.'),
        );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to post');
    }
  }

  Future<dynamic> singleOvertime(
      String accesToken, int id, String staffId) async {
    Map data = {"id": id, "staff_id": staffId};
    var body = jsonEncode(data);
    final response = await http
        .post(
          Uri.parse(_baseUrl + _singleOvertime),
          headers: <String, String>{
            'Authorization': accesToken,
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body,
        )
        .timeout(
          Duration(seconds: 30),
          onTimeout: () =>
              throw TimeoutException('Can\'t connect in 30 seconds.'),
        );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to post');
    }
  }

  Future<dynamic> appRejOvertime(String accesToken, int id, int status,
      String keterangan_approvereject, String jamDari, String jamSampai) async {
    Map data = {
      "id": id,
      "status": status,
      "keterangan_approvereject": keterangan_approvereject,
      "jam_mulai": jamDari,
      "jam_akhir": jamSampai
    };
    var body = jsonEncode(data);
    final response = await http
        .post(
          Uri.parse(_baseUrl + _appRejOvertime),
          headers: <String, String>{
            'Authorization': accesToken,
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body,
        )
        .timeout(
          Duration(seconds: 30),
          onTimeout: () =>
              throw TimeoutException('Can\'t connect in 30 seconds.'),
        );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to post');
    }
  }

  Future<dynamic> appDelOvertime(String accesToken, int id) async {
    Map data = {"id": id};
    var body = jsonEncode(data);
    final response = await http
        .post(
          Uri.parse(_baseUrl + _appDelOvertime),
          headers: <String, String>{
            'Authorization': accesToken,
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body,
        )
        .timeout(
          Duration(seconds: 30),
          onTimeout: () =>
              throw TimeoutException('Can\'t connect in 30 seconds.'),
        );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to post');
    }
  }

  Future<dynamic> updateTokenFirebase(String accesToken, String token) async {
    Map data = {"token": token};
    var body = jsonEncode(data);
    final response = await http
        .post(
          Uri.parse(_baseUrl + _tokenFirebase),
          headers: <String, String>{
            'Authorization': accesToken,
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body,
        )
        .timeout(
          Duration(seconds: 30),
          onTimeout: () =>
              throw TimeoutException('Can\'t connect in 30 seconds.'),
        );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to post');
    }
  }

  Future<dynamic> getHome(String accesToken) async {
    final response = await http.get(
      Uri.parse(_baseUrl + _getHome),
      headers: <String, String>{
        'Authorization': accesToken,
      },
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<dynamic> tipeIzin(String accesToken) async {
    final response = await http.get(
      Uri.parse(_baseUrl + _tipeIzin),
      headers: <String, String>{
        'Authorization': accesToken,
      },
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<dynamic> listIzin(String accesToken) async {
    final response = await http.get(
      Uri.parse(_baseUrl + _listIzin),
      headers: <String, String>{
        'Authorization': accesToken,
      },
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<dynamic> simpanIzin(String accesToken, int idIzin, String keterangan,
      List<String> files, String tanggal, String mulaiJam) async {
    Map data = {
      "id_izin": idIzin,
      "keterangan": keterangan,
      "tanggal": tanggal,
      "mulai_jam": mulaiJam,
      "files": files
    };
    var body = jsonEncode(data);
    final response = await http
        .post(
          Uri.parse(_baseUrl + _simpanIzin),
          headers: <String, String>{
            'Authorization': accesToken,
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body,
        )
        .timeout(
          Duration(seconds: 30),
          onTimeout: () =>
              throw TimeoutException('Can\'t connect in 30 seconds.'),
        );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to post');
    }
  }

  Future<dynamic> singleIzin(String accesToken, int id) async {
    Map data = {"id": id};
    var body = jsonEncode(data);
    final response = await http
        .post(
          Uri.parse(_baseUrl + _singleIzin),
          headers: <String, String>{
            'Authorization': accesToken,
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body,
        )
        .timeout(
          Duration(seconds: 30),
          onTimeout: () =>
              throw TimeoutException('Can\'t connect in 30 seconds.'),
        );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to post');
    }
  }

  Future<dynamic> appRejIzin(String accesToken, int id, int status) async {
    Map data = {"id": id, "status": status};
    var body = jsonEncode(data);
    final response = await http
        .post(
          Uri.parse(_baseUrl + _appRejIzin),
          headers: <String, String>{
            'Authorization': accesToken,
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body,
        )
        .timeout(
          Duration(seconds: 30),
          onTimeout: () =>
              throw TimeoutException('Can\'t connect in 30 seconds.'),
        );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to post');
    }
  }

  Future<dynamic> listShift(String accesToken, String tahunBulan) async {
    var param = "?tahunbulan=${tahunBulan}";
    final response = await http.get(
      Uri.parse(_baseUrl + _listShift + param),
      headers: <String, String>{
        'Authorization': accesToken,
      },
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<dynamic> getProfileSingle(String accesToken) async {
    final response = await http.get(
      Uri.parse(_baseUrl + _profileSingle),
      headers: <String, String>{
        'Authorization': accesToken,
      },
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<dynamic> getProfileDoc(String accesToken) async {
    final response = await http.get(
      Uri.parse(_baseUrl + _singleDocument),
      headers: <String, String>{
        'Authorization': accesToken,
      },
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<dynamic> updateProfile(
      String accesToken,
      String first_name,
      String nik,
      String email,
      String phone,
      String address,
      String addres_domisili,
      String gender,
      String birth_place,
      String birth_day,
      String marital_status,
      String blood) async {
    Map data = {
      "first_name": first_name,
      "nik": nik,
      "email": email,
      "phone": phone,
      "address": address,
      "addres_domisili": addres_domisili,
      "gender": gender,
      "birth_place": birth_place,
      "birth_day": birth_day,
      "marital_status": marital_status,
      "blood": blood
    };
    var body = jsonEncode(data);
    final response = await http
        .post(
          Uri.parse(_baseUrl + _updateProfile),
          headers: <String, String>{
            'Authorization': accesToken,
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body,
        )
        .timeout(
          Duration(seconds: 30),
          onTimeout: () =>
              throw TimeoutException('Can\'t connect in 30 seconds.'),
        );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to post');
    }
  }

  Future<dynamic> updateBpjs(String accesToken, String no_bpjs_kesehatan,
      String no_bpjs_tk, String no_bpjs_jp) async {
    Map data = {
      "no_bpjs_kesehatan": no_bpjs_kesehatan,
      "no_bpjs_tk": no_bpjs_tk,
      "no_bpjs_jp": no_bpjs_jp
    };
    var body = jsonEncode(data);
    final response = await http
        .post(
          Uri.parse(_baseUrl + _updateBpjs),
          headers: <String, String>{
            'Authorization': accesToken,
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body,
        )
        .timeout(
          Duration(seconds: 30),
          onTimeout: () =>
              throw TimeoutException('Can\'t connect in 30 seconds.'),
        );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to post');
    }
  }

  Future<dynamic> updateBank(String accesToken, String bank_bankname,
      String bank_name, String bank_accountno) async {
    Map data = {
      "bank_bankname": bank_bankname,
      "bank_name": bank_name,
      "bank_accountno": bank_accountno
    };
    var body = jsonEncode(data);
    final response = await http
        .post(
          Uri.parse(_baseUrl + _updateBank),
          headers: <String, String>{
            'Authorization': accesToken,
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body,
        )
        .timeout(
          Duration(seconds: 30),
          onTimeout: () =>
              throw TimeoutException('Can\'t connect in 30 seconds.'),
        );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to post');
    }
  }

  Future<dynamic> updatePhotoProfile(String accesToken, String files) async {
    Map data = {"files": files};
    var body = jsonEncode(data);
    final response = await http
        .post(
          Uri.parse(_baseUrl + _uploadPhoto),
          headers: <String, String>{
            'Authorization': accesToken,
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body,
        )
        .timeout(
          Duration(seconds: 30),
          onTimeout: () =>
              throw TimeoutException('Can\'t connect in 30 seconds.'),
        );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to post');
    }
  }

  Future<dynamic> uploadDocument(
      String accesToken, List<String> files, String id_doctype) async {
    Map data = {"files": files, "id_doctype": id_doctype};
    var body = jsonEncode(data);
    final response = await http
        .post(
          Uri.parse(_baseUrl + _uploadDocument),
          headers: <String, String>{
            'Authorization': accesToken,
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body,
        )
        .timeout(
          Duration(seconds: 30),
          onTimeout: () =>
              throw TimeoutException('Can\'t connect in 30 seconds.'),
        );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to post');
    }
  }

  Future<dynamic> updatePassword(String accesToken, String password) async {
    Map data = {"password": password};
    var body = jsonEncode(data);
    final response = await http
        .post(
          Uri.parse(_baseUrl + _updatePassword),
          headers: <String, String>{
            'Authorization': accesToken,
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body,
        )
        .timeout(
          Duration(seconds: 30),
          onTimeout: () =>
              throw TimeoutException('Can\'t connect in 30 seconds.'),
        );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to post');
    }
  }
}
