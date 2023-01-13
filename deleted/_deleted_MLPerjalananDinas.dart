// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/api/api_service.dart';
// import 'package:flutter_application_1/models/return_check.dart';
// import 'package:flutter_application_1/pages/general_widget/widget_snackbar.dart';
// import 'package:flutter_application_1/style/colors.dart';
// import 'package:google_fonts/google_fonts.dart';
// // ignore: import_of_legacy_library_into_null_safe
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class MLPerjalananDinas extends StatefulWidget {
//   @override
//   _MLPerjalananDinasState createState() => _MLPerjalananDinasState();
// }

// class _MLPerjalananDinasState extends State<MLPerjalananDinas> {
//   TextEditingController cNamaKegiatan = new TextEditingController();
//   TextEditingController cTanggalMulai = new TextEditingController();
//   TextEditingController cTanggalSelesai = new TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//   }

//   Future<void> initData() async {}

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
//         title: Text("Perjalanan Dinas"),
//       ),
//       body: ListView(
//         // crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             margin: EdgeInsets.only(bottom: 5, left: 35, top: 20),
//             child: Text("Nama Kegiatan",
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
//               controller: cNamaKegiatan,
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
//             child: Text("Tanggal Mulai",
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
//                   cTanggalMulai.text =
//                       convertDateTimeDisplay(pickedDate.toString());
//                 });
//               },
//               controller: cTanggalMulai,
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
//             child: Text("Tanggal Selesai",
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
//                   cTanggalSelesai.text =
//                       convertDateTimeDisplay(pickedDate.toString());
//                 });
//               },
//               controller: cTanggalSelesai,
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

//                 ReturnCheck returnCheck = await _devService.perjalanDinas(
//                     accesToken,
//                     cTanggalMulai.text,
//                     cTanggalSelesai.text,
//                     cNamaKegiatan.text);

//                 WidgetSnackbar(
//                     context: context,
//                     message: returnCheck.remarks!,
//                     warna: "hijau");
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
