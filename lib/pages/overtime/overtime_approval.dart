import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../../api/api_service.dart';
import '../../models/absen/return.dart';
import '../../style/colors.dart';
import '../general_widget/widget_snackbar.dart';

class CutiApproval extends StatefulWidget {
  final int id;
  final String staffId;

  const CutiApproval({Key? key, required this.id, required this.staffId})
      : super(key: key);

  @override
  State<CutiApproval> createState() => _CutiApprovalState();
}

class _CutiApprovalState extends State<CutiApproval> {
  DevService _devService = DevService();
  bool loading = false;
  bool failed = false;
  bool loadingSubmit = false;
  bool failedSubmit = false;
  String remakrs = '';

  int jumlahKuota = 0;
  String jumlahKuotaString = '';
  String namaKaryawan = '';
  String staffID = '';
  List<Widget> widgetTanggal = [];
  List<TanggalCuti> itemTanggal = [];
  dynamic dataCuti;
  String deleteAll = '0';

  TextEditingController controllerCatatan = TextEditingController();

  void getData() async {
    setState(() {
      loading = true;
      failed = false;
      remakrs = '';
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    var accesToken = pref.getString("PREF_TOKEN")!;
    _devService
        .singleCuti(accesToken, widget.id, widget.staffId)
        .then((value) async {
      var res = json.decode(value);
      if (res['status_json'] == true) {
        dismisKeyboard();
        setState(() {
          jumlahKuota = res['jumlah_kuota'];
          jumlahKuotaString = res['kuota'];
          namaKaryawan = res['data_cuti']['first_name'];
          staffID = res['data_cuti']['staff_id'];
          dataCuti = res['data_cuti'];
          for (var element in res['data_cuti_tanggal']) {
            itemTanggal.add(new TanggalCuti(
                id: element['id'].toString(),
                value: element['tanggalcuti'],
                delete: "0"));
          }
          generateWidget(itemTanggal);
        });
        loading = false;
        failed = false;
        remakrs = '';
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
    setState(() {});
  }

  void submit(int status) {
    if (mounted) ToastContext().init(context);
    List<TanggalCuti> tanggals =
        itemTanggal.where((element) => element.delete == '1').toList();
    if (tanggals.length > jumlahKuota) {
      Toast.show("Maksimal Cuti adalah " + jumlahKuota.toString(),
          duration: 4, gravity: Toast.bottom);
    } else {
      if (status == -1 && tanggals.length > 0) {
        Toast.show(
            "Mohon Uncheck terlebih dahulu tanggal yg di approve jika anda akan me-Reject Permintaan Cuti",
            duration: 4,
            gravity: Toast.bottom);
      } else if (status == 1 && tanggals.length <= 0) {
        Toast.show("Minimial tanggal yg di approve adalah 1",
            duration: 4, gravity: Toast.bottom);
      } else if (controllerCatatan.text == '') {
        Toast.show("Mohon isi catatan", duration: 4, gravity: Toast.bottom);
      } else {
        pushData(status);
      }
    }
  }

  Future pushData(int status) async {
    List<TanggalCuti> tanggalPost = itemTanggal;
    setState(() {
      loadingSubmit = true;
      failedSubmit = false;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    var accesToken = pref.getString("PREF_TOKEN")!;
    _devService
        .appRejCuti(
            accesToken, widget.id, status, tanggalPost, controllerCatatan.text)
        .then((value) async {
      var res = json.decode(value);
      if (res['status_json'] == true) {
        dismisKeyboard();
        Navigator.pop(context, "GETDATA");
        WidgetSnackbar(
            context: context, message: res['remarks'], warna: "hijau");
      } else {
        if (mounted) ToastContext().init(context);
        setState(() {
          loadingSubmit = false;
          failedSubmit = true;
        });
        Toast.show(res['remarks'], duration: 4, gravity: Toast.bottom);
      }
    }).catchError((Object obj) {
      if (mounted)
        setState(() {
          loadingSubmit = false;
          failedSubmit = true;
        });

      if (mounted) ToastContext().init(context);
      Toast.show("Gagal menyambungkan ke server",
          duration: 4, gravity: Toast.bottom);
    });
  }

  void dismisKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: ColorsTheme.primary1));

    return Scaffold(
      appBar: AppBar(
        title: Text("Approval Cuti"),
        elevation: 0,
        backgroundColor: ColorsTheme.primary1,
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onTap: () {
            dismisKeyboard();
            Navigator.pop(context);
          },
        ),
      ),
      body: loading
          ? Center(child: Text("Loading Page .."))
          : SingleChildScrollView(
              child: Column(
              children: [
                jumlahKuotaCard(
                    namaKaryawan.toUpperCase() + " (" + staffID + ")",
                    jumlahKuotaString),
                pageRequest(context),
              ],
            )),
    );
  }

  Widget pageRequest(BuildContext context) {
    return Card(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  "FORM APPROVAL CUTI",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: ColorsTheme.primary1),
                )),
            Divider(),
            Padding(
              padding: EdgeInsets.only(bottom: 4, left: 8, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: 150,
                      child: Text("TIPE CUTI", style: TextStyle(fontSize: 14))),
                  Expanded(
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
                        child: Text(dataCuti['leavetype'] +
                            ' (' +
                            dataCuti['kategori'] +
                            ')'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 4),
            Padding(
              padding: EdgeInsets.only(bottom: 4, left: 8, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: 150,
                      child: Text("KEPERLUAN", style: TextStyle(fontSize: 14))),
                  Expanded(
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
                        child: Text(dataCuti['ket']),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.only(bottom: 4, left: 8, right: 8),
              child: Row(
                children: [
                  Expanded(
                      child:
                          Text("TANGGAL CUTI", style: TextStyle(fontSize: 14))),
                  SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      String paramDeleteAll = '1';
                      if (deleteAll == '1') {
                        paramDeleteAll = '0';
                      }
                      setState(() {
                        if (deleteAll == '1') {
                          deleteAll = '0';
                        } else {
                          deleteAll = '1';
                        }
                      });
                      removeTanggalAll(paramDeleteAll);
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
                        child: deleteAll == '0'
                            ? Icon(
                                Icons.square,
                                color: Colors.white,
                              )
                            : Icon(
                                Icons.check,
                                color: ColorsTheme.hijau,
                              ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              child: Column(children: widgetTanggal),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.only(bottom: 4, left: 8, right: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("CATATAN", style: TextStyle(fontSize: 14)),
                  SizedBox(height: 8),
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
                        controller: controllerCatatan,
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        decoration:
                            InputDecoration.collapsed(hintText: 'Tulis ...'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 4, left: 8, right: 8),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (!loadingSubmit) {
                            if (mounted) ToastContext().init(context);
                            dismisKeyboard();
                            if (jumlahKuota <= 0) {
                              Toast.show("Kuota Cuti Tidak Ada",
                                  duration: 4, gravity: Toast.bottom);
                            } else {
                              submit(-1);
                            }
                          }
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                jumlahKuota <= 0
                                    ? ColorsTheme.background3
                                    : ColorsTheme.merah),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 0),
                          child: Text(
                            loadingSubmit ? "Loading.." : "REJECT",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (!loadingSubmit) {
                            if (mounted) ToastContext().init(context);
                            dismisKeyboard();
                            if (jumlahKuota <= 0) {
                              Toast.show("Kuota Cuti Tidak Ada",
                                  duration: 4, gravity: Toast.bottom);
                            } else {
                              submit(1);
                            }
                          }
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                jumlahKuota <= 0
                                    ? ColorsTheme.background3
                                    : ColorsTheme.primary1),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 0),
                          child: Text(
                            loadingSubmit ? "Loading.." : "APPROVE",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void removeTanggal(TanggalCuti param, String delete) {
    TanggalCuti tile = itemTanggal.firstWhere((item) => item.id == param.id);
    setState(() => tile.delete = delete);
    setState(() {
      generateWidget(itemTanggal);
    });
  }

  void removeTanggalAll(String delete) {
    for (var i in itemTanggal) {
      final changeToAll = itemTanggal.firstWhere((item) => item.id == i.id);
      changeToAll.delete = delete;
    }
    setState(() {
      generateWidget(itemTanggal);
    });
  }

  void generateWidget(List<TanggalCuti> tanggals) {
    widgetTanggal.clear();
    for (var i = 0; i < tanggals.length; i++) {
      String paramDelete = '1';
      String delete = tanggals[i].delete!;
      if (delete == '1') {
        paramDelete = '0';
      }
      widgetTanggal.add(new Padding(
        padding: EdgeInsets.only(bottom: 4, left: 8, right: 8),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: ColorsTheme.grey,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8)),
                    border: Border.all(
                      color:
                          delete == '0' ? ColorsTheme.grey : ColorsTheme.hijau,
                    )),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: Text(tanggals[i].value.toString())),
                      delete == '0'
                          ? Icon(
                              Icons.square,
                              color: ColorsTheme.grey,
                            )
                          : Icon(
                              Icons.check,
                              color: ColorsTheme.hijau,
                            )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 4),
            GestureDetector(
              onTap: () {
                removeTanggal(tanggals[i], paramDelete);
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
                    child: delete == '0'
                        ? Icon(
                            Icons.square,
                            color: Colors.white,
                          )
                        : Icon(
                            Icons.check,
                            color: ColorsTheme.primary1,
                          )),
              ),
            ),
          ],
        ),
      ));
    }
  }

  Widget jumlahKuotaCard(String nama, String jumlahKuota) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                nama.toUpperCase(),
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: ColorsTheme.primary1),
              )),
          Divider(),
          Padding(
              padding: EdgeInsets.only(left: 8, right: 8),
              child: Text("KUOTA : ")),
          Padding(
              padding: EdgeInsets.only(bottom: 8, left: 8, right: 8),
              child: Html(
                data: jumlahKuota,
                style: {
                  "body": Style(
                      color: ColorsTheme.merah,
                      fontSize: FontSize(12),
                      margin: EdgeInsets.zero,
                      padding: EdgeInsets.zero),
                },
              )),
        ],
      ),
    );
  }
}
