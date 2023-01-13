// import 'dart:convert';

// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_application_1/api/api_service_dokumen.dart';
// import 'package:flutter_application_1/api/api_service.dart';
// import 'package:flutter_application_1/models/documenttype/return.dart';
// import 'package:flutter_application_1/models/return_check.dart';
// import 'package:flutter_application_1/pages/general_widget/widget_snackbar.dart';
// import 'package:flutter_application_1/style/colors.dart';
// import 'package:google_fonts/google_fonts.dart';
// // ignore: import_of_legacy_library_into_null_safe
// import 'package:intl/intl.dart';

// import 'package:shared_preferences/shared_preferences.dart';

// class MLStaffDokumen extends StatefulWidget {
//   @override
//   _MLStaffDokumenState createState() => _MLStaffDokumenState();
// }

// class _MLStaffDokumenState extends State<MLStaffDokumen> {
//   String? dokumenId;
//   DevService _devService = DevService();

//   List<ReturnDocumentTypeListDocument?>? listDocumentType = [];

//   TextEditingController cTipeDokumen = new TextEditingController();
//   TextEditingController cTanggalMulai = new TextEditingController();
//   TextEditingController cTanggalSelesai = new TextEditingController();

//   @override
//   void initState() {
//     getDocumentType();
//     super.initState();
//   }

//   Future getDocumentType() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     var accesToken = pref.getString("PREF_TOKEN")!;

//     _devService.documentType(accesToken).then((value) async {
//       var res = ReturnDocumentType.fromJson(json.decode(value));

//       if (res.statusJson == true) {
//         setState(() {
//           listDocumentType = res.listDocument;
//         });
//       }
//     });
//   }

//   String convertDateTimeDisplay(String date) {
//     final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
//     final DateFormat serverFormater = DateFormat('yyyy-MM-dd');
//     final DateTime displayDate = displayFormater.parse(date);
//     final String formatted = serverFormater.format(displayDate);
//     return formatted;
//   }

//   String? _fileName;
//   String? _filePath;

//   String? pdf64;
//   List<PlatformFile>? _paths;
//   // ignore: unused_field
//   String? _directoryPath;
//   // ignore: unused_field
//   String? _extension;
//   // ignore: unused_field
//   bool _loadingPath = false;
//   bool _multiPick = false;
//   FileType _pickingType = FileType.custom;
//   bool? optionTitle = false;

//   void _openFileExplorer() async {
//     setState(() => _loadingPath = true);
//     try {
//       _directoryPath = null;
//       _paths = (await FilePicker.platform.pickFiles(
//         type: _pickingType,
//         allowMultiple: _multiPick,
//         onFileLoading: (FilePickerStatus status) => print(status),
//         allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg'],
//       ))
//           ?.files;

//       final path = _paths!.map((e) => e.path).toList()[0].toString();

//       // ignore: unnecessary_null_comparison
//       if (path != null || path != '') {
//         setState(() {
//           _filePath = path;
//         });
//       }
//     } on PlatformException catch (e) {
//     } catch (ex) {}
//     if (!mounted) return;
//     setState(() {
//       _loadingPath = false;
//       _fileName =
//           _paths != null ? _paths!.map((e) => e.name).toString() : '...';
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Staff Dokumen"),
//       ),
//       body: ListView(
//         // crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             margin: EdgeInsets.only(bottom: 5, left: 35, top: 20),
//             child: Text("Tipe Dokumen",
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
//               readOnly: true,
//               onTap: () {
//                 setState(() {
//                   optionTitle = true;
//                 });
//               },
//               controller: cTipeDokumen,
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
//           if (optionTitle == true)
//             SizedBox(
//               height: 8,
//             ),
//           if (optionTitle == true)
//             Container(
//               height: MediaQuery.of(context).size.height * 0.18,
//               child: ListView.builder(
//                 padding: EdgeInsets.only(top: 10),
//                 itemCount: listDocumentType?.length,
//                 itemBuilder: (context, position) {
//                   String typeName = listDocumentType?[position]!.nama ?? "";
//                   String typeId =
//                       listDocumentType?[position]!.id.toString() ?? "";

//                   return Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 20, vertical: 8),
//                       child: GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             optionTitle = false;
//                             dokumenId = typeId;
//                             cTipeDokumen.text = typeName;
//                           });
//                         },
//                         child: Container(
//                           decoration: new BoxDecoration(
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Color(0x3f000000),
//                                   blurRadius: 4,
//                                   offset: Offset(1, 1),
//                                 ),
//                               ],
//                               color: Color(0xfffafaff),
//                               borderRadius: new BorderRadius.all(
//                                 Radius.circular(5.0),
//                                 //  topRight: const Radius.circular(15.0),
//                               )),
//                           child: Padding(
//                             padding: const EdgeInsets.all(6.0),
//                             child: Text(" -> " + typeName,
//                                 style: GoogleFonts.ibmPlexSans(
//                                     textStyle: TextStyle(
//                                         fontSize: 15,
//                                         color: Color(0xff4a4c4f)))),
//                           ),
//                         ),
//                       ));
//                 },
//               ),
//             ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Container(
//                 margin: EdgeInsets.only(bottom: 5, left: 35, top: 20),
//                 child: Text("Tambahkan File",
//                     style: TextStyle(
//                         fontWeight: FontWeight.w600, letterSpacing: 0)),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   _openFileExplorer();
//                 },
//                 child: Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     color: Colors.blueGrey,
//                   ),
//                   margin: EdgeInsets.only(bottom: 5, right: 30, top: 20),
//                   child: Padding(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
//                     child: Text("File",
//                         style: TextStyle(
//                             fontSize: 12,
//                             color: Colors.white,
//                             fontWeight: FontWeight.w600,
//                             letterSpacing: 0)),
//                   ),
//                 ),
//               )
//             ],
//           ),
//           Container(
//             margin: EdgeInsets.only(bottom: 15, left: 35, top: 0),
//             child: Text(_fileName ?? "",
//                 style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 12,
//                     fontWeight: FontWeight.w400,
//                     letterSpacing: 0)),
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           Center(
//             // ignore: deprecated_member_use
//             child: ElevatedButton(
//               onPressed: () async {
//                 if (_filePath! != '') {
//                   SharedPreferences pref =
//                       await SharedPreferences.getInstance();
//                   var accesToken = pref.getString("PREF_TOKEN")!;

//                   DokumenService dokumenService = new DokumenService();

//                   ReturnCheck returnCheck = await dokumenService.postDocument(
//                       _filePath!, dokumenId ?? '', accesToken);

//                   WidgetSnackbar(
//                       context: context,
//                       message: returnCheck.remarks!,
//                       warna: "hijau");
//                 }
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
