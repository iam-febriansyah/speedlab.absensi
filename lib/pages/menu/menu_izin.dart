// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/api/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/general_widget/widget_no_data.dart';
import 'package:flutter_application_1/pages/izin/izin_approval.dart';
import 'package:flutter_application_1/pages/izin/izin_request.dart';
import 'package:flutter_application_1/style/colors.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuIzin extends StatefulWidget {
  @override
  _MenuIzinState createState() => _MenuIzinState();
}

class _MenuIzinState extends State<MenuIzin>
    with SingleTickerProviderStateMixin {
  bool loading = true;
  bool failed = false;
  String remakrs = '';
  List<dynamic> dataIzinPending = [];
  List<dynamic> dataIzinRiwayat = [];
  List<dynamic> dataIzinApproval = [];
  List<dynamic> dataIzinApprovalPending = [];

  DevService _devService = DevService();
  String tahunBulan = '';
  String tahunBulanText = '';

  Future getData() async {
    DateTime now = await NTP.now();
    String month = DateFormat('MM').format(now);
    String monthText = DateFormat('MMMM').format(now);
    String year = DateFormat('y').format(now);
    await getPending();
  }

  Future getPending() async {
    setState(() {
      loading = true;
      failed = false;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    var accesToken = pref.getString("PREF_TOKEN")!;
    _devService.listIzin(accesToken).then((value) async {
      var res = json.decode(value);
      if (res['status_json'] == true) {
        setState(() {
          dataIzinPending.clear();
          dataIzinApproval.clear();
          loading = false;
          failed = false;
          for (var element in res['izin_data']) {
            var status = element['status'].toString();

            if (status == 'null' || status == '0') {
              dataIzinPending.add(element);
            } else {
              dataIzinRiwayat.add(element);
            }
          }
          for (var element in res['izin_approval']) {
            if (element['status'].toString() == 'null' ||
                element['status'].toString() == '0') {
              dataIzinApprovalPending.add(element);
            }
            dataIzinApproval.add(element);
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
          title: Text("Izin"),
          elevation: 0,
          backgroundColor: ColorsTheme.primary1,
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              color: Colors.white,
              onPressed: () async {
                final result = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => IzinRequest()));
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
                              showBadge: dataIzinApprovalPending.length == 0
                                  ? false
                                  : true,
                              padding: EdgeInsets.all(dataIzinApprovalPending
                                          .length
                                          .toString()
                                          .length ==
                                      1
                                  ? 5
                                  : 4),
                              position: BadgePosition.topEnd(top: 0.001),
                              badgeColor: Colors.red,
                              badgeContent: Text(
                                dataIzinApprovalPending.length.toString(),
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
                        listIzin(dataIzinPending, 'izin'),
                        listIzin(dataIzinRiwayat, 'izin'),
                        listIzin(dataIzinApproval, 'approval'),
                      ]),
                    ),
                  ],
                ),
              ));
  }

  Widget listIzin(data, type) {
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
                        var status = dt['status'].toString();
                        if (status == 'null' || status == '0') {
                          final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => IzinApproval(
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
  var izin = data['izin'].toString();
  var status = data['status'].toString();
  var id = data['id'].toString();
  var first_name = data['first_name'].toString();
  var staff_id = data['staff_id'].toString();
  var tanggal = data['tanggal'].toString();
  var mulaiJam = data['mulai_jam'].toString();
  var create_at = data['created_at'].toString();
  var ket = data['keterangan'].toString();

  if (status == 'null' || status == '0') {
    colorStatus = ColorsTheme.kuning;
    status = 'Pending';
  } else if (status == '1') {
    colorStatus = ColorsTheme.hijau;
    status = 'Approved';
  } else {
    status = 'Rejected';
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
                    ],
                  )),
            ),
            statusWidget(colorStatus, status),
          ],
        ),
        Divider(height: 1),
        Container(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                rowWidget("ID IZIN", id),
                rowWidget("IZIN", izin),
                rowWidget("WAKTU PENGAJUAN", create_at),
                rowWidget("PERMINTAAN IZIN", tanggal + " " + mulaiJam),
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
  var izin = data['izin'].toString();
  var status = data['status'].toString();
  var id = data['id'].toString();
  var tanggal = data['tanggal'].toString();
  var mulaiJam = data['mulai_jam'].toString();
  var create_at = data['created_at'].toString();
  var ket = data['keterangan'].toString();
  var apprejName = data['apprejName'].toString();
  var apprejAt = data['app_rej_at'].toString();

  Color colorStatus = ColorsTheme.biru;
  if (status == 'null' || status == '0') {
    colorStatus = ColorsTheme.kuning;
    status = 'Pending';
  } else if (status == '1') {
    colorStatus = ColorsTheme.hijau;
    status = 'Approved';
  } else {
    status = 'Rejected';
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
                    "ID ${id} : " + izin.toUpperCase(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
            ),
            statusWidget(colorStatus, status),
          ],
        ),
        Divider(),
        Container(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                rowWidget("KEPERLUAN", ket),
                rowWidget("WAKTU PENGAJUAN", create_at),
                rowWidget("WAKTU IZIN", tanggal + ' ' + mulaiJam),
                rowWidget("STATUS", status),
                status != 'Pending'
                    ? rowWidget("ATASAN", apprejName.toUpperCase())
                    : Container()
              ],
            ),
          ),
        )
      ],
    ),
  );
}

Widget statusWidget(colorStatus, status) {
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
          status,
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
