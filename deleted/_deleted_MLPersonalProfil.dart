// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/api/api_service.dart';
// import 'package:flutter_application_1/models/personalprofil/get.dart';
// import 'package:flutter_application_1/models/return_check.dart';
// import 'package:flutter_application_1/pages/general_widget/widget_snackbar.dart';
// import 'package:flutter_application_1/style/colors.dart';
// import 'package:google_fonts/google_fonts.dart';
// // ignore: import_of_legacy_library_into_null_safe
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class MLPersonalProfil extends StatefulWidget {
//   @override
//   _MLPersonalProfilState createState() => _MLPersonalProfilState();
// }

// class _MLPersonalProfilState extends State<MLPersonalProfil> {
//   TextEditingController cNik = new TextEditingController();
//   TextEditingController cNama = new TextEditingController();
//   TextEditingController cHp = new TextEditingController();
//   TextEditingController cAlamat = new TextEditingController();
//   TextEditingController cJenisKelamin = new TextEditingController();
//   TextEditingController cTempatLahir = new TextEditingController();
//   TextEditingController cTanggalLahir = new TextEditingController();

//   TextEditingController cGolDarah = new TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     initData();
//   }

//   Future<void> initData() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     var accesToken = pref.getString("PREF_TOKEN")!;

//     DevService _devService = DevService();

//     ReturnMyPersonalProfil returnMyPersonalProfil =
//         await _devService.myPersonalInfo(
//       accesToken,
//     );

//     cNik.text = returnMyPersonalProfil.personalProfil?.nik ?? '';
//     cNama.text = returnMyPersonalProfil.personalProfil?.firstName ?? '';
//     cHp.text = returnMyPersonalProfil.personalProfil?.phone ?? '';
//     cAlamat.text = returnMyPersonalProfil.personalProfil?.address ?? '';
//     cJenisKelamin.text = returnMyPersonalProfil.personalProfil?.gender ?? '';
//     cTempatLahir.text = returnMyPersonalProfil.personalProfil?.birthPlace ?? '';
//     cTanggalLahir.text = returnMyPersonalProfil.personalProfil?.birthDay ?? '';
//     cGolDarah.text = returnMyPersonalProfil.personalProfil?.blood ?? '';
//   }

//   String convertDateTimeDisplay(String date) {
//     final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
//     final DateFormat serverFormater = DateFormat('yyyy-MM-dd');
//     final DateTime displayDate = displayFormater.parse(date);
//     final String formatted = serverFormater.format(displayDate);
//     return formatted;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Personal Profil"),
//       ),
//       body: ListView(
//         // crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             margin: EdgeInsets.only(bottom: 5, left: 35, top: 20),
//             child: Text("Nomor Induk Kependudukan",
//                 style:
//                     TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0)),
//           ),
//           Container(
//             decoration: BoxDecoration(
//               boxShadow: [
//                 BoxShadow(
//                   color: Color(0x3f000000),
//                   blurRadius: 4,
//                   offset: Offset(1, 1),
//                 ),
//               ],
//             ),
//             margin: EdgeInsets.only(top: 5, left: 30, right: 20),
//             child: TextFormField(
//               onTap: () {},
//               controller: cNik,
//               style: GoogleFonts.ibmPlexSans(
//                   textStyle: TextStyle(fontSize: 15, color: Color(0xff4a4c4f))),
//               decoration: InputDecoration(
//                 //    enabled: false,
//                 hintText: "",
//                 hintStyle: GoogleFonts.ibmPlexSans(
//                     textStyle:
//                         TextStyle(fontSize: 15, color: Color(0xff4a4c4f))),
//                 border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(8.0),
//                     ),
//                     borderSide: BorderSide.none),
//                 enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(8.0),
//                     ),
//                     borderSide: BorderSide.none),
//                 focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(8.0),
//                     ),
//                     borderSide: BorderSide.none),
//                 filled: true,
//                 fillColor: Color(0xfffafaff),
//                 // prefixIcon: Icon(
//                 //   Icons.zoom_out,
//                 //   size: 22,
//                 // ),
//                 isDense: true,
//                 contentPadding: EdgeInsets.all(10),
//               ),
//               keyboardType: TextInputType.number,
//               textCapitalization: TextCapitalization.sentences,
//             ),
//           ),
//           Container(
//             margin: EdgeInsets.only(bottom: 5, left: 35, top: 20),
//             child: Text("Nama Lengkap",
//                 style:
//                     TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0)),
//           ),
//           Container(
//             decoration: BoxDecoration(
//               boxShadow: [
//                 BoxShadow(
//                   color: Color(0x3f000000),
//                   blurRadius: 4,
//                   offset: Offset(1, 1),
//                 ),
//               ],
//             ),
//             margin: EdgeInsets.only(top: 5, left: 30, right: 20),
//             child: TextFormField(
//               onTap: () {},
//               controller: cNama,
//               style: GoogleFonts.ibmPlexSans(
//                   textStyle: TextStyle(fontSize: 15, color: Color(0xff4a4c4f))),
//               decoration: InputDecoration(
//                 //    enabled: false,
//                 hintText: "",
//                 hintStyle: GoogleFonts.ibmPlexSans(
//                     textStyle:
//                         TextStyle(fontSize: 15, color: Color(0xff4a4c4f))),
//                 border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(8.0),
//                     ),
//                     borderSide: BorderSide.none),
//                 enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(8.0),
//                     ),
//                     borderSide: BorderSide.none),
//                 focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(8.0),
//                     ),
//                     borderSide: BorderSide.none),
//                 filled: true,
//                 fillColor: Color(0xfffafaff),
//                 // prefixIcon: Icon(
//                 //   Icons.zoom_out,
//                 //   size: 22,
//                 // ),
//                 isDense: true,
//                 contentPadding: EdgeInsets.all(10),
//               ),
//               keyboardType: TextInputType.text,
//               textCapitalization: TextCapitalization.sentences,
//             ),
//           ),
//           Container(
//             margin: EdgeInsets.only(bottom: 5, left: 35, top: 20),
//             child: Text("Phone",
//                 style:
//                     TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0)),
//           ),
//           Container(
//             decoration: BoxDecoration(
//               boxShadow: [
//                 BoxShadow(
//                   color: Color(0x3f000000),
//                   blurRadius: 4,
//                   offset: Offset(1, 1),
//                 ),
//               ],
//             ),
//             margin: EdgeInsets.only(top: 5, left: 30, right: 20),
//             child: TextFormField(
//               onTap: () {},
//               controller: cHp,
//               style: GoogleFonts.ibmPlexSans(
//                   textStyle: TextStyle(fontSize: 15, color: Color(0xff4a4c4f))),
//               decoration: InputDecoration(
//                 //    enabled: false,
//                 hintText: "",
//                 hintStyle: GoogleFonts.ibmPlexSans(
//                     textStyle:
//                         TextStyle(fontSize: 15, color: Color(0xff4a4c4f))),
//                 border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(8.0),
//                     ),
//                     borderSide: BorderSide.none),
//                 enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(8.0),
//                     ),
//                     borderSide: BorderSide.none),
//                 focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(8.0),
//                     ),
//                     borderSide: BorderSide.none),
//                 filled: true,
//                 fillColor: Color(0xfffafaff),
//                 // prefixIcon: Icon(
//                 //   Icons.zoom_out,
//                 //   size: 22,
//                 // ),
//                 isDense: true,
//                 contentPadding: EdgeInsets.all(10),
//               ),
//               keyboardType: TextInputType.phone,
//               textCapitalization: TextCapitalization.sentences,
//             ),
//           ),
//           Container(
//             margin: EdgeInsets.only(bottom: 5, left: 35, top: 20),
//             child: Text("Alamat Lengkap",
//                 style:
//                     TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0)),
//           ),
//           Container(
//             decoration: BoxDecoration(
//               boxShadow: [
//                 BoxShadow(
//                   color: Color(0x3f000000),
//                   blurRadius: 4,
//                   offset: Offset(1, 1),
//                 ),
//               ],
//             ),
//             margin: EdgeInsets.only(top: 5, left: 30, right: 20),
//             child: TextFormField(
//               onTap: () {},
//               controller: cAlamat,
//               style: GoogleFonts.ibmPlexSans(
//                   textStyle: TextStyle(fontSize: 15, color: Color(0xff4a4c4f))),
//               decoration: InputDecoration(
//                 //    enabled: false,
//                 hintText: "",
//                 hintStyle: GoogleFonts.ibmPlexSans(
//                     textStyle:
//                         TextStyle(fontSize: 15, color: Color(0xff4a4c4f))),
//                 border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(8.0),
//                     ),
//                     borderSide: BorderSide.none),
//                 enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(8.0),
//                     ),
//                     borderSide: BorderSide.none),
//                 focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(8.0),
//                     ),
//                     borderSide: BorderSide.none),
//                 filled: true,
//                 fillColor: Color(0xfffafaff),
//                 // prefixIcon: Icon(
//                 //   Icons.zoom_out,
//                 //   size: 22,
//                 // ),
//                 isDense: true,
//                 contentPadding: EdgeInsets.all(10),
//               ),
//               keyboardType: TextInputType.text,
//               textCapitalization: TextCapitalization.sentences,
//             ),
//           ),
//           Container(
//             margin: EdgeInsets.only(bottom: 5, left: 35, top: 20),
//             child: Text("Jenis Kelamin",
//                 style:
//                     TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0)),
//           ),
//           Container(
//             decoration: BoxDecoration(
//               boxShadow: [
//                 BoxShadow(
//                   color: Color(0x3f000000),
//                   blurRadius: 4,
//                   offset: Offset(1, 1),
//                 ),
//               ],
//             ),
//             margin: EdgeInsets.only(top: 5, left: 30, right: 20),
//             child: TextFormField(
//               onTap: () {},
//               controller: cJenisKelamin,
//               style: GoogleFonts.ibmPlexSans(
//                   textStyle: TextStyle(fontSize: 15, color: Color(0xff4a4c4f))),
//               decoration: InputDecoration(
//                 //    enabled: false,
//                 hintText: "",
//                 hintStyle: GoogleFonts.ibmPlexSans(
//                     textStyle:
//                         TextStyle(fontSize: 15, color: Color(0xff4a4c4f))),
//                 border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(8.0),
//                     ),
//                     borderSide: BorderSide.none),
//                 enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(8.0),
//                     ),
//                     borderSide: BorderSide.none),
//                 focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(8.0),
//                     ),
//                     borderSide: BorderSide.none),
//                 filled: true,
//                 fillColor: Color(0xfffafaff),
//                 // prefixIcon: Icon(
//                 //   Icons.zoom_out,
//                 //   size: 22,
//                 // ),
//                 isDense: true,
//                 contentPadding: EdgeInsets.all(10),
//               ),
//               keyboardType: TextInputType.text,
//               textCapitalization: TextCapitalization.sentences,
//             ),
//           ),
//           Container(
//             margin: EdgeInsets.only(bottom: 5, left: 35, top: 20),
//             child: Text("Tempat Lahir",
//                 style:
//                     TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0)),
//           ),
//           Container(
//             decoration: BoxDecoration(
//               boxShadow: [
//                 BoxShadow(
//                   color: Color(0x3f000000),
//                   blurRadius: 4,
//                   offset: Offset(1, 1),
//                 ),
//               ],
//             ),
//             margin: EdgeInsets.only(top: 5, left: 30, right: 20),
//             child: TextFormField(
//               onTap: () {},
//               controller: cTempatLahir,
//               style: GoogleFonts.ibmPlexSans(
//                   textStyle: TextStyle(fontSize: 15, color: Color(0xff4a4c4f))),
//               decoration: InputDecoration(
//                 //    enabled: false,
//                 hintText: "",
//                 hintStyle: GoogleFonts.ibmPlexSans(
//                     textStyle:
//                         TextStyle(fontSize: 15, color: Color(0xff4a4c4f))),
//                 border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(8.0),
//                     ),
//                     borderSide: BorderSide.none),
//                 enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(8.0),
//                     ),
//                     borderSide: BorderSide.none),
//                 focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(8.0),
//                     ),
//                     borderSide: BorderSide.none),
//                 filled: true,
//                 fillColor: Color(0xfffafaff),
//                 // prefixIcon: Icon(
//                 //   Icons.zoom_out,
//                 //   size: 22,
//                 // ),
//                 isDense: true,
//                 contentPadding: EdgeInsets.all(10),
//               ),
//               keyboardType: TextInputType.text,
//               textCapitalization: TextCapitalization.sentences,
//             ),
//           ),
//           Container(
//             margin: EdgeInsets.only(bottom: 5, left: 35, top: 20),
//             child: Text("Tanggal Lahir",
//                 style:
//                     TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0)),
//           ),
//           Container(
//             decoration: BoxDecoration(
//               boxShadow: [
//                 BoxShadow(
//                   color: Color(0x3f000000),
//                   blurRadius: 4,
//                   offset: Offset(1, 1),
//                 ),
//               ],
//             ),
//             margin: EdgeInsets.only(top: 5, left: 30, right: 20),
//             child: TextFormField(
//               onTap: () {
//                 showDatePicker(
//                   context: context,
//                   initialDate: DateTime.now(),
//                   firstDate: DateTime(1950, 1),
//                   lastDate: DateTime(2023, 12),
//                 ).then((pickedDate) {
//                   cTanggalLahir.text =
//                       convertDateTimeDisplay(pickedDate.toString());
//                 });
//               },
//               controller: cTanggalLahir,
//               style: GoogleFonts.ibmPlexSans(
//                   textStyle: TextStyle(fontSize: 15, color: Color(0xff4a4c4f))),
//               decoration: InputDecoration(
//                 //    enabled: false,
//                 hintText: "",
//                 hintStyle: GoogleFonts.ibmPlexSans(
//                     textStyle:
//                         TextStyle(fontSize: 15, color: Color(0xff4a4c4f))),
//                 border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(8.0),
//                     ),
//                     borderSide: BorderSide.none),
//                 enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(8.0),
//                     ),
//                     borderSide: BorderSide.none),
//                 focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(8.0),
//                     ),
//                     borderSide: BorderSide.none),
//                 filled: true,
//                 fillColor: Color(0xfffafaff),
//                 // prefixIcon: Icon(
//                 //   Icons.zoom_out,
//                 //   size: 22,
//                 // ),
//                 isDense: true,
//                 contentPadding: EdgeInsets.all(10),
//               ),
//               keyboardType: TextInputType.text,
//               textCapitalization: TextCapitalization.sentences,
//             ),
//           ),
//           Container(
//             margin: EdgeInsets.only(bottom: 5, left: 35, top: 20),
//             child: Text("Golongan Darah",
//                 style:
//                     TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0)),
//           ),
//           Container(
//             decoration: BoxDecoration(
//               boxShadow: [
//                 BoxShadow(
//                   color: Color(0x3f000000),
//                   blurRadius: 4,
//                   offset: Offset(1, 1),
//                 ),
//               ],
//             ),
//             margin: EdgeInsets.only(top: 5, left: 30, right: 20),
//             child: TextFormField(
//               onTap: () {},
//               controller: cGolDarah,
//               style: GoogleFonts.ibmPlexSans(
//                   textStyle: TextStyle(fontSize: 15, color: Color(0xff4a4c4f))),
//               decoration: InputDecoration(
//                 //    enabled: false,
//                 hintText: "",
//                 hintStyle: GoogleFonts.ibmPlexSans(
//                     textStyle:
//                         TextStyle(fontSize: 15, color: Color(0xff4a4c4f))),
//                 border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(8.0),
//                     ),
//                     borderSide: BorderSide.none),
//                 enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(8.0),
//                     ),
//                     borderSide: BorderSide.none),
//                 focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(8.0),
//                     ),
//                     borderSide: BorderSide.none),
//                 filled: true,
//                 fillColor: Color(0xfffafaff),
//                 // prefixIcon: Icon(
//                 //   Icons.zoom_out,
//                 //   size: 22,
//                 // ),
//                 isDense: true,
//                 contentPadding: EdgeInsets.all(10),
//               ),
//               keyboardType: TextInputType.text,
//               textCapitalization: TextCapitalization.sentences,
//             ),
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           Center(
//             // ignore: deprecated_member_use
//             child: ElevatedButton(
//               onPressed: () async {
//                 SharedPreferences pref = await SharedPreferences.getInstance();
//                 var accesToken = pref.getString("PREF_TOKEN")!;

//                 DevService _devService = DevService();

//                 ReturnCheck returnCheck = await _devService.personalProfil(
//                     accesToken,
//                     cNik.text,
//                     cNama.text,
//                     cHp.text,
//                     cAlamat.text,
//                     cJenisKelamin.text,
//                     cTempatLahir.text,
//                     cTanggalLahir.text,
//                     cGolDarah.text);

//                 WidgetSnackbar(
//                     context: context,
//                     message: returnCheck.remarks!,
//                     warna: "hijau");

//                 // _devService
//                 //     .myprofile(accesToken, ctrlPhone.text)
//                 //     .then((value) async {
//                 //   var res = ReturnCheck.fromJson(json.decode(value));

//                 //   if (res.statusJson == true) {
//                 //     WidgetSnackbar(
//                 //         context: context,
//                 //         message: "Nomor Handphone Berhasil disimpan",
//                 //         warna: "hijau");
//                 //   } else {
//                 //     WidgetSnackbar(
//                 //         context: context,
//                 //         message: "Something Wrong",
//                 //         warna: "merah");
//                 //   }
//                 // });
//               },
//               style: ButtonStyle(
//                   backgroundColor:
//                       MaterialStateProperty.all<Color>(ColorsTheme.primary1),
//                   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                       RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ))),
//               child: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
//                 child: Text(
//                   "SIMPAN",
//                   style: TextStyle(color: Colors.white, fontSize: 16),
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 20,
//           ),
//         ],
//       ),
//     );
//   }
// }
