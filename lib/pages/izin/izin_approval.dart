import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/izin/izin_file.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../../api/api_service.dart';
import '../../style/colors.dart';
import '../general_widget/widget_snackbar.dart';

class IzinApproval extends StatefulWidget {
  final int id;
  final String staffId;

  const IzinApproval({Key? key, required this.id, required this.staffId})
      : super(key: key);

  @override
  State<IzinApproval> createState() => _IzinApprovalState();
}

class _IzinApprovalState extends State<IzinApproval> {
  DevService _devService = DevService();
  bool loading = false;
  bool failed = false;
  bool loadingSubmit = false;
  bool failedSubmit = false;
  String remakrs = '';

  String namaKaryawan = '';
  String staffID = '';
  dynamic dataIzin;

  void getData() async {
    setState(() {
      loading = true;
      failed = false;
      remakrs = '';
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    var accesToken = pref.getString("PREF_TOKEN")!;
    _devService.singleIzin(accesToken, widget.id).then((value) async {
      var res = json.decode(value);
      if (res['status_json'] == true) {
        dismisKeyboard();
        setState(() {
          dataIzin = res['izin'];
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
    pushData(status);
  }

  Future pushData(int status) async {
    setState(() {
      loadingSubmit = true;
      failedSubmit = false;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    var accesToken = pref.getString("PREF_TOKEN")!;
    _devService.appRejIzin(accesToken, widget.id, status).then((value) async {
      var res = json.decode(value);
      if (res['status_json'] == true) {
        dismisKeyboard();
        setState(() {
          loadingSubmit = false;
          failedSubmit = false;
        });
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
        title: Text("Approval Izin"),
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
                jumlahKuotaCard(dataIzin['first_name'].toUpperCase() +
                    " (" +
                    dataIzin['staff_id'] +
                    ")"),
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
                  "FORM APPROVAL IZIN",
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
                      child: Text("TIPE IZIN", style: TextStyle(fontSize: 14))),
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
                        child: Text(dataIzin['izin']),
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
                      child:
                          Text("WAKTU IZIN", style: TextStyle(fontSize: 14))),
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
                        child: Text(
                            dataIzin['tanggal'] + ' ' + dataIzin['mulai_jam']),
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
                      child: Text("ALASAN", style: TextStyle(fontSize: 14))),
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
                        child: Text(dataIzin['keterangan']),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 4),
            dataIzin['is_file'].toString() == "1"
                ? Padding(
                    padding: EdgeInsets.only(bottom: 4, left: 8, right: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: 150,
                            child: Text("LAMPIRAN",
                                style: TextStyle(fontSize: 14))),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      IzinFile(url: dataIzin['files'])));
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
                                child: Text("Lihat File"),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(),
            SizedBox(height: 8),
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
                            submit(-1);
                          }
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                ColorsTheme.merah),
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
                            submit(1);
                          }
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                ColorsTheme.primary1),
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

  Widget jumlahKuotaCard(String nama) {
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
        ],
      ),
    );
  }
}
