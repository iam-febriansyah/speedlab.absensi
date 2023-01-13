// import 'dart:convert';

// import 'package:flutter_application_1/api/api_service.dart';
// import 'package:flutter_application_1/models/myovertime/return.dart';
// import 'package:flutter_application_1/models/return_check.dart';
// import 'package:flutter_application_1/style/colors.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// // ignore: import_of_legacy_library_into_null_safe
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class MenuLembur extends StatefulWidget {
//   @override
//   _MenuLemburState createState() => _MenuLemburState();
// }

// class _MenuLemburState extends State<MenuLembur> {
//   DevService _devService = DevService();

//   late List<Listovertime> listovertime = [];
//   Future getData() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     var accesToken = pref.getString("PREF_TOKEN")!;

//     _devService.myovertime(accesToken).then((value) async {
//       var res = ReturnMyOvertime.fromJson(json.decode(value));
//       if (mounted) if (res.statusJson == true) {
//         setState(() {
//           listovertime = res.listovertime;
//         });
//       }
//     });
//   }

//   TextEditingController tanggalLembur = TextEditingController();
//   TextEditingController timestart = TextEditingController();
//   TextEditingController timeend = TextEditingController();
//   TextEditingController keterangan = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     getData();
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
//         backgroundColor: Colors.white,
//         body: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: 16),
//               Container(
//                 child: Center(
//                   child: Text(
//                     "Lembur",
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
//               // Container(
//               //   margin: EdgeInsets.only(bottom: 5, left: 35, top: 20),
//               //   child: Text("Title",
//               //       style: TextStyle(
//               //           fontWeight: FontWeight.w600, letterSpacing: 0)),
//               // ),
//               // Container(
//               //   margin: EdgeInsets.only(top: 15, left: 30, right: 20),
//               //   child: TextFormField(
//               //     //    controller: ctrlMaritalStatus,
//               //     style: GoogleFonts.ibmPlexSans(
//               //         textStyle:
//               //             TextStyle(fontSize: 15, color: Color(0xff4a4c4f))),
//               //     decoration: InputDecoration(
//               //       hintText: "Title",
//               //       hintStyle: GoogleFonts.ibmPlexSans(
//               //           textStyle:
//               //               TextStyle(fontSize: 15, color: Color(0xff4a4c4f))),
//               //       border: OutlineInputBorder(
//               //           borderRadius: BorderRadius.all(
//               //             Radius.circular(8.0),
//               //           ),
//               //           borderSide: BorderSide.none),
//               //       enabledBorder: OutlineInputBorder(
//               //           borderRadius: BorderRadius.all(
//               //             Radius.circular(8.0),
//               //           ),
//               //           borderSide: BorderSide.none),
//               //       focusedBorder: OutlineInputBorder(
//               //           borderRadius: BorderRadius.all(
//               //             Radius.circular(8.0),
//               //           ),
//               //           borderSide: BorderSide.none),
//               //       filled: true,
//               //       fillColor: Color(0xfffafaff),
//               //       prefixIcon: Icon(
//               //         Icons.title,
//               //         size: 22,
//               //       ),
//               //       isDense: true,
//               //       contentPadding: EdgeInsets.all(0),
//               //     ),
//               //     keyboardType: TextInputType.emailAddress,
//               //     textCapitalization: TextCapitalization.sentences,
//               //   ),
//               // ),'

//               SizedBox(
//                 height: 30,
//               ),
//               Container(
//                 margin: EdgeInsets.only(bottom: 5, left: 35, top: 10),
//                 child: Text("Tanggal",
//                     style: TextStyle(
//                         fontWeight: FontWeight.w600, letterSpacing: 0)),
//               ),
//               Container(
//                 margin: EdgeInsets.only(top: 5, left: 30, right: 20),
//                 decoration: BoxDecoration(
//                   boxShadow: [
//                     BoxShadow(
//                       color: Color(0x3f000000),
//                       blurRadius: 4,
//                       offset: Offset(1, 1),
//                     ),
//                   ],
//                 ),
//                 child: TextFormField(
//                   onTap: () {
//                     showDatePicker(
//                       context: context,
//                       initialDate: DateTime.now(),
//                       firstDate: DateTime(2022, 1),
//                       lastDate: DateTime(2024, 12),
//                     ).then((pickedDate) {
//                       tanggalLembur.text =
//                           convertDateTimeDisplay(pickedDate.toString());
//                     });
//                   },
//                   controller: tanggalLembur,
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
//                 child: Text("Jam In",
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
//                 child: Text("Jam Out",
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
//                 height: 30,
//               ),
//               Center(
//                 // ignore: deprecated_member_use
//                 child: ElevatedButton(
//                   onPressed: () async {
//                     SharedPreferences pref =
//                         await SharedPreferences.getInstance();
//                     var accesToken = pref.getString("PREF_TOKEN")!;
//                     var idstaff = pref.getString("PREF_NIP")!;

//                     _devService
//                         .overtime(
//                             accesToken,
//                             idstaff,
//                             tanggalLembur.text,
//                             keterangan.text,
//                             tanggalLembur.text,
//                             timestart.text,
//                             timeend.text)
//                         .then((value) async {
//                       var res = ReturnCheck.fromJson(json.decode(value));

//                       if (res.statusJson == true) {
//                         getData();
//                       }
//                     });
//                     // }
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
//               SizedBox(
//                 height: 15,
//               ),

//               Container(
//                 margin: EdgeInsets.only(bottom: 5, left: 35, top: 20),
//                 child: Text("History Overtime",
//                     style: TextStyle(
//                         fontWeight: FontWeight.w600, letterSpacing: 0)),
//               ),
//               SizedBox(
//                 height: 15,
//               ),
//               Container(
//                 height: 250,
//                 child: ListView.builder(
//                     itemCount: listovertime.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       return card2(
//                         listovertime[index],
//                       );
//                     }),
//               ),

//               SizedBox(
//                 height: 50,
//               )
//             ],
//           ),
//         ));
//   }
// }

// Widget card2(Listovertime item) {
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
//                   child: Text(item.tanggal,
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
//                     Text("Jam in",
//                         style: GoogleFonts.ibmPlexSans(
//                             textStyle: TextStyle(
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: 14,
//                                 color: Color(0xff4a4c4f)))),
//                     Text(item.jamMulai,
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
//                     Text("Jam Out",
//                         style: GoogleFonts.ibmPlexSans(
//                             textStyle: TextStyle(
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: 14,
//                                 color: Color(0xff4a4c4f)))),
//                     Text(item.jamAkhir,
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
//                       Text(item.ket,
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
//                     color: (item.status.toString() == "null" ||
//                             item.status.toString() == "0")
//                         ? Colors.blueGrey
//                         : Colors.green,
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

// Widget card(Listovertime item) {
//   // DateTime tempDate =
//   //     DateFormat("yyyy-MM-dd hh:mm:ss").parse("2020-08-09 00:00:00");
//   // String tanggal = DateFormat('dd').format(tempDate);
//   // String hari = DateFormat('EEEE').format(tempDate);
//   // String bulantahun = DateFormat('MM/yyyy').format(tempDate);
//   // String wfhWfo = item.wfhWfo!.toUpperCase();
//   // String datangPulang = item.datangPulang!.toUpperCase();
//   // String tanggalAbsen = item.tanggalAbsen!;
//   // String jamAbsen = item.jamAbsen!;

//   return Center(
//     child: Container(
//         width: SizeConfig.screenWidth * 0.9,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           boxShadow: [
//             BoxShadow(
//               color: Color(0x3f000000),
//               blurRadius: 4,
//               offset: Offset(1, 1),
//             ),
//           ],
//           color: Color(0xfffafaff),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Row(
//             children: [
//               Container(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(
//                       child: Text(
//                         "TANGGAL           :   " + item.tanggal,
//                         textAlign: TextAlign.center,
//                         style: GoogleFonts.ibmPlexSans(
//                             textStyle: TextStyle(
//                                 fontSize: 12, color: Color(0xff4a4c4f))),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 5,
//                     ),
//                     SizedBox(
//                       child: Text(
//                         "JAM IN                :  " + item.jamMulai,
//                         textAlign: TextAlign.center,
//                         style: GoogleFonts.ibmPlexSans(
//                             textStyle: TextStyle(
//                                 fontSize: 12, color: Color(0xff4a4c4f))),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 5,
//                     ),
//                     SizedBox(
//                       child: Text(
//                         "JAM OUT            :  " + item.jamAkhir,
//                         textAlign: TextAlign.center,
//                         style: GoogleFonts.ibmPlexSans(
//                             textStyle: TextStyle(
//                                 fontSize: 12, color: Color(0xff4a4c4f))),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 5,
//                     ),
//                     (item.status.toString() == "null" ||
//                             item.status.toString() == "0")
//                         ? SizedBox(
//                             child: Text(
//                               "STATUS               :  " + "PENDING",
//                               textAlign: TextAlign.center,
//                               style: GoogleFonts.ibmPlexSans(
//                                   textStyle: TextStyle(
//                                       fontSize: 12, color: Colors.orange)),
//                             ),
//                           )
//                         : SizedBox(
//                             child: Text(
//                               "STATUS               :  " + "ACCEPTED",
//                               textAlign: TextAlign.center,
//                               style: GoogleFonts.ibmPlexSans(
//                                   textStyle: TextStyle(
//                                       fontSize: 12, color: Colors.green)),
//                             ),
//                           )
//                   ],
//                 ),
//               ),
//               // Container(
//               //     height: 80,
//               //     child: VerticalDivider(color: ColorsTheme.primary1)),
//             ],
//           ),
//         )),
//   );
// }
