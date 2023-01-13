import 'package:flutter_application_1/pages/auth/login.dart';
import 'package:flutter_application_1/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class WidgetErrorConnection extends StatefulWidget {
  Function? onRetry;
  String? remarks;
  WidgetErrorConnection({Key? key, this.onRetry, this.remarks})
      : super(key: key);
  @override
  _WidgetErrorConnectionState createState() => _WidgetErrorConnectionState();
}

class _WidgetErrorConnectionState extends State<WidgetErrorConnection> {
  Future logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      preferences.clear();
    });

    Navigator.of(context).pushReplacement(new MaterialPageRoute(
        builder: (BuildContext context) => LoginPage(),
        fullscreenDialog: true));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
          child: Padding(
              padding:
                  EdgeInsets.only(left: 16, right: 16, top: 42, bottom: 42),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Container(
                          width: 140,
                          child: Image.asset(
                              "assets/ilustration/lost_connection.png"))),
                  Text("Gangguan Koneksi",
                      style: TextStyle(
                          color: ColorsTheme.text1,
                          height: 1.1,
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(widget.remarks!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        height: 1.2,
                        fontSize: 14,
                        color: ColorsTheme.text2,
                      )),
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    // ignore: deprecated_member_use
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onRetry!();
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              ColorsTheme.primary1),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ))),
                      child: Text(
                        "Coba Lagi",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  )
                ],
              ))),
    );
  }
}
