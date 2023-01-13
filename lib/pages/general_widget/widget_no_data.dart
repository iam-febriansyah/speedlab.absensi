import 'package:flutter_application_1/style/colors.dart';
import 'package:flutter/material.dart';

class WidgetNoData extends StatefulWidget {
  @override
  _WidgetNoDataState createState() => _WidgetNoDataState();
}

class _WidgetNoDataState extends State<WidgetNoData> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Image.asset(
            "assets/images/kosong.png",
            width: 70,
            height: 70,
          ),
          SizedBox(height: 8),
          Text(
            "Data Tidak ada",
            style: TextStyle(color: ColorsTheme.text4),
          )
        ],
      ),
    );
  }
}
