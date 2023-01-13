import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/pages/izin/izin_type.dart';
import 'package:flutter_application_1/style/sizes.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../../api/api_service.dart';
import 'dart:io' as Io;
import '../../style/colors.dart';
import '../general_widget/widget_snackbar.dart';

class IzinRequest extends StatefulWidget {
  const IzinRequest({Key? key}) : super(key: key);

  @override
  State<IzinRequest> createState() => _IzinRequestState();
}

class _IzinRequestState extends State<IzinRequest> {
  DevService _devService = DevService();
  bool loading = false;
  bool failed = false;
  String remakrs = '';

  String namaKaryawan = '';
  String staffID = '';
  List<String> listFiles = [];
  String tanggal = 'yyyy-mm-dd';
  String jamMulai = 'HH-ii';
  String tipeIzin = '';
  String tipeIzinText = 'Pilih';
  bool isFile = false;
  String fileName = "";
  TextEditingController controllerKeperluan = TextEditingController();

  void getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
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
      Toast.show("Harap isi tanggal izin Anda",
          duration: 4, gravity: Toast.bottom);
    } else if (jamMulai == 'HH:ii') {
      Toast.show("Harap isi jam izin Anda", duration: 4, gravity: Toast.bottom);
    } else if (tipeIzin == '') {
      Toast.show("Harap memilih Tipe Izin", duration: 4, gravity: Toast.bottom);
    } else if (controllerKeperluan.text == '') {
      Toast.show("Harap mengisi Keperluan Izin",
          duration: 4, gravity: Toast.bottom);
    } else {
      pushData();
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
        .simpanIzin(accesToken, int.parse(tipeIzin), controllerKeperluan.text,
            listFiles, tanggal, jamMulai)
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

  Widget jamPicker(dariSampai) {
    return Padding(
      padding: EdgeInsets.only(left: 8, right: 8),
      child: Container(
        width: MediaQuery.of(context).size.width * 1,
        decoration: BoxDecoration(
          color: ColorsTheme.grey,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(8),
              bottomRight: Radius.circular(8),
              topLeft: Radius.circular(8),
              bottomLeft: Radius.circular(8)),
        ),
        child: Padding(
          padding: EdgeInsets.all(0),
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
                              jamMulai = jamSelected;
                            } else {
                              jamMulai = jamSelected;
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
                    child: Text(dariSampai == 'dari' ? jamMulai : jamMulai)),
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

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'pdf', 'png', 'jpeg']);
    if (result != null) {
      listFiles.clear();
      PlatformFile file = result.files.first;
      File fileTemp = File(file.path!);
      var bytes = fileTemp.readAsBytesSync();
      String base64Image = base64.encode(bytes);
      String extWidthBase64 = "ext/${file.path};${base64Image}";
      listFiles.add(extWidthBase64);
      setState(() {
        fileName = file.name;
      });
    } else {
      // User canceled the picker
    }
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
        title: Text("Pengajuan Izin"),
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
          Container(
              width: MediaQuery.of(context).size.width,
              child: jumlahKuotaCard(
                  namaKaryawan.toUpperCase() + "\n(" + staffID + ")")),
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
                  "FORM PENGAJUAN IZIN",
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
                    child: GestureDetector(
                      onTap: () async {
                        dismisKeyboard();
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => IzinType()),
                        );
                        setState(() {
                          if (result != null) {
                            tipeIzin = result['id'].toString();
                            tipeIzinText = result['izin'];
                            isFile = result['is_file'] == 0 ? false : true;
                            listFiles.clear();
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
                              Expanded(child: Text(tipeIzinText)),
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
                      child: Text("ALASAN", style: TextStyle(fontSize: 14))),
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
                  child: jamPicker('dari'),
                ),
              ),
            ),
            SizedBox(height: 8),
            isFile
                ? GestureDetector(
                    onTap: () {
                      dismisKeyboard();
                      pickFile();
                    },
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 4, left: 8, right: 8),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width,
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_box,
                                color: ColorsTheme.primary1,
                              ),
                              Text(
                                fileName == "" ? "Tambahkan File" : fileName,
                                style: TextStyle(
                                    color: ColorsTheme.background3,
                                    fontSize: 16),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
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
        ],
      ),
    );
  }
}
