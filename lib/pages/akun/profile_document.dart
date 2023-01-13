import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/api/api_service.dart';
import 'package:flutter_application_1/models/auth/cls_profile.dart';
import 'package:flutter_application_1/pages/general_widget/widget_progress.dart';
import 'package:flutter_application_1/pages/general_widget/widget_snackbar.dart';
import 'package:flutter_application_1/pages/izin/izin_file.dart';
import 'package:flutter_application_1/style/colors.dart';
import 'package:flutter_application_1/style/sizes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class ProfileDocument extends StatefulWidget {
  final Profile profile;
  const ProfileDocument({Key? key, required this.profile}) : super(key: key);
  @override
  State<ProfileDocument> createState() => _ProfileDocumentState();
}

class _ProfileDocumentState extends State<ProfileDocument> {
  bool loading = true;
  bool failed = false;
  String remarks = "";
  DevService _devService = DevService();
  List<dynamic> dataList = [];

  getData() async {
    setState(() {
      loading = true;
      failed = false;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    var accesToken = pref.getString("PREF_TOKEN")!;
    _devService.getProfileDoc(accesToken).then((value) async {
      var res = json.decode(value);
      if (res['status_json']) {
        setState(() {
          dataList = res['profile_doc'];
          loading = false;
          failed = false;
        });
      } else {
        setState(() {
          loading = false;
          failed = true;
          remarks = res['remarks'];
        });
      }
    }).catchError((Object obj) {
      if (mounted)
        setState(() {
          loading = false;
          failed = true;
          remarks = "Gagal menyambungkan ke server, coba beberapa saat lagi.";
        });
    });
  }

  void uploadPhoto(List<String> base64, String id_doctype) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => WidgetProgressSubmit());
    SharedPreferences pref = await SharedPreferences.getInstance();
    var accesToken = pref.getString("PREF_TOKEN")!;
    _devService
        .uploadDocument(accesToken, base64, id_doctype)
        .then((value) async {
      var res = json.decode(value);
      print(res.toString());
      if (res['status_json'] == true) {
        Navigator.of(context, rootNavigator: true).pop();
        WidgetSnackbar(
            context: context, message: res['remarks'], warna: "hijau");
        getData();
      } else {
        Navigator.of(context, rootNavigator: true).pop();
        if (mounted) ToastContext().init(context);
        Toast.show(res['remarks'], duration: 4, gravity: Toast.bottom);
      }
    }).catchError((Object obj) {
      Navigator.of(context, rootNavigator: true).pop();
      if (mounted) ToastContext().init(context);
      Toast.show("Gagal menyambungkan ke server",
          duration: 4, gravity: Toast.bottom);
    });
  }

  Future<void> pickFile(String id_doctype) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg']);
    if (result != null) {
      PlatformFile file = result.files.first;
      File fileTemp = File(file.path!);
      var bytes = fileTemp.readAsBytesSync();
      String base64Image = base64.encode(bytes);
      String extWidthBase64 = "ext/${file.path};${base64Image}";
      List<String> listBase64 = [];
      listBase64.add(extWidthBase64);
      uploadPhoto(listBase64, id_doctype);
    } else {
      // User canceled the picker
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
          title: Text("Dokument Saya"),
          elevation: 0,
          backgroundColor: ColorsTheme.primary1,
        ),
        body: loading
            ? Center(child: CupertinoActivityIndicator())
            : failed
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info,
                        color: ColorsTheme.merah,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          remarks,
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: ColorsTheme.text1, fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 4, left: 8, right: 8),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: ElevatedButton(
                            onPressed: () {
                              getData();
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        ColorsTheme.primary1),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 0),
                              child: Text(
                                "Coba Lagi",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : dataList.length == 0
                    ? Center(child: Text("Data Tidak Ada"))
                    : SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8),
                              ListView.builder(
                                  padding: EdgeInsets.all(0),
                                  shrinkWrap: true,
                                  itemCount: dataList.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var item = dataList[index];
                                    return InkWell(
                                      onTap: () {
                                        Navigator.pop(context, item);
                                      },
                                      child: card(item),
                                    );
                                  }),
                            ],
                          ),
                        ),
                      ));
  }

  Widget card(item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.95,
            child: Text(
              item['nama'],
              style: TextStyle(color: ColorsTheme.text2, fontSize: 12),
            ),
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Container(
                height: 26,
                child: Center(
                  child: ElevatedButton(
                      onPressed: () async {
                        pickFile(item['id_doctype'].toString());
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              ColorsTheme.grey),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ))),
                      child: Row(
                        children: [
                          Icon(
                            Icons.picture_as_pdf,
                            color: ColorsTheme.text1,
                            size: 10,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "UPLOAD FILE",
                            style: TextStyle(
                                color: ColorsTheme.text1, fontSize: 10),
                          ),
                        ],
                      )),
                ),
              ),
              SizedBox(width: 16),
              item['path_document'] != null
                  ? Container(
                      height: 26,
                      child: Center(
                        child: ElevatedButton(
                            onPressed: () async {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      IzinFile(url: item['path_document'])));
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        ColorsTheme.primary1),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ))),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.picture_as_pdf,
                                  color: Colors.white,
                                  size: 10,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  "LIHAT FILE",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 10),
                                ),
                              ],
                            )),
                      ),
                    )
                  : Container(),
            ],
          ),
          SizedBox(height: 8),
          Container(
            width: MediaQuery.of(context).size.width * 0.95,
            height: 0.5,
            color: Colors.grey,
          )
        ],
      ),
    );
  }
}
