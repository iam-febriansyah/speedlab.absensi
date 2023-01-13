// import 'dart:convert';

// import 'package:flutter_application_1/api/camera.service.dart';
// import 'package:flutter_application_1/api/erp.glomed.service.dart';
// import 'package:flutter_application_1/api/facenet.service.dart';
// import 'package:flutter_application_1/api/service.dart';
// import 'package:flutter_application_1/models/absen/post.dart';
// import 'package:flutter_application_1/models/absen/return.dart';
// import 'package:flutter_application_1/models/auth/cls_return_login.dart';
// import 'package:flutter_application_1/models/database.dart';
// import 'package:flutter_application_1/models/menu/cls_absen_hari_ini.dart';
// import 'package:flutter_application_1/models/updateface/return.dart';
// import 'package:flutter_application_1/models/user.model.dart';
// import 'package:flutter_application_1/pages/general_widget.dart/widget_progress.dart';
// import 'package:flutter_application_1/pages/general_widget.dart/widget_snackbar.dart';
// import 'package:flutter_application_1/pages/main_menu.dart';
// import 'package:flutter_application_1/pages/widgets/app_button.dart';
// import 'package:flutter_application_1/style/colors.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class AuthActionButton extends StatefulWidget {
//   AuthActionButton(this._initializeControllerFuture,
//       {Key? key,
//       required this.onPressed,
//       required this.isLogin,
//       required this.reload,
//       required this.absen});
//   final Future _initializeControllerFuture;
//   final Function()? onPressed;
//   final bool isLogin;
//   final Function reload;
//   final Absen absen;
//   @override
//   _AuthActionButtonState createState() => _AuthActionButtonState();
// }

// class _AuthActionButtonState extends State<AuthActionButton> {
//   /// service injection
//   // final FaceNetService _faceNetService = FaceNetService();

//   String? predictedUser;
//   DevService _devService = DevService();

//   Future _signUp(context) async {
//     /// gets predicted data from facenet service (user face detected)
//     ///
//     List predictedData = _faceNetService.predictedDataList;
//     print("========DAFTAR============");
//     print(json.encode(predictedData));
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context) => WidgetProgressSubmit());
//     DataUser dataSubmit = new DataUser();
//     print("===============SUBMIT===============");
//     print(json.encode(predictedData));
//     dataSubmit.facedata = json.encode(predictedData);

//     //  List<dynamic> facedata = predictedData;
//     print("predictedData " + predictedData.toString());

//     _devService
//         .updatefacedata(pref.getString("PREF_TOKEN")!, predictedData)
//         .then((value) async {
//       var res = ReturnUpdateFace.fromJson(json.decode(value));

//       if (res.status_json == true) {
//         pref.setString("PREF_FACE", json.encode(predictedData));
//         Navigator.of(context).pushAndRemoveUntil(
//             MaterialPageRoute(builder: (context) => MainMenu()),
//             (Route<dynamic> route) => false);
//         WidgetSnackbar(context: context, message: res.remarks, warna: "hijau");
//       } else {
//         Navigator.of(context).pushAndRemoveUntil(
//             MaterialPageRoute(builder: (context) => MainMenu()),
//             (Route<dynamic> route) => false);
//         WidgetSnackbar(context: context, message: res.remarks, warna: "merah");
//       }
//     });

//     // getClient()
//     //     .updateFaceData(pref.getString("PREF_TOKEN")!, dataSubmit)
//     //     .then((res) async {
//     //   Navigator.pop(context);
//     //   if (res.statusJson) {
//     //     pref.setString("PREF_FACE", json.encode(predictedData));
//     //     Navigator.of(context).pushAndRemoveUntil(
//     //         MaterialPageRoute(builder: (context) => MainMenu()),
//     //         (Route<dynamic> route) => false);
//     //     WidgetSnackbar(context: context, message: res.remarks, warna: "hijau");
//     //   } else {
//     //     Navigator.of(context).pushAndRemoveUntil(
//     //         MaterialPageRoute(builder: (context) => MainMenu()),
//     //         (Route<dynamic> route) => false);
//     //     WidgetSnackbar(context: context, message: res.remarks, warna: "merah");
//     //   }
//     // }).catchError((Object obj) {
//     //   Navigator.of(context).pushAndRemoveUntil(
//     //       MaterialPageRoute(builder: (context) => MainMenu()),
//     //       (Route<dynamic> route) => false);
//     //   WidgetSnackbar(
//     //       context: context,
//     //       message: "Failed connect to server!",
//     //       warna: "merah");
//     // });

//     /// resets the face stored in the face net sevice
//     this._faceNetService.setPredictedData(null);
//   }

//   // Future _signUp(context) async {
//   //   /// gets predicted data from facenet service (user face detected)
//   //   ///
//   //   List predictedData = _faceNetService.predictedDataList;
//   //   print("========DAFTAR============");
//   //   print(json.encode(predictedData));
//   //   SharedPreferences pref = await SharedPreferences.getInstance();
//   //   showDialog(
//   //       context: context,
//   //       barrierDismissible: false,
//   //       builder: (BuildContext context) => WidgetProgressSubmit());
//   //   DataUser dataSubmit = new DataUser();
//   //   print("===============SUBMIT===============");
//   //   print(json.encode(predictedData));
//   //   dataSubmit.facedata = json.encode(predictedData);

//   //   getClient()
//   //       .updateFaceData(pref.getString("PREF_TOKEN")!, dataSubmit)
//   //       .then((res) async {
//   //     Navigator.pop(context);
//   //     if (res.statusJson) {
//   //       pref.setString("PREF_FACE", json.encode(predictedData));
//   //       Navigator.of(context).pushAndRemoveUntil(
//   //           MaterialPageRoute(builder: (context) => MainMenu()),
//   //           (Route<dynamic> route) => false);
//   //       WidgetSnackbar(context: context, message: res.remarks, warna: "hijau");
//   //     } else {
//   //       Navigator.of(context).pushAndRemoveUntil(
//   //           MaterialPageRoute(builder: (context) => MainMenu()),
//   //           (Route<dynamic> route) => false);
//   //       WidgetSnackbar(context: context, message: res.remarks, warna: "merah");
//   //     }
//   //   }).catchError((Object obj) {
//   //     Navigator.of(context).pushAndRemoveUntil(
//   //         MaterialPageRoute(builder: (context) => MainMenu()),
//   //         (Route<dynamic> route) => false);
//   //     WidgetSnackbar(
//   //         context: context,
//   //         message: "Failed connect to server!",
//   //         warna: "merah");
//   //   });

//   //   /// resets the face stored in the face net sevice
//   //   this._faceNetService.setPredictedData(null);
//   // }

//   navigateToHome() {
//     Navigator.of(context).pushAndRemoveUntil(
//         MaterialPageRoute(builder: (context) => MainMenu()),
//         (Route<dynamic> route) => false);
//   }

//   Future _signIn(context) async {
//     // ignore: unrelated_type_equality_checks
//     if (this.predictedUser != "") {
//       SharedPreferences pref = await SharedPreferences.getInstance();
//       showDialog(
//           context: context,
//           barrierDismissible: false,
//           builder: (BuildContext context) => WidgetProgressSubmit());
//       print(json.encode(widget.absen));

//       PostAbsen postAbsen = new PostAbsen();
//       postAbsen.tipe_absen = widget.absen.tipeAbsen;

//       postAbsen.datang_pulang = widget.absen.datangPulang;
//       postAbsen.wfh_wfo = widget.absen.wfhWfo;
//       postAbsen.tanggal_absen = widget.absen.tanggalAbsen;

//       postAbsen.jam_absen = widget.absen.jamAbsen;

//       postAbsen.lokasi = widget.absen.lokasi;

//       postAbsen.latitude = widget.absen.latitude;

//       postAbsen.longitude = widget.absen.longitude;
//       postAbsen.keterangan = widget.absen.keterangan;

//       // getClient()
//       //     .postAbsen(pref.getString("PREF_TOKEN")!, widget.absen)
//       //     .then((res) async {
//       //   Navigator.pop(context);
//       //   if (res.statusJson) {
//       //     displayDialog(context, res.remarks, true);
//       //   } else {
//       //     WidgetSnackbar(
//       //         context: context, message: res.remarks, warna: "merah");
//       //   }
//       // }).catchError((Object obj) {
//       //   Navigator.pop(context);
//       //   WidgetSnackbar(
//       //       context: context,
//       //       message: "Failed connect to server!",
//       //       warna: "merah");
//       // });

//       _devService
//           .absen(pref.getString("PREF_TOKEN")!, postAbsen)
//           .then((value) async {
//         var res = ReturnAbsen.fromJson(json.decode(value));

//         if (res.status_json == true) {
//           displayDialog(context, res.remarks!, true);
//         } else {
//           WidgetSnackbar(
//               context: context, message: res.remarks, warna: "merah");
//         }
//       });
//     } else {
//       showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             content: Text('Wajah tidak cocok!'),
//           );
//         },
//       );
//     }
//   }

//   // Future _signIn(context) async {
//   //   // ignore: unrelated_type_equality_checks
//   //   if (this.predictedUser != "") {
//   //     SharedPreferences pref = await SharedPreferences.getInstance();
//   //     showDialog(
//   //         context: context,
//   //         barrierDismissible: false,
//   //         builder: (BuildContext context) => WidgetProgressSubmit());
//   //     print(json.encode(widget.absen));
//   //     getClient()
//   //         .postAbsen(pref.getString("PREF_TOKEN")!, widget.absen)
//   //         .then((res) async {
//   //       Navigator.pop(context);
//   //       if (res.statusJson) {
//   //         displayDialog(context, res.remarks, true);
//   //       } else {
//   //         WidgetSnackbar(
//   //             context: context, message: res.remarks, warna: "merah");
//   //       }
//   //     }).catchError((Object obj) {
//   //       Navigator.pop(context);
//   //       WidgetSnackbar(
//   //           context: context,
//   //           message: "Failed connect to server!",
//   //           warna: "merah");
//   //     });
//   //   } else {
//   //     showDialog(
//   //       context: context,
//   //       builder: (context) {
//   //         return AlertDialog(
//   //           content: Text('Wajah tidak cocok!'),
//   //         );
//   //       },
//   //     );
//   //   }
//   // }

//   String? _predictUser(List<dynamic> datas) {
//     print("before userAndPass");

//     String? userAndPass = _faceNetService.predict(datas);
//     print("userAndPass" + userAndPass.toString());
//     return userAndPass;
//   }

//   displayDialog(BuildContext context, String msg, bool navigate) async {
//     return showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (context) {
//           return AlertDialog(
//             title: Center(child: Text('Informasi')),
//             content: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisSize: MainAxisSize.min,
//                 children: <Widget>[
//                   SizedBox(
//                     height: 12,
//                   ),
//                   Center(child: Text(msg))
//                 ]),
//             actions: <Widget>[
//               Padding(
//                 padding: EdgeInsets.only(
//                     left: SizeConfig.screenWidth * 0.05, right: SizeConfig.screenWidth * 0.05, bottom: 8),
//                 child: Container(
//                   width: SizeConfig.screenWidth * 1,
//                   child: SizedBox(
//                     height: SizeConfig.screenHeight * 0.045,
//                     child: RaisedButton(
//                       onPressed: () {
//                         navigate
//                             ? Navigator.of(context).pushReplacement(
//                                 new MaterialPageRoute(
//                                     builder: (BuildContext context) =>
//                                         MainMenu(),
//                                     fullscreenDialog: true))
//                             : Navigator.pop(context);
//                       },
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(25)),
//                       color: ColorsTheme.primary1,
//                       child: Text(
//                         "TUTUP",
//                         style: TextStyle(
//                             color: Colors.white, fontSize: SizeConfig.screenWidth * 0.04),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () async {
//         try {
//           // Ensure that the camera is initialized.
//           await widget._initializeControllerFuture;
//           // onShot event (takes the image and predict output)
//           bool faceDetected = await widget.onPressed!();

//           if (faceDetected) {
//             print("===================userAndPass===================");
//             if (widget.isLogin) {
//               print("===================widget.isLogi===================");

//               SharedPreferences pref = await SharedPreferences.getInstance();
//               List<dynamic> datas = json.decode(pref.getString("PREF_FACE")!);
//               print("datas " + datas.toString());
//               predictedUser = _predictUser(datas);
//               print("after predict ");

//               this.predictedUser = predictedUser;

//               print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@predictedUser");
//               print(predictedUser);
//             }
//             PersistentBottomSheetController bottomSheetController =
//                 Scaffold.of(context)
//                     .showBottomSheet((context) => signSheet(context));

//             bottomSheetController.closed.whenComplete(() => widget.reload());
//           }
//         } catch (e) {
//           // If an error occurs, log the error to the console.
//           print(e);
//         }
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           color: Color(0xFF0F0BDB),
//           boxShadow: <BoxShadow>[
//             BoxShadow(
//               color: Colors.blue.withOpacity(0.1),
//               blurRadius: 1,
//               offset: Offset(0, 2),
//             ),
//           ],
//         ),
//         alignment: Alignment.center,
//         padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
//         width: MediaQuery.of(context).size.width * 0.8,
//         height: 60,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'CAPTURE',
//               style: TextStyle(color: Colors.white),
//             ),
//             SizedBox(
//               width: 10,
//             ),
//             Icon(Icons.camera_alt, color: Colors.white)
//           ],
//         ),
//       ),
//     );
//   }

//   signSheet(context) {
//     return Container(
//       padding: EdgeInsets.all(20),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Container(
//             width: SizeConfig.screenWidth * 1,
//             child: Column(
//               children: [
//                 widget.isLogin
//                     ? AppButton(
//                         text: 'ABSEN SEKARANG',
//                         onPressed: () async {
//                           _signIn(context);
//                         },
//                         icon: Icon(
//                           Icons.login,
//                           color: Colors.white,
//                         ),
//                       )
//                     : !widget.isLogin
//                         ? AppButton(
//                             text: 'DAFTARKAN',
//                             onPressed: () async {
//                               await _signUp(context);
//                             },
//                             icon: Icon(
//                               Icons.person_add,
//                               color: Colors.white,
//                             ),
//                           )
//                         : Container(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }
// }
