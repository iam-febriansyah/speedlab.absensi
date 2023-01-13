// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';

// import 'package:easy_permission_validator/easy_permission_validator.dart';
// import 'package:flutter_application_1/pages/menu/_deleted_menu_cabang.dart';
// import 'package:flutter_application_1/api/api_service.dart';
// import 'package:flutter_application_1/models/absenhari/return.dart';
// import 'package:flutter_application_1/models/database.dart';
// import 'package:flutter_application_1/models/listabsen/return.dart';
// import 'package:flutter_application_1/models/menu/cls_absen_hari_ini.dart';
// import 'package:flutter_application_1/models/shift/return.dart';
// import 'package:flutter_application_1/pages/general_widget/widget_error.dart';
// import 'package:flutter_application_1/pages/general_widget/widget_loading_page.dart';
// import 'package:flutter_application_1/pages/general_widget/widget_snackbar.dart';
// import 'package:flutter_application_1/pages/menu/_deleted_sign-up.dart';
// import 'package:flutter_application_1/provider/provider.cabang.dart';
// import 'package:flutter_application_1/style/colors.dart';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:get/get.dart';
// // ignore: import_of_legacy_library_into_null_safe
// import 'package:intl/intl.dart';
// // ignore: import_of_legacy_library_into_null_safe
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
// import 'package:new_version/new_version.dart';
// import 'package:ntp/ntp.dart';
// // ignore: unused_import
// import 'package:package_info/package_info.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class OldMenuHome extends StatefulWidget {
//   @override
//   _OldMenuHomeState createState() => _OldMenuHomeState();
// }

// class _OldMenuHomeState extends State<OldMenuHome> {
//   final alasanController = TextEditingController();
//   bool connected = true;
//   bool loading = false;
//   bool failed = false;
//   String remakrs = '';
//   String nama = '';
//   String departemen = '';
//   String posisi = '';
//   String nip = '';
//   String hari = '';
//   String tanggal = '';
//   String bulantahun = '';
//   String imageProfil =
//       'https://cdn-icons-png.flaticon.com/512/3011/3011270.png';
//   ReturnAbsenHariAbsen_in? absenIn;
//   ReturnAbsenHariAbsen_out? absenOut;

//   // FaceNetService _faceNetService = FaceNetService();
//   // MLKitService _mlKitService = MLKitService();
//   // ignore: unused_field
//   DataBaseService _dataBaseService = DataBaseService();

//   DevService _devService = DevService();

//   late CameraDescription cameraDescription;
//   var faceData;
//   List<Absen> dataAbsen = [];
//   String hariKalender = "0";
//   String hadir = "0";
//   String sakit = "0";
//   String cuti = "0";
//   String efektif = "0";
//   String harioff = "0";
//   String izin = "0";
//   String tugas = "0";
//   String mangkir = "0";
//   String count = "0.0";
//   String bulan = "Januari";
//   String tahun = "2021";
//   var informasi = '';
//   bool canMockLocation = false;
//   String canMockLocationString = "ABSEN SEKARANG";

//   bool permissionLocation = false;
//   void safeDevice() async {
//     checkConnection();
//     if (Platform.isAndroid) {
//       bool isMock = false;
//       if (mounted)
//         setState(() {
//           canMockLocation = isMock;
//           if (canMockLocation) {
//             canMockLocationString = "Please Disable Your Fake GPS";
//           } else {
//             canMockLocationString = "ABSEN SEKARANG";
//           }
//         });
//     }
//   }

//   checkConnection() async {
//     try {
//       final result = await InternetAddress.lookup('smarterp.speedlab.id');
//       if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//         if (mounted)
//           setState(() {
//             connected = true;
//           });
//       }
//     } on SocketException catch (_) {
//       connected = false;
//     }
//   }

//   String version = "";
//   Future<void> _initPackageInfo() async {
//     final PackageInfo info = await PackageInfo.fromPlatform();
//     setState(() {
//       version = info.version;
//     });
//   }

//   Future getData() async {
//     _initPackageInfo();
//     startUp();
//     setState(() {
//       loading = true;
//       failed = false;
//     });
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     var accesToken = pref.getString("PREF_TOKEN")!;
//     informasi = pref.getString("PREF_INFO")!;
//     faceData = pref.getString("PREF_FACE")!;
//     var f = pref.getString("PREF_FOTO");
//     if (f != null) {
//       imageProfil = pref.getString("PREF_FOTO")!;
//     }
//     _devService.absenhariini(accesToken).then((value) async {
//       var res = ReturnAbsenHari.fromJson(json.decode(value));

//       if (res.status_json == true) {
//         if (mounted)
//           setState(() {
//             hari = res.hari!;
//             tanggal = res.tanggal!;
//             bulantahun = res.bulantahun!;
//             absenIn = res.absen_in;
//             absenOut = res.absen_out;
//             nama = pref.getString("PREF_NAMA")!;
//             departemen = pref.getString("PREF_DEPARTEMEN")!;
//             posisi = pref.getString("PREF_POSISI")!;
//             nip = pref.getString("PREF_NIP")!;

//             loading = false;
//             failed = false;
//           });
//       } else {
//         setState(() {
//           loading = false;
//           failed = true;
//           remakrs = res.remarks!;
//         });
//       }
//     });

//     _devService.listabsen(accesToken).then((value) async {
//       var res = ReturnListAbsen.fromJson(json.decode(value));
//       if (res.status_json == true) {
//         DateTime now = await NTP.now();
//         String day = DateFormat('d').format(now);
//         String month = DateFormat('M').format(now);
//         String year = DateFormat('y').format(now);

//         tahun = year;

//         if (month == "1") {
//           bulan = "Januari";
//         }
//         if (month == "2") {
//           bulan = "Februari";
//         }
//         if (month == "3") {
//           bulan = "Maret";
//         }
//         if (month == "4") {
//           bulan = "April";
//         }
//         if (month == "5") {
//           bulan = "Mei";
//         }
//         if (month == "6") {
//           bulan = "Juni";
//         }
//         if (month == "7") {
//           bulan = "Juli";
//         }
//         if (month == "8") {
//           bulan = "Agustus";
//         }
//         if (month == "9") {
//           bulan = "September";
//         }
//         if (month == "10") {
//           bulan = "Oktober";
//         }
//         if (month == "11") {
//           bulan = "November";
//         }
//         if (month == "12") {
//           bulan = "Desember";
//         }

//         int hadir_ = 0;

//         res.listabsen?.forEach((val) {
//           DateTime parseDate = DateTime.parse(val?.tanggal_absen ?? "");
//           String formatMonth = DateFormat('M').format(parseDate);

//           if (month == formatMonth && val?.datang_pulang == "in") {
//             hadir_ = hadir_ + 1;
//           }
//         });

//         setState(() {
//           hariKalender = day;
//           hadir = hadir_.toString();

//           double kehadiran =
//               double.parse(hadir) / double.parse(hariKalender) * 100;

//           if (kehadiran.toString() == "0.0") {
//           } else {
//             int lenKehadiran = kehadiran.toString().length;
//             int lengthPercen = lenKehadiran > 5 ? 5 : lenKehadiran;
//             count = kehadiran.toString().substring(0, lengthPercen);
//           }
//         });
//       }
//     });
//   }

//   _permissionRequest() async {
//     final permissionValidator = EasyPermissionValidator(
//       context: context,
//       appName: 'Speedlab Mobile Employee',
//     );
//     var result = await permissionValidator.location();
//     await permissionValidator.camera();
//     if (result) {
//       permissionLocation = true;
//     } else {
//       permissionLocation = false;
//       _permissionRequest();
//     }
//     setState(() {
//       permissionLocation = permissionLocation;
//     });
//   }

//   void startUp() async {
//     List<CameraDescription> cameras = await availableCameras();
//     cameraDescription = cameras.firstWhere(
//       (CameraDescription camera) =>
//           camera.lensDirection == CameraLensDirection.front,
//     );
//   }

//   Widget online() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Container(
//         width: SizeConfig.screenWidth * 1,
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.end,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             SizedBox(
//               width: 51,
//               height: 16,
//               child: Text(
//                 'v' + version,
//                 textAlign: TextAlign.right,
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 14,
//                   fontFamily: "Sansation Light",
//                   fontWeight: FontWeight.w300,
//                 ),
//               ),
//             ),
//             SizedBox(
//               width: 51,
//               height: 16,
//               child: Text(
//                 connected ? "Online" : "Offline",
//                 textAlign: TextAlign.right,
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 14,
//                   fontFamily: "Sansation Light",
//                   fontWeight: FontWeight.w300,
//                 ),
//               ),
//             ),
//             SizedBox(width: 7),
//             Container(
//               width: 15,
//               height: 15,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: connected ? Color(0xff08cc04) : Colors.red,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget profile() {
//     return Padding(
//       padding: EdgeInsets.only(top: 32, left: 16),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 width: 40,
//                 height: 40,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: Border.all(
//                     color: Color(0xffd6d2d2),
//                     width: 1,
//                   ),
//                   color: Colors.white,
//                 ),
//                 child: CircleAvatar(
//                   radius: SizeConfig.screenWidth * 0.2,
//                   backgroundImage: NetworkImage(imageProfil),
//                   // fit: BoxFit.,
//                   backgroundColor: Colors.transparent,
//                 ),
//               ),
//               SizedBox(width: 16),
//               Container(
//                 child: Text(
//                   "Hi, " + nama,
//                   textAlign: TextAlign.right,
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontFamily: "Sansation Light",
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Padding(
//             padding: EdgeInsets.only(top: 16),
//             child: Container(
//               child: Text(
//                 nip,
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontFamily: "Sansation Light",
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//           ),
//           // Padding(
//           //   padding: EdgeInsets.only(top: 4),
//           //   child: Container(
//           //     child: Text(
//           //       posisi!,
//           //       style: TextStyle(
//           //         color: Color(0xff171111),
//           //         fontSize: 14,
//           //         fontFamily: "Sansation Light",
//           //       ),
//           //     ),
//           //   ),
//           // ),
//           // Padding(
//           //   padding: EdgeInsets.only(top: 4),
//           //   child: Container(
//           //     child: Text(
//           //       "Dept : " + departemen!,
//           //       style: TextStyle(
//           //         color: Color(0xff171111),
//           //         fontSize: 14,
//           //         fontFamily: "Sansation Light",
//           //       ),
//           //     ),
//           //   ),
//           // ),
//         ],
//       ),
//     );
//   }

//   Widget thismonth(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: EdgeInsets.only(top: SizeConfig.screenHeight * 0.40),
//         child: Container(
//           width: MediaQuery.of(context).size.width * 0.95,
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   Expanded(
//                     flex: 2,
//                     child: Card(
//                         elevation: 1,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         child: Container(
//                           height: 60,
//                           child: Center(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   hariKalender,
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 18),
//                                 ),
//                                 SizedBox(
//                                   height: 5,
//                                 ),
//                                 Text("Hari Kalender",
//                                     style: TextStyle(fontSize: 12))
//                               ],
//                             ),
//                           ),
//                         )),
//                   ),
//                   Expanded(
//                     flex: 1,
//                     child: Card(
//                         elevation: 1,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         child: Container(
//                           height: 60,
//                           child: Center(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   hadir,
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 18),
//                                 ),
//                                 SizedBox(
//                                   height: 5,
//                                 ),
//                                 Text("Hadir", style: TextStyle(fontSize: 12))
//                               ],
//                             ),
//                           ),
//                         )),
//                   ),
//                   Expanded(
//                     flex: 1,
//                     child: Card(
//                         elevation: 1,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         child: Container(
//                           height: 60,
//                           child: Center(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   "0",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 18),
//                                 ),
//                                 SizedBox(
//                                   height: 5,
//                                 ),
//                                 Text("Sakit", style: TextStyle(fontSize: 12))
//                               ],
//                             ),
//                           ),
//                         )),
//                   ),
//                   Expanded(
//                     flex: 1,
//                     child: Card(
//                         elevation: 1,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         child: Container(
//                           height: 60,
//                           child: Center(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   "0",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 18),
//                                 ),
//                                 SizedBox(
//                                   height: 5,
//                                 ),
//                                 Text("Cuti", style: TextStyle(fontSize: 12))
//                               ],
//                             ),
//                           ),
//                         )),
//                   ),
//                   Expanded(
//                     flex: 1,
//                     child: Card(
//                         elevation: 1,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         child: Container(
//                           height: 60,
//                           child: Center(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   "0",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 18),
//                                 ),
//                                 SizedBox(
//                                   height: 5,
//                                 ),
//                                 Text("Izin", style: TextStyle(fontSize: 12))
//                               ],
//                             ),
//                           ),
//                         )),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 15,
//               ),
//               Row(
//                 // mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   SizedBox(width: 4),
//                   Expanded(
//                     child: Padding(
//                       padding: EdgeInsets.only(right: 10),
//                       child: Container(
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(4),
//                             // border: Border.all(color: Colors.red),
//                             color: Colors.grey),
//                         child: Padding(
//                           padding: EdgeInsets.all(4),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               Padding(
//                                 padding: EdgeInsets.only(left: 4),
//                                 child: Icon(Icons.info, color: Colors.red),
//                               ),
//                               Html(
//                                 data: "<span style='color:white'>" +
//                                     informasi +
//                                     "</span>",
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Container(
//                     child: Stack(
//                       alignment: Alignment.center,
//                       children: [
//                         SizedBox(
//                           width: 90,
//                           height: 90,
//                           child: CustomPaint(
//                             painter: CirclePainter(),
//                           ),
//                         ),
//                         Column(
//                           children: [
//                             Row(
//                               children: [
//                                 Text(count,
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 16,
//                                         color: Colors.black)),
//                                 Text(" %"),
//                               ],
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(top: 0),
//                               child: Card(
//                                 color: Colors.red,
//                                 elevation: 1,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 child: Container(
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(6.0),
//                                     child: Text(
//                                       bulan + " " + tahun,
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.w600,
//                                           fontSize: 14,
//                                           color: Colors.white),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(width: 4),
//                 ],
//               ),
//               Center(
//                 child: Padding(
//                   padding: EdgeInsets.only(top: SizeConfig.screenHeight * 0.01),
//                   // ignore: deprecated_member_use
//                   child: ElevatedButton(
//                     onPressed: () async {
//                       if (!permissionLocation && Platform.isAndroid) {
//                         _permissionRequest();
//                       } else {
//                         if (!canMockLocation) {
//                           SharedPreferences pref =
//                               await SharedPreferences.getInstance();
//                           var accesToken = pref.getString("PREF_TOKEN")!;
//                           var idstaff = pref.getString("PREF_ID_USER")!;
//                           DevService devService = new DevService();
//                           devService.shift(accesToken, idstaff).then((value) {
//                             ReturnStaffShift returnStaffShift =
//                                 ReturnStaffShift.fromJson(json.decode(value));

//                             if (returnStaffShift.listshift != null)
//                               _modalBottomSheet(
//                                   returnStaffShift.listshift!.jamDari!,
//                                   returnStaffShift.listshift!.jamSampai!);
//                           });
//                         }
//                       }
//                     },
//                     style: ButtonStyle(
//                         backgroundColor: MaterialStateProperty.all<Color>(
//                             canMockLocation
//                                 ? Colors.red
//                                 : ColorsTheme.primary1),
//                         shape:
//                             MaterialStateProperty.all<RoundedRectangleBorder>(
//                                 RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ))),
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                         permissionLocation && Platform.isAndroid
//                             ? canMockLocationString
//                             : "Absen Sekarang",
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontSize: canMockLocation ? 16 : 20),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget cardAbsenHariIni() {
//     return Padding(
//       padding: EdgeInsets.only(top: SizeConfig.screenHeight * 0.2),
//       child: Center(
//         child: Card(
//           elevation: 1,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Container(
//               width: SizeConfig.screenWidth * 0.8,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Color(0x3f000000),
//                     blurRadius: 4,
//                     offset: Offset(0, 4),
//                   ),
//                 ],
//                 color: Colors.white,
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   children: [
//                     Container(
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           SizedBox(
//                             child: Text(
//                               hari.toUpperCase(),
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 color: Color(0xff171111),
//                                 fontSize: 14,
//                                 fontFamily: "Sansation Light",
//                                 fontWeight: FontWeight.w300,
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: 1.50),
//                           Text(
//                             tanggal,
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 40,
//                               fontFamily: "Sansation Light",
//                               fontWeight: FontWeight.w300,
//                             ),
//                           ),
//                           SizedBox(height: 1.50),
//                           SizedBox(
//                             width: 81,
//                             height: 21,
//                             child: Text(
//                               bulantahun,
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 color: Color(0xff171111),
//                                 fontSize: 14,
//                                 fontFamily: "Sansation Light",
//                                 fontWeight: FontWeight.w300,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                         height: 80,
//                         child: VerticalDivider(color: ColorsTheme.primary1)),
//                     Expanded(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           Container(
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 SizedBox(
//                                   child: Text(
//                                     "IN",
//                                     textAlign: TextAlign.center,
//                                     style: TextStyle(
//                                       color: Color(0xff171111),
//                                       fontSize: 30,
//                                       fontFamily: "Sansation Light",
//                                       fontWeight: FontWeight.w300,
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(height: 4),
//                                 absenIn == null
//                                     ? Container()
//                                     : Column(
//                                         children: [
//                                           SizedBox(
//                                             child: Text(
//                                               absenIn!.tanggal_absen == null
//                                                   ? "-"
//                                                   : absenIn!.tanggal_absen!,
//                                               textAlign: TextAlign.center,
//                                               style: TextStyle(
//                                                 color: Color(0xff171111),
//                                                 fontSize: 12,
//                                                 fontFamily: "Sansation Light",
//                                                 fontWeight: FontWeight.w300,
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(height: 4),
//                                           SizedBox(
//                                             child: Text(
//                                               absenIn!.jam_absen == null
//                                                   ? "-"
//                                                   : absenIn!.jam_absen!,
//                                               textAlign: TextAlign.center,
//                                               style: TextStyle(
//                                                 color: Color(0xff171111),
//                                                 fontSize: 14,
//                                                 fontFamily: "Sansation Light",
//                                                 fontWeight: FontWeight.w300,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                               ],
//                             ),
//                           ),
//                           Container(
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 SizedBox(
//                                   child: Text(
//                                     "OUT",
//                                     textAlign: TextAlign.center,
//                                     style: TextStyle(
//                                       color: Color(0xff171111),
//                                       fontSize: 30,
//                                       fontFamily: "Sansation Light",
//                                       fontWeight: FontWeight.w300,
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(height: 4),
//                                 absenOut == null
//                                     ? Container()
//                                     : Column(
//                                         children: [
//                                           SizedBox(
//                                             child: Text(
//                                               absenOut!.tanggal_absen == null
//                                                   ? "-"
//                                                   : absenOut!.tanggal_absen!,
//                                               textAlign: TextAlign.center,
//                                               style: TextStyle(
//                                                 color: Color(0xff171111),
//                                                 fontSize: 12,
//                                                 fontFamily: "Sansation Light",
//                                                 fontWeight: FontWeight.w300,
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(height: 4),
//                                           SizedBox(
//                                             child: Text(
//                                               absenOut!.jam_absen == null
//                                                   ? "-"
//                                                   : absenOut!.jam_absen!,
//                                               textAlign: TextAlign.center,
//                                               style: TextStyle(
//                                                 color: Color(0xff171111),
//                                                 fontSize: 14,
//                                                 fontFamily: "Sansation Light",
//                                                 fontWeight: FontWeight.w300,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//               )),
//         ),
//       ),
//     );
//   }

//   Widget cardFaceData() {
//     return Padding(
//       padding: EdgeInsets.only(top: SizeConfig.screenHeight * 0.32),
//       child: Center(
//         child: Card(
//             elevation: 0.5,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: InkWell(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (BuildContext context) => SignUp(
//                       cameraDescription: cameraDescription,
//                     ),
//                   ),
//                 );
//               },
//               child: Container(
//                 width: SizeConfig.screenWidth * 0.8,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Color(0x3f000000),
//                       blurRadius: 4,
//                       offset: Offset(0, 4),
//                     ),
//                   ],
//                   color: Colors.red,
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(12),
//                   child: Center(
//                     child: Text(
//                       "Data wajah anda belum di daftarkan\nDaftarkan Sekarang!",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ),
//             )),
//       ),
//     );
//   }

//   void _modalBottomSheet(String jamMasuk, String jamKeluar) {
//     showModalBottomSheet(
//         context: context,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(
//             top: Radius.circular(20),
//           ),
//         ),
//         builder: (builder) {
//           return Consumer<ProviderCabang>(builder: (context, provider, _) {
//             return Container(
//               height: SizeConfig.screenHeight * 0.3,
//               color: Colors.transparent,
//               child: Container(
//                   decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.only(
//                           topLeft: const Radius.circular(10.0),
//                           topRight: const Radius.circular(10.0))),
//                   child: Center(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         GestureDetector(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Container(
//                                     width: 120,
//                                     height: 120,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(10.0),
//                                       // color: Colors.black12,
//                                       image: DecorationImage(
//                                           image: AssetImage(
//                                               "assets/images/in.png"),
//                                           fit: BoxFit.cover),
//                                     )),
//                                 SizedBox(height: 4),
//                                 Text(
//                                   "IN",
//                                   style: TextStyle(
//                                     color: Color(0xff171111),
//                                     fontSize: 20,
//                                     fontFamily: "Sansation Light",
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 SizedBox(height: 8),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       "EXPECTED : ",
//                                       style: TextStyle(
//                                         color: Color(0xff171111),
//                                         fontSize: 14,
//                                         fontFamily: "Sansation Light",
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     Text(
//                                       jamMasuk,
//                                       style: TextStyle(
//                                         color: Colors.green,
//                                         fontSize: 14,
//                                         fontFamily: "Sansation Light",
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(height: 4),
//                                 (absenIn?.jam_absen != null)
//                                     ? Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                             "ACTUAL : ",
//                                             style: TextStyle(
//                                               color: Color(0xff171111),
//                                               fontSize: 14,
//                                               fontFamily: "Sansation Light",
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                           Text(
//                                             absenIn!.jam_absen!,
//                                             style: TextStyle(
//                                               color: Colors.red,
//                                               fontSize: 14,
//                                               fontFamily: "Sansation Light",
//                                               fontWeight: FontWeight.w500,
//                                             ),
//                                           ),
//                                         ],
//                                       )
//                                     : Text(
//                                         '',
//                                         style: TextStyle(
//                                           color: Colors.red,
//                                           fontSize: 14,
//                                           fontFamily: "Sansation Light",
//                                           fontWeight: FontWeight.w500,
//                                         ),
//                                       ),
//                               ],
//                             ),
//                             onTap: () async {
//                               if (absenIn?.jam_absen != null) {
//                                 return WidgetSnackbar(
//                                     context: context,
//                                     message: 'Anda sudah absen in',
//                                     warna: "merah");
//                               }

//                               provider.setIsLate(false);
//                               provider.setInOut('IN');

//                               DateTime now = await NTP.now();
//                               int nowInMinutes = now.hour * 60 + now.minute;

//                               var hourMasuk =
//                                   int.parse(jamMasuk.substring(0, 2));

//                               var menitMasuk =
//                                   int.parse(jamMasuk.substring(3, 5));

//                               TimeOfDay testDate = TimeOfDay(
//                                   hour: hourMasuk, minute: menitMasuk);
//                               int testDateInMinutes =
//                                   testDate.hour * 60 + testDate.minute;

//                               if (nowInMinutes >= testDateInMinutes) {
//                                 provider.setIsLate(true);
//                                 alasan("you're late", context);
//                               } else {
//                                 await provider.fetchHistory;
//                                 var results = provider.returnCabang;
//                                 // ignore: unnecessary_null_comparison
//                                 if (results != null) {
//                                   provider.setFilterCabang('');
//                                   goToCabangOption();
//                                 }
//                               }
//                             }),
//                         GestureDetector(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Container(
//                                     width: 120,
//                                     height: 120,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(10.0),
//                                       // color: Colors.black12,
//                                       image: DecorationImage(
//                                           image: AssetImage(
//                                               "assets/images/out.png"),
//                                           fit: BoxFit.cover),
//                                     )),
//                                 SizedBox(height: 4),
//                                 Text(
//                                   "OUT",
//                                   style: TextStyle(
//                                     color: Color(0xff171111),
//                                     fontSize: 20,
//                                     fontFamily: "Sansation Light",
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 SizedBox(height: 8),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       "EXPECTED : ",
//                                       style: TextStyle(
//                                         color: Color(0xff171111),
//                                         fontSize: 14,
//                                         fontFamily: "Sansation Light",
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     Text(
//                                       jamKeluar,
//                                       style: TextStyle(
//                                         color: Colors.green,
//                                         fontSize: 14,
//                                         fontFamily: "Sansation Light",
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(height: 4),
//                                 (absenOut?.jam_absen != null)
//                                     ? Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                             "ACTUAL : ",
//                                             style: TextStyle(
//                                               color: Color(0xff171111),
//                                               fontSize: 14,
//                                               fontFamily: "Sansation Light",
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                           Text(
//                                             absenOut!.jam_absen!,
//                                             style: TextStyle(
//                                               color: Colors.red,
//                                               fontSize: 14,
//                                               fontFamily: "Sansation Light",
//                                               fontWeight: FontWeight.w500,
//                                             ),
//                                           ),
//                                         ],
//                                       )
//                                     : Text(
//                                         '',
//                                         style: TextStyle(
//                                           color: Colors.red,
//                                           fontSize: 14,
//                                           fontFamily: "Sansation Light",
//                                           fontWeight: FontWeight.w500,
//                                         ),
//                                       ),
//                               ],
//                             ),
//                             onTap: () async {
//                               if (absenOut?.jam_absen != null) {
//                                 return WidgetSnackbar(
//                                     context: context,
//                                     message: 'Anda sudah absen out',
//                                     warna: "merah");
//                               }

//                               provider.setIsLate(false);

//                               provider.setInOut('OUT');

//                               DateTime now = await NTP.now();
//                               int nowInMinutes = now.hour * 60 + now.minute;

//                               var hourMasuk =
//                                   int.parse(jamKeluar.substring(0, 2));

//                               var menitMasuk =
//                                   int.parse(jamKeluar.substring(3, 5));

//                               TimeOfDay testDate = TimeOfDay(
//                                   hour: hourMasuk, minute: menitMasuk);
//                               int testDateInMinutes =
//                                   testDate.hour * 60 + testDate.minute;

//                               if (nowInMinutes <= testDateInMinutes) {
//                                 provider.setIsLate(true);

//                                 alasan("you're out too early", context);
//                               } else {
//                                 await provider.fetchHistory;
//                                 var results = provider.returnCabang;
//                                 // ignore: unnecessary_null_comparison
//                                 if (results != null) {
//                                   provider.setFilterCabang('');
//                                   goToCabangOption();
//                                 }
//                               }
//                             }),
//                       ],
//                     ),
//                   )),
//             );
//           });
//         });
//   }

//   Future alasan(String title, BuildContext context) {
//     return showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             scrollable: true,
//             title: Text(title),
//             content: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Form(
//                 child: Column(
//                   children: <Widget>[
//                     TextFormField(
//                       controller: alasanController,
//                       decoration: InputDecoration(
//                         labelText: 'input reason here . .',
//                         icon: Icon(Icons.notes),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             actions: [
//               Consumer<ProviderCabang>(builder: (context, provider, _) {
//                 // ignore: deprecated_member_use
//                 return ElevatedButton(
//                     child: Text("Submit"),
//                     onPressed: () async {
//                       provider.setReason(alasanController.text);

//                       await provider.fetchHistory;

//                       var results = provider.returnCabang;

//                       // ignore: unnecessary_null_comparison
//                       if (results != null) {
//                         provider.setFilterCabang('');
//                         goToCabangOption();
//                       }
//                     });
//               })
//             ],
//           );
//         });
//   }

//   void goToCabangOption() {
//     showMaterialModalBottomSheet(
//       expand: false,
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (context) => PageCabang(
//         reverse: false,
//       ),
//     );
//   }

//   basicStatusCheck(NewVersion newVersion) {
//     newVersion.showAlertIfNecessary(context: context);
//   }

//   advancedStatusCheck(NewVersion newVersion) async {
//     final status = await newVersion.getVersionStatus();
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     if (status != null) {
//       var newVersionStore = status.storeVersion.toString();
//       var newVersionServer = pref.getString("PREF_NEWVERSION")!;
//       var newVersionForce = pref.getString("PREF_NEWVERSION_FORCE")!;
//       bool allowDismissal = true;
//       if (newVersionStore.toLowerCase() == newVersionServer.toLowerCase()) {
//         if (newVersionForce == '1') {
//           allowDismissal = false;
//         }
//       }
//       var oldNewVersion = "";
//       oldNewVersion += "\n\nOld : v" + status.localVersion;
//       oldNewVersion += "\nNew : v" + status.storeVersion;
//       if (status.canUpdate)
//         newVersion.showUpdateDialog(
//             context: context,
//             updateButtonText: "UPDATE",
//             versionStatus: status,
//             dialogTitle: 'Update Version',
//             dialogText:
//                 'Versi Aplikasi terbaru sudah tersedia, silakan update untuk menikmati fitur-fitur menarik' +
//                     oldNewVersion,
//             allowDismissal: allowDismissal,
//             dismissButtonText: 'NANTI');
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _permissionRequest();
//     final newVersion = NewVersion(
//       iOSId: 'id.galeritekno.speederp001',
//       androidId: 'com.galeritekno.speederp',
//     );
//     // _getAndroidStoreVersion();
//     Timer.periodic(Duration(seconds: 1), (Timer t) => safeDevice());
//     getData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return loading
//         ? WidgetLoadingPage()
//         : failed
//             ? WidgetErrorConnection(
//                 onRetry: () {
//                   setState(() {
//                     getData();
//                   });
//                 },
//                 remarks: remakrs)
//             : RefreshIndicator(
//                 onRefresh: () => getData(),
//                 child: Scaffold(
//                   body: SingleChildScrollView(
//                     physics: AlwaysScrollableScrollPhysics(),
//                     child: Stack(
//                       children: <Widget>[
//                         Container(
//                           width: SizeConfig.screenWidth * 1,
//                           height: 219,
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.only(
//                                 topLeft: Radius.circular(0),
//                                 topRight: Radius.circular(0),
//                                 bottomLeft: Radius.circular(0),
//                                 bottomRight: Radius.circular(0),
//                               ),
//                               color: ColorsTheme.primary1),
//                         ),
//                         online(),
//                         profile(),
//                         cardAbsenHariIni(),

//                         Padding(
//                           padding: EdgeInsets.only(
//                               top: faceData.toString().length < 5
//                                   ? SizeConfig.screenHeight * 0.05
//                                   : SizeConfig.screenHeight * 0),
//                           child: thismonth(context),
//                         ),
//                         if (faceData.toString().length < 5)
//                           Padding(
//                             padding: EdgeInsets.only(
//                                 top: SizeConfig.screenHeight * 0.03),
//                             child: cardFaceData(),
//                           ),
//                         //cardFaceData(),

//                         // runningClock(),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//   }
// }

// /// Draws a circle if placed into a square widget.
// class CirclePainter extends CustomPainter {
//   final _paint = Paint()
//     ..color = Colors.grey.withOpacity(0.4)
//     ..strokeWidth = 5
//     // Use [PaintingStyle.fill] if you want the circle to be filled.
//     ..style = PaintingStyle.stroke;

//   @override
//   void paint(Canvas canvas, Size size) {
//     canvas.drawOval(
//       Rect.fromLTWH(0, 0, size.width, size.height),
//       _paint,
//     );
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => false;
// }
