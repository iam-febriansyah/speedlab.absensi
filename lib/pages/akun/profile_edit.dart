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

class ProfileEdit extends StatefulWidget {
  final Profile profile;
  const ProfileEdit({Key? key, required this.profile}) : super(key: key);
  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  DevService _devService = DevService();
  bool loading = false;
  bool failed = false;
  String remakrs = '';

  TextEditingController ctrlNik = new TextEditingController();
  TextEditingController ctrlNama = new TextEditingController();
  TextEditingController ctrlJk = new TextEditingController();
  TextEditingController ctrlTglLahir = new TextEditingController();
  TextEditingController ctrlTempatLahir = new TextEditingController();
  TextEditingController ctrlAlamatKtp = new TextEditingController();
  TextEditingController ctrlAlamatDomisili = new TextEditingController();
  TextEditingController ctrlNomorHp = new TextEditingController();
  TextEditingController ctrlEmail = new TextEditingController();
  TextEditingController ctrlGolDar = new TextEditingController();
  TextEditingController ctrlStatusKawin = new TextEditingController();
  List<String> listJK = ['LAKI-LAKI', 'PEREMPUAN'];
  List<String> listStatusKawin = ['MENIKAH', 'LAJANG', 'DUDA', 'JANDA'];
  List<String> listGolDar = ['A', 'A-', 'B', 'B-', 'AB', 'AB-', 'O', 'O-'];

  getData() {
    ctrlNik.text = widget.profile.nik.toString().toUpperCase();
    ctrlNama.text = widget.profile.firstName.toString().toUpperCase();
    ctrlJk.text = genderText(widget.profile.gender.toString());
    ctrlTglLahir.text = widget.profile.birthDay.toString().toUpperCase();
    ctrlTempatLahir.text = widget.profile.birthPlace.toString().toUpperCase();
    ctrlAlamatKtp.text = widget.profile.address.toString().toUpperCase();
    ctrlAlamatDomisili.text =
        widget.profile.addresDomisili.toString().toUpperCase();
    ctrlNomorHp.text = widget.profile.phone.toString().toUpperCase();
    ctrlEmail.text = widget.profile.email.toString();
    ctrlGolDar.text = widget.profile.blood.toString().toUpperCase();
    ctrlStatusKawin.text =
        widget.profile.maritalStatus.toString().toUpperCase();
  }

  String genderText(String p) {
    if (p == '1' ||
        p.toLowerCase().trim() == 'laki laki' ||
        p.toLowerCase().trim() == 'laki-laki' ||
        p.toLowerCase().trim() == 'laki - laki' ||
        p.toLowerCase().trim() == 'pria') {
      return "LAKI-LAKI";
    } else if (p == '2' ||
        p.toLowerCase().trim() == 'perempuan' ||
        p.toLowerCase().trim() == 'female' ||
        p.toLowerCase().trim() == 'p' ||
        p.toLowerCase().trim() == 'wanita') {
      return "PEREMPUAN";
    } else {
      return "";
    }
  }

  showDate(TextEditingController controller) {
    dismisKeyboard();
    String now = controller.text;
    DateTime dateParam = new DateFormat("yyyy-MM-dd").parse(now + " 00:00:00");
    DateTime dateNow = new DateTime.now();
    int minDate = 365 * (-100);
    showDatePicker(
      context: context,
      initialDate: dateParam,
      firstDate: dateNow.add(Duration(days: minDate)),
      lastDate: dateNow.add(Duration(days: 365)),
    ).then((pickedDate) {
      setState(() {
        controller.text = convertDateTimeDisplay(pickedDate.toString());
      });
    });
  }

  String convertDateTimeDisplay(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('yyyy-MM-dd');
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    return formatted;
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

  void submit() {
    dismisKeyboard();
    if (mounted) ToastContext().init(context);
    if (ctrlNik.text == '') {
      Toast.show("Harap isi NIK", duration: 4, gravity: Toast.bottom);
    } else if (ctrlNama.text == '') {
      Toast.show("Harap isi Nama", duration: 4, gravity: Toast.bottom);
    } else if (ctrlJk.text == '') {
      Toast.show("Harap isi Jenis Kelamin", duration: 4, gravity: Toast.bottom);
    } else if (ctrlTempatLahir.text == '') {
      Toast.show("Harap isi Tempat Lahir", duration: 4, gravity: Toast.bottom);
    } else if (ctrlTglLahir.text == '') {
      Toast.show("Harap isi Tanggal Lahir", duration: 4, gravity: Toast.bottom);
    } else if (ctrlAlamatKtp.text == '') {
      Toast.show("Harap isi Alamat KTP", duration: 4, gravity: Toast.bottom);
    } else if (ctrlAlamatDomisili.text == '') {
      Toast.show("Harap isi Alamat Domisili",
          duration: 4, gravity: Toast.bottom);
    } else if (ctrlNomorHp.text == '') {
      Toast.show("Harap isi Nomor HP", duration: 4, gravity: Toast.bottom);
    } else if (ctrlStatusKawin.text == '') {
      Toast.show("Harap isi Status Kawin", duration: 4, gravity: Toast.bottom);
    } else {
      pushData();
    }
  }

  String genderPost() {
    if (ctrlJk.text.toLowerCase() == 'perempuan') {
      return '2';
    }
    return '1';
  }

  Future pushData() async {
    setState(() {
      loading = true;
      failed = false;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    var accesToken = pref.getString("PREF_TOKEN")!;
    _devService
        .updateProfile(
            accesToken,
            ctrlNama.text.toUpperCase(),
            ctrlNik.text,
            ctrlEmail.text.toLowerCase(),
            ctrlNomorHp.text.toUpperCase(),
            ctrlAlamatKtp.text.toUpperCase(),
            ctrlAlamatDomisili.text.toUpperCase(),
            genderPost(),
            ctrlTempatLahir.text.toUpperCase(),
            ctrlTglLahir.text.toUpperCase(),
            ctrlStatusKawin.text.toUpperCase(),
            ctrlGolDar.text.toUpperCase())
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
          title: Text("Edit Profil"),
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
                card("NIK", ctrlNik, true),
                card("NAMA", ctrlNama, true),
                GestureDetector(
                    onTap: () {
                      goToList(listJK, ctrlJk);
                    },
                    child: card("JENIS KELAMIN", ctrlJk, false)),
                card("TEMPAT LAHIR", ctrlTempatLahir, true),
                GestureDetector(
                  onTap: () {
                    showDate(ctrlTglLahir);
                  },
                  child: card("TANGGAL LAHIR", ctrlTglLahir, false),
                ),
                card("ALAMAT KTP", ctrlAlamatKtp, true),
                card("ALAMAT DOMISILI", ctrlAlamatDomisili, true),
                card("NOMOR HP", ctrlNomorHp, true),
                GestureDetector(
                  onTap: () {
                    goToList(listGolDar, ctrlGolDar);
                  },
                  child: card("GOLONGAN DARAH", ctrlGolDar, false),
                ),
                GestureDetector(
                  onTap: () {
                    goToList(listStatusKawin, ctrlStatusKawin);
                  },
                  child: card("STATUS KAWIN", ctrlStatusKawin, false),
                ),
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
