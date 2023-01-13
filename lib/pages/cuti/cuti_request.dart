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
import 'cuti_type.dart';

class CutiRequest extends StatefulWidget {
  final int jumlahKuota;
  final String jumlahKuotaString;

  const CutiRequest(
      {Key? key, required this.jumlahKuota, required this.jumlahKuotaString})
      : super(key: key);

  @override
  State<CutiRequest> createState() => _CutiRequestState();
}

class _CutiRequestState extends State<CutiRequest> {
  DevService _devService = DevService();
  bool loading = false;
  bool failed = false;
  String remakrs = '';

  int jumlahKuota = 0;
  String jumlahKuotaString = '';
  String namaKaryawan = '';
  String staffID = '';
  List<TanggalCuti> itemTanggal = [];
  List<String> tanggalPost = [];
  String tanggal0 = 'yyyy-mm-dd';
  String tipeCuti = '';
  String tipeCutiText = 'Pilih';

  TextEditingController controllerKeperluan = TextEditingController();
  List<Widget> widgetTanggal = [];

  void getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      jumlahKuota = widget.jumlahKuota;
      jumlahKuotaString = widget.jumlahKuotaString;
      namaKaryawan = pref.getString("PREF_NAMA")!;
      staffID = pref.getString("PREF_NIP")!;
    });
  }

  String convertDateTimeDisplay(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('yyyy-MM-dd');
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    return formatted;
  }

  void submit() {
    if (mounted) ToastContext().init(context);
    tanggalPost.clear();
    List<TanggalCuti> tanggals =
        itemTanggal.where((element) => element.delete == '0').toList();
    if ((tanggals.length + 1) > jumlahKuota) {
      Toast.show("Maksimal Cuti Anda adalah " + jumlahKuota.toString(),
          duration: 4, gravity: Toast.bottom);
    } else {
      if (tanggal0 == 'yyyy-mm-dd') {
        Toast.show("Harap isi tanggal Cuti Anda",
            duration: 4, gravity: Toast.bottom);
      } else if (tipeCuti == '') {
        Toast.show("Harap memilih Tipe Cuti",
            duration: 4, gravity: Toast.bottom);
      } else if (controllerKeperluan.text == '') {
        Toast.show("Harap mengisi Keperluan Cuti",
            duration: 4, gravity: Toast.bottom);
      } else {
        tanggalPost.add(tanggal0);
        for (var element in tanggals) {
          if (element.value == 'yyyy-mm-dd') {
            Toast.show("Harap isi tanggal Cuti Anda",
                duration: 4, gravity: Toast.bottom);
            break;
          }
          tanggalPost.add(element.value.toString());
        }
        pushData();
      }
    }
  }

  Future pushData() async {
    setState(() {
      loading = true;
      failed = false;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    var accesToken = pref.getString("PREF_TOKEN")!;
    _devService
        .simpanCuti(accesToken, int.parse(tipeCuti), controllerKeperluan.text,
            tanggalPost)
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
          loading = false;
          failed = true;
          remakrs = res['remarks'];
        });
        Toast.show(res['remarks'], duration: 4, gravity: Toast.bottom);
      }
    }).catchError((Object obj) {
      if (mounted)
        setState(() {
          loading = false;
          failed = true;
          remakrs = "Gagal menyambungkan ke server";
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
        title: Text("Pengajuan Cuti"),
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
      body: SingleChildScrollView(
          child: Column(
        children: [
          jumlahKuotaCard(namaKaryawan.toUpperCase() + "(" + staffID + ")",
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
                  "FORM PENGAJUAN CUTI",
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
                    child: GestureDetector(
                      onTap: () async {
                        dismisKeyboard();
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CutiType()),
                        );
                        setState(() {
                          if (result != null) {
                            tipeCuti = result['id'].toString();
                            tipeCutiText = result['leavetype'] +
                                ' (' +
                                result['kategori'] +
                                ')';
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
                              Expanded(child: Text(tipeCutiText)),
                              Icon(Icons.arrow_drop_down)
                            ],
                          ),
                        ),
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
                          controller: controllerKeperluan,
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: 10,
                          decoration: InputDecoration.collapsed(
                              hintText: 'Tulis Alasan'),
                        ),
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
                  IconButton(
                    icon: Icon(Icons.add),
                    color: ColorsTheme.primary1,
                    onPressed: () {
                      dismisKeyboard();
                      addTanggal();
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 4, left: 8, right: 8),
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
                  child: GestureDetector(
                    onTap: () {
                      dismisKeyboard();
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      ).then((pickedDate) {
                        setState(() {
                          tanggal0 =
                              convertDateTimeDisplay(pickedDate.toString());
                        });
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: Text(tanggal0)),
                        Icon(
                          Icons.date_range,
                          color: ColorsTheme.primary1,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: Column(children: widgetTanggal),
            ),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.only(bottom: 4, left: 8, right: 8),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () async {
                    if (!loading) {
                      if (mounted) ToastContext().init(context);
                      dismisKeyboard();
                      if (jumlahKuota <= 0) {
                        Toast.show("Anda tidak mempunyai kuota Cuti",
                            duration: 4, gravity: Toast.bottom);
                      } else {
                        submit();
                      }
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          jumlahKuota <= 0
                              ? ColorsTheme.background3
                              : ColorsTheme.primary1),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ))),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                    child: Text(
                      loading ? "Menyimpan data.." : "SIMPAN",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addTanggal() {
    if (mounted) ToastContext().init(context);
    int newCount = itemTanggal.length;
    String item = "tanggal" + (newCount + 1).toString();

    List<TanggalCuti> tanggals =
        itemTanggal.where((element) => element.delete == '0').toList();

    if (tanggals.length < (jumlahKuota - 1)) {
      itemTanggal
          .add(new TanggalCuti(id: item, value: 'yyyy-mm-dd', delete: "0"));
      setState(() {
        generateWidget(itemTanggal);
      });
    } else {
      Toast.show("Maksimal Cuti Anda adalah " + jumlahKuota.toString(),
          duration: 4, gravity: Toast.bottom);
    }
  }

  void removeTanggal(TanggalCuti param) {
    TanggalCuti tile = itemTanggal.firstWhere((item) => item.id == param.id);
    setState(() => tile.delete = "1");
    setState(() {
      generateWidget(itemTanggal);
    });
  }

  void generateWidget(List<TanggalCuti> tanggals) {
    widgetTanggal.clear();
    for (var i = 0; i < tanggals.length; i++) {
      if (tanggals[i].delete == '0') {
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
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        dismisKeyboard();
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                        ).then((pickedDate) {
                          String value =
                              convertDateTimeDisplay(pickedDate.toString());
                          TanggalCuti tile = tanggals
                              .firstWhere((item) => item.id == tanggals[i].id);
                          setState(() => tile.value = value);
                          setState(() {
                            generateWidget(itemTanggal);
                          });
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(child: Text(tanggals[i].value.toString())),
                          Icon(
                            Icons.date_range,
                            color: ColorsTheme.primary1,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete),
                color: ColorsTheme.merah,
                onPressed: () {
                  removeTanggal(tanggals[i]);
                },
              ),
            ],
          ),
        ));
      }
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
