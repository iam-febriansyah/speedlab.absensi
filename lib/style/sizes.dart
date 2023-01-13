import 'package:flutter/material.dart';

class SizeConfig {
  static MediaQueryData? mediaQueryData;
  static double screenWidth = 0;
  static double screenHeight = 0;
  static double screenLeftRight0 = 0;
  static double screenLeftRight1 = 0;
  static double screenLeftRight2 = 0;
  static double screenLeftRight3 = 0;
  static double screenLeftRight4 = 0;
  static double screenLeftRight5 = 0;
  static double screenLeftRight6 = 0;
  static double screenLeftRight7 = 0;

  static double screenTopBottom = 0;
  static double screenTopBottom0 = 0;
  static double screenTopBottom1 = 0;
  static double screenTopBottom2 = 0;
  static double screenTopBottom3 = 0;
  static double screenTopBottom4 = 0;
  static double screenTopBottom5 = 0;
  static double screenTopBottom6 = 0;
  static double screenTopBottom7 = 0;

  static double fontSize1 = 0;
  static double fontSize2 = 0;
  static double fontSize3 = 0;
  static double fontSize4 = 0;
  static double fontSize5 = 0;
  static double fontSize6 = 0;
  static double fontSize7 = 0;
  static double fontSize8 = 0;
  static double fontSize9 = 0;

  void init(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    screenWidth = mediaQueryData!.size.width;
    screenHeight = mediaQueryData!.size.height;

    screenLeftRight0 = screenWidth * 0.025;
    screenLeftRight1 = screenWidth * 0.05;
    screenLeftRight2 = screenWidth * 0.075;
    screenLeftRight3 = screenWidth * 0.1;
    screenLeftRight4 = screenWidth * 0.125;
    screenLeftRight5 = screenWidth * 0.15;
    screenLeftRight6 = screenWidth * 0.175;
    screenLeftRight7 = screenWidth * 0.2;

    screenTopBottom = screenHeight * 0.01;
    screenTopBottom0 = screenHeight * 0.025;
    screenTopBottom1 = screenHeight * 0.05;
    screenTopBottom2 = screenHeight * 0.075;
    screenTopBottom3 = screenHeight * 0.1;
    screenTopBottom4 = screenHeight * 0.125;
    screenTopBottom5 = screenHeight * 0.15;
    screenTopBottom6 = screenHeight * 0.175;
    screenTopBottom7 = screenHeight * 0.2;

    fontSize1 = screenWidth * 0.01;
    fontSize2 = screenWidth * 0.02;
    fontSize3 = screenWidth * 0.03;
    fontSize4 = screenWidth * 0.04;
    fontSize5 = screenWidth * 0.05;
    fontSize6 = screenWidth * 0.06;
    fontSize7 = screenWidth * 0.07;
    fontSize8 = screenWidth * 0.08;
    fontSize9 = screenWidth * 0.09;
  }
  //how to call in pages ?
  //SizeConfig().init(context);
  //SizeConfig.screenLeftRight1
}
