import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/api/api_service.dart';
import 'package:flutter_application_1/models/login/post.dart';
import 'package:flutter_application_1/models/login/return.dart';
import 'package:flutter_application_1/models/return_check.dart';
import 'package:flutter_application_1/pages/general_widget/widget_snackbar.dart';
import 'package:flutter_application_1/pages/main_menu.dart';
import 'package:flutter_application_1/style/colors.dart';
import 'package:flutter_application_1/style/sizes.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../general_widget/widget_progress.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController ctrlemail = new TextEditingController();
  TextEditingController ctrlPassword = new TextEditingController();
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  String deviceId = "";
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  DevService _devService = DevService();

  Future submitLogin(BuildContext context, ReturnLogin returnLogin) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    // showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (BuildContext context) => WidgetProgressSubmit());
    //ModelPostLogin dataSubmit = new ModelPostLogin();
    //  dataSubmit.username = ctrlemail.text;
    //  dataSubmit.password = ctrlPassword.text;
    // getClient().postLogin(dataSubmit).then((res) async {
    //   Navigator.pop(context);
    //   if (res.statusJson!) {

    if (returnLogin.dataUser != null) {
      var firstname = returnLogin.dataUser?.firstName ?? "";
      var lastname = returnLogin.dataUser?.lastName ?? "";

      pref.setString("PREF_TOKEN", returnLogin.token!);
      pref.setString("PREF_URLFACE", returnLogin.urlFace!);
      pref.setString("PREF_ID_USER", returnLogin.dataUser!.userId!);
      pref.setString("PREF_USERNAME", returnLogin.dataUser!.username!);
      pref.setString("PREF_EMAIL", returnLogin.dataUser!.email!);
      pref.setString("PREF_NIP", returnLogin.dataUser?.staffId ?? "");
      pref.setString("PREF_NIK", returnLogin.dataUser?.nik ?? "");
      pref.setString("PREF_NAMA", firstname + " " + lastname);
      pref.setString("PREF_JK", "unknown");
      pref.setString(
          "PREF_TEMPAT_LAHIR", returnLogin.dataUser?.birthPlace ?? "");
      pref.setString(
          "PREF_TANGGAL_LAHIR", returnLogin.dataUser?.birthDay ?? "");
      pref.setString("PREF_ALAMAT", returnLogin.dataUser?.address ?? "");
      pref.setString("PREF_RT", "unknown");
      pref.setString("PREF_RW", "unknown");
      pref.setString("PREF_DESA", "unknown");
      pref.setString("PREF_KECAMATAN", "unknown");
      pref.setString("PREF_KOTA", "unknown");
      pref.setString("PREF_PROVINSI", "unknown");
      pref.setString("PREF_DEPARTEMEN", returnLogin.dataUser?.division ?? "");
      pref.setString("PREF_POSISI", returnLogin.dataUser?.position ?? "");
      pref.setString("PREF_FACE", returnLogin.dataUser?.facedata ?? "");
      pref.setString("PREF_FOTO", returnLogin.dataUser?.foto ?? "");
      pref.setString(
          "PREF_JARAK", returnLogin.dataUser?.radius.toString() ?? "");
      pref.setString(
          "PREF_LATITUDE", returnLogin.dataUser?.latitude.toString() ?? "");

      pref.setString(
          "PREF_LONGITUDE", returnLogin.dataUser?.longitude.toString() ?? "");

      pref.setString(
          "PREF_FACE_IOS", returnLogin.dataUser?.faceIos.toString() ?? "");

      pref.setString("PREF_FACE_ANDROID",
          returnLogin.dataUser?.faceAndroid.toString() ?? "");

      pref.setString(
          "PREF_SECTION_ID", returnLogin.dataUser?.section_id ?? "0");
      updateDeviceId();
    } else {
      WidgetSnackbar(
          context: context, message: returnLogin.remarks!, warna: "merah");
    }
  }

  String version = "";
  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      version = info.version;
    });
  }

  updateDeviceId() async {
    PostDeviceId post = new PostDeviceId();
    post.deviceId = deviceId;
    post.deviceDesc = _deviceData.toString();
    post.ostype = Platform.isAndroid ? 'android' : 'ios';
    post.version = version;
    SharedPreferences pref = await SharedPreferences.getInstance();
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
        navigateToHome();
      }
    });
  }

  checkMandatory() {
    if (ctrlemail.text.isEmpty) {
      return "Silakan isi Email";
    } else if (ctrlPassword.text.isEmpty) {
      return "Silakan isi Password";
    } else {
      return "";
    }
  }

  clearPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

  navigateToHome() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MainMenu()),
        (Route<dynamic> route) => false);
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
    initPlatformState();
    super.initState();
    clearPref();
    _initPackageInfo();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        statusBarColor: ColorsTheme.primary1,
        statusBarBrightness: Brightness.light));

    SizeConfig().init(context);
    return Scaffold(
      body: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Image.asset(
                      "assets/ilustration/login.png",
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width * 0.7,
                    ),
                  ),
                  Center(
                    child: Container(
                      child: Text(
                        "SpeedERP For Employee",
                        style: TextStyle(
                            fontFamily: 'BalsamiqSans',
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.075,
                  ),

                  //email FIELD
                  Padding(
                    padding: EdgeInsets.only(
                        left: SizeConfig.screenLeftRight3,
                        right: SizeConfig.screenLeftRight3),
                    child: Container(
                      decoration: BoxDecoration(
                        color: ColorsTheme.background2,
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: SizeConfig.screenLeftRight1,
                            right: SizeConfig.screenLeftRight1),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.email),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: TextField(
                                controller: ctrlemail,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Email'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  //PASSWORD FIELD
                  Padding(
                    padding: EdgeInsets.only(
                        left: SizeConfig.screenLeftRight3,
                        right: SizeConfig.screenLeftRight3),
                    child: Container(
                      decoration: BoxDecoration(
                        color: ColorsTheme.background2,
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.only(left: SizeConfig.screenLeftRight1),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.lock),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: TextField(
                                controller: ctrlPassword,
                                obscureText: true,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Password'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: SizeConfig.screenLeftRight3,
                        right: SizeConfig.screenLeftRight3),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.06,
                        // ignore: deprecated_member_use
                        child: ElevatedButton(
                          onPressed: () {
                            String check = checkMandatory();
                            if (check == "") {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) =>
                                      WidgetProgressSubmit());
                              _devService
                                  .login(ctrlemail.text, ctrlPassword.text)
                                  .then((value) {
                                var res =
                                    ReturnCheck.fromJson(json.decode(value));

                                if (res.statusJson == true) {
                                  var data =
                                      ReturnLogin.fromJson(json.decode(value));
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  submitLogin(context, data);
                                } else {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  WidgetSnackbar(
                                      context: context,
                                      message: res.remarks!,
                                      warna: "merah");
                                }
                              });
                            } else {
                              FocusScope.of(context).requestFocus(FocusNode());
                              WidgetSnackbar(
                                  context: context,
                                  message: check,
                                  warna: "merah");
                            }
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  ColorsTheme.primary1),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ))),
                          child: Text(
                            "LOGIN",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: SizeConfig.fontSize4),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.015,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.015,
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
