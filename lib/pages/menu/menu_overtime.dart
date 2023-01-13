// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/api/api_service.dart';
import 'package:flutter_application_1/pages/general_widget/widget_no_data.dart';
import 'package:flutter_application_1/pages/overtime/overtime_request.dart';
import 'package:flutter_application_1/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../../models/absen/return.dart';
import '../general_widget/widget_snackbar.dart';
import '../absen/absen_listbulan.dart';

class MenuOvertime extends StatefulWidget {
  @override
  _MenuOvertimeState createState() => _MenuOvertimeState();
}

class _MenuOvertimeState extends State<MenuOvertime>
    with SingleTickerProviderStateMixin {
  bool loading = false;
  bool failed = false;
  bool loadingSubmit = false;
  bool failedSubmit = false;
  String remakrs = '';
  bool loadingApp = false;
  bool failedApp = false;
  bool loadingSubmitApp = false;
  bool failedSubmitApp = false;
  String remakrsApp = '';
  List<dynamic> dataOvertimePending = [];
  List<dynamic> dataOvertimeRiwayat = [];
  List<dynamic> dataOvertimeApproval = [];
  List<dynamic> listBulan = [];
  String tahunBulan = '';
  String tahunBulanText = '';
  String status = 'PENDING';
  List<TipeLembur> listStatus = [];
  TextEditingController controllerKeterangan = TextEditingController();
  String jamDari = 'HH:ii';
  String jamSampai = 'HH:ii';
  String badgeLembur = '0';

  DevService _devService = DevService();

  Future getData() async {
    DateTime now = await NTP.now();
    String month = DateFormat('MM').format(now);
    String monthText = DateFormat('MMMM').format(now);
    String year = DateFormat('y').format(now);
    setState(() {
      loading = true;
      failed = false;
      remakrs = '';
      listStatus.add(new TipeLembur(selected: '1', value: 'PENDING'));
      listStatus.add(new TipeLembur(selected: '0', value: 'APPROVE'));
      listStatus.add(new TipeLembur(selected: '0', value: 'REJECT'));
      tahunBulan = year + '' + month;
      tahunBulanText = monthText + ' ' + year;
    });
    getPending();
    getApproval();
  }

  void changeTipeLembur(String value) {
    for (var element in listStatus) {
      TipeLembur tile =
          listStatus.firstWhere((item) => item.value == element.value);
      setState(() => tile.selected = "0");
    }
    TipeLembur tile = listStatus.firstWhere((item) => item.value == value);
    setState(() => tile.selected = "1");
    setState(() {
      status = value;
      listStatus = listStatus;
    });
    getApproval();
  }

  void getPending() async {
    if (mounted) ToastContext().init(context);
    setState(() {
      loading = true;
      failed = false;
      dataOvertimePending.clear();
      dataOvertimeRiwayat.clear();
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    var accesToken = pref.getString("PREF_TOKEN")!;
    badgeLembur = pref.getString("PREF_LEMBUR")!;
    _devService.listOvertime(accesToken).then((value) async {
      var res = json.decode(value);
      if (res['status_json'] == true) {
        setState(() {
          loading = false;
          failed = false;
          for (var element in res['overtime_pending']) {
            var status = element['status'].toString();
            if (status == 'null' || status == '0') {
              dataOvertimePending.add(element);
            } else {
              dataOvertimeRiwayat.add(element);
            }
          }
        });
      } else {
        setState(() {
          loading = false;
          failed = true;
          remakrs = res['remarks'];
        });
        Toast.show(res['remarks'], duration: 4, gravity: Toast.bottom);
      }
    }).catchError((Object obj) {
      if (mounted) {
        setState(() {
          loading = false;
          failed = true;
          remakrs = "Gagal menyambungkan ke server";
        });
        Toast.show("Gagal menyambungkan ke server",
            duration: 4, gravity: Toast.bottom);
      }
    });
  }

  void getApproval() async {
    if (mounted) ToastContext().init(context);
    setState(() {
      loadingApp = true;
      failedApp = false;
      dataOvertimeApproval.clear();
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    var accesToken = pref.getString("PREF_TOKEN")!;
    String statusPost = '0';
    if (status == 'APPROVE') {
      statusPost = '1';
    } else if (status == 'REJECT') {
      statusPost = '2';
    }
    _devService
        .listOvertimeApproval(accesToken, tahunBulan, statusPost)
        .then((value) async {
      var res = json.decode(value);
      if (res['status_json'] == true) {
        setState(() {
          loadingApp = false;
          failedApp = false;
          dataOvertimeApproval = res['overtime_approval'];
          listBulan = res['overtime_bulan'];
        });
      } else {
        setState(() {
          loadingApp = false;
          failedApp = true;
          remakrsApp = res['remarks'];
        });
        Toast.show(res['remarks'], duration: 4, gravity: Toast.bottom);
      }
    }).catchError((Object obj) {
      if (mounted)
        setState(() {
          loadingApp = false;
          failedApp = true;
          remakrsApp = "Gagal menyambungkan ke server";
        });
      if (mounted) ToastContext().init(context);
      Toast.show("Gagal menyambungkan ke server",
          duration: 4, gravity: Toast.bottom);
    });
  }

  void dismisKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  Widget jamPicker(dariSampai, String jam, setState) {
    setState(() {
      if (dariSampai == 'dari') {
        jamDari = jam;
      } else {
        jamSampai = jam;
      }
    });
    return Padding(
      padding: EdgeInsets.only(bottom: 4),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.3,
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
          child: GestureDetector(
            onTap: () {
              DateTime now = DateFormat("hh:mm").parse(jam.toString());
              dismisKeyboard();
              showCupertinoModalPopup(
                  context: context,
                  builder: (BuildContext builder) {
                    return Container(
                      height: 200,
                      color: Colors.white,
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.time,
                        use24hFormat: true,
                        initialDateTime: now,
                        onDateTimeChanged: (value) {
                          DateTime tempDate = DateFormat("yyyy-MM-dd hh:mm:ss")
                              .parse(value.toString());
                          String jamSelected =
                              DateFormat('HH:mm').format(tempDate);
                          setState(() {
                            if (dariSampai == 'dari') {
                              jamDari = jamSelected;
                            } else {
                              jamSampai = jamSelected;
                            }
                          });
                        },
                      ),
                    );
                  });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: Text(dariSampai == 'dari' ? jamDari : jamSampai)),
                Icon(
                  Icons.timer,
                  color: ColorsTheme.primary1,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context, int id, String status, String pJamDari,
      String pJamSampai) {
    setState(() {
      controllerKeterangan.text = '';
    });

    String textStatus = 'APPROVE';
    Color colorStatus = ColorsTheme.hijau;
    if (status == '2') {
      colorStatus = ColorsTheme.merah;
      textStatus = 'REJECT';
    }

    Widget submitButton = Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            onPressed: () async {
              if (!loading) {
                if (mounted) ToastContext().init(context);
                dismisKeyboard();
                if (controllerKeterangan.text == '' && status == '2') {
                  Toast.show("Harap isi keterangan",
                      duration: 4, gravity: Toast.bottom);
                } else {
                  submitApp(id, status, controllerKeterangan.text);
                }
              }
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(colorStatus),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
              child: Text(
                loadingSubmitApp ? "Menyimpan data.." : textStatus,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ));

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                children: [
                  Expanded(child: Text(textStatus)),
                  IconButton(
                    icon: Icon(Icons.close),
                    color: Colors.grey,
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Anda Yakin akan ${textStatus} Lembur ini?",
                    style: TextStyle(fontSize: 12),
                  ),
                  SizedBox(height: 8),
                  Container(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          jamPicker('dari', pJamDari, setState),
                          // Text("s/d"),
                          jamPicker('sampai', pJamSampai, setState)
                        ]),
                  ),
                  Container(
                    height: 100,
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
                      child: TextFormField(
                        controller: controllerKeterangan,
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 10,
                        decoration:
                            InputDecoration.collapsed(hintText: 'Keterangan'),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [submitButton],
            );
          },
        );
      },
    );
  }

  showAlertDialogHapus(BuildContext context, int id) {
    setState(() {
      controllerKeterangan.text = '';
    });
    String textStatus = 'HAPUS';
    Color colorStatus = ColorsTheme.merah;

    Widget submitButton = Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            onPressed: () async {
              if (!loading) {
                if (mounted) ToastContext().init(context);
                dismisKeyboard();
                submitHapus(id);
              }
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(colorStatus),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
              child: Text(
                loadingSubmitApp ? "Menghapus data.." : textStatus,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ));

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Row(
        children: [
          Expanded(child: Text(textStatus)),
          IconButton(
            icon: Icon(Icons.close),
            color: Colors.grey,
            onPressed: () async {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Anda Yakin akan ${textStatus} Lembur ini?",
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
      actions: [submitButton],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  submitHapus(id) async {
    if (mounted) ToastContext().init(context);
    setState(() {
      loadingSubmitApp = true;
      failedSubmitApp = false;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    var accesToken = pref.getString("PREF_TOKEN")!;
    _devService.appDelOvertime(accesToken, id).then((value) async {
      var res = json.decode(value);
      if (res['status_json'] == true) {
        setState(() {
          loadingSubmitApp = false;
          failedSubmitApp = false;
          dismisKeyboard();
          Navigator.pop(context);
          WidgetSnackbar(
              context: context, message: res['remarks'], warna: "hijau");
          getPending();
        });
      } else {
        setState(() {
          loadingSubmitApp = false;
          failedSubmitApp = true;
        });
        Toast.show(res['remarks'], duration: 4, gravity: Toast.bottom);
      }
    }).catchError((Object obj) {
      if (mounted)
        setState(() {
          loadingSubmitApp = false;
          failedSubmitApp = true;
          remakrs = "Gagal menyambungkan ke server";
        });
      Toast.show("Gagal menyambungkan ke server",
          duration: 4, gravity: Toast.bottom);
    });
  }

  void submitApp(int id, String status, String keterangan) async {
    if (mounted) ToastContext().init(context);
    setState(() {
      loadingSubmitApp = true;
      failedSubmitApp = false;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    var accesToken = pref.getString("PREF_TOKEN")!;
    _devService
        .appRejOvertime(
            accesToken, id, int.parse(status), keterangan, jamDari, jamSampai)
        .then((value) async {
      var res = json.decode(value);
      if (res['status_json'] == true) {
        setState(() {
          loadingSubmitApp = false;
          failedSubmitApp = false;
          dismisKeyboard();
          Navigator.pop(context);
          WidgetSnackbar(
              context: context, message: res['remarks'], warna: "hijau");
          getData();
        });
      } else {
        setState(() {
          loadingSubmitApp = false;
          failedSubmitApp = true;
        });
        Toast.show(res['remarks'], duration: 4, gravity: Toast.bottom);
      }
    }).catchError((Object obj) {
      if (mounted)
        setState(() {
          loadingSubmitApp = false;
          failedSubmitApp = true;
          remakrs = "Gagal menyambungkan ke server";
        });
      Toast.show("Gagal menyambungkan ke server",
          duration: 4, gravity: Toast.bottom);
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
          title: Text("Lembur"),
          elevation: 0,
          backgroundColor: ColorsTheme.primary1,
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              color: Colors.white,
              onPressed: () async {
                final result = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => OvertimeRequest()));
                if (result != null) {
                  getData();
                }
              },
            ),
          ],
        ),
        body: loading
            ? Center(child: Text("Loading Page.."))
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
                              showBadge: badgeLembur == '0' ? false : true,
                              padding: EdgeInsets.all(
                                  badgeLembur.length == 1 ? 5 : 4),
                              position: BadgePosition.topEnd(top: 0.001),
                              badgeColor: Colors.red,
                              badgeContent: Text(
                                badgeLembur,
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
                        loading
                            ? Center(child: Text("Loading Page.."))
                            : listOvertime(dataOvertimePending, 'overtime'),
                        loading
                            ? Center(child: Text("Loading Page.."))
                            : listOvertime(dataOvertimeRiwayat, 'overtime'),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.04,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: 3,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          TipeLembur item = listStatus[index];
                                          return Padding(
                                            padding: EdgeInsets.all(2),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                String value = item.value!;
                                                changeTipeLembur(value);
                                              },
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(item
                                                                  .selected ==
                                                              '1'
                                                          ? ColorsTheme.primary1
                                                          : ColorsTheme.grey),
                                                  shape: MaterialStateProperty
                                                      .all<RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ))),
                                              child: Text(
                                                item.value!.toUpperCase(),
                                                style: TextStyle(
                                                    color: item.selected == '1'
                                                        ? Colors.white
                                                        : ColorsTheme.primary1,
                                                    fontSize: 8),
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  child: GestureDetector(
                                    onTap: () async {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AbsenListBulan(
                                                  dataList: listBulan,
                                                )),
                                      );
                                      setState(() {
                                        if (result != null) {
                                          tahunBulan =
                                              result['bulanKey'].toString();
                                          tahunBulanText =
                                              result['bulanText'].toString();
                                          getApproval();
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                                child: Text(
                                              tahunBulanText,
                                              style: TextStyle(fontSize: 10),
                                            )),
                                            Icon(Icons.arrow_drop_down)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Expanded(
                              child: loadingApp
                                  ? Center(child: Text("Loading Page.."))
                                  : listOvertime(
                                      dataOvertimeApproval, 'approval'),
                            ),
                          ],
                        ),
                      ]),
                    ),
                  ],
                ),
              ));
  }

  Widget listOvertime(data, type) {
    return data.length == 0
        ? WidgetNoData()
        : ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: data.length,
            itemBuilder: (context, index) {
              var dt = data[index];
              return type == 'approval' ? cardApproval(context, dt) : card(dt);
            });
  }

  Widget cardApproval(BuildContext context, data) {
    Color colorStatus = ColorsTheme.biru;
    var tgl_lembur = data['tgl_lembur'].toString();
    var jam_mulai = data['jam_mulai'].toString();
    var jam_akhir = data['jam_akhir'].toString();
    var tipe_lembur = data['tipe_lembur'].toString();
    var status = data['status'].toString();
    var first_name = data['first_name'].toString();
    var staff_id = data['staff_id'].toString();
    var id = data['id'].toString();
    var create_at = data['created_at'].toString();
    var ket = data['ket'].toString();
    var keterangan_approvereject = data['keterangan_approvereject'].toString();

    var statusOvertime = '';
    if (status == 'null' || status == '0') {
      colorStatus = ColorsTheme.kuning;
      statusOvertime = 'Pending';
    } else if (status == '1') {
      colorStatus = ColorsTheme.hijau;
      statusOvertime = 'Approved';
    } else {
      statusOvertime = 'Rejected';
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
                          "ID ${id}\n" +
                              first_name.toUpperCase() +
                              ' (' +
                              staff_id +
                              ')',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(tgl_lembur,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: ColorsTheme.merah))
                      ],
                    )),
              ),
              statusCutiWidget(colorStatus, statusOvertime),
            ],
          ),
          Divider(height: 1),
          Container(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  rowWidget("ID OVERTIME", id),
                  rowWidget("TIPE", tipe_lembur.toUpperCase()),
                  rowWidget("WAKTU PENGAJUAN", create_at),
                  rowWidget("JAM LEMBUR", jam_mulai + ' s/d ' + jam_akhir),
                  rowWidget("KEPERLUAN", ket),
                  statusOvertime == 'Pending'
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: ElevatedButton(
                                onPressed: () async {
                                  showAlertDialog(context, int.parse(id), '2',
                                      jam_mulai, jam_akhir);
                                },
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            ColorsTheme.merah),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ))),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 0),
                                  child: Text(
                                    "REJECT",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 4),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  showAlertDialog(context, int.parse(id), '1',
                                      jam_mulai, jam_akhir);
                                },
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            ColorsTheme.hijau),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ))),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 0),
                                  child: Text(
                                    "APPROVE",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  statusOvertime != 'Pending'
                      ? rowWidget(
                          "KETERANGAN", keterangan_approvereject.toUpperCase())
                      : Container()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget card(data) {
    Color colorStatus = ColorsTheme.biru;
    var tgl_lembur = data['tgl_lembur'].toString();
    var jam_mulai = data['jam_mulai'].toString();
    var jam_akhir = data['jam_akhir'].toString();
    var tipe_lembur = data['tipe_lembur'].toString();
    var status = data['status'].toString();
    var first_name = data['first_name'].toString();
    var staff_id = data['staff_id'].toString();
    var id = data['id'].toString();
    var create_at = data['created_at'].toString();
    var ket = data['ket'].toString();
    var keterangan_approvereject = data['keterangan_approvereject'].toString();
    var statusOvertime = '';
    if (status == 'null' || status == '0') {
      colorStatus = ColorsTheme.kuning;
      statusOvertime = 'Pending';
    } else if (status == '1') {
      colorStatus = ColorsTheme.hijau;
      statusOvertime = 'Approved';
    } else {
      statusOvertime = 'Rejected';
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
                      "ID ${id} : " + ket.toUpperCase() + '\n' + tgl_lembur,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
              ),
              statusCutiWidget(colorStatus, statusOvertime),
            ],
          ),
          Divider(height: 1),
          Container(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  rowWidget("ID OVERTIME", id),
                  rowWidget("TIPE", tipe_lembur.toUpperCase()),
                  rowWidget("WAKTU PENGAJUAN", create_at),
                  rowWidget("JAM LEMBUR", jam_mulai + ' s/d ' + jam_akhir),
                  rowWidget("KEPERLUAN", ket),
                  statusOvertime != 'Pending'
                      ? rowWidget(
                          "KETERANGAN", keterangan_approvereject.toUpperCase())
                      : Container(),
                  statusOvertime == 'Pending'
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.03,
                          child: ElevatedButton(
                            onPressed: () async {
                              showAlertDialogHapus(context, int.parse(id));
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        ColorsTheme.merah),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 0),
                              child: Text(
                                "HAPUS",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ),
                          ),
                        )
                      : Container()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

Widget statusCutiWidget(colorStatus, statusOvertime) {
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
          statusOvertime,
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
