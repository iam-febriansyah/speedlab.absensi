import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/api/api_service.dart';
import 'package:flutter_application_1/models/login/post.dart';
import 'package:flutter_application_1/pages/auth/login.dart';
import 'package:flutter_application_1/pages/general_widget/widget_snackbar.dart';
import 'package:flutter_application_1/pages/main_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/style/colors.dart';
import 'package:flutter_application_1/style/sizes.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool connected = true;
  DevService _devService = DevService();
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  String deviceId = "";
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  String version = "";
  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      version = info.version;
    });
  }

  checkConnection() async {
    if (mounted) ToastContext().init(context);
    try {
      final result = await InternetAddress.lookup('smarterp.speedlab.id');
      if (mounted) if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          connected = true;
        });
      }
    } on SocketException catch (_) {
      Toast.show("Internet not available", duration: 4, gravity: Toast.bottom);
    }
  }

  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var duration = const Duration(seconds: 3);
    return Timer(duration, () async {
      if (preferences.getString("PREF_TOKEN") == null ||
          preferences.getString("PREF_TOKEN") == "") {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginPage()),
            (Route<dynamic> route) => false);
      } else {
        updateDeviceId();
      }
    });
  }

  updateDeviceId() async {
    PostDeviceId post = new PostDeviceId();
    post.deviceId = deviceId;
    post.deviceDesc = _deviceData.toString();
    post.ostype = Platform.isAndroid ? 'android' : 'ios';
    post.version = version;
    SharedPreferences pref = await SharedPreferences.getInstance();
    print(pref.getString("PREF_TOKEN")!);
    _devService
        .updateDeviceId(pref.getString("PREF_TOKEN")!, post)
        .then((value) async {
      var res = json.decode(value);
      var status_json = res['status_json'];
      var remarks = res['remarks'];
      var informasi = res['informasi'];
      var versionandroid = res['versionandroid'];
      var versionios = res['versionios'];
      var useface = res['useface'];
      if (Platform.isAndroid) {
        pref.setString("PREF_NEWVERSION",
            versionandroid != null ? versionandroid['version'] : '');
        pref.setString(
            "PREF_NEWVERSION_FORCE",
            versionandroid != null
                ? versionandroid['force_update'].toString()
                : '0');
      } else {
        pref.setString(
            "PREF_NEWVERSION", versionios != null ? versionios['version'] : '');
        pref.setString("PREF_NEWVERSION_FORCE",
            versionios != null ? versionios['force_update'].toString() : '0');
      }

      pref.setString("PREF_INFO", informasi!);
      pref.setString("PREF_DEVICEID", deviceId);
      pref.setBool("PREF_USEFACE", useface);
      if (!status_json) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginPage()),
            (Route<dynamic> route) => false);
        WidgetSnackbar(context: context, message: remarks, warna: "merah");
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => MainMenu()),
            (Route<dynamic> route) => false);
      }
    }).catchError((onError) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false);
      WidgetSnackbar(context: context, message: "Please login", warna: "merah");
    });
    ;
  }

  Future<void> initPlatformState() async {
    var deviceData = <String, dynamic>{};
    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }
    if (!mounted) return;
    setState(() {
      _deviceData = deviceData;
    });
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    setState(() {
      deviceId = build.id.toString();
    });
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    setState(() {
      deviceId = data.identifierForVendor.toString();
    });
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  @override
  void initState() {
    super.initState();
    getData();
    _initPackageInfo();
    initPlatformState();
    checkConnection();
    Timer.periodic(Duration(seconds: 1), (Timer t) => checkConnection());
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        statusBarColor: ColorsTheme.primary1,
        statusBarBrightness: Brightness.light));
    return Scaffold(
        body: Container(
            width: MediaQuery.of(context).size.width * 1,
            height: MediaQuery.of(context).size.height * 1,
            color: Colors.white,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                  Align(
                      alignment: Alignment.center,
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: Image.asset("assets/launcher/launcher.png"))),
                  Text(
                    "SpeedERP",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColorsTheme.text1,
                      fontSize: 42,
                      fontFamily: "Sansation Light",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.2),
                    child: Text(
                      "for Employee",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Sansation Light",
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                  Text(
                    "Powered by\nPT. GALERI TEKNOLOGI BERSAMA",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColorsTheme.text1,
                      fontSize: 12,
                      fontFamily: "Sansation Light",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )));
  }
}
