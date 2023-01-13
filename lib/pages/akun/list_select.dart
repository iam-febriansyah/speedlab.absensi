import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../style/colors.dart';

class ListSelect extends StatefulWidget {
  final List<String> list;
  const ListSelect({Key? key, required this.list}) : super(key: key);
  @override
  _ListSelectState createState() => _ListSelectState();
}

class _ListSelectState extends State<ListSelect> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: ColorsTheme.primary1));
    return Scaffold(
        appBar: AppBar(
          title: Text("Pilih Data"),
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
        body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.only(top: 8, left: 16, right: 16),
              child: ListView.builder(
                  padding: EdgeInsets.all(0),
                  shrinkWrap: true,
                  itemCount: widget.list.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    var item = widget.list[index];
                    return InkWell(
                      onTap: () {
                        Navigator.pop(context, item);
                      },
                      child: card(item),
                    );
                  })),
        ));
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
                  Text(item,
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
