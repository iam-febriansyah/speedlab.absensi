import 'package:flutter_application_1/style/colors.dart';
import 'package:flutter/material.dart';

Widget widgetTextField(
    {String? textTitle,
    String? textHint,
    TextEditingController? controllers,
    TextInputType? textType,
    double? topPadding,
    int? maxLengths,
    bool? mandatory,
    IconData? icons,
    String? satuan,
    onChangeds,
    bool? isEnabled,
    TextCapitalization? textCapitalization,
    bool? obscureText}) {
  // ignore: unnecessary_statements
  topPadding == null ? topPadding = 0.0 : topPadding;
  // ignore: unnecessary_statements
  textTitle == null ? textTitle = "Enter Title" : textTitle;
  // ignore: unnecessary_statements
  textHint == null ? textHint = "Enter Hint" : textHint;
  // ignore: unnecessary_statements
  mandatory == null ? mandatory = false : mandatory;
  // ignore: unnecessary_statements
  isEnabled == null ? isEnabled = true : isEnabled;
  return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(
                bottom: 8,
              ),
              child: Row(
                children: <Widget>[
                  Text(
                    textTitle,
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.black38,
                        fontWeight: FontWeight.w400),
                  ),
                  mandatory
                      ? Text(
                          " *",
                          style: TextStyle(
                              fontSize: 14, color: Colors.red.withOpacity(0.8)),
                        )
                      : Container(),
                ],
              )),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              icons == null
                  ? Container()
                  : Padding(
                      padding: EdgeInsets.only(top: 12, right: 8),
                      child: Icon(icons, size: 24, color: ColorsTheme.primary1),
                    ),
              Expanded(
                  child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          obscureText:
                              obscureText == null ? false : obscureText,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                          controller: controllers,
                          enabled: isEnabled,
                          onChanged: onChangeds,
                          keyboardType:
                              textType == null ? TextInputType.text : textType,
                          textCapitalization: textCapitalization == null
                              ? TextCapitalization.sentences
                              : textCapitalization,
                          maxLines:
                              textType != TextInputType.multiline ? 1 : null,
                          maxLength: maxLengths,
                          decoration: InputDecoration(
                              counterText: "",
                              contentPadding: EdgeInsets.only(top: 4),
                              border: InputBorder.none,
                              hintText: textHint,
                              hintStyle: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400)),
                        ),
                      ),
                      satuan != null
                          ? Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Text("Meter",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400)))
                          : Container(),
                    ],
                  ),
                  Divider()
                ],
              ))
            ],
          )
        ],
      ));
}
