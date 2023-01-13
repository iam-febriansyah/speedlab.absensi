// // ignore_for_file: import_of_legacy_library_into_null_safe

// import 'dart:convert';

// import 'package:flutter_application_1/api/api_service.dart';
// import 'package:flutter_application_1/models/leavetype/return.dart';
// import 'package:flutter_application_1/models/myleave/return.dart';
// import 'package:flutter_application_1/models/return_check.dart';
// import 'package:flutter_application_1/pages/general_widget/widget_snackbar.dart';
// import 'package:flutter_application_1/style/colors.dart';
// // import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:io' as Io;
// import 'package:file_picker/file_picker.dart';

// class MenuApplication extends StatefulWidget {
//   @override
//   _MenuApplicationState createState() => _MenuApplicationState();
// }

// enum SingingCharacter { lafayette, jefferson }

// class _MenuApplicationState extends State<MenuApplication> {
//   DevService _devService = DevService();

//   late List<ReturnMyLeaveListleave> listleave = [];
//   late List<ReturnLeaveTypeLeaveType?> listleavetype = [];

//   Future getlistLeave() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     var accesToken = pref.getString("PREF_TOKEN")!;

//     _devService.myleave(accesToken).then((value) async {
//       var res = ReturnMyLeave.fromJson(json.decode(value));

//       if (res.statusJson == true) {
//         setState(() {
//           listleave = res.listleave;
//         });
//       }
//     });
//   }

//   Future getlistLeaveType() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     var accesToken = pref.getString("PREF_TOKEN")!;

//     _devService.leaveType(accesToken).then((value) async {
//       var res = ReturnLeaveType.fromJson(json.decode(value));

//       if (res.statusJson == true) {
//         setState(() {
//           listleavetype = res.leaveType!;
//         });
//       }
//     });
//   }

//   TextEditingController timestart = TextEditingController();
//   TextEditingController timeend = TextEditingController();
//   TextEditingController tanggalMulai = TextEditingController();
//   TextEditingController tanggalAkhir = TextEditingController();
//   TextEditingController keterangan = TextEditingController();
//   TextEditingController tipe = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     getlistLeave();
//     getlistLeaveType();
//   }

//   String convertDateTimeDisplay(String date) {
//     final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
//     final DateFormat serverFormater = DateFormat('yyyy-MM-dd');
//     final DateTime displayDate = displayFormater.parse(date);
//     final String formatted = serverFormater.format(displayDate);
//     return formatted;
//   }

//   String? _fileName;
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
//   // ignore: unused_field
//   TextEditingController _controller = TextEditingController();
//   bool? optionTitle = false;

//   void _openFileExplorer() async {
//     setState(() => _loadingPath = true);
//     try {
//       _directoryPath = null;
//       _paths = (await FilePicker.platform.pickFiles(
//         type: _pickingType,
//         allowMultiple: _multiPick,
//         onFileLoading: (FilePickerStatus status) => print(status),
//         allowedExtensions: ['pdf'],
//       ))
//           ?.files;

//       final path = _paths!.map((e) => e.path).toList()[0].toString();
//       final bytes = Io.File(path).readAsBytesSync();

//       pdf64 = base64Encode(bytes);
//     } on PlatformException catch (e) {
//     } catch (ex) {}
//     if (!mounted) return;
//     setState(() {
//       _loadingPath = false;
//       _fileName =
//           _paths != null ? _paths!.map((e) => e.name).toString() : '...';
//     });
//   }

//   // ignore: unused_field
//   SingingCharacter? _character;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.white,
//         body: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: 16),
//               Container(
//                 child: Center(
//                   child: Text(
//                     "Leave Application",
//                     textAlign: TextAlign.left,
//                     style: TextStyle(
//                       color: Color(0xff171111),
//                       fontSize: 20,
//                       fontFamily: "Sansation Light",
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 30,
//               ),
//               Container(
//                 margin: EdgeInsets.only(bottom: 5, left: 35, top: 20),
//                 child: Text("Pilih kategori",
//                     style: TextStyle(
//                         fontWeight: FontWeight.w600, letterSpacing: 0)),
//               ),
//               Container(
//                 decoration: BoxDecoration(
//                   boxShadow: [
//                     BoxShadow(
//                       color: Color(0x3f000000),
//                       blurRadius: 4,
//                       offset: Offset(1, 1),
//                     ),
//                   ],
//                 ),
//                 margin: EdgeInsets.only(top: 15, left: 30, right: 20),
//                 child: TextFormField(
//                   readOnly: true,
//                   onTap: () {
//                     setState(() {
//                       optionTitle = true;
//                     });
//                   },
//                   controller: tipe,
//                   style: GoogleFonts.ibmPlexSans(
//                       textStyle:
//                           TextStyle(fontSize: 15, color: Color(0xff4a4c4f))),
//                   decoration: InputDecoration(
//                     //    enabled: false,
//                     hintText: "Kategori",
//                     hintStyle: GoogleFonts.ibmPlexSans(
//                         textStyle:
//                             TextStyle(fontSize: 15, color: Color(0xff4a4c4f))),
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(8.0),
//                         ),
//                         borderSide: BorderSide.none),
//                     enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(8.0),
//                         ),
//                         borderSide: BorderSide.none),
//                     focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(8.0),
//                         ),
//                         borderSide: BorderSide.none),
//                     filled: true,
//                     fillColor: Color(0xfffafaff),
//                     prefixIcon: Icon(
//                       Icons.title,
//                       size: 22,
//                     ),
//                     isDense: true,
//                     contentPadding: EdgeInsets.all(0),
//                   ),
//                   keyboardType: TextInputType.emailAddress,
//                   textCapitalization: TextCapitalization.sentences,
//                 ),
//               ),
//               if (optionTitle == true)
//                 SizedBox(
//                   height: 8,
//                 ),
//               if (optionTitle == true)
//                 Container(
//                   height: MediaQuery.of(context).size.height * 0.18,
//                   child: ListView.builder(
//                     padding: EdgeInsets.only(top: 10),
//                     itemCount: listleavetype.length,
//                     itemBuilder: (context, position) {
//                       String typeName =
//                           listleavetype[position]!.leavetype ?? "";
//                       return Padding(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 20, vertical: 8),
//                           child: GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 optionTitle = false;
//                                 tipe.text = typeName;
//                               });
//                             },
//                             child: Container(
//                               decoration: new BoxDecoration(
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Color(0x3f000000),
//                                       blurRadius: 4,
//                                       offset: Offset(1, 1),
//                                     ),
//                                   ],
//                                   color: Color(0xfffafaff),
//                                   borderRadius: new BorderRadius.all(
//                                     Radius.circular(5.0),
//                                     //  topRight: const Radius.circular(15.0),
//                                   )),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(6.0),
//                                 child: Text(" -> " + typeName,
//                                     style: GoogleFonts.ibmPlexSans(
//                                         textStyle: TextStyle(
//                                             fontSize: 15,
//                                             color: Color(0xff4a4c4f)))),
//                               ),
//                             ),
//                           ));
//                       // leading: Radio<SingingCharacter>(
//                       //   value: SingingCharacter.lafayette,
//                       //   groupValue: _character,
//                       //   onChanged: (SingingCharacter? value) {
//                       //     setState(() {
//                       //       // _character = value;
//                       //       // optionTitle = false;
//                       //       tipe.text = typeName;
//                       //     });
//                       //   },
//                       // ),
//                     },
//                   ),
//                 ),
//               // Padding(
//               //   padding: const EdgeInsets.symmetric(horizontal: 20),
//               //   child: ListTile(
//               //     title: const Text('Izin'),
//               //     leading: Radio<SingingCharacter>(
//               //       value: SingingCharacter.lafayette,
//               //       groupValue: _character,
//               //       onChanged: (SingingCharacter? value) {
//               //         setState(() {
//               //           _character = value;
//               //           optionTitle = false;
//               //           tipe.text = "Izin";
//               //         });
//               //       },
//               //     ),
//               //   ),
//               // ),
//               // if (optionTitle == true)
//               //   Padding(
//               //     padding: const EdgeInsets.symmetric(horizontal: 20),
//               //     child: ListTile(
//               //       title: const Text('Sakit'),
//               //       leading: Radio<SingingCharacter>(
//               //         value: SingingCharacter.jefferson,
//               //         groupValue: _character,
//               //         onChanged: (SingingCharacter? value) {
//               //           setState(() {
//               //             _character = value;
//               //             optionTitle = false;
//               //             tipe.text = "Sakit";
//               //           });
//               //         },
//               //       ),
//               //     ),
//               //   ),
//               Container(
//                 margin: EdgeInsets.only(bottom: 5, left: 35, top: 20),
//                 child: Text("Tanggal Mulai",
//                     style: TextStyle(
//                         fontWeight: FontWeight.w600, letterSpacing: 0)),
//               ),
//               Container(
//                 decoration: BoxDecoration(
//                   boxShadow: [
//                     BoxShadow(
//                       color: Color(0x3f000000),
//                       blurRadius: 4,
//                       offset: Offset(1, 1),
//                     ),
//                   ],
//                 ),
//                 margin: EdgeInsets.only(top: 5, left: 30, right: 20),
//                 child: TextFormField(
//                   controller: tanggalMulai,
//                   onTap: () {
//                     showDatePicker(
//                       context: context,
//                       initialDate: DateTime.now(),
//                       firstDate: DateTime(2021, 1),
//                       lastDate: DateTime(2023, 12),
//                     ).then((pickedDate) {
//                       tanggalMulai.text =
//                           convertDateTimeDisplay(pickedDate.toString());
//                     });
//                   },
//                   style: GoogleFonts.ibmPlexSans(
//                       textStyle:
//                           TextStyle(fontSize: 15, color: Color(0xff4a4c4f))),
//                   decoration: InputDecoration(
//                     hintText: "mm/dd/yyyy",
//                     hintStyle: GoogleFonts.ibmPlexSans(
//                         textStyle:
//                             TextStyle(fontSize: 15, color: Color(0xff4a4c4f))),
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(8.0),
//                         ),
//                         borderSide: BorderSide.none),
//                     enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(8.0),
//                         ),
//                         borderSide: BorderSide.none),
//                     focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(8.0),
//                         ),
//                         borderSide: BorderSide.none),
//                     filled: true,
//                     fillColor: Color(0xfffafaff),
//                     prefixIcon: Icon(
//                       Icons.date_range,
//                       size: 22,
//                     ),
//                     isDense: true,
//                     contentPadding: EdgeInsets.all(0),
//                   ),
//                   keyboardType: TextInputType.emailAddress,
//                   textCapitalization: TextCapitalization.sentences,
//                 ),
//               ),
//               Container(
//                 margin: EdgeInsets.only(bottom: 5, left: 35, top: 20),
//                 child: Text("Tanggal Akhir",
//                     style: TextStyle(
//                         fontWeight: FontWeight.w600, letterSpacing: 0)),
//               ),
//               Container(
//                 decoration: BoxDecoration(
//                   boxShadow: [
//                     BoxShadow(
//                       color: Color(0x3f000000),
//                       blurRadius: 4,
//                       offset: Offset(1, 1),
//                     ),
//                   ],
//                 ),
//                 margin: EdgeInsets.only(top: 5, left: 30, right: 20),
//                 child: TextFormField(
//                   controller: tanggalAkhir,
//                   onTap: () {
//                     showDatePicker(
//                       context: context,
//                       initialDate: DateTime.now(),
//                       firstDate: DateTime(2020, 1),
//                       lastDate: DateTime(2023, 12),
//                     ).then((pickedDate) {
//                       tanggalAkhir.text =
//                           convertDateTimeDisplay(pickedDate.toString());
//                     });
//                   },
//                   style: GoogleFonts.ibmPlexSans(
//                       textStyle:
//                           TextStyle(fontSize: 15, color: Color(0xff4a4c4f))),
//                   decoration: InputDecoration(
//                     hintText: "mm/dd/yyyy",
//                     hintStyle: GoogleFonts.ibmPlexSans(
//                         textStyle:
//                             TextStyle(fontSize: 15, color: Color(0xff4a4c4f))),
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(8.0),
//                         ),
//                         borderSide: BorderSide.none),
//                     enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(8.0),
//                         ),
//                         borderSide: BorderSide.none),
//                     focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(8.0),
//                         ),
//                         borderSide: BorderSide.none),
//                     filled: true,
//                     fillColor: Color(0xfffafaff),
//                     prefixIcon: Icon(
//                       Icons.date_range,
//                       size: 22,
//                     ),
//                     isDense: true,
//                     contentPadding: EdgeInsets.all(0),
//                   ),
//                   keyboardType: TextInputType.emailAddress,
//                   textCapitalization: TextCapitalization.sentences,
//                 ),
//               ),
//               Container(
//                 margin: EdgeInsets.only(bottom: 5, left: 35, top: 20),
//                 child: Text("Jam Mulai",
//                     style: TextStyle(
//                         fontWeight: FontWeight.w600, letterSpacing: 0)),
//               ),
//               Container(
//                 decoration: BoxDecoration(
//                   boxShadow: [
//                     BoxShadow(
//                       color: Color(0x3f000000),
//                       blurRadius: 4,
//                       offset: Offset(1, 1),
//                     ),
//                   ],
//                 ),
//                 margin: EdgeInsets.only(top: 5, left: 30, right: 20),
//                 child: TextFormField(
//                   controller: timestart, //editing controller of this TextField

//                   onTap: () async {
//                     TimeOfDay? pickedTime = await showTimePicker(
//                       initialTime: TimeOfDay.now(),
//                       context: context,
//                     );

//                     if (pickedTime != null) {
//                       setState(() {
//                         timestart.text = pickedTime.format(context).toString();
//                       });
//                     } else {}
//                   },

//                   //    controller: ctrlMaritalStatus,
//                   style: GoogleFonts.ibmPlexSans(
//                       textStyle:
//                           TextStyle(fontSize: 15, color: Color(0xff4a4c4f))),
//                   decoration: InputDecoration(
//                     //  hintText: "mm/dd/yyyy",
//                     hintStyle: GoogleFonts.ibmPlexSans(
//                         textStyle:
//                             TextStyle(fontSize: 15, color: Color(0xff4a4c4f))),
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(8.0),
//                         ),
//                         borderSide: BorderSide.none),
//                     enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(8.0),
//                         ),
//                         borderSide: BorderSide.none),
//                     focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(8.0),
//                         ),
//                         borderSide: BorderSide.none),
//                     filled: true,
//                     fillColor: Color(0xfffafaff),
//                     prefixIcon: Icon(
//                       Icons.alarm,
//                       size: 22,
//                     ),
//                     isDense: true,
//                     contentPadding: EdgeInsets.all(0),
//                   ),
//                   keyboardType: TextInputType.emailAddress,
//                   textCapitalization: TextCapitalization.sentences,
//                 ),
//               ),
//               Container(
//                 margin: EdgeInsets.only(bottom: 5, left: 35, top: 20),
//                 child: Text("Jam Akhir",
//                     style: TextStyle(
//                         fontWeight: FontWeight.w600, letterSpacing: 0)),
//               ),
//               Container(
//                 decoration: BoxDecoration(
//                   boxShadow: [
//                     BoxShadow(
//                       color: Color(0x3f000000),
//                       blurRadius: 4,
//                       offset: Offset(1, 1),
//                     ),
//                   ],
//                 ),
//                 margin: EdgeInsets.only(top: 5, left: 30, right: 20),
//                 child: TextFormField(
//                   controller: timeend, //editing controller of this TextField

//                   onTap: () async {
//                     TimeOfDay? pickedTime = await showTimePicker(
//                       initialTime: TimeOfDay.now(),
//                       context: context,
//                     );

//                     if (pickedTime != null) {
//                       setState(() {
//                         timeend.text = pickedTime.format(context).toString();
//                       });
//                     }
//                   },

//                   //    controller: ctrlMaritalStatus,
//                   style: GoogleFonts.ibmPlexSans(
//                       textStyle:
//                           TextStyle(fontSize: 15, color: Color(0xff4a4c4f))),
//                   decoration: InputDecoration(
//                     //  hintText: "mm/dd/yyyy",
//                     hintStyle: GoogleFonts.ibmPlexSans(
//                         textStyle:
//                             TextStyle(fontSize: 15, color: Color(0xff4a4c4f))),
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(8.0),
//                         ),
//                         borderSide: BorderSide.none),
//                     enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(8.0),
//                         ),
//                         borderSide: BorderSide.none),
//                     focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(8.0),
//                         ),
//                         borderSide: BorderSide.none),
//                     filled: true,
//                     fillColor: Color(0xfffafaff),
//                     prefixIcon: Icon(
//                       Icons.alarm,
//                       size: 22,
//                     ),
//                     isDense: true,
//                     contentPadding: EdgeInsets.all(0),
//                   ),
//                   keyboardType: TextInputType.emailAddress,
//                   textCapitalization: TextCapitalization.sentences,
//                 ),
//               ),
//               Container(
//                 margin: EdgeInsets.only(bottom: 5, left: 35, top: 20),
//                 child: Text("Keterangan",
//                     style: TextStyle(
//                         fontWeight: FontWeight.w600, letterSpacing: 0)),
//               ),
//               Container(
//                 decoration: BoxDecoration(
//                   boxShadow: [
//                     BoxShadow(
//                       color: Color(0x3f000000),
//                       blurRadius: 4,
//                       offset: Offset(1, 1),
//                     ),
//                   ],
//                 ),
//                 margin: EdgeInsets.only(top: 15, left: 30, right: 20),
//                 child: TextFormField(
//                   maxLines: 3,
//                   controller: keterangan,
//                   style: GoogleFonts.ibmPlexSans(
//                       textStyle:
//                           TextStyle(fontSize: 15, color: Color(0xff4a4c4f))),
//                   decoration: InputDecoration(
//                     hintText: "",
//                     hintStyle: GoogleFonts.ibmPlexSans(
//                         textStyle:
//                             TextStyle(fontSize: 15, color: Color(0xff4a4c4f))),
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(8.0),
//                         ),
//                         borderSide: BorderSide.none),
//                     enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(8.0),
//                         ),
//                         borderSide: BorderSide.none),
//                     focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(8.0),
//                         ),
//                         borderSide: BorderSide.none),
//                     filled: true,
//                     fillColor: Color(0xfffafaff),
//                     isDense: true,
//                     contentPadding: EdgeInsets.all(15),
//                   ),
//                   keyboardType: TextInputType.emailAddress,
//                   textCapitalization: TextCapitalization.sentences,
//                 ),
//               ),
//               SizedBox(
//                 height: 15,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Container(
//                     margin: EdgeInsets.only(bottom: 5, left: 35, top: 20),
//                     child: Text("File tambahan",
//                         style: TextStyle(
//                             fontWeight: FontWeight.w600, letterSpacing: 0)),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       _openFileExplorer();
//                     },
//                     child: Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         color: Colors.blueGrey,
//                       ),
//                       margin: EdgeInsets.only(bottom: 5, right: 30, top: 20),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 15, vertical: 5),
//                         child: Text("Add PDF",
//                             style: TextStyle(
//                                 fontSize: 12,
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w600,
//                                 letterSpacing: 0)),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//               Container(
//                 margin: EdgeInsets.only(bottom: 15, left: 35, top: 0),
//                 child: Text(_fileName ?? "",
//                     style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 12,
//                         fontWeight: FontWeight.w400,
//                         letterSpacing: 0)),
//               ),
//               Center(
//                 // ignore: deprecated_member_use
//                 child: ElevatedButton(
//                   onPressed: () async {
//                     if (tanggalMulai.text == "" ||
//                         keterangan.text == "" ||
//                         tipe.text == "" ||
//                         tanggalMulai.text == "" ||
//                         tanggalAkhir.text == "" ||
//                         timestart.text == "" ||
//                         timeend.text == "") {
//                     } else {
//                       SharedPreferences pref =
//                           await SharedPreferences.getInstance();
//                       var accesToken = pref.getString("PREF_TOKEN")!;
//                       var idstaff = pref.getString("PREF_NIP")!;

//                       _devService
//                           .leave(
//                         accesToken,
//                         idstaff,
//                         tanggalMulai.text,
//                         keterangan.text,
//                         tipe.text,
//                         tanggalMulai.text,
//                         tanggalAkhir.text,
//                         timestart.text,
//                         timeend.text,
//                         //pdf64 ?? ""
//                       )
//                           .then((value) async {
//                         var res = ReturnCheck.fromJson(json.decode(value));

//                         if (res.statusJson == true) {
//                           WidgetSnackbar(
//                               context: context,
//                               message: "Pengajuan ditambahkan",
//                               warna: "hijau");
//                           getlistLeave();
//                         }
//                       });
//                     }
//                   },
//                   style: ButtonStyle(
//                       backgroundColor: MaterialStateProperty.all<Color>(
//                           ColorsTheme.primary1),
//                       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                           RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ))),
//                   child: Padding(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
//                     child: Text(
//                       "AJUKAN",
//                       style: TextStyle(color: Colors.white, fontSize: 16),
//                     ),
//                   ),
//                 ),
//               ),
//               Container(
//                 margin: EdgeInsets.only(bottom: 5, left: 35, top: 25),
//                 child: Text("History Leave Application",
//                     style: TextStyle(
//                         fontWeight: FontWeight.w600, letterSpacing: 0)),
//               ),
//               SizedBox(
//                 height: 15,
//               ),
//               Container(
//                 height: 350,
//                 child: ListView.builder(
//                     padding: EdgeInsets.zero,
//                     itemCount: listleave.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       // return Padding(
//                       //   padding: const EdgeInsets.only(
//                       //       left: 26, right: 25, bottom: 10, top: 5),
//                       //   child: card(listleave[index]),
//                       // );

//                       return card2(listleave[index]);
//                     }),
//               ),
//               SizedBox(
//                 height: 100,
//               )
//             ],
//           ),
//         ));
//   }
// }

// Widget card2(ReturnMyLeaveListleave item) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//     child: Card(
//       elevation: 2,
//       //   shadowColor: Colors.blue,
//       child: Container(
//         //     height: 200,
//         child: Column(
//           children: [
//             SizedBox(
//               height: 10,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 // Icon(Icons.topic_outlined, size: 20, color: Colors.grey),
//                 // SizedBox(
//                 //   width: 5,
//                 // ),
//                 Container(
//                   margin: EdgeInsets.symmetric(horizontal: 20),
//                   child: Text(item.tipe ?? "",
//                       style: GoogleFonts.ibmPlexSans(
//                           textStyle: TextStyle(
//                               fontWeight: FontWeight.w600,
//                               fontSize: 14,
//                               color: Color(0xff4a4c4f)))),
//                 ),
//                 Container(
//                     margin: EdgeInsets.symmetric(horizontal: 20),
//                     child:
//                         Icon(Icons.more_vert, size: 20, color: Colors.black)),
//               ],
//             ),
//             SizedBox(
//               height: 5,
//             ),
//             Row(
//               children: [
//                 SizedBox(
//                   width: 20,
//                 ),
//                 Column(
//                   children: [
//                     Text("Mulai",
//                         style: GoogleFonts.ibmPlexSans(
//                             textStyle: TextStyle(
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: 14,
//                                 color: Color(0xff4a4c4f)))),
//                     Text(item.mulai ?? "",
//                         style: GoogleFonts.ibmPlexSans(
//                             textStyle: TextStyle(
//                                 fontWeight: FontWeight.w400,
//                                 fontSize: 14,
//                                 color: Color(0xff4a4c4f)))),
//                     Text(item.jamMulai ?? "",
//                         style: GoogleFonts.ibmPlexSans(
//                             textStyle: TextStyle(
//                                 fontWeight: FontWeight.w400,
//                                 fontSize: 14,
//                                 color: Color(0xff4a4c4f)))),
//                   ],
//                 ),
//                 Spacer(),
//                 Column(
//                   children: [
//                     Text("Akhir",
//                         style: GoogleFonts.ibmPlexSans(
//                             textStyle: TextStyle(
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: 14,
//                                 color: Color(0xff4a4c4f)))),
//                     Text(item.akhir ?? "",
//                         style: GoogleFonts.ibmPlexSans(
//                             textStyle: TextStyle(
//                                 fontWeight: FontWeight.w400,
//                                 fontSize: 14,
//                                 color: Color(0xff4a4c4f)))),
//                     Text(item.jamAkhir.toString(),
//                         style: GoogleFonts.ibmPlexSans(
//                             textStyle: TextStyle(
//                                 fontWeight: FontWeight.w400,
//                                 fontSize: 14,
//                                 color: Color(0xff4a4c4f)))),
//                   ],
//                 ),
//                 SizedBox(
//                   width: 20,
//                 ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 10, bottom: 10),
//               child: Divider(
//                 color: Colors.grey,
//                 height: 1,
//               ),
//             ),
//             Row(
//               children: [
//                 SizedBox(
//                   width: 20,
//                 ),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Ket:",
//                           style: GoogleFonts.ibmPlexSans(
//                               textStyle: TextStyle(
//                                   fontWeight: FontWeight.w400,
//                                   fontSize: 14,
//                                   color: Color(0xff4a4c4f)))),
//                       Text(item.ket ?? "",
//                           style: GoogleFonts.ibmPlexSans(
//                               textStyle: TextStyle(
//                                   fontWeight: FontWeight.w500,
//                                   fontSize: 15,
//                                   color: Color(0xff4a4c4f)))),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     color: Colors.blueGrey,
//                   ),
//                   margin: EdgeInsets.only(bottom: 5, right: 30, top: 20),
//                   child: Padding(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
//                     child: Text(
//                         (item.status.toString() == "null" ||
//                                 item.status.toString() == "0")
//                             ? "PENDING"
//                             : "ACCEPTED",
//                         style: TextStyle(
//                             fontSize: 12,
//                             color: Colors.white,
//                             fontWeight: FontWeight.w600,
//                             letterSpacing: 0)),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 5,
//             )
//           ],
//         ),
//       ),
//     ),
//   );
// }

// // Widget card(ReturnMyLeaveListleave? item) {
// //   // DateTime tempDate =
// //   //     DateFormat("yyyy-MM-dd hh:mm:ss").parse("2020-08-09 00:00:00");
// //   // String tanggal = DateFormat('dd').format(tempDate);
// //   // String hari = DateFormat('EEEE').format(tempDate);
// //   // String bulantahun = DateFormat('MM/yyyy').format(tempDate);
// //   // String wfhWfo = item.wfhWfo!.toUpperCase();
// //   // String datangPulang = item.datangPulang!.toUpperCase();
// //   // String tanggalAbsen = item.tanggalAbsen!;
// //   // String jamAbsen = item.jamAbsen!;

// //   return Center(
// //     child: Container(
// //         width: SizeConfig.screenWidth * 0.9,
// //         decoration: BoxDecoration(
// //           borderRadius: BorderRadius.circular(10),
// //           boxShadow: [
// //             BoxShadow(
// //               color: Color(0x3f000000),
// //               blurRadius: 4,
// //               offset: Offset(1, 1),
// //             ),
// //           ],
// //           color: Color(0xfffafaff),
// //         ),
// //         child: Padding(
// //           padding: const EdgeInsets.all(20.0),
// //           child: Row(
// //             children: [
// //               Container(
// //                 child: Column(
// //                   mainAxisSize: MainAxisSize.min,
// //                   mainAxisAlignment: MainAxisAlignment.end,
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     SizedBox(
// //                       child: Text(
// //                         "TITLE                               :   " + item.tipe,
// //                         textAlign: TextAlign.center,
// //                         style: GoogleFonts.ibmPlexSans(
// //                             textStyle: TextStyle(
// //                                 fontSize: 12, color: Color(0xff4a4c4f))),
// //                       ),
// //                     ),
// //                     SizedBox(
// //                       height: 5,
// //                     ),
// //                     SizedBox(
// //                       child: Text(
// //                         "TANGGAL MULAI          :   " + item!.mulai ?? ,
// //                         textAlign: TextAlign.center,
// //                         style: GoogleFonts.ibmPlexSans(
// //                             textStyle: TextStyle(
// //                                 fontSize: 12, color: Color(0xff4a4c4f))),
// //                       ),
// //                     ),
// //                     SizedBox(
// //                       height: 5,
// //                     ),
// //                     SizedBox(
// //                       child: Text(
// //                         "TANGGAL AKHIR          :   " + item.akhir,
// //                         textAlign: TextAlign.center,
// //                         style: GoogleFonts.ibmPlexSans(
// //                             textStyle: TextStyle(
// //                                 fontSize: 12, color: Color(0xff4a4c4f))),
// //                       ),
// //                     ),
// //                     SizedBox(
// //                       height: 5,
// //                     ),
// //                     SizedBox(
// //                       child: Text(
// //                         "JAM IN                             :  " +
// //                             item.jamMulai,
// //                         textAlign: TextAlign.center,
// //                         style: GoogleFonts.ibmPlexSans(
// //                             textStyle: TextStyle(
// //                                 fontSize: 12, color: Color(0xff4a4c4f))),
// //                       ),
// //                     ),
// //                     SizedBox(
// //                       height: 5,
// //                     ),
// //                     SizedBox(
// //                       child: Text(
// //                         "JAM OUT                         :  " + item.jamAkhir,
// //                         textAlign: TextAlign.center,
// //                         style: GoogleFonts.ibmPlexSans(
// //                             textStyle: TextStyle(
// //                                 fontSize: 12, color: Color(0xff4a4c4f))),
// //                       ),
// //                     ),
// //                     SizedBox(
// //                       height: 5,
// //                     ),
// //                     (item.status.toString() == "null" ||
// //                             item.status.toString() == "0")
// //                         ? SizedBox(
// //                             child: Text(
// //                               "STATUS                            :  " +
// //                                   "PENDING",
// //                               textAlign: TextAlign.center,
// //                               style: GoogleFonts.ibmPlexSans(
// //                                   textStyle: TextStyle(
// //                                       fontSize: 12, color: Colors.orange)),
// //                             ),
// //                           )
// //                         : SizedBox(
// //                             child: Text(
// //                               "STATUS                :  " + "ACCEPTED",
// //                               textAlign: TextAlign.center,
// //                               style: GoogleFonts.ibmPlexSans(
// //                                   textStyle: TextStyle(
// //                                       fontSize: 12, color: Colors.green)),
// //                             ),
// //                           )
// //                   ],
// //                 ),
// //               ),
// //               // Container(
// //               //     height: 80,
// //               //     child: VerticalDivider(color: ColorsTheme.primary1)),
// //             ],
// //           ),
// //         )),
// //   );
// // }
