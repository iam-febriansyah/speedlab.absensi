// // A screen that allows users to take a picture using a given camera.
// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter_application_1/api/_deleted_camera.service.dart';
// import 'package:flutter_application_1/api/api_service.dart';
// import 'package:flutter_application_1/api/_deleted_face.service.dart';
// import 'package:flutter_application_1/models/absen/post.dart';
// import 'package:flutter_application_1/models/absen/return.dart';
// import 'package:flutter_application_1/models/menu/cls_absen_hari_ini.dart';
// import 'package:flutter_application_1/models/return_check.dart';
// import 'package:flutter_application_1/models/return_face_data.dart';
// import 'package:flutter_application_1/pages/general_widget/widget_snackbar.dart';
// import 'package:flutter_application_1/pages/main_menu.dart';
// import 'widgets/_deleted_camera_header.dart';
// import 'package:camera/camera.dart';
// import 'package:flutter_application_1/provider/provider.cabang.dart';
// import 'package:flutter/material.dart';
// // ignore: import_of_legacy_library_into_null_safe
// import 'package:intl/intl.dart';
// import 'package:ntp/ntp.dart';
// import 'package:package_info/package_info.dart';
// import 'package:provider/provider.dart';
// import 'dart:math' as math;

// import 'package:shared_preferences/shared_preferences.dart';

// class SignIn extends StatefulWidget {
//   final CameraDescription cameraDescription;
//   final Absen absen;

//   const SignIn({Key? key, required this.cameraDescription, required this.absen})
//       : super(key: key);

//   @override
//   SignInState createState() => SignInState();
// }

// class SignInState extends State<SignIn> {
//   /// Service injection
//   CameraService _cameraService = CameraService();
//   // MLKitService _mlKitService = MLKitService();
//   // FaceNetService _faceNetService = FaceNetService();
//   DevService _devService = DevService();

//   Future? _initializeControllerFuture;

//   bool cameraInitializated = false;
//   bool _detectingFaces = false;
//   bool pictureTaked = false;

//   // switchs when the user press the camera
//   // ignore: unused_field
//   bool _saving = false;
//   bool _bottomSheetVisible = false;
//   bool postFace = false;

//   String imagePath = "";
//   Size? imageSize;
//   // Face? faceDetected;

//   @override
//   void initState() {
//     super.initState();
//     _start();
//     getTimeZone();
//   }

//   @override
//   void dispose() {
//     // Dispose of the controller when the widget is disposed.
//     _cameraService.dispose();
//     super.dispose();
//   }

//   /// starts the camera & start framing faces
//   _start() async {
//     _initializeControllerFuture =
//         _cameraService.startService(widget.cameraDescription);
//     await _initializeControllerFuture;

//     setState(() {
//       cameraInitializated = true;
//     });

//     _frameFaces();
//   }

//   //start stream and draws rectangles when detects faces
//   _frameFaces() {
//     imageSize = _cameraService.getImageSize();

//     _cameraService.cameraController.startImageStream((image) async {
//       // ignore: unnecessary_null_comparison
//       if (_cameraService.cameraController != null) {
//         // if its currently busy, avoids overprocessing
//         if (_detectingFaces) return;

//         _detectingFaces = true;

//         try {
//           _detectingFaces = false;
//         } catch (e) {
//           print(e);
//           _detectingFaces = false;
//         }
//       }
//     });
//   }

//   /// handles the button pressed event
//   Future<ReturnFaceData> onShot_() async {
//     try {
//       await _cameraService.cameraController.stopImageStream();
//       await Future.delayed(Duration(milliseconds: 200));
//       XFile file = await _cameraService.takePicture();

//       setState(() {
//         _bottomSheetVisible = true;
//         pictureTaked = true;
//         imagePath = file.path;
//       });

//       FaceService faceService = new FaceService();
//       SharedPreferences pref = await SharedPreferences.getInstance();
//       var idUser = pref.getString("PREF_ID_USER")!;

//       var post = await faceService.checkFace(imagePath, idUser).then((value) {
//         ReturnFaceData returnFaceData = value;
//         return returnFaceData;
//       });

//       return post;
//     } catch (e) {
//       ReturnFaceData data = new ReturnFaceData();
//       data.status = false;
//       data.message = e.toString();
//       return data;
//     }
//   }

//   String timezone = "";
//   String timezoneoffset = "";
//   getTimeZone() async {
//     DateTime dateTime = await NTP.now();
//     setState(() {
//       timezone = dateTime.timeZoneName;
//       timezoneoffset = dateTime.timeZoneOffset.toString();
//     });
//   }

//   Future<ReturnAbsen> absenNow() async {
//     final PackageInfo info = await PackageInfo.fromPlatform();
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     var deviceid = pref.getString("PREF_DEVICEID")!;

//     PostAbsen postAbsen = new PostAbsen();
//     postAbsen.tipe_absen = widget.absen.tipeAbsen;

//     postAbsen.datang_pulang = widget.absen.datangPulang;
//     postAbsen.wfh_wfo = widget.absen.wfhWfo;
//     postAbsen.tanggal_absen = widget.absen.tanggalAbsen;

//     postAbsen.jam_absen = widget.absen.jamAbsen;

//     postAbsen.lokasi = widget.absen.lokasi;

//     postAbsen.latitude = widget.absen.latitude;

//     postAbsen.longitude = widget.absen.longitude;
//     postAbsen.keterangan = widget.absen.keterangan;

//     postAbsen.cabang_id = widget.absen.cabang_id;
//     postAbsen.section_id = widget.absen.section_id;

//     postAbsen.timezone = timezone;
//     postAbsen.timezoneoffset = timezoneoffset;
//     postAbsen.deviceid = deviceid;
//     // ignore: unnecessary_null_comparison
//     postAbsen.version = info.version == null ? "" : info.version;

//     var absen = await _devService
//         .absen(pref.getString("PREF_TOKEN")!, postAbsen)
//         .then((value) async {
//       return ReturnAbsen.fromJson(json.decode(value));
//     });
//     return absen;
//   }

//   Future<bool> telatNow(String alasan) async {
//     bool result = false;
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     DateTime now = await NTP.now();
//     String jam = DateFormat('kk:mm').format(now);
//     var token = pref.getString("PREF_TOKEN")!;
//     var idstaff = pref.getString("PREF_ID_USER")!;

//     // ignore: unused_local_variable
//     var absen = await _devService
//         .telat(token, idstaff, jam, jam, '', alasan)
//         .then((value) async {
//       var res = ReturnCheck.fromJson(json.decode(value));

//       if (res.statusJson == true) {
//         result = true;
//       } else {
//         result = false;
//       }
//     });

//     return result;
//   }

//   _onBackPressed() {
//     Navigator.of(context).pop();
//   }

//   _reload() {
//     setState(() {
//       _bottomSheetVisible = false;
//       cameraInitializated = false;
//       pictureTaked = false;
//     });
//     this._start();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var providerCabang = Provider.of<ProviderCabang>(context);

//     final double mirror = math.pi;
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
//     return Scaffold(
//       body: Stack(
//         children: [
//           FutureBuilder<void>(
//               future: _initializeControllerFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.done) {
//                   if (pictureTaked) {
//                     return Container(
//                       width: width,
//                       height: height,
//                       child: Transform(
//                           alignment: Alignment.center,
//                           child: FittedBox(
//                             fit: BoxFit.cover,
//                             child: Image.file(File(imagePath)),
//                           ),
//                           transform: Matrix4.rotationY(mirror)),
//                     );
//                   } else {
//                     return Transform.scale(
//                       scale: 1.0,
//                       child: AspectRatio(
//                         aspectRatio: MediaQuery.of(context).size.aspectRatio,
//                         child: OverflowBox(
//                           alignment: Alignment.center,
//                           child: FittedBox(
//                             fit: BoxFit.fitHeight,
//                             child: Container(
//                               width: width,
//                               height: width *
//                                   _cameraService
//                                       .cameraController.value.aspectRatio,
//                               child: Stack(
//                                 fit: StackFit.expand,
//                                 children: <Widget>[
//                                   CameraPreview(
//                                       _cameraService.cameraController),
//                                   // if (faceDetected != null)
//                                   //   CustomPaint(
//                                   //     painter: FacePainter(
//                                   //         face: faceDetected!,
//                                   //         imageSize: imageSize!),
//                                   //   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   }
//                 } else {
//                   return Center(child: CircularProgressIndicator());
//                 }
//               }),
//           CameraHeader(
//             "VALIDASI WAJAH",
//             onBackPressed: _onBackPressed,
//           ),
//           if (postFace == true)
//             Center(
//               child: CircularProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)),
//             )
//         ],
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       floatingActionButton: !_bottomSheetVisible
//           ? GestureDetector(
//               onTap: () async {
//                 setState(() {
//                   postFace = true;
//                 });
//                 SharedPreferences pref = await SharedPreferences.getInstance();
//                 bool useFace = pref.getBool("PREF_USEFACE")!;
//                 bool statusFace = true;
//                 String remarksFace = '';
//                 if (useFace) {
//                   ReturnFaceData result = await onShot_();
//                   statusFace = result.status!;
//                   remarksFace = result.message!;
//                 }

//                 // 1. jika wajah di db cocok / hasil shot merupakan real face
//                 if (statusFace == true) {
//                   // 2. lakukan absen
//                   ReturnAbsen postAbsen = await absenNow();
//                   if (postAbsen.status_json!) {
//                     if (providerCabang.isLate == true) {
//                       // ignore: unused_local_variable
//                       var postTelat = await telatNow(providerCabang.reason);
//                       Navigator.of(context).pushAndRemoveUntil(
//                           MaterialPageRoute(builder: (context) => MainMenu()),
//                           (Route<dynamic> route) => false);
//                       WidgetSnackbar(
//                           context: context,
//                           message: "Absen berhasil",
//                           warna: "hijau");
//                     } else {
//                       Navigator.of(context).pushAndRemoveUntil(
//                           MaterialPageRoute(builder: (context) => MainMenu()),
//                           (Route<dynamic> route) => false);
//                       WidgetSnackbar(
//                           context: context,
//                           message: "Absen berhasil",
//                           warna: "hijau");
//                     }
//                   } else {
//                     _reload();
//                     WidgetSnackbar(
//                         context: context,
//                         message: postAbsen.remarks!,
//                         warna: "merah");
//                   }
//                 } else {
//                   _reload();
//                   WidgetSnackbar(
//                       context: context, message: remarksFace, warna: "merah");
//                 }

//                 setState(() {
//                   postFace = false;
//                 });
//               },
//               child: Container(
//                 decoration: BoxDecoration(
//                     color: Colors.white,
//                     shape: BoxShape.rectangle,
//                     borderRadius: BorderRadius.only(
//                         topRight: Radius.circular(5.0),
//                         bottomLeft: Radius.circular(5.0),
//                         topLeft: Radius.circular(5.0),
//                         bottomRight: Radius.circular(5.0))),
//                 width: 50,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Icon(
//                     Icons.camera_alt,
//                     color: Colors.black,
//                     size: 30,
//                   ),
//                 ),
//               ),
//             )
//           : Container(),
//     );
//   }
// }
