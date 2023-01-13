import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_1/api/api_service.dart';
import 'package:flutter_application_1/models/cabang/return.dart';
import 'package:flutter_application_1/pages/absen/absen.dart';
import 'package:flutter_application_1/style/colors.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListCabang extends StatefulWidget {
  final String alasan;
  final String idShift;
  final String jamAbsenWajib;
  const ListCabang(
      {Key? key,
      required this.alasan,
      required this.idShift,
      required this.jamAbsenWajib})
      : super(key: key);

  @override
  State<ListCabang> createState() => _ListCabangState();
}

class _ListCabangState extends State<ListCabang> {
  bool loading = false;
  bool failed = false;
  String remakrs = '';

  String namaKaryawan = '';
  String staffID = '';
  DevService _devService = DevService();
  List<ReturnCabangListcabang?>? listcabang = [];
  List<ReturnCabangListcabang?>? listcabangTemp = [];

  void getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var accesToken = pref.getString("PREF_TOKEN")!;
    _devService.allcabangNew(accesToken).then((value) async {
      var res = json.decode(value);
      if (res['status_json']) {
        setState(() {
          loading = false;
          failed = false;
          remakrs = res['remarks'];
          for (var element in res['listcabang']) {
            listcabang!.add(new ReturnCabangListcabang(
              cabangId: element['cabang_id'].toString(),
              instansiId: element['instansi_id'].toString(),
              namaCabang: element['nama_cabang'].toString(),
              alamatCabang: element['alamat_cabang'].toString(),
              tipe: element['tipe'].toString(),
              latitude: element['latitude'].toString(),
              longitude: element['longitude'].toString(),
              radiusAbsen: element['radius_absen'].toString(),
              polygon: element['polygon'].toString(),
            ));
          }
          listcabangTemp = listcabang;
        });
      } else {
        setState(() {
          loading = false;
          failed = true;
          remakrs = res['remarks'];
        });
      }
    });

    if (mounted)
      setState(() {
        namaKaryawan = pref.getString("PREF_NAMA")!;
        staffID = pref.getString("PREF_NIP")!;
      });
  }

  void cariCabang(String value) {
    List<ReturnCabangListcabang?> listTemp = listcabangTemp!
        .where((element) =>
            element!.namaCabang!.toLowerCase().contains(value.toLowerCase()) ||
            element.alamatCabang!.toLowerCase().contains(value.toLowerCase()))
        .toList();
    setState(() {
      listcabang = listTemp;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Pilih Lokasi Absen"),
          elevation: 0,
          backgroundColor: ColorsTheme.primary1,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      namaKaryawan.toUpperCase() + '\n(' + staffID + ')',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: ColorsTheme.primary1),
                    )),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Container(
                      // height: 100,
                      decoration: BoxDecoration(
                        color: ColorsTheme.grey,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                          // controller: controllerKeperluan,
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: 10,
                          decoration:
                              InputDecoration.collapsed(hintText: 'Cari..'),
                          onChanged: (v) {
                            cariCabang(v);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
                child: loading
                    ? Center(
                        child: CupertinoActivityIndicator(
                        radius: 10,
                      ))
                    : cabang(context)),
          ],
        ));
  }

  Widget cabang(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      children: [
        ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: listcabang!.length,
            itemBuilder: (context, index) {
              String name = listcabang![index]!.namaCabang ?? "";
              String alamat = listcabang![index]!.alamatCabang ?? "";

              return GestureDetector(
                  onTap: () async {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => AbsenForm(
                                  cabang: listcabang![index]!,
                                  idShift: widget.idShift,
                                  jamAbsenWajib: widget.jamAbsenWajib,
                                )));
                  },
                  child: (name != "")
                      ? ListTile(
                          contentPadding: EdgeInsets.only(
                              bottom: 5, top: 5, left: 15, right: 15),
                          leading: Container(
                            margin: EdgeInsets.only(bottom: 0),
                            height: MediaQuery.of(context).size.height * 0.0783,
                            width: MediaQuery.of(context).size.width * 0.1654,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24.0),
                              child: Center(
                                child: Image.asset(
                                  "assets/images/hospital.png",
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                          ),
                          title: Container(
                            height: MediaQuery.of(context).size.height * 0.161,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    width: 0.8,
                                    color: Colors.grey.withOpacity(0.5)),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    textAlign: TextAlign.justify,
                                    maxLines: 2,
                                    style: TextStyle(
                                        fontSize: 14,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.bold,
                                        height: 0.8421052631578947),
                                  ),
                                  Expanded(child: Html(data: alamat))
                                ],
                              ),
                            ),
                          ),
                        )
                      : SizedBox());
            }),
      ],
    );
  }
}
