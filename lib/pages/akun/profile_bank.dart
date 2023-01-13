import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/api/api_service.dart';
import 'package:flutter_application_1/models/auth/cls_profile.dart';
import 'package:flutter_application_1/pages/akun/list_select.dart';
import 'package:flutter_application_1/pages/general_widget/widget_snackbar.dart';
import 'package:flutter_application_1/style/colors.dart';
import 'package:flutter_application_1/style/sizes.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class ProfileBank extends StatefulWidget {
  final Profile profile;
  const ProfileBank({Key? key, required this.profile}) : super(key: key);
  @override
  State<ProfileBank> createState() => _ProfileBankState();
}

class _ProfileBankState extends State<ProfileBank> {
  DevService _devService = DevService();
  bool loading = false;
  bool failed = false;
  String remakrs = '';
  List<String> listBank = [
    'BCA',
    'BNI',
    'MANDIRI',
    'BRI',
    'PERMATA',
    'CIMBNIAGA',
    'PERMATA',
    'BTN',
    'OCBC NISP',
    'MUAMALAT'
  ];
  TextEditingController ctrlPemilik = new TextEditingController();
  TextEditingController ctrlNamaBank = new TextEditingController();
  TextEditingController ctrlNomorRekening = new TextEditingController();

  getData() {
    ctrlPemilik.text = widget.profile.firstName.toString().toUpperCase();
    ctrlNamaBank.text = widget.profile.bankName.toString().toUpperCase();
    ctrlNomorRekening.text =
        widget.profile.bankAccountno.toString().toUpperCase();
  }

  void submit() {
    dismisKeyboard();
    if (mounted) ToastContext().init(context);
    if (ctrlNamaBank.text == '') {
      Toast.show("Harap Pilih Bank", duration: 4, gravity: Toast.bottom);
    } else if (ctrlNomorRekening.text == '') {
      Toast.show("Harap isi Nomor Rekening",
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
        .updateBank(accesToken, ctrlPemilik.text.toUpperCase(),
            ctrlNamaBank.text, ctrlNomorRekening.text)
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

  goToList(List<String> list, controller) async {
    dismisKeyboard();
    var res = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ListSelect(list: list)));
    if (res != null) {
      setState(() {
        controller.text = res.toString().toUpperCase();
      });
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

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: ColorsTheme.primary1));

    return Scaffold(
        appBar: AppBar(
          title: Text("Edit Akun Bank"),
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
                card("NAMA PEMILIK", ctrlPemilik, false),
                GestureDetector(
                  onTap: () {
                    goToList(listBank, ctrlNamaBank);
                  },
                  child: card("BANK", ctrlNamaBank, false),
                ),
                card("NOMOR REKENING", ctrlNomorRekening, true),
                Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (!loading) {
                          if (mounted) ToastContext().init(context);
                          submit();
                        }
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              ColorsTheme.primary1),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 0),
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
