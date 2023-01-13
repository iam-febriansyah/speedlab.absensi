import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../../api/api_service.dart';
import '../../models/absen/return.dart';
import '../../style/colors.dart';
import '../general_widget/widget_snackbar.dart';

class OvertimeRequest extends StatefulWidget {
  const OvertimeRequest({Key? key}) : super(key: key);

  @override
  State<OvertimeRequest> createState() => _OvertimeRequestState();
}

class _OvertimeRequestState extends State<OvertimeRequest> {
  DevService _devService = DevService();
  bool loading = false;
  bool failed = false;
  String remakrs = '';

  String namaKaryawan = '';
  String staffID = '';
  String jamDari = 'HH:ii';
  String jamSampai = 'HH:ii';
  String tipeOvertime = '';
  String tipeOvertimeText = 'Pilih';
  String tanggal = 'yyyy-mm-dd';
  TextEditingController controllerCatatan = TextEditingController();
  List<TipeLembur> listTipe = [];

  void getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      listTipe.add(new TipeLembur(selected: '1', value: 'hari kerja'));
      listTipe.add(new TipeLembur(selected: '0', value: 'libur nasional'));
      tipeOvertime = 'hari kerja';
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
    if (tanggal == 'yyyy-mm-dd') {
      Toast.show("Harap pilih tanggal lembur",
          duration: 4, gravity: Toast.bottom);
    } else {
      if (jamDari == 'HH:ii') {
        Toast.show("Harap isi Jam Mulai Lembur",
            duration: 4, gravity: Toast.bottom);
      } else if (jamSampai == 'HH:ii') {
        Toast.show("Harap isi Jam Selesai Lembur",
            duration: 4, gravity: Toast.bottom);
      } else if (controllerCatatan.text == '') {
        Toast.show("Harap mengisi Keperluan Lembur",
            duration: 4, gravity: Toast.bottom);
      } else if (tipeOvertime == '') {
        Toast.show("Harap memilih tipe Lembur",
            duration: 4, gravity: Toast.bottom);
      } else {
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
        .simpanOvertime(accesToken, tipeOvertime, tanggal,
            controllerCatatan.text, jamDari, jamSampai)
        .then((value) async {
      var res = json.decode(value);
      if (res['status_json'] == true) {
        dismisKeyboard();
        setState(() {
          loading = false;
          failed = false;
        });
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

  void changeTipeLembur(String value) {
    for (var element in listTipe) {
      TipeLembur tile =
          listTipe.firstWhere((item) => item.value == element.value);
      setState(() => tile.selected = "0");
    }
    TipeLembur tile = listTipe.firstWhere((item) => item.value == value);
    setState(() => tile.selected = "1");
    setState(() {
      tipeOvertime = value;
      listTipe = listTipe;
    });
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
        title: Text("Pengajuan Lembur"),
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
          jumlahKuotaCard(namaKaryawan.toUpperCase() + "(" + staffID + ")"),
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
                  "FORM PENGAJUAN LEMBUR",
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
                      child:
                          Text("TIPE LEMBUR", style: TextStyle(fontSize: 14))),
                  Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.04,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: listTipe.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            TipeLembur item = listTipe[index];
                            return Padding(
                              padding: EdgeInsets.all(2),
                              child: ElevatedButton(
                                onPressed: () {
                                  dismisKeyboard();
                                  String value = item.value!;
                                  changeTipeLembur(value);
                                },
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            item.selected == '1'
                                                ? ColorsTheme.primary1
                                                : ColorsTheme.grey),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
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
                          controller: controllerCatatan,
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
                child: Text("TANGGAL LEMBUR", style: TextStyle(fontSize: 14))),
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
                        firstDate: DateTime.now().add(const Duration(days: -3)),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      ).then((pickedDate) {
                        setState(() {
                          tanggal =
                              convertDateTimeDisplay(pickedDate.toString());
                        });
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: Text(tanggal)),
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
            SizedBox(height: 8),
            Container(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    jamPicker('dari'),
                    Text("s/d"),
                    jamPicker('sampai')
                  ]),
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
                      submit();
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          ColorsTheme.primary1),
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

  Widget jamPicker(dariSampai) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4, left: 8, right: 8),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
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
              showCupertinoModalPopup(
                  context: context,
                  builder: (BuildContext builder) {
                    return Container(
                      height: 200,
                      color: Colors.white,
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.time,
                        use24hFormat: true,
                        initialDateTime: DateTime.now(),
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

  Widget jumlahKuotaCard(String nama) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            nama.toUpperCase(),
            style: TextStyle(
                fontWeight: FontWeight.bold, color: ColorsTheme.primary1),
          )),
    );
  }
}
