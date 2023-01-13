// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/api/api_service.dart';
import 'package:flutter_application_1/pages/cuti/cuti_approval.dart';
import 'package:flutter_application_1/pages/cuti/cuti_request.dart';
import 'package:flutter_application_1/pages/general_widget/widget_no_data.dart';
import 'package:flutter_application_1/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuCuti extends StatefulWidget {
  @override
  _MenuCutiState createState() => _MenuCutiState();
}

class _MenuCutiState extends State<MenuCuti>
    with SingleTickerProviderStateMixin {
  bool loading = true;
  bool failed = false;
  String remakrs = '';
  List<dynamic> dataCutiPending = [];
  List<dynamic> dataCutiRiwayat = [];
  List<dynamic> dataCutiApproval = [];
  List<dynamic> dataCutiApprovalPending = [];

  DevService _devService = DevService();
  int jumlahKuota = 0;
  String jumlahKuotaString = '';
  String tahunBulan = '';
  String tahunBulanText = '';

  Future getData() async {
    DateTime now = await NTP.now();
    String month = DateFormat('MM').format(now);
    String monthText = DateFormat('MMMM').format(now);
    String year = DateFormat('y').format(now);
    getPending();
  }

  void getPending() async {
    setState(() {
      loading = true;
      failed = false;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    var accesToken = pref.getString("PREF_TOKEN")!;
    _devService.listCuti(accesToken).then((value) async {
      var res = json.decode(value);
      if (res['status_json'] == true) {
        setState(() {
          jumlahKuotaString = res['kuota'];
          jumlahKuota = res['jumlah_kuota'];
          loading = false;
          failed = false;
          for (var element in res['cuti_pending']) {
            var statusCuti = element['statuscuti'].toString();

            if (statusCuti == 'null' || statusCuti == '0') {
              dataCutiPending.add(element);
            } else {
              dataCutiRiwayat.add(element);
            }
          }
          for (var element in res['cuti_approval']) {
            var jeniscuti = element['jeniscuti'].toString();
            if (jeniscuti != 'null') {
              dataCutiApproval.add(element);
            }
            if (element['status'].toString() == 'null' ||
                element['status'].toString() == '0') {
              dataCutiApprovalPending.add(element);
            }
          }
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
          title: Text("Cuti"),
          elevation: 0,
          backgroundColor: ColorsTheme.primary1,
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              color: Colors.white,
              onPressed: () async {
                final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CutiRequest(
                              jumlahKuota: jumlahKuota,
                              jumlahKuotaString: jumlahKuotaString,
                            )));
                if (result != null) {
                  getData();
                }
              },
            ),
          ],
        ),
        body: loading
            ? Center(child: Text("Loading Page .."))
            : DefaultTabController(
                length: 3,
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      child: TabBar(
                        tabs: [
                          Tab(text: "Pending"),
                          Tab(text: "Riwayat"),
                          Badge(
                              showBadge: dataCutiApprovalPending.length == 0
                                  ? false
                                  : true,
                              padding: EdgeInsets.all(dataCutiApprovalPending
                                          .length
                                          .toString()
                                          .length ==
                                      1
                                  ? 5
                                  : 4),
                              position: BadgePosition.topEnd(top: 0.001),
                              badgeColor: Colors.red,
                              badgeContent: Text(
                                dataCutiApprovalPending.length.toString(),
                                style:
                                    TextStyle(color: Colors.white, fontSize: 8),
                              ),
                              child: Tab(text: "Approval")),
                        ],
                        labelColor: ColorsTheme.primary1,
                      ),
                    ),
                    Expanded(
                      child: TabBarView(children: [
                        listCuti(dataCutiPending, 'cuti'),
                        listCuti(dataCutiRiwayat, 'cuti'),
                        listCuti(dataCutiApproval, 'approval'),
                      ]),
                    ),
                  ],
                ),
              ));
  }

  Widget listCuti(data, type) {
    return data.length == 0
        ? WidgetNoData()
        : ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: data.length,
            itemBuilder: (context, index) {
              var dt = data[index];
              return type == 'approval'
                  ? GestureDetector(
                      onTap: () async {
                        var statusCuti = dt['statuscuti'].toString();
                        if (statusCuti == 'null' || statusCuti == '0') {
                          final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CutiApproval(
                                        id: dt['id'],
                                        staffId: dt['staff_id'],
                                      )));
                          if (result != null) {
                            getData();
                          }
                        }
                      },
                      child: cardApproval(dt),
                    )
                  : card(dt);
            });
  }
}

Widget cardApproval(data) {
  Color colorStatus = ColorsTheme.biru;
  var leavetype = data['jeniscuti'].toString();
  var kategori = data['kategori'].toString();
  var statusCuti = data['statuscuti'].toString();
  var id = data['id'].toString();
  var first_name = data['first_name'].toString();
  var staff_id = data['staff_id'].toString();
  var tanggalcuti = data['tanggalcuti'].toString();
  var create_at = data['create_at'].toString();
  var ket = data['ket'].toString();
  final totalCuti = tanggalcuti.split(',');

  if (statusCuti == 'null' || statusCuti == '0') {
    colorStatus = ColorsTheme.kuning;
    statusCuti = 'Pending';
  } else if (statusCuti == '1') {
    colorStatus = ColorsTheme.hijau;
    statusCuti = 'Approved';
  } else {
    statusCuti = 'Rejected';
    colorStatus = ColorsTheme.merah;
  }

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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ID ${id} : " +
                            first_name.toUpperCase() +
                            ' (' +
                            staff_id +
                            ')',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(totalCuti.length.toString() + ' Hari',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: ColorsTheme.merah))
                    ],
                  )),
            ),
            statusCutiWidget(colorStatus, statusCuti),
          ],
        ),
        Divider(height: 1),
        Container(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                rowWidget("ID CUTI", id),
                rowWidget("TIPE", kategori + " (" + leavetype + ")"),
                rowWidget("WAKTU PENGAJUAN", create_at),
                rowWidget("PERMINTAAN CUTI", tanggalcuti),
                rowWidget("KEPERLUAN", ket),
              ],
            ),
          ),
        )
      ],
    ),
  );
}

Widget card(data) {
  var id = data['id'].toString();
  var statusCuti = data['statuscuti'].toString();
  var status = data['status'].toString();
  var ket = data['ket'].toString();
  var waktu_pengajuan = data['create_at'].toString();
  var kategori = data['kategori'].toString();
  var leavetype = data['leavetype'].toString();
  var tanggalcuti = data['tanggalcuti'].toString();
  var namaatasan = data['namaatasan'].toString();

  Color colorStatus = ColorsTheme.biru;
  if (statusCuti == 'null' || statusCuti == '0') {
    colorStatus = ColorsTheme.kuning;
    statusCuti = 'Pending';
  } else if (statusCuti == '1') {
    colorStatus = ColorsTheme.hijau;
    statusCuti = 'Approved';
  } else {
    statusCuti = 'Rejected';
    colorStatus = ColorsTheme.merah;
  }

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
                    "ID ${id} : " + ket.toUpperCase(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
            ),
            statusCutiWidget(colorStatus, statusCuti),
          ],
        ),
        Divider(),
        Container(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                rowWidget("TIPE", kategori + " (" + leavetype + ")"),
                rowWidget("WAKTU PENGAJUAN", waktu_pengajuan),
                rowWidget("WAKTU CUTI", tanggalcuti),
                rowWidget("STATUS", status),
                statusCuti != 'Pending'
                    ? rowWidget("ATASAN", namaatasan.toUpperCase())
                    : Container()
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
        child: Text(
          statusCuti,
          style: TextStyle(color: Colors.white, fontSize: 10),
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
        Container(width: 150, child: Text(key, style: TextStyle(fontSize: 11))),
        Text(": ", style: TextStyle(fontSize: 11)),
        Expanded(
            child: Html(
          data: value,
          style: {
            "body": Style(
                fontSize: FontSize(11),
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero),
          },
        )),
      ],
    ),
  );
}
