import 'package:flutter_application_1/style/colors.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_spinkit/flutter_spinkit.dart';

class WidgetLoadingPage extends StatefulWidget {
  @override
  _WidgetLoadingPageState createState() => _WidgetLoadingPageState();
}

class _WidgetLoadingPageState extends State<WidgetLoadingPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 42, bottom: 42),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: SpinKitThreeBounce(
                    color: ColorsTheme.primary1,
                    size: 25.0,
                  ),
                ),
                Text("Mohon Tunggu...",
                    style: TextStyle(
                        color: ColorsTheme.text1,
                        height: 1.1,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text("Sedang memuat data anda",
                    style: TextStyle(
                        height: 1.1, fontSize: 14, color: ColorsTheme.text2)),
              ],
            )));
  }
}
