class ReturnMyOvertime {
  ReturnMyOvertime({
    required this.statusJson,
    required this.remarks,
    required this.listovertime,
  });
  late final bool statusJson;
  late final String remarks;
  late final List<Listovertime> listovertime;

  ReturnMyOvertime.fromJson(Map<String, dynamic> json) {
    statusJson = json['status_json'];
    remarks = json['remarks'];
    listovertime = List.from(json['listovertime'])
        .map((e) => Listovertime.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status_json'] = statusJson;
    _data['remarks'] = remarks;
    _data['listovertime'] = listovertime.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Listovertime {
  Listovertime({
    required this.id,
    required this.staffId,
    required this.tanggal,
    required this.ket,
    required this.status,
    required this.tglLembur,
    required this.jamMulai,
    required this.jamAkhir,
  });
  late final int id;
  late final String staffId;
  late final String tanggal;
  late final String ket;
  late final int status;
  late final String tglLembur;
  late final String jamMulai;
  late final String jamAkhir;

  Listovertime.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    staffId = json['staff_id'];
    tanggal = json['tanggal'];
    ket = json['ket'];
    status = json['status'];
    tglLembur = json['tgl_lembur'];
    jamMulai = json['jam_mulai'];
    jamAkhir = json['jam_akhir'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['staff_id'] = staffId;
    _data['tanggal'] = tanggal;
    _data['ket'] = ket;
    _data['status'] = status;
    _data['tgl_lembur'] = tglLembur;
    _data['jam_mulai'] = jamMulai;
    _data['jam_akhir'] = jamAkhir;
    return _data;
  }
}
