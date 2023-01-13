import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/models/auth/cls_profile.dart';
import 'package:flutter_application_1/style/colors.dart';
import 'package:flutter_application_1/style/sizes.dart';

class ProfileLihat extends StatefulWidget {
  final Profile profile;
  const ProfileLihat({Key? key, required this.profile}) : super(key: key);
  @override
  State<ProfileLihat> createState() => _ProfileLihatState();
}

class _ProfileLihatState extends State<ProfileLihat> {
  String genderText(String p) {
    if (p == '1' ||
        p.toLowerCase().trim() == 'laki laki' ||
        p.toLowerCase().trim() == 'laki-laki' ||
        p.toLowerCase().trim() == 'laki - laki' ||
        p.toLowerCase().trim() == 'pria') {
      return "LAKI-LAKI";
    } else if (p == '2' ||
        p.toLowerCase().trim() == 'perempuan' ||
        p.toLowerCase().trim() == 'female' ||
        p.toLowerCase().trim() == 'p' ||
        p.toLowerCase().trim() == 'wanita') {
      return "PEREMPUAN";
    } else {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: ColorsTheme.primary1));

    return Scaffold(
        appBar: AppBar(
          title: Text("Profil Saya"),
          elevation: 0,
          backgroundColor: ColorsTheme.primary1,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Text(
                    "INFO PRIBADI",
                    style: TextStyle(color: ColorsTheme.primary1, fontSize: 18),
                  ),
                ),
                SizedBox(height: 8),
                Divider(height: 1),
                SizedBox(height: 8),
                card("NIK", widget.profile.nik.toString()),
                card("NAMA", widget.profile.firstName.toString()),
                card("JENIS KELAMIN",
                    genderText(widget.profile.gender.toString())),
                card("TEMPAT LAHIR", widget.profile.birthPlace.toString()),
                card("TANGGAL LAHIR", widget.profile.birthDay.toString()),
                card("ALAMAT KTP", widget.profile.address.toString()),
                card("ALAMAT DOMISILI",
                    widget.profile.addresDomisili.toString()),
                card("NOMOR HP", widget.profile.phone.toString()),
                card("EMAIL", widget.profile.email.toString()),
                card("GOLONGAN DARAH", widget.profile.blood.toString()),
                card("STATUS KAWIN", widget.profile.maritalStatus.toString()),
                SizedBox(height: 16),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Text(
                    "INFO PERUSAHAAN",
                    style: TextStyle(color: ColorsTheme.primary1, fontSize: 18),
                  ),
                ),
                SizedBox(height: 8),
                Divider(height: 1),
                SizedBox(height: 8),
                card("STAFF ID", widget.profile.staffId.toString()),
                card("TANGGAL BERGABUNG",
                    widget.profile.dateOfJoining.toString()),
                card("DIVISI", widget.profile.division.toString()),
                card("DEPARTEMENT", widget.profile.departement.toString()),
                card("BAGIAN", widget.profile.section.toString()),
                card("POSISI", widget.profile.position.toString()),
                card("LEVEL", widget.profile.level.toString()),
                SizedBox(height: 16),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Text(
                    "INFO BPJS",
                    style: TextStyle(color: ColorsTheme.primary1, fontSize: 18),
                  ),
                ),
                SizedBox(height: 8),
                Divider(height: 1),
                SizedBox(height: 8),
                card("BPJS TK", widget.profile.noBpjsTk.toString()),
                card("BPJS JP", widget.profile.noBpjsJp.toString()),
                card("BPJS KESEHATAN",
                    widget.profile.noBpjsKesehatan.toString()),
                SizedBox(height: 16),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Text(
                    "INFO AKUN BANK",
                    style: TextStyle(color: ColorsTheme.primary1, fontSize: 18),
                  ),
                ),
                SizedBox(height: 8),
                Divider(height: 1),
                SizedBox(height: 8),
                card("NAMA PEMILIK", widget.profile.bankBankname.toString()),
                card("BANK", widget.profile.bankName.toString()),
                card("NOMOR REKENING", widget.profile.bankAccountno.toString()),
              ],
            ),
          ),
        ));
  }

  Widget card(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Text(
              title,
              style: TextStyle(color: ColorsTheme.text2, fontSize: 12),
            ),
          ),
          SizedBox(height: 4),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Text(
              subtitle.toUpperCase(),
              style: TextStyle(color: ColorsTheme.text1, fontSize: 16),
            ),
          ),
          SizedBox(height: 8),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: 0.5,
            color: Colors.grey,
          )
        ],
      ),
    );
  }
}
