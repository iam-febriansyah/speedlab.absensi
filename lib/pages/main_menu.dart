import 'package:badges/badges.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/pages/menu/menu_newhome.dart';
import 'package:flutter_application_1/pages/menu/menu_overtime.dart';
import 'package:flutter_application_1/pages/menu/menu_profile.dart';
import 'package:flutter_application_1/style/colors.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'menu/menu_absen.dart';
import 'menu/menu_cuti.dart';

class MainMenu extends StatefulWidget {
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  int currentIndex = 0;
  PageController? pageController;
  String token = "";
  String badgeCuti = '0';
  String badgeLembur = '0';

  getDataBadge() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      badgeCuti = pref.getString("PREF_CUTI") ?? '0';
      badgeLembur = pref.getString("PREF_LEMBUR") ?? '0';
    });
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    getDataBadge();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        statusBarColor: ColorsTheme.primary1, // Color for Android
        statusBarBrightness:
            Brightness.light // Dark == white status bar -- for IOS.
        ));
    return Scaffold(
      body: SizedBox.expand(
        child: PageView(
          controller: pageController,
          onPageChanged: (index) {
            setState(() => currentIndex = index);
          },
          children: <Widget>[
            MenuHome(),
            MenuAbsen(),
            MenuOvertime(),
            MenuCuti(),
            MenuProfile()
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        showElevation: false,
        selectedIndex: currentIndex,
        onItemSelected: (index) {
          setState(() => currentIndex = index);
          pageController!.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: Icon(Icons.home),
            title: Text('Dashboard'),
            activeColor: ColorsTheme.primary1,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.history),
            title: Text('Absensi'),
            activeColor: ColorsTheme.primary1,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Badge(
                showBadge: badgeLembur == '0' ? false : true,
                padding: EdgeInsets.all(badgeLembur.length == 1 ? 6 : 4),
                badgeContent: Text(badgeLembur,
                    style: TextStyle(color: Colors.white, fontSize: 8)),
                child: Icon(Icons.lock_clock)),
            title: Text('Lembur'),
            activeColor: ColorsTheme.primary1,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Badge(
                showBadge: badgeCuti == '0' ? false : true,
                padding: EdgeInsets.all(badgeCuti.length == 1 ? 6 : 4),
                badgeContent: Text(badgeCuti,
                    style: TextStyle(color: Colors.white, fontSize: 8)),
                child: Icon(Icons.work_off)),
            title: Text('Cuti'),
            activeColor: ColorsTheme.primary1,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.person),
            title: Text('Akun'),
            activeColor: ColorsTheme.primary1,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
