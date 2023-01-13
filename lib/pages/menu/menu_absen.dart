import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/pages/general_widget/widget_no_data.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api_service.dart';
import '../../style/colors.dart';
import '../absen/absen_listbulan.dart';

class MenuAbsen extends StatefulWidget {
  const MenuAbsen({Key? key}) : super(key: key);

  @override
  State<MenuAbsen> createState() => _MenuAbsenState();
}

class _MenuAbsenState extends State<MenuAbsen> {
  bool loading = false;
  bool failed = false;
  String remakrs = '';
  List<dynamic> listAbsen = [];
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
    String monthText = DateFormat('MMMM').format(now);
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
    _devService.listabsennew(accesToken, tahunBulan).then((value) async {
      var res = json.decode(value);
      if (res['status_json'] == true) {
        setState(() {
          listAbsen = res['listabsen'];
          listBulan = res['listbulan'];
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
            title: Text("Riwayat Absensi"),
            elevation: 0,
            backgroundColor: ColorsTheme.primary1),
        body: loading
            ? Center(child: Text("Loading Page .."))
            : Column(
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
                                  builder: (context) => AbsenListBulan(
                                        dataList: listBulan,
                                      )),
                            );
                            setState(() {
                              if (result != null) {
                                tahunBulan = result['bulanKey'].toString();
                                tahunBulanText = result['bulanText'].toString();
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
                  Expanded(
                      child: listAbsen.length == 0
                          ? WidgetNoData()
                          : listViewAbsen(listAbsen)),
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
    var datang_pulang = data['datang_pulang'].toString();
    var wfhWfo = data['wfh_wfo'].toString();
    var tanggalAbsen = data['tanggal_absen'].toString();
    var jam_absen = data['jam_absen'].toString();
    var lokasi = data['lokasi'].toString();
    Color colorStatus = ColorsTheme.merah;
    if (datang_pulang == 'in') {
      colorStatus = ColorsTheme.hijau;
    }
    DateTime tempDate = DateFormat("yyyy-MM-dd hh:mm:ss")
        .parse(tanggalAbsen + " " + "00:00:00");
    String tanggal = DateFormat('dd').format(tempDate);
    String hari = DateFormat('EEEE').format(tempDate);
    String bulantahun = DateFormat('MMM yyyy').format(tempDate);
    String tgl = convertHari(hari) + ', ' + tanggal + ' ' + bulantahun;

    return Card(
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
                      tgl,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
              ),
              statusCutiWidget(colorStatus, datang_pulang.toUpperCase()),
            ],
          ),
          Divider(height: 1),
          Container(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  rowWidget("JAM ABSEN", jam_absen),
                  rowWidget("LOKASI", lokasi),
                  rowWidget("ON", wfhWfo.toUpperCase())
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget statusCutiWidget(colorStatus, statusCuti) {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        decoration: BoxDecoration(
          color: colorStatus,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(0),
              bottomRight: Radius.circular(0),
              topLeft: Radius.circular(0),
              bottomLeft: Radius.circular(10)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Container(
            width: 50,
            child: Center(
              child: Text(
                statusCuti,
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
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
