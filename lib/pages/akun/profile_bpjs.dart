import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/api/api_service.dart';
import 'package:flutter_application_1/models/auth/cls_profile.dart';
import 'package:flutter_application_1/pages/general_widget/widget_snackbar.dart';
import 'package:flutter_application_1/style/colors.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class ProfileBPJS extends StatefulWidget {
  final Profile profile;
  const ProfileBPJS({Key? key, required this.profile}) : super(key: key);
  @override
  State<ProfileBPJS> createState() => _ProfileBPJSState();
}

class _ProfileBPJSState extends State<ProfileBPJS> {
  DevService _devService = DevService();
  bool loading = false;
  bool failed = false;
  String remakrs = '';

  TextEditingController ctrlBpjsKesehatan = new TextEditingController();
  TextEditingController ctrlBpjsTK = new TextEditingController();
  TextEditingController ctrlBpjsJP = new TextEditingController();

  getData() {
    ctrlBpjsKesehatan.text =
        widget.profile.noBpjsKesehatan.toString().toUpperCase();
    ctrlBpjsTK.text = widget.profile.noBpjsTk.toString().toUpperCase();
    ctrlBpjsJP.text = widget.profile.noBpjsJp.toString().toUpperCase();
  }

  void submit() {
    dismisKeyboard();
    if (mounted) ToastContext().init(context);
    pushData();
  }

  Future pushData() async {
    setState(() {
      loading = true;
      failed = false;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    var accesToken = pref.getString("PREF_TOKEN")!;
    _devService
        .updateBpjs(accesToken, ctrlBpjsKesehatan.text.toUpperCase(),
            ctrlBpjsTK.text, ctrlBpjsJP.text)
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

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: ColorsTheme.primary1));

    return Scaffold(
        appBar: AppBar(
          title: Text("Edit Data BPJS"),
          elevation: 0,
          backgroundColor: ColorsTheme.primary1,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                card("BPJS KESEHATAN", ctrlBpjsKesehatan, false),
                card("BPJS TENAGA KERJA", ctrlBpjsTK, false),
                card("BPJS JP", ctrlBpjsJP, false),
                // Padding(
                //   padding: EdgeInsets.only(bottom: 4),
                //   child: Container(
                //     width: MediaQuery.of(context).size.width,
                //     child: ElevatedButton(
                //       onPressed: () async {
                //         if (!loading) {
                //           if (mounted) ToastContext().init(context);
                //           submit();
                //         }
                //       },
                //       style: ButtonStyle(
                //           backgroundColor: MaterialStateProperty.all<Color>(
                //               ColorsTheme.primary1),
                //           shape:
                //               MaterialStateProperty.all<RoundedRectangleBorder>(
                //                   RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(10),
                //           ))),
                //       child: Padding(
                //         padding: const EdgeInsets.symmetric(
                //             horizontal: 15, vertical: 0),
                //         child: Text(
                //           loading ? "Menyimpan data.." : "SIMPAN",
                //           style: TextStyle(color: Colors.white, fontSize: 16),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ));
  }

  Widget card(String title, TextEditingController controller, bool enabled) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Text(
              title,
              style: TextStyle(color: ColorsTheme.text2, fontSize: 12),
            ),
          ),
          SizedBox(height: 4),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child: TextFormField(
              controller: controller,
              enabled: enabled,
              keyboardType: TextInputType.text,
              decoration:
                  InputDecoration.collapsed(hintText: 'Tulis Disini ..'),
            ),
          ),
          SizedBox(height: 8),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: 0.5,
            color: Colors.grey,
          )
        ],
      ),
    );
  }
}
