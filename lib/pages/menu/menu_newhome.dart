import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:badges/badges.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/pages/absen/list_cabang.dart';
import 'package:flutter_application_1/pages/menu/menu_absen.dart';
import 'package:flutter_application_1/pages/menu/menu_cuti.dart';
import 'package:flutter_application_1/pages/menu/menu_izin.dart';
import 'package:flutter_application_1/pages/menu/menu_overtime.dart';
import 'package:flutter_application_1/api/api_service.dart';
import 'package:flutter_application_1/models/menu/cls_absen_hari_ini.dart';
import 'package:flutter_application_1/pages/general_widget/widget_error.dart';
import 'package:flutter_application_1/pages/general_widget/widget_loading_page.dart';
import 'package:flutter_application_1/pages/general_widget/widget_snackbar.dart';
import 'package:flutter_application_1/pages/myshift/list_shift.dart';
import 'package:flutter_application_1/provider/provider.cabang.dart';
import 'package:flutter_application_1/style/colors.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/style/sizes.dart';
import 'package:new_version/new_version.dart';
import 'package:ntp/ntp.dart';
import 'package:package_info/package_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuHome extends StatefulWidget {
  @override
  _MenuHomeState createState() => _MenuHomeState();
}

class _MenuHomeState extends State<MenuHome> {
  final alasanController = TextEditingController();
  bool connected = true;
  bool loading = false;
  bool failed = false;
  String remakrs = '';
  String nama = '';
  String departemen = '';
  String posisi = '';
  String nip = '';
  String hari = '';
  String tanggal = '';
  String bulantahun = '';
  String imageProfil =
      'https://cdn-icons-png.flaticon.com/512/3011/3011270.png';
  String absenIn = '-';
  String absenInTgl = '-';
  String absenOut = '-';
  String absenOutTgl = '-';
  String shiftJamMasuk = '';
  String shiftJamKeluar = '';
  String badgeLembur = '0';
  String badgeIzin = '0';
  String badgeCuti = '0';
  double badgeTop = SizeConfig.screenHeight * 0.03;
  double badgeEnd = SizeConfig.screenWidth * 0.03;
  double badgeSizeFont = 8.0;

  DevService _devService = DevService();

  late CameraDescription cameraDescription;
  var faceData;
  List<Absen> dataAbsen = [];
  var informasi = '';
  bool canMockLocation = false;
  String canMockLocationString = "ABSEN SEKARANG";

  bool statusShift = true;
  String remarksShift = "";

  String idShift = '';
  String jamAbsenWajibIn = '';
  String jamAbsenWajibOut = '';

  bool permissionLocation = false;
  void safeDevice() async {
    checkConnection();
    if (Platform.isAndroid) {
      bool isMock = false;
      if (mounted)
        setState(() {
          canMockLocation = isMock;
          if (canMockLocation) {
            canMockLocationString = "Please Disable Your Fake GPS";
          } else {
            canMockLocationString = "ABSEN SEKARANG";
          }
        });
    }
  }

  checkConnection() async {
    try {
      final result = await InternetAddress.lookup('smarterp.speedlab.id');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (mounted)
          setState(() {
            connected = true;
          });
      }
    } on SocketException catch (_) {
      connected = false;
    }
  }

  String version = "";
  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      version = info.version;
    });
  }

  Future getData() async {
    _initPackageInfo();
    startUp();
    setState(() {
      loading = true;
      failed = false;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    var accesToken = pref.getString("PREF_TOKEN")!;
    informasi = pref.getString("PREF_INFO")!;
    faceData = pref.getString("PREF_FACE")!;
    var f = pref.getString("PREF_FOTO");
    if (f != null) {
      imageProfil = pref.getString("PREF_FOTO")!;
    }
    _devService.getHome(accesToken).then((value) async {
      print(value.toString());
      var res = json.decode(value);
      var remarkshift = '';
      if (res['status_json'] == true) {
        if (mounted)
          setState(() {
            badgeCuti = res['cuti_approval'].toString();
            badgeIzin = res['izin_approval'].toString();
            badgeLembur = res['lembur_approval'].toString();
            pref.setString("PREF_LEMBUR", badgeLembur);
            pref.setString("PREF_IZIN", badgeIzin);
            pref.setString("PREF_CUTI", badgeCuti);
            hari = res['hari'];
            tanggal = res['tanggal'];
            bulantahun = res['bulantahun'];
            if (res['absen_in'] != null) {
              absenIn = res['absen_in']['jam_absen'];
              absenInTgl = res['absen_in']['tanggal_absen'];
            }
            if (res['absen_out'] != null) {
              absenOut = res['absen_out']['jam_absen'];
              absenOutTgl = res['absen_out']['tanggal_absen'];
            }
            statusShift = res['status_shift'];
            remarkshift += res['remakrs_shift'];
            if (res['status_shift']) {
              if (res['data_shift'] != null) {
                remarkshift += "\n[";
                remarkshift += res['data_shift']['shift_code'];
                remarkshift += "] " + res['data_shift']['shift_name'];
                remarkshift += "\nJam Masuk ";
                remarkshift += res['data_shift']['jam_dari'];
                remarkshift += "\nJam Keluar ";
                remarkshift += res['data_shift']['jam_sampai'];
                shiftJamMasuk = res['data_shift']['jam_dari'];
                shiftJamKeluar = res['data_shift']['jam_sampai'];
                idShift = res['data_shift']['id'].toString();
                jamAbsenWajibIn = res['data_shift']['jam_dari'];
                jamAbsenWajibOut = res['data_shift']['jam_sampai'];
              } else {
                statusShift = false;
                remarkshift = "Shift tidak ditemukan, haraf hubungi HR";
              }
            }
            remarksShift = remarkshift;

            nama = pref.getString("PREF_NAMA")!;
            departemen = pref.getString("PREF_DEPARTEMEN")!;
            posisi = pref.getString("PREF_POSISI")!;
            nip = pref.getString("PREF_NIP")!;

            loading = false;
            failed = false;
          });
      } else {
        setState(() {
          loading = false;
          failed = true;
          remakrs = res['remarks'];
        });
      }
    });
    badgeTop = MediaQuery.of(context).size.height * 0.04;
    badgeEnd = MediaQuery.of(context).size.width * 0.025;
  }

  _permissionRequest() async {
    await Permission.location.request();
    await Permission.camera.request();
    var result = await Permission.location.isGranted;
    if (result) {
      if (result) {
        permissionLocation = true;
      } else {
        permissionLocation = false;
        _permissionRequest();
      }
      setState(() {
        permissionLocation = permissionLocation;
      });
    } else {
      await Permission.location.request();
    }
  }

  void startUp() async {
    List<CameraDescription> cameras = await availableCameras();
    cameraDescription = cameras.firstWhere(
      (CameraDescription camera) =>
          camera.lensDirection == CameraLensDirection.front,
    );
  }

  Widget online() {
    return Padding(
      padding: EdgeInsets.only(left: 8, right: 8, top: 36, bottom: 8),
      child: Container(
        width: MediaQuery.of(context).size.width * 1,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 51,
              height: 16,
              child: Text(
                'v' + version,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: "Sansation Light",
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            SizedBox(
              width: 51,
              height: 16,
              child: Text(
                connected ? "Online" : "Offline",
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: "Sansation Light",
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            SizedBox(width: 7),
            Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: connected ? Color(0xff08cc04) : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget profile() {
    return Padding(
      padding: EdgeInsets.only(top: 50, left: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Color(0xffd6d2d2),
                    width: 1,
                  ),
                  color: Colors.white,
                ),
                child: CircleAvatar(
                  radius: MediaQuery.of(context).size.width * 0.2,
                  backgroundImage: NetworkImage(imageProfil),
                  // fit: BoxFit.,
                  backgroundColor: Colors.transparent,
                ),
              ),
              SizedBox(width: 16),
              Container(
                child: Text(
                  "Hi, " + nama,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: "Sansation Light",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: Container(
              child: Text(
                nip,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: "Sansation Light",
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget cardAbsenHariIni() {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
      child: Center(
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x3f000000),
                    blurRadius: 4,
                    offset: Offset(0, 4),
                  ),
                ],
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            child: Text(
                              hari.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xff171111),
                                fontSize: 14,
                                fontFamily: "Sansation Light",
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                          SizedBox(height: 1.50),
                          Text(
                            tanggal,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 40,
                              fontFamily: "Sansation Light",
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          SizedBox(height: 1.50),
                          SizedBox(
                            width: 81,
                            height: 21,
                            child: Text(
                              bulantahun,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xff171111),
                                fontSize: 14,
                                fontFamily: "Sansation Light",
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        height: 80,
                        child: VerticalDivider(color: ColorsTheme.primary1)),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  child: Text(
                                    "IN",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xff171111),
                                      fontSize: 30,
                                      fontFamily: "Sansation Light",
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Column(
                                  children: [
                                    SizedBox(
                                      child: Text(
                                        absenIn,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color(0xff171111),
                                          fontSize: 12,
                                          fontFamily: "Sansation Light",
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    SizedBox(
                                      child: Text(
                                        absenInTgl,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color(0xff171111),
                                          fontSize: 14,
                                          fontFamily: "Sansation Light",
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  child: Text(
                                    "OUT",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xff171111),
                                      fontSize: 30,
                                      fontFamily: "Sansation Light",
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Column(
                                  children: [
                                    SizedBox(
                                      child: Text(
                                        absenOut,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color(0xff171111),
                                          fontSize: 12,
                                          fontFamily: "Sansation Light",
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    SizedBox(
                                      child: Text(
                                        absenOutTgl,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color(0xff171111),
                                          fontSize: 14,
                                          fontFamily: "Sansation Light",
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }

  void _modalBottomSheet(String jamMasuk, String jamKeluar) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        builder: (builder) {
          return Consumer<ProviderCabang>(builder: (context, provider, _) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.3,
              color: Colors.transparent,
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(10.0),
                          topRight: const Radius.circular(10.0))),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      // color: Colors.black12,
                                      image: DecorationImage(
                                          image: AssetImage(
                                              "assets/images/in.png"),
                                          fit: BoxFit.cover),
                                    )),
                                SizedBox(height: 4),
                                Text(
                                  "IN",
                                  style: TextStyle(
                                    color: Color(0xff171111),
                                    fontSize: 20,
                                    fontFamily: "Sansation Light",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "EXPECTED : ",
                                      style: TextStyle(
                                        color: Color(0xff171111),
                                        fontSize: 14,
                                        fontFamily: "Sansation Light",
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      jamMasuk,
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 14,
                                        fontFamily: "Sansation Light",
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                absenIn != '-'
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "ACTUAL : ",
                                            style: TextStyle(
                                              color: Color(0xff171111),
                                              fontSize: 14,
                                              fontFamily: "Sansation Light",
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            absenIn,
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 14,
                                              fontFamily: "Sansation Light",
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Text(
                                        '',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 14,
                                          fontFamily: "Sansation Light",
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                              ],
                            ),
                            onTap: () async {
                              alasanController.text = '';
                              if (absenIn != '-') {
                                return WidgetSnackbar(
                                    context: context,
                                    message: 'Anda sudah absen in',
                                    warna: "merah");
                              }

                              provider.setIsLate(false);
                              provider.setInOut('IN');

                              DateTime now = await NTP.now();
                              int nowInMinutes = now.hour * 60 + now.minute;

                              var hourMasuk =
                                  int.parse(jamMasuk.substring(0, 2));

                              var menitMasuk =
                                  int.parse(jamMasuk.substring(3, 5));

                              TimeOfDay testDate = TimeOfDay(
                                  hour: hourMasuk, minute: menitMasuk);
                              int testDateInMinutes =
                                  testDate.hour * 60 + testDate.minute;

                              Navigator.pop(context);
                              if (nowInMinutes >= testDateInMinutes) {
                                provider.setIsLate(true);
                                alasan("You're late", 'IN', context);
                              } else {
                                goToCabangOption("", 'IN');
                              }
                            }),
                        GestureDetector(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      // color: Colors.black12,
                                      image: DecorationImage(
                                          image: AssetImage(
                                              "assets/images/out.png"),
                                          fit: BoxFit.cover),
                                    )),
                                SizedBox(height: 4),
                                Text(
                                  "OUT",
                                  style: TextStyle(
                                    color: Color(0xff171111),
                                    fontSize: 20,
                                    fontFamily: "Sansation Light",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "EXPECTED : ",
                                      style: TextStyle(
                                        color: Color(0xff171111),
                                        fontSize: 14,
                                        fontFamily: "Sansation Light",
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      jamKeluar,
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 14,
                                        fontFamily: "Sansation Light",
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                absenOut != '-'
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "ACTUAL : ",
                                            style: TextStyle(
                                              color: Color(0xff171111),
                                              fontSize: 14,
                                              fontFamily: "Sansation Light",
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            absenOut,
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 14,
                                              fontFamily: "Sansation Light",
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Text(
                                        '',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 14,
                                          fontFamily: "Sansation Light",
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                              ],
                            ),
                            onTap: () async {
                              alasanController.text = '';
                              if (absenOut != '-') {
                                return WidgetSnackbar(
                                    context: context,
                                    message: 'Anda sudah absen out',
                                    warna: "merah");
                              }
                              provider.setIsLate(false);
                              provider.setInOut('OUT');
                              DateTime now = await NTP.now();
                              int nowInMinutes = now.hour * 60 + now.minute;

                              var hourMasuk =
                                  int.parse(jamKeluar.substring(0, 2));

                              var menitMasuk =
                                  int.parse(jamKeluar.substring(3, 5));

                              TimeOfDay testDate = TimeOfDay(
                                  hour: hourMasuk, minute: menitMasuk);
                              int testDateInMinutes =
                                  testDate.hour * 60 + testDate.minute;

                              Navigator.pop(context);
                              if (nowInMinutes <= testDateInMinutes) {
                                provider.setIsLate(true);
                                alasan("You're out too early", 'OUT', context);
                              } else {
                                goToCabangOption("", 'OUT');
                              }
                            }),
                      ],
                    ),
                  )),
            );
          });
        });
  }

  Future alasan(String title, String inOut, BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: Text(title),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: alasanController,
                      decoration: InputDecoration(
                        labelText: 'input reason here . .',
                        icon: Icon(Icons.notes),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              Consumer<ProviderCabang>(builder: (context, provider, _) {
                // ignore: deprecated_member_use
                return ElevatedButton(
                    child: Text("Submit"),
                    onPressed: () async {
                      if (alasanController.text == '') {
                        WidgetSnackbar(
                            context: context,
                            message: 'Mohon isi alasan anda',
                            warna: "merah");
                      } else {
                        Navigator.pop(context);
                        goToCabangOption(alasanController.text, inOut);
                      }
                    });
              })
            ],
          );
        });
  }

  void goToCabangOption(String alasan, String inOut) {
    String jamAbsenWajib = jamAbsenWajibIn;
    if (inOut.toLowerCase() == 'out') {
      jamAbsenWajib = jamAbsenWajibOut;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => ListCabang(
            alasan: alasan, idShift: idShift, jamAbsenWajib: jamAbsenWajib),
      ),
    );
  }

  basicStatusCheck(NewVersion newVersion) {
    newVersion.showAlertIfNecessary(context: context);
  }

  advancedStatusCheck(NewVersion newVersion) async {
    final status = await newVersion.getVersionStatus();
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (status != null) {
      var newVersionStore = status.storeVersion.toString();
      var newVersionServer = pref.getString("PREF_NEWVERSION")!;
      var newVersionForce = pref.getString("PREF_NEWVERSION_FORCE")!;
      bool allowDismissal = true;
      if (newVersionStore.toLowerCase() == newVersionServer.toLowerCase()) {
        if (newVersionForce == '1') {
          allowDismissal = false;
        }
      }
      var oldNewVersion = "";
      oldNewVersion += "\n\nOld : v" + status.localVersion;
      oldNewVersion += "\nNew : v" + status.storeVersion;
      if (status.canUpdate)
        newVersion.showUpdateDialog(
            context: context,
            updateButtonText: "UPDATE",
            versionStatus: status,
            dialogTitle: 'Update Version',
            dialogText:
                'Versi Aplikasi terbaru sudah tersedia, silakan update untuk menikmati fitur-fitur menarik' +
                    oldNewVersion,
            allowDismissal: allowDismissal,
            dismissButtonText: 'NANTI');
    }
  }

  @override
  void initState() {
    super.initState();
    _permissionRequest();
    final newVersion = NewVersion(
      iOSId: 'id.galeritekno.speederp001',
      androidId: 'com.galeritekno.speederp',
    );
    // _getAndroidStoreVersion();
    Timer.periodic(Duration(seconds: 1), (Timer t) => safeDevice());
    getData();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: ColorsTheme.primary1));
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 1.5;
    final double itemWidth = size.width / 1.3;

    return loading
        ? WidgetLoadingPage()
        : failed
            ? WidgetErrorConnection(
                onRetry: () {
                  setState(() {
                    getData();
                  });
                },
                remarks: remakrs)
            : RefreshIndicator(
                onRefresh: () => getData(),
                child: Scaffold(
                  backgroundColor: Colors.white,
                  body: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 1,
                          height: 219,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(0),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(0),
                              ),
                              color: ColorsTheme.primary1),
                        ),
                        online(),
                        profile(),
                        cardAbsenHariIni(),
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.32,
                              left: MediaQuery.of(context).size.width * 0.05,
                              right: MediaQuery.of(context).size.width * 0.05),
                          child: Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: GridView.count(
                                  primary: true,
                                  shrinkWrap: true,
                                  childAspectRatio: (itemWidth / itemHeight),
                                  physics: NeverScrollableScrollPhysics(),
                                  crossAxisCount: 4,
                                  children: <Widget>[
                                    GestureDetector(
                                        onTap: () {
                                          if (!permissionLocation &&
                                              Platform.isAndroid) {
                                            _permissionRequest();
                                          } else {
                                            if (!canMockLocation) {
                                              if (shiftJamMasuk != '' &&
                                                  shiftJamKeluar != '') {
                                                _modalBottomSheet(shiftJamMasuk,
                                                    shiftJamKeluar);
                                              } else {
                                                WidgetSnackbar(
                                                    context: context,
                                                    message:
                                                        'Anda tidak mempunyai Shift / Jadwal Kerja. Harap Hubungi HR / Atasan anda',
                                                    warna: "merah");
                                              }
                                            }
                                          }
                                        },
                                        child: card('Absen',
                                            "assets/images/absen.png")),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MenuAbsen()));
                                      },
                                      child: card('Riwayat Absen',
                                          "assets/images/riwayatabsen.png"),
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MenuOvertime()));
                                        },
                                        child: Badge(
                                          showBadge:
                                              badgeLembur == '0' ? false : true,
                                          padding: EdgeInsets.all(
                                              badgeLembur.length == 1
                                                  ? 6.5
                                                  : 5),
                                          position: BadgePosition.topEnd(
                                              top: badgeTop, end: badgeEnd),
                                          badgeColor: Colors.red,
                                          badgeContent: Text(
                                            badgeLembur,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: badgeSizeFont),
                                          ),
                                          child: card('Lembur',
                                              "assets/images/lembur.png"),
                                        )),
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MenuIzin()));
                                        },
                                        child: Badge(
                                          showBadge:
                                              badgeIzin == '0' ? false : true,
                                          padding: EdgeInsets.all(
                                              badgeIzin.length == 1 ? 6.5 : 5),
                                          position: BadgePosition.topEnd(
                                              top: badgeTop, end: badgeEnd),
                                          badgeColor: Colors.red,
                                          badgeContent: Text(
                                            badgeIzin,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: badgeSizeFont),
                                          ),
                                          child: card(
                                              'Izin', "assets/images/izin.png"),
                                        )),
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MenuCuti()));
                                        },
                                        child: Badge(
                                          showBadge:
                                              badgeCuti == '0' ? false : true,
                                          position: BadgePosition.topEnd(
                                              top: badgeTop, end: badgeEnd),
                                          badgeColor: Colors.red,
                                          padding: EdgeInsets.all(
                                              badgeLembur.length == 1
                                                  ? 6.5
                                                  : 5),
                                          badgeContent: Text(
                                            badgeCuti,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: badgeSizeFont),
                                          ),
                                          child: card(
                                              'Cuti', "assets/images/cuti.png"),
                                        )),
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ListShift()));
                                        },
                                        child: card('My Shift',
                                            "assets/images/shift.png")),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8),
                              Padding(
                                padding: EdgeInsets.all(4),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: statusShift
                                              ? ColorsTheme.hijau
                                                  .withOpacity(0.3)
                                              : ColorsTheme.merah
                                                  .withOpacity(0.3)),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4)),
                                      color: statusShift
                                          ? ColorsTheme.hijau.withOpacity(0.1)
                                          : ColorsTheme.merah.withOpacity(0.1)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Informasi Jadwal Kerja Hari Ini",
                                            style: const TextStyle(
                                                // color: ColorsTheme.text2,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold)),
                                        Divider(height: 2),
                                        Text(remarksShift,
                                            style: const TextStyle(
                                              color: ColorsTheme.text1,
                                              fontSize: 12,
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
  }

  Widget card(String data, String path) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          // Card(
          //   elevation: 0.5,
          //   child: Padding(
          //       padding: const EdgeInsets.all(8),
          //       child: Image.asset(path, width: MediaQuery.of(context).size.width * 0.2)),
          // ),
          Padding(
              padding: const EdgeInsets.all(8),
              child: Image.asset(path,
                  width: MediaQuery.of(context).size.width * 0.15)),

          Text(data,
              style: const TextStyle(
                color: ColorsTheme.text1,
                fontSize: 10,
                fontFamily: "Sansation Light",
              ))
        ]);
  }
}

/// Draws a circle if placed into a square widget.
class CirclePainter extends CustomPainter {
  final _paint = Paint()
    ..color = Colors.grey.withOpacity(0.4)
    ..strokeWidth = 5
    // Use [PaintingStyle.fill] if you want the circle to be filled.
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawOval(
      Rect.fromLTWH(0, 0, size.width, size.height),
      _paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
