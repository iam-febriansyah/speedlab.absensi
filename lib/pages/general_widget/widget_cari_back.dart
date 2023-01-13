import 'package:flutter_application_1/style/colors.dart';
import 'package:flutter/material.dart';

class WidgetCariBack extends StatelessWidget {
  const WidgetCariBack({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        SizedBox(
          width: 16,
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: ColorsTheme.background2,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: <Widget>[
                Expanded(
                    child: Text(
                  "Cari ...",
                  style: TextStyle(fontSize: 16, color: ColorsTheme.primary1),
                )),
                Icon(
                  Icons.search,
                  color: ColorsTheme.primary1,
                ),
              ]),
            ),
          ),
        ),
      ],
    );
  }
}
