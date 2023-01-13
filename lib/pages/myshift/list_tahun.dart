import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../api/api_service.dart';
import '../../style/colors.dart';

class ListTahun extends StatefulWidget {
  final List<dynamic> listTahun;
  const ListTahun({Key? key, required this.listTahun}) : super(key: key);

  @override
  _ListTahunState createState() => _ListTahunState();
}

class _ListTahunState extends State<ListTahun> {
  DevService _devService = DevService();
  bool loading = false;
  bool failed = false;
  String remakrs = '';
  List<dynamic> dataList = [];

  Future getData() async {
    setState(() {
      loading = true;
      failed = false;
      dataList = widget.listTahun;
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: ColorsTheme.primary1));
    return Scaffold(
      appBar: AppBar(
        title: Text("Pilih Bulan"),
        elevation: 0,
        backgroundColor: ColorsTheme.primary1,
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: loading
          ? Center(child: Text("Loading Page .."))
          : SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.only(top: 8, left: 16, right: 16),
                  child: ListView.builder(
                      padding: EdgeInsets.all(0),
                      shrinkWrap: true,
                      itemCount: dataList.length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        var item = dataList[index];
                        return InkWell(
                          onTap: () {
                            Navigator.pop(context, item);
                          },
                          child: card(item),
                        );
                      })),
            ),
    );
  }

  Widget card(item) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['text'],
                      style: TextStyle(
                          fontFamily: 'Poppins-Regular',
                          fontSize: 16,
                          color: ColorsTheme.primary1)),
                  Divider()
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: ColorsTheme.grey)
          ],
        ));
  }
}
