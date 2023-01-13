import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_1/pages/myshift/list_tahun.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api_service.dart';
import '../../style/colors.dart';

class ListShift extends StatefulWidget {
  const ListShift({Key? key}) : super(key: key);

  @override
  State<ListShift> createState() => _ListShiftState();
}

class _ListShiftState extends State<ListShift> {
  bool loading = false;
  bool failed = false;
  String remakrs = '';
  List<dynamic> listShift = [];
  List<dynamic> listBulan = [];
  String namaKaryawan = '';
  String tahunBulan = '';
  String tahunBulanText = '';
  String staffID = '';
  DevService _devService = DevService();

  void getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    DateTime now = await NTP.now();
    String month = DateFormat('MM').format(now);
    String monthText = convertMonthText(month);
    String year = DateFormat('y').format(now);
    if (mounted)
      setState(() {
        namaKaryawan = pref.getString("PREF_NAMA")!;
        staffID = pref.getString("PREF_NIP")!;
        loading = true;
        failed = false;
        tahunBulan = year + '' + month;
        tahunBulanText = monthText + ' ' + year;
      });
    getListData(tahunBulan, tahunBulanText);
  }

  getListData(tahunBulanParam, tahunBulanTextParam) async {
    setState(() {
      loading = true;
      failed = false;
      tahunBulan = tahunBulanParam;
      tahunBulanText = tahunBulanTextParam;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    var accesToken = pref.getString("PREF_TOKEN")!;
    _devService.listShift(accesToken, tahunBulan).then((value) async {
      var res = json.decode(value);
      if (res['status_json'] == true) {
        setState(() {
          listShift = res['list_shift'];
          listBulan = res['list_tahun'];
          loading = false;
          failed = false;
        });
      } else {
        setState(() {
          loading = false;
          failed = true;
          remakrs = res['remarks'];
        });
      }
    }).catchError((Object obj) {
      if (mounted)
        setState(() {
          loading = false;
          failed = true;
          remakrs = "Gagal menyambungkan ke server";
        });
    });
  }

  String convertHari(day) {
    if (day == 'Sunday') {
      return 'Minggu';
    } else if (day == 'Monday') {
      return 'Senin';
    } else if (day == 'Tuesday') {
      return 'Selasa';
    } else if (day == 'Wednesday') {
      return 'Rabu';
    } else if (day == 'Thursday') {
      return 'Kamis';
    } else if (day == 'Friday') {
      return 'Jumat';
    } else {
      return 'Sabtu';
    }
  }

  String convertMonthText(month) {
    if (month == '01') {
      return 'Januari';
    } else if (month == '02') {
      return 'Februari';
    } else if (month == '03') {
      return 'Maret';
    } else if (month == '04') {
      return 'April';
    } else if (month == '05') {
      return 'Mei';
    } else if (month == '06') {
      return 'Juni';
    } else if (month == '07') {
      return 'Juli';
    } else if (month == '08') {
      return 'Agustus';
    } else if (month == '09') {
      return 'September';
    } else if (month == '10') {
      return 'Oktober';
    } else if (month == '11') {
      return 'September';
    } else {
      return 'Desember';
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: ColorsTheme.primary1));

    return Scaffold(
        appBar: AppBar(
            title: Text("My Shift"),
            elevation: 0,
            backgroundColor: ColorsTheme.primary1),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      namaKaryawan.toUpperCase() + '\n(' + staffID + ')',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: ColorsTheme.primary1),
                    )),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ListTahun(
                                  listTahun: listBulan,
                                )),
                      );
                      setState(() {
                        if (result != null) {
                          tahunBulan = result['key'].toString();
                          tahunBulanText = result['text'].toString();
                          getListData(tahunBulan, tahunBulanText);
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: ColorsTheme.grey,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(child: Text(tahunBulanText)),
                            Icon(Icons.arrow_drop_down)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(child: listViewAbsen(listShift)),
          ],
        ));
  }

  Widget listViewAbsen(data) {
    return ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: data.length,
        itemBuilder: (context, index) {
          var dt = data[index];
          return card(dt);
        });
  }

  Widget card(data) {
    var tanggal = data['tanggal'].toString();
    var shift = data['shift'];
    Color colorStatus = Colors.white;
    String shiftName = '';
    String jamDari = '';
    String jamSampai = '';
    if (shift == false) {
      colorStatus = ColorsTheme.merah.withOpacity(0.3);
    } else {
      shiftName = shift['shift_name'];
      jamDari = shift['jam_dari'];
      jamSampai = shift['jam_sampai'];
      if (shiftName.toUpperCase() == 'LIBUR') {
        colorStatus = ColorsTheme.hijau.withOpacity(0.1);
      }
    }

    return Card(
      child: Container(
        decoration: BoxDecoration(
          color: colorStatus,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(4),
              bottomRight: Radius.circular(4),
              topLeft: Radius.circular(4),
              bottomLeft: Radius.circular(4)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        tanggal,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                ),
                // statusCutiWidget(colorStatus, datang_pulang.toUpperCase()),
              ],
            ),
            Divider(height: 1),
            Container(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: shiftName == ''
                    ? Text(
                        "TIDAK ADA SHIFT, HARAP HUBUNGI ATASAN ANDA",
                        textAlign: TextAlign.start,
                        style:
                            TextStyle(color: ColorsTheme.merah, fontSize: 12),
                      )
                    : Column(
                        children: [
                          rowWidget("SHIFT", shiftName.toUpperCase()),
                          rowWidget("JAM MASUK", jamDari),
                          rowWidget("JAM KELUAR", jamSampai)
                        ],
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget rowWidget(key, value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: 150, child: Text(key, style: TextStyle(fontSize: 11))),
          Text(": ", style: TextStyle(fontSize: 11)),
          Expanded(
              child: Html(
            data: value,
            style: {
              "body": Style(
                  fontSize: FontSize(10),
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero),
            },
          )),
        ],
      ),
    );
  }
}
