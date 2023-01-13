import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/api/api_service.dart';
import 'package:flutter_application_1/models/absen/post.dart';
import 'package:flutter_application_1/models/absen/return.dart';
import 'package:flutter_application_1/models/menu/cls_absen_hari_ini.dart';
import 'package:flutter_application_1/pages/general_widget/widget_progress.dart';
import 'package:flutter_application_1/pages/general_widget/widget_snackbar.dart';
import 'package:flutter_application_1/pages/main_menu.dart';
import 'package:flutter_application_1/style/colors.dart';
import 'package:flutter_application_1/style/sizes.dart';
import 'package:ntp/ntp.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AbsenCamera extends StatefulWidget {
  final Absen absen;
  final List<CameraDescription> cameras;
  const AbsenCamera({Key? key, required this.absen, required this.cameras})
      : super(key: key);

  @override
  State<AbsenCamera> createState() => _AbsenCameraState();
}

class _AbsenCameraState extends State<AbsenCamera> {
  bool loading = false;
  bool failed = false;
  String remakrs = '';
  DevService _devService = DevService();
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  int selectedCamera = 1;

  initializeCamera(int cameraIndex) async {
    if (widget.cameras.length < 1) {
      cameraIndex = 0;
    }
    _controller = CameraController(
        widget.cameras[cameraIndex], ResolutionPreset.medium,
        enableAudio: false);
    _initializeControllerFuture = _controller.initialize();
    setState(() {
      loading = false;
    });
  }

  void ambilGambar() async {
    await _initializeControllerFuture;
    var xFile = await _controller.takePicture();
    File file = File(xFile.path);
    var bytes = file.readAsBytesSync();
    String base64Image = base64.encode(bytes);
    String extWidthBase64 = "${base64Image}";
    // print(extWidthBase64);
    absenNow(extWidthBase64);
  }

  String timezone = "";
  String timezoneoffset = "";
  getTimeZone() async {
    DateTime dateTime = await NTP.now();
    setState(() {
      timezone = dateTime.timeZoneName;
      timezoneoffset = dateTime.timeZoneOffset.toString();
    });
  }

  void absenNow(String base64) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => WidgetProgressSubmit());

    final PackageInfo info = await PackageInfo.fromPlatform();
    SharedPreferences pref = await SharedPreferences.getInstance();
    var deviceid = pref.getString("PREF_DEVICEID")!;

    PostAbsen postAbsen = new PostAbsen();
    postAbsen.tipe_absen = widget.absen.tipeAbsen;
    postAbsen.datang_pulang = widget.absen.datangPulang;
    postAbsen.wfh_wfo = widget.absen.wfhWfo;
    postAbsen.tanggal_absen = widget.absen.tanggalAbsen;
    postAbsen.jam_absen = widget.absen.jamAbsen;
    postAbsen.lokasi = widget.absen.lokasi;
    postAbsen.latitude = widget.absen.latitude;
    postAbsen.longitude = widget.absen.longitude;
    postAbsen.keterangan = widget.absen.keterangan;
    postAbsen.cabang_id = widget.absen.cabang_id;
    postAbsen.section_id = widget.absen.section_id;
    postAbsen.timezone = timezone;
    postAbsen.timezoneoffset = timezoneoffset;
    postAbsen.deviceid = deviceid;
    postAbsen.foto = base64;
    postAbsen.id_shift = widget.absen.id_shift;
    postAbsen.jam_absen_wajib = widget.absen.jam_absen_wajib;
    // ignore: unnecessary_null_comparison
    postAbsen.version = info.version == null ? "" : info.version;
    ReturnAbsen absen = await _devService
        .absenNewV2(pref.getString("PREF_TOKEN")!, postAbsen)
        .then((value) async {
      return ReturnAbsen.fromJson(json.decode(value));
    });
    Navigator.of(context).pop();
    if (absen.status_json!) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => MainMenu()),
          (Route<dynamic> route) => false);
      WidgetSnackbar(context: context, message: absen.remarks!, warna: "hijau");
    } else {
      WidgetSnackbar(context: context, message: absen.remarks!, warna: "merah");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    initializeCamera(selectedCamera);
    getTimeZone();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Foto Diri Di Lokasi Kerja"),
          elevation: 0,
          backgroundColor: ColorsTheme.primary1,
        ),
        body: loading
            ? Center(child: CupertinoActivityIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  FutureBuilder<void>(
                    future: _initializeControllerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return CameraPreview(_controller);
                      } else {
                        return Center(child: CupertinoActivityIndicator());
                      }
                    },
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: IconButton(
                              onPressed: () {
                                if (widget.cameras.length > 1) {
                                  setState(() {
                                    selectedCamera =
                                        selectedCamera == 0 ? 1 : 0;
                                    initializeCamera(selectedCamera);
                                  });
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text('No secondary camera found'),
                                    duration: const Duration(seconds: 2),
                                  ));
                                }
                              },
                              icon: Icon(Icons.switch_camera_rounded,
                                  color: ColorsTheme.primary1),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              ambilGambar();
                            },
                            child: Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: ColorsTheme.primary1,
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.1)
                        ],
                      ),
                    ),
                  ),
                ],
              ));
    ;
  }
}
