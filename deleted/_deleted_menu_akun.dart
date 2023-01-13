// import 'dart:convert';

// import 'package:flutter_application_1/api/api_service.dart';
// import 'package:flutter_application_1/models/profil/return.dart';
// import 'package:flutter_application_1/pages/akun/_deleted_MLBankAccount.dart';
// import 'package:flutter_application_1/pages/akun/_deleted_MLPerjalananDinas.dart';
// import 'package:flutter_application_1/pages/akun/_deleted_MLPersonalProfil.dart';
// import 'package:flutter_application_1/pages/akun/_deleted_MLStaffDokumen.dart';
// import 'package:flutter_application_1/pages/auth/login.dart';
// import 'package:flutter_application_1/pages/general_widget/widget_snackbar.dart';
// import 'package:flutter_application_1/style/colors.dart';
// import 'package:flutter_application_1/style/sizes.dart';
// import 'package:flutter/material.dart';
// import 'package:package_info/package_info.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class MenuAkun extends StatefulWidget {
//   @override
//   _MenuAkunState createState() => _MenuAkunState();
// }

// class _MenuAkunState extends State<MenuAkun> {
//   String staffId = "";
//   String nama = "";
//   String alamat = "";
//   String imageProfil = "";
//   String version = "";
//   String nik = "";
//   String maritalStatus = "";
//   String birthday = "";
//   String gender = "";
//   String blood = "";
//   String phone = "";
//   String email = "";
//   String address = "";
//   String bankName = "";
//   String nobankName = "";

//   String division = "";
//   String position = "";
//   String section = "";

//   late ThemeData themeData;

//   TextEditingController ctrlMaritalStatus = new TextEditingController();
//   TextEditingController ctrlBirthday = new TextEditingController();
//   TextEditingController ctrlGender = new TextEditingController();
//   TextEditingController ctrlBlood = new TextEditingController();
//   TextEditingController ctrlPhone = new TextEditingController();
//   TextEditingController ctrlEmail = new TextEditingController();
//   TextEditingController ctrlAddress = new TextEditingController();

//   TextEditingController ctrlNama = new TextEditingController();
//   TextEditingController ctrlAlamat = new TextEditingController();
//   TextEditingController ctrlPayroll = new TextEditingController();

//   TextEditingController ctrlBankName = new TextEditingController();
//   TextEditingController ctrlNoBank = new TextEditingController();

//   TextEditingController ctrDivison = new TextEditingController();
//   TextEditingController ctrlPosition = new TextEditingController();
//   TextEditingController ctrlSection = new TextEditingController();

//   DevService _devService = DevService();

//   getData() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     final PackageInfo info = await PackageInfo.fromPlatform();
//     var accesToken = pref.getString("PREF_TOKEN")!;

//     _devService.profil(accesToken).then((value) async {
//       var res = ReturnProfil.fromJson(json.decode(value));
//       if (res.status_json == true) {
//         if (mounted)
//           setState(() {
//             version = info.version;

//             staffId = res.profile?.staff_id ?? "";
//             var lastname = res.profile?.last_name ?? "";
//             var firstname = res.profile?.first_name ?? "";
//             nama = firstname + " " + lastname;
//             alamat = res.profile?.address ?? " ";
//             nik = res.profile?.nik ?? " ";
//             imageProfil = res.profile?.foto_profile ?? "";
//             maritalStatus = res.profile?.marital_status ?? "";
//             birthday = res.profile?.birth_day ?? "";
//             gender = res.profile?.gender ?? "";
//             blood = res.profile?.blood ?? "";
//             phone = res.profile?.phone ?? "";
//             email = res.profile?.email ?? "";
//             address = res.profile?.address ?? "";
//             bankName = res.profile?.bank_name ?? "";
//             nobankName = res.profile?.bank_accountno ?? "";

//             division = res.profile?.division ?? "";
//             position = res.profile?.position ?? "";
//             section = res.profile?.section ?? "";

//             ctrDivison.text = division;
//             ctrlPosition.text = position;
//             ctrlSection.text = section;

//             ctrlMaritalStatus.text = maritalStatus;
//             ctrlBirthday.text = birthday;
//             ctrlGender.text = gender;
//             ctrlBlood.text = blood;
//             ctrlPhone.text = phone;
//             ctrlEmail.text = email;
//             ctrlAddress.text = address;

//             ctrlBankName.text = bankName;
//             ctrlNoBank.text = nobankName;
//           });
//       }
//     });
//   }

//   dialogLogout() async {
//     return showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (context) {
//           return AlertDialog(
//             title: Center(child: Text('Konfirmasi')),
//             content: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisSize: MainAxisSize.min,
//                 children: <Widget>[
//                   SizedBox(
//                     height: 12,
//                   ),
//                   //USERNAME FIELD
//                   Text("Anda yakin akan keluar aplikasi ?")
//                 ]),
//             actions: <Widget>[
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: <Widget>[
//                   Padding(
//                     padding: EdgeInsets.only(
//                         left: SizeConfig.screenLeftRight1, bottom: 8),
//                     child: Container(
//                       width: SizeConfig.screenWidth * 0.35,
//                       child: SizedBox(
//                         height: SizeConfig.screenHeight * 0.045,
//                         // ignore: deprecated_member_use
//                         child: ElevatedButton(
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                           style: ButtonStyle(
//                               backgroundColor: MaterialStateProperty.all<Color>(
//                                   Colors.white),
//                               shape: MaterialStateProperty.all<
//                                       RoundedRectangleBorder>(
//                                   RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                               ))),
//                           child: Text(
//                             "TIDAK",
//                             style: TextStyle(color: ColorsTheme.primary1),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     width: 2,
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(
//                         right: SizeConfig.screenLeftRight1, bottom: 8),
//                     child: Container(
//                       width: SizeConfig.screenWidth * 0.35,
//                       child: SizedBox(
//                         height: SizeConfig.screenHeight * 0.045,
//                         // ignore: deprecated_member_use
//                         child: ElevatedButton(
//                           onPressed: () {
//                             goToLogin();
//                           },
//                           style: ButtonStyle(
//                               backgroundColor: MaterialStateProperty.all<Color>(
//                                   ColorsTheme.primary1),
//                               shape: MaterialStateProperty.all<
//                                       RoundedRectangleBorder>(
//                                   RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                               ))),
//                           child: Text(
//                             "YA",
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           );
//         });
//   }

//   Widget textField(TextEditingController ctrl, String hintText,
//       TextInputType textInputType, bool obscureText) {
//     return Padding(
//       padding: EdgeInsets.only(
//           left: SizeConfig.screenLeftRight0,
//           right: SizeConfig.screenLeftRight0,
//           bottom: 8),
//       child: Container(
//         decoration: BoxDecoration(
//           color: ColorsTheme.background2,
//           borderRadius: BorderRadius.circular(10.0),
//         ),
//         child: Padding(
//           padding: EdgeInsets.only(left: SizeConfig.screenLeftRight1),
//           child: Row(
//             children: <Widget>[
//               SizedBox(
//                 width: 8,
//               ),
//               Expanded(
//                 child: TextField(
//                   controller: ctrl,
//                   keyboardType: textInputType,
//                   obscureText: obscureText,
//                   decoration: InputDecoration(
//                       border: InputBorder.none, hintText: hintText),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   updateProfileDialog(String value) {
//     showDialog(
//         context: context,
//         builder: (BuildContext bc) {
//           return AlertDialog(
//               title: Center(child: Text(value)),
//               content: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisSize: MainAxisSize.min,
//                   children: <Widget>[
//                     SizedBox(
//                       height: 12,
//                     ),
//                     // textField(ctrlNip, "NIP", TextInputType.text, false),
//                     // textField(ctrlNama, "Nama", TextInputType.text, false),
//                     // textField(ctrlAlamat, "Alamat", TextInputType.text, false),
//                   ]),
//               actions: <Widget>[
//                 Padding(
//                   padding: EdgeInsets.only(
//                       left: SizeConfig.screenLeftRight1,
//                       right: SizeConfig.screenLeftRight1,
//                       bottom: 8),
//                   child: Container(
//                     width: SizeConfig.screenWidth,
//                     child: SizedBox(
//                       height: SizeConfig.screenHeight * 0.045,
//                       // ignore: deprecated_member_use
//                       child: ElevatedButton(
//                         onPressed: () {
//                           String check = checkMandatory();
//                           if (check == "") {
//                             submitRegister();
//                           } else {
//                             FocusScope.of(context).requestFocus(FocusNode());
//                             WidgetSnackbar(
//                                 context: context,
//                                 message: check,
//                                 warna: "merah");
//                           }
//                         },
//                         style: ButtonStyle(
//                             backgroundColor: MaterialStateProperty.all<Color>(
//                                 ColorsTheme.primary1),
//                             shape: MaterialStateProperty.all<
//                                 RoundedRectangleBorder>(RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ))),
//                         child: Text(
//                           "SUBMIT",
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: SizeConfig.fontSize4),
//                         ),
//                       ),
//                     ),
//                   ),
//                 )
//               ]);
//         });
//   }

//   goToLogin() {
//     Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
//       MaterialPageRoute(
//         builder: (BuildContext context) {
//           updateToken("");
//           return LoginPage();
//         },
//       ),
//       (_) => false,
//     );
//   }

//   updateToken(token) async {
//     print(token);
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     var accesToken = pref.getString("PREF_TOKEN")!;
//     _devService
//         .updateTokenFirebase(accesToken, token)
//         .then((value) async {})
//         .catchError((Object obj) {});
//   }

//   void _showPopupMenu() async {
//     String? selected = await showMenu(
//       context: context,
//       position: RelativeRect.fromLTRB(50, 50, 0, 0),
//       items: [
//         // PopupMenuItem<String>(
//         //   child: Text('Edit Profile'),
//         //   value: "Edit Profile",
//         // ),
//         PopupMenuItem<String>(
//           child: Text('Logout'),
//           value: "Logout",
//         ),
//       ],
//       elevation: 8.0,
//     );
//     if (selected == "Edit Profile") {
//       //  updateProfileDialog(selected!);
//     } else if (selected == "Logout") {
//       dialogLogout();
//     }
//   }

//   Future submitRegister() async {}

//   checkMandatory() {
//     return "";
//   }

//   @override
//   void initState() {
//     super.initState();
//     getData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     themeData = Theme.of(context);
//     return Scaffold(
//       body: SingleChildScrollView(
//         physics: AlwaysScrollableScrollPhysics(),
//         child: Stack(
//           children: <Widget>[
//             Container(
//                 height: SizeConfig.screenHeight * 0.4,
//                 decoration: BoxDecoration(color: ColorsTheme.primary1)),
//             Padding(
//               padding: EdgeInsets.only(
//                   left: SizeConfig.screenLeftRight1 + 10,
//                   right: SizeConfig.screenLeftRight1 + 10,
//                   top: SizeConfig.screenHeight * 0.05),
//               child: Row(
//                 children: <Widget>[
//                   Expanded(
//                     child: Text(
//                       " Akun",
//                       style: TextStyle(
//                           fontFamily: 'BalsamiqSans',
//                           fontSize: 24,
//                           color: Colors.white),
//                     ),
//                   ),
//                   InkWell(
//                     onTap: () {
//                       _showPopupMenu();
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Icon(
//                         Icons.widgets,
//                         color: Colors.white,
//                         size: 24,
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(top: SizeConfig.screenHeight * 0.3),
//               child: Container(
//                 // height: SizeConfig.screenHeight * 0.4,
//                 decoration: BoxDecoration(
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.5),
//                       spreadRadius: 2,
//                       blurRadius: 4,
//                       offset: Offset(0, 3), // changes position of shadow
//                     ),
//                   ],
//                   borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(40),
//                       topRight: Radius.circular(40)),
//                   color: Colors.white,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     SizedBox(
//                       height: SizeConfig.screenHeight * 0.20,
//                     ),
//                     Container(
//                       margin: EdgeInsets.symmetric(horizontal: 20),
//                       height: 150,
//                       width: MediaQuery.of(context).size.width,
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: GestureDetector(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => MLPersonalProfil()),
//                                 );
//                               },
//                               child: Container(
//                                 margin: EdgeInsets.only(right: 10),
//                                 decoration: BoxDecoration(
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: Colors.black.withOpacity(0.1),
//                                         spreadRadius: 2,
//                                         blurRadius: 2,
//                                         offset: Offset(
//                                             0, 2), // changes position of shadow
//                                       ),
//                                     ],
//                                     borderRadius: BorderRadius.all(
//                                       Radius.circular(20),
//                                     ),
//                                     color: Color(0xfffafaff)),
//                                 //  height: 60,

//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Image.asset(
//                                       "assets/images/user.png",
//                                       width: 50,
//                                       color: Colors.black.withOpacity(0.8),
//                                     ),
//                                     SizedBox(
//                                       height: 5,
//                                     ),
//                                     Text(
//                                       'Personal Profil',
//                                       textAlign: TextAlign.center,
//                                       style: GoogleFonts.roboto(
//                                         color: Colors.black.withOpacity(0.8),
//                                         fontSize: 18,
//                                         letterSpacing:
//                                             0.5 /*percentages not used in flutter. defaulting to zero*/,
//                                         fontWeight: FontWeight.w400,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             child: GestureDetector(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => MLBankAccount()),
//                                 );
//                               },
//                               child: Container(
//                                 margin: EdgeInsets.only(left: 10),
//                                 decoration: BoxDecoration(
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: Colors.black.withOpacity(0.1),
//                                         spreadRadius: 2,
//                                         blurRadius: 2,
//                                         offset: Offset(
//                                             0, 2), // changes position of shadow
//                                       ),
//                                     ],
//                                     borderRadius: BorderRadius.all(
//                                       Radius.circular(20),
//                                     ),
//                                     color: Color(0xfffafaff)),
//                                 //  height: 60,

//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Image.asset(
//                                       "assets/images/bank.png",
//                                       width: 50,
//                                       color: Colors.black.withOpacity(0.8),
//                                     ),
//                                     SizedBox(
//                                       height: 5,
//                                     ),
//                                     Text(
//                                       'Bank Account',
//                                       textAlign: TextAlign.center,
//                                       style: GoogleFonts.roboto(
//                                         color: Colors.black.withOpacity(0.8),
//                                         fontSize: 18,
//                                         letterSpacing:
//                                             0.5 /*percentages not used in flutter. defaulting to zero*/,
//                                         fontWeight: FontWeight.w400,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     Container(
//                       margin: EdgeInsets.symmetric(horizontal: 20),
//                       height: 150,
//                       width: MediaQuery.of(context).size.width,
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: GestureDetector(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) =>
//                                           MLPerjalananDinas()),
//                                 );
//                               },
//                               child: Container(
//                                 margin: EdgeInsets.only(right: 10),
//                                 decoration: BoxDecoration(
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: Colors.black.withOpacity(0.1),
//                                         spreadRadius: 2,
//                                         blurRadius: 2,
//                                         offset: Offset(
//                                             0, 2), // changes position of shadow
//                                       ),
//                                     ],
//                                     borderRadius: BorderRadius.all(
//                                       Radius.circular(20),
//                                     ),
//                                     color: Color(0xfffafaff)),
//                                 //  height: 60,

//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Image.asset(
//                                       "assets/images/suitcase.png",
//                                       width: 50,
//                                       color: Colors.black.withOpacity(0.8),
//                                     ),
//                                     SizedBox(
//                                       height: 5,
//                                     ),
//                                     Text(
//                                       'Perjalanan Dinas',
//                                       textAlign: TextAlign.center,
//                                       style: GoogleFonts.roboto(
//                                         color: Colors.black.withOpacity(0.8),
//                                         fontSize: 18,
//                                         letterSpacing:
//                                             0.5 /*percentages not used in flutter. defaulting to zero*/,
//                                         fontWeight: FontWeight.w400,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             child: GestureDetector(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => MLStaffDokumen()),
//                                 );
//                               },
//                               child: Container(
//                                 margin: EdgeInsets.only(left: 10),
//                                 decoration: BoxDecoration(
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: Colors.black.withOpacity(0.1),
//                                         spreadRadius: 2,
//                                         blurRadius: 2,
//                                         offset: Offset(
//                                             0, 2), // changes position of shadow
//                                       ),
//                                     ],
//                                     borderRadius: BorderRadius.all(
//                                       Radius.circular(20),
//                                     ),
//                                     color: Color(0xfffafaff)),
//                                 //  height: 60,

//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Image.asset(
//                                       "assets/images/document.png",
//                                       width: 50,
//                                       color: Colors.black.withOpacity(0.8),
//                                     ),
//                                     SizedBox(
//                                       height: 5,
//                                     ),
//                                     Text(
//                                       'Staff Dokumen',
//                                       textAlign: TextAlign.center,
//                                       style: GoogleFonts.roboto(
//                                         color: Colors.black.withOpacity(0.8),
//                                         fontSize: 18,
//                                         letterSpacing:
//                                             0.5 /*percentages not used in flutter. defaulting to zero*/,
//                                         fontWeight: FontWeight.w400,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       height: SizeConfig.screenHeight * 0.075,
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         dialogLogout();
//                       },
//                       child: Center(
//                         child: Text(
//                           "KELUAR",
//                           style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                               color: ColorsTheme.text1),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: SizeConfig.screenHeight * 0.025,
//                     ),
//                     Center(
//                       child: Text(
//                         // ignore: unnecessary_null_comparison
//                         version == null ? "" : "Version " + version,
//                         style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: ColorsTheme.primary1),
//                       ),
//                     ),
//                     SizedBox(
//                       height: SizeConfig.screenHeight * 0.05,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(
//                   left: SizeConfig.screenLeftRight1,
//                   right: SizeConfig.screenLeftRight1,
//                   top: SizeConfig.screenHeight * 0.2),
//               child: Align(
//                 alignment: Alignment.topCenter,
//                 child: Column(
//                   children: <Widget>[
//                     if (imageProfil != "")
//                       Container(
//                         decoration: BoxDecoration(
//                             borderRadius:
//                                 BorderRadius.all(Radius.circular(50))),
//                         height: SizeConfig.screenHeight * 0.175,
//                         width: SizeConfig.screenWidth * 0.375,
//                         child: CircleAvatar(
//                           radius: SizeConfig.screenWidth * 0.2,
//                           backgroundImage: NetworkImage(imageProfil),
//                           backgroundColor: Colors.transparent,
//                         ),
//                       ),
//                     if (imageProfil == "")
//                       Container(
//                         decoration: BoxDecoration(
//                             borderRadius:
//                                 BorderRadius.all(Radius.circular(50))),
//                         height: SizeConfig.screenHeight * 0.175,
//                         width: SizeConfig.screenWidth * 0.375,
//                         child:

//                             // CircleAvatar(
//                             //   radius: SizeConfig.screenWidth * 0.2,
//                             //   backgroundImage: NetworkImage(imageProfil),
//                             //   // fit: BoxFit.,

//                             //   backgroundColor: Colors.transparent,
//                             // ),

//                             CircleAvatar(
//                           radius: SizeConfig.screenWidth * 0.2,
//                           backgroundImage:
//                               AssetImage("assets/images/profil.png"),
//                           // fit: BoxFit.,

//                           backgroundColor: Colors.transparent,
//                         ),
//                       ),
//                     SizedBox(
//                       height: 15,
//                     ),
//                     Text(nama.toUpperCase(),
//                         style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             letterSpacing: 0)),
//                     SizedBox(
//                       height: 5,
//                     ),
//                     Text("ID Staff : " + staffId.toUpperCase(),
//                         style: GoogleFonts.ibmPlexSans(
//                             textStyle: TextStyle(
//                                 fontSize: 12, color: Color(0xff4a4c4f)))),
//                     SizedBox(
//                       height: 4,
//                     ),
//                     Text(
//                       "NIK : " + nik.toUpperCase(),
//                       style: GoogleFonts.ibmPlexSans(
//                           textStyle: TextStyle(
//                               fontSize: 12, color: Color(0xff4a4c4f))),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// Widget card(BuildContext context, IconData icon, String key, String value) {
//   return Padding(
//     padding: const EdgeInsets.only(left: 16, right: 16, bottom: 4),
//     child: Card(
//       elevation: 2,
//       child: ClipPath(
//         clipper: ShapeBorderClipper(
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
//         child: Container(
//           // height: 100,
//           width: SizeConfig.screenWidth,
//           decoration: BoxDecoration(
//               border: Border(
//                   left: BorderSide(color: ColorsTheme.primary1, width: 5))),
//           child: Padding(
//             padding: EdgeInsets.all(10.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Text(
//                   key,
//                   style: TextStyle(
//                       fontFamily: 'BalsamiqSans',
//                       fontSize: 16,
//                       color: Colors.blueGrey),
//                 ),
//                 SizedBox(
//                   height: 8,
//                 ),
//                 Text(
//                   value,
//                   style: TextStyle(
//                       fontFamily: 'BalsamiqSans',
//                       fontSize: 18,
//                       color: ColorsTheme.text1),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     ),
//   );
// }
