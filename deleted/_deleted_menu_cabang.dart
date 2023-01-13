// // ignore: unnecessary_import
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/pages/absen/absen.dart';
// import 'package:flutter_application_1/provider/provider.cabang.dart';
// import 'package:flutter_html/flutter_html.dart';

// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';

// class PageCabang extends StatelessWidget {
//   final bool reverse;

//   const PageCabang({this.reverse = false});

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Container(
//           decoration: BoxDecoration(
//             border: Border.all(
//               color: Color.fromRGBO(193, 193, 193, 1),
//               width: 0.5,
//             ),
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(10),
//               topRight: Radius.circular(10),
//             ),
//             color: Colors.white,
//           ),
//           child: cabang(context)),
//     );
//   }

//   Widget cabang(BuildContext context) {
//     return Consumer<ProviderCabang>(builder: (context, provider, _) {
//       //provider.setFilterCabang('');

//       return ListView(
//         padding: EdgeInsets.zero,
//         shrinkWrap: true,
//         // controller: ModalScrollController.of(context),
//         physics: ClampingScrollPhysics(),
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(30.0),
//                 child: Container(
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(30),
//                         topRight: Radius.circular(30),
//                         bottomLeft: Radius.circular(30),
//                         bottomRight: Radius.circular(30),
//                       ),
//                       color: Color(0xFF00B1D3)),
//                   padding: EdgeInsets.symmetric(horizontal: 17, vertical: 10),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: <Widget>[
//                       Padding(
//                         padding: const EdgeInsets.only(top: 5),
//                         child: Text(
//                           'Pilih cabang',
//                           textAlign: TextAlign.left,
//                           style: GoogleFonts.mPlusRounded1c(
//                               color: Color.fromRGBO(255, 255, 255, 1),
//                               fontSize: 20,
//                               letterSpacing:
//                                   0 /*percentages not used in flutter. defaulting to zero*/,
//                               fontWeight: FontWeight.bold,
//                               height: 0.7),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(right: 20),
//                 child: FloatingActionButton(
//                   mini: true,
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   child: Icon(
//                     Icons.backspace,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Container(
//             margin: EdgeInsets.only(bottom: 15, top: 5, left: 30, right: 20),
//             child: TextFormField(
//               // controller: ctrlfilterCabang,
//               onChanged: (value) {
//                 if (value.length <= 1) {
//                   provider.setFilterCabang('reset');
//                 } else {
//                   provider.setFilterCabang(value.toLowerCase());
//                 }
//               },
//               style: GoogleFonts.ibmPlexSans(
//                   textStyle: TextStyle(fontSize: 16, color: Color(0xff4a4c4f))),
//               decoration: InputDecoration(
//                 hintText: "Search",
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
//                 prefixIcon: Icon(
//                   Icons.search,
//                   size: 22,
//                 ),
//                 isDense: true,
//                 contentPadding: EdgeInsets.all(0),
//               ),
//               keyboardType: TextInputType.emailAddress,
//               textCapitalization: TextCapitalization.sentences,
//             ),
//           ),
//           ListView.builder(
//               padding: EdgeInsets.zero,
//               shrinkWrap: true,
//               physics: ClampingScrollPhysics(),
//               //   itemCount: provider.returnCabang.listcabang?.length,
//               itemCount: provider.returnCabangFilter.listcabang?.length,
//               itemBuilder: (context, index) {
//                 String name = provider
//                         .returnCabangFilter.listcabang![index]?.namaCabang ??
//                     "";

//                 String alamat = provider
//                         .returnCabangFilter.listcabang![index]?.alamatCabang ??
//                     "";

//                 return GestureDetector(
//                     onTap: () async {
//                       provider.setCabangClick(index);

//                       // ignore: unnecessary_null_comparison
//                       if (provider.cabangClick != null) {
//                         // Get.to(AbsenForm());
//                         // Navigator.pushReplacement(
//                         //     context,
//                         //     MaterialPageRoute(
//                         //         builder: (BuildContext context) => AbsenForm(
//                         //               cabang: provider.returnCabangFilter
//                         //                   .listcabang![index]!,
//                         //                   idShift: w,
//                         //             )));
//                       }
//                     },
//                     child: (name != "")
//                         ? ListTile(
//                             contentPadding: EdgeInsets.only(
//                                 bottom: 5, top: 5, left: 15, right: 15),
//                             leading: Container(
//                               margin: EdgeInsets.only(bottom: 0),
//                               height:
//                                   MediaQuery.of(context).size.height * 0.0783,
//                               width: MediaQuery.of(context).size.width * 0.1654,
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(24.0),
//                                 child: Image.asset(
//                                   "assets/images/hospital.png",
//                                   fit: BoxFit.fitHeight,
//                                 ),
//                               ),
//                             ),
//                             title: Container(
//                               height:
//                                   MediaQuery.of(context).size.height * 0.161,
//                               decoration: BoxDecoration(
//                                 border: Border(
//                                   bottom: BorderSide(
//                                       width: 0.8,
//                                       color: Colors.grey.withOpacity(0.5)),
//                                 ),
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.only(top: 14),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       name,
//                                       textAlign: TextAlign.justify,
//                                       maxLines: 2,
//                                       style: GoogleFonts.mPlusRounded1c(
//                                           color: Color.fromRGBO(79, 79, 79, 1),
//                                           fontSize: 14,
//                                           letterSpacing:
//                                               0 /*percentages not used in flutter. defaulting to zero*/,
//                                           fontWeight: FontWeight.bold,
//                                           height: 0.8421052631578947),
//                                     ),
//                                     Expanded(child: Html(data: alamat))
//                                     // Text(
//                                     //   alamat,
//                                     //   textAlign: TextAlign.left,
//                                     //   maxLines: 2,
//                                     //   style: GoogleFonts.mPlusRounded1c(
//                                     //       color: Color.fromRGBO(130, 130, 130, 1),
//                                     //       fontSize: 14,
//                                     //       letterSpacing:
//                                     //           0 /*percentages not used in flutter. defaulting to zero*/,
//                                     //       fontWeight: FontWeight.normal,
//                                     //       height: 1.2857142857142858),
//                                     // ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           )
//                         : SizedBox());
//               }),
//         ],
//       );
//     });
//   }
// }
