import 'package:flutter_application_1/style/colors.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_spinkit/flutter_spinkit.dart';

class WidgetProgressSubmit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 50,
        backgroundColor: Colors.white,
        child: Container(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Container(
                  height: 30,
                  child: Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: SpinKitChasingDots(
                      color: ColorsTheme.primary1,
                      size: 30.0,
                    ),
                  )),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Mohon Tunggu...",
                    style: TextStyle(
                      color: ColorsTheme.text1,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      "Sedang memproses data",
                      style: TextStyle(
                        color: ColorsTheme.text2,
                        fontSize: 14.0,
                      ),
                    ),
                  )
                ],
              ))
            ],
          ),
        ));
  }
}
