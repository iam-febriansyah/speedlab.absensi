import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_application_1/api/api_service.dart';
import 'package:flutter_application_1/models/auth/cls_profile.dart';
import 'package:flutter_application_1/pages/akun/profile_bank.dart';
import 'package:flutter_application_1/pages/akun/profile_bpjs.dart';
import 'package:flutter_application_1/pages/akun/profile_camera.dart';
import 'package:flutter_application_1/pages/akun/profile_document.dart';
import 'package:flutter_application_1/pages/akun/profile_edit.dart';
import 'package:flutter_application_1/pages/akun/profile_lihat.dart';
import 'package:flutter_application_1/pages/akun/profile_password.dart';
import 'package:flutter_application_1/pages/auth/login.dart';
import 'package:flutter_application_1/pages/general_widget/widget_progress.dart';
import 'package:flutter_application_1/pages/general_widget/widget_snackbar.dart';
import 'package:flutter_application_1/style/colors.dart';
import 'package:flutter_application_1/style/sizes.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuProfile extends StatefulWidget {
  const MenuProfile({Key? key}) : super(key: key);

  @override
  State<MenuProfile> createState() => _MenuProfileState();
}

class _MenuProfileState extends State<MenuProfile> {
  DevService _devService = DevService();
  Profile profile = new Profile();
  String version = "";
  String urlUpdateAplikasi = "";

  bool connected = true;
  bool loading = false;
  bool failed = false;
  String remarks = "";

  getData() async {
    setState(() {
      loading = true;
      failed = false;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    final PackageInfo info = await PackageInfo.fromPlatform();
    var accesToken = pref.getString("PREF_TOKEN")!;
    _devService.getProfileSingle(accesToken).then((value) async {
      var res = json.decode(value);
      if (res['status_json']) {
        setState(() {
          version = info.version;
          if (Platform.isAndroid) {
            urlUpdateAplikasi = "https://bit.ly/PlaystoreSpeedERP";
          } else if (Platform.isIOS) {
            urlUpdateAplikasi = "https://apple.co/3qisM1o";
          }
          var profileData = res['profile']!;
          profile.id = profileData['id'].toString();
          profile.staffId = profileData['staff_id'].toString();
          profile.firstName = profileData['first_name'].toString();
          profile.nik = profileData['nik'].toString();
          profile.email = profileData['email'].toString();
          profile.dateOfJoining = profileData['date_of_joining'].toString();
          profile.fotoProfile = profileData['foto_profile'].toString();
          profile.phone = profileData['phone'].toString();
          profile.address = profileData['address'].toString();
          profile.addresDomisili = profileData['addres_domisili'].toString();
          profile.gender = profileData['gender'].toString();
          profile.birthPlace = profileData['birth_place'].toString();
          profile.birthDay = profileData['birth_day'].toString();
          profile.maritalStatus = profileData['marital_status'].toString();
          profile.blood = profileData['blood'].toString();
          profile.bankBankname = profileData['bank_bankname'].toString();
          profile.bankName = profileData['bank_name'].toString();
          profile.bankAccountno = profileData['bank_accountno'].toString();
          profile.noBpjsKesehatan = profileData['no_bpjs_kesehatan'].toString();
          profile.noBpjsTk = profileData['no_bpjs_tk'].toString();
          profile.noBpjsJp = profileData['no_bpjs_jp'].toString();
          profile.noNpwp = profileData['no_npwp'].toString();
          profile.position = profileData['position'].toString();
          profile.section = profileData['section'].toString();
          profile.departement = profileData['departement'].toString();
          profile.division = profileData['division'].toString();
          profile.level = profileData['level'].toString();
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

  void logout() {
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (BuildContext context) {
          updateToken("");
          return LoginPage();
        },
      ),
      (_) => false,
    );
  }

  void updateToken(token) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var accesToken = pref.getString("PREF_TOKEN")!;
    _devService
        .updateTokenFirebase(accesToken, token)
        .then((value) async {})
        .catchError((Object obj) {});
  }

  void _launchInBrowser() async {
    if (!await launchUrl(Uri.parse(urlUpdateAplikasi),
        mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $urlUpdateAplikasi';
    }
  }

  void uploadPhoto(String base64) async {
    Navigator.pop(context);
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => WidgetProgressSubmit());
    SharedPreferences pref = await SharedPreferences.getInstance();
    var accesToken = pref.getString("PREF_TOKEN")!;
    _devService.updatePhotoProfile(accesToken, base64).then((value) async {
      var res = json.decode(value);
      if (res['status_json'] == true) {
        WidgetSnackbar(
            context: context, message: res['remarks'], warna: "hijau");
        Navigator.pop(context);
      } else {
        if (mounted) ToastContext().init(context);
        Toast.show(res['remarks'], duration: 4, gravity: Toast.bottom);
        Navigator.pop(context);
      }
    }).catchError((Object obj) {
      if (mounted) ToastContext().init(context);
      Toast.show("Gagal menyambungkan ke server",
          duration: 4, gravity: Toast.bottom);
      Navigator.pop(context);
    });
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ['jpg', 'png', 'jpeg']);
    if (result != null) {
      PlatformFile file = result.files.first;
      File fileTemp = File(file.path!);
      var bytes = fileTemp.readAsBytesSync();
      String base64Image = base64.encode(bytes);
      String extWidthBase64 = "ext/${file.path};${base64Image}";
      uploadPhoto(extWidthBase64);
    } else {
      // User canceled the picker
    }
  }

  void dialogPilihFile() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(child: Text('Pilih File')),
            actionsAlignment: MainAxisAlignment.center,
            actions: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () async {
                        List<CameraDescription> cameras =
                            await availableCameras();
                        var res = await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    ProfileCamera(cameras: cameras)));
                        if (res != null) {
                          uploadPhoto(res);
                        }
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ))),
                      child: Text(
                        "KAMERA",
                        style: TextStyle(color: ColorsTheme.primary1),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () {
                        pickFile();
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              ColorsTheme.primary1),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ))),
                      child: Text(
                        "FILE",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
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
          title: Text("Akun"),
          elevation: 0,
          backgroundColor: ColorsTheme.primary1,
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              color: Colors.white,
              onPressed: () async {
                logout();
              },
            ),
          ],
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
                : SingleChildScrollView(
                    // physics: NeverScrollableScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        profileWidget(profile),
                        buttonEditProfile(profile),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Divider(height: 16),
                        ),
                        listCard(profile),
                        SizedBox(height: 16),
                        Center(
                          child: Text(
                            "Version " + version,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: ColorsTheme.primary1),
                          ),
                        ),
                      ],
                    ),
                  ));
  }

  Widget profileWidget(Profile profile) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                border: Border.all(
                  color: Color(0xffd6d2d2),
                  width: 1,
                ),
                color: Color(0xffd6d2d2),
              ),
              child: CachedNetworkImage(
                imageUrl: profile.fotoProfile,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                    ),
                  ),
                ),
                placeholder: (context, url) => CupertinoActivityIndicator(),
                errorWidget: (context, url, error) =>
                    Icon(FontAwesome5.smile_beam),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.firstName,
                    style: TextStyle(color: ColorsTheme.text1, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    profile.staffId,
                    style: TextStyle(color: ColorsTheme.text1, fontSize: 12),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Position. " + profile.position,
                    style: TextStyle(color: ColorsTheme.text1, fontSize: 10),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Dept. " + profile.departement,
                    style: TextStyle(color: ColorsTheme.text1, fontSize: 10),
                  ),
                  SizedBox(height: 8),
                  Container(
                    height: 26,
                    width: 110,
                    child: Center(
                      child: ElevatedButton(
                          onPressed: () async {
                            dialogPilihFile();
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  ColorsTheme.grey),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ))),
                          child: Row(
                            children: [
                              Icon(
                                Icons.camera_alt,
                                color: ColorsTheme.text1,
                                size: 10,
                              ),
                              SizedBox(width: 4),
                              Text(
                                "UBAH FOTO",
                                style: TextStyle(
                                    color: ColorsTheme.text1, fontSize: 10),
                              ),
                            ],
                          )),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buttonEditProfile(Profile profile) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 40,
                child: Center(
                  child: ElevatedButton(
                      onPressed: () async {
                        var res = await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    ProfileEdit(profile: profile)));
                        if (res != null) {
                          getData();
                        }
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              ColorsTheme.primary1),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.edit,
                            size: 14,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "EDIT PROFILE",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      )),
                ),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Container(
                height: 40,
                child: Center(
                  child: ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                ProfileLihat(profile: profile)));
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              ColorsTheme.primary1),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.account_box,
                            size: 14,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "LIHAT PROFILE",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget listCard(Profile profile) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                var res = await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProfilePassword(profile: profile)));
                if (res != null) {
                  getData();
                }
              },
              child: card(Icons.key, "Ganti Password",
                  "Ganti Password kamu secara berkala"),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () async {
                var res = await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProfileBPJS(profile: profile)));
                if (res != null) {
                  getData();
                }
              },
              child: card(Icons.health_and_safety, "Data BPJS",
                  "Nomor nomor yang berkaitan dengan Jaminan Sosial dari Pemerintah"),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () async {
                var res = await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProfileBank(profile: profile)));
                if (res != null) {
                  getData();
                }
              },
              child: card(FontAwesome.bank, "Update Akun Bank",
                  "Isi Akun Bank anda agar mempermudah payroll"),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProfileDocument(profile: profile)));
              },
              child: card(Icons.book, "Dokumen-dokumen",
                  "Lengkapi dokumen-dokumen untuk menunjang kebutuhan HR"),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                _launchInBrowser();
              },
              child: card(Icons.update, "Check Update Aplikasi",
                  "Update aplikasi kamu agar bisa menikmati fitur-fitur terbaru"),
            ),
          ],
        ),
      ),
    );
  }

  Widget card(IconData icon, String title, String subtile) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 16),
          child: Icon(icon),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Text(
                title,
                style: TextStyle(color: ColorsTheme.text1, fontSize: 16),
              ),
            ),
            SizedBox(height: 4),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Text(
                subtile,
                style: TextStyle(color: ColorsTheme.text2, fontSize: 12),
              ),
            ),
            SizedBox(height: 8),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 0.5,
              color: Colors.grey,
            )
          ],
        ),
      ],
    );
  }
}
