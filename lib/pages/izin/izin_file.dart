import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/style/colors.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// ignore: must_be_immutable
class IzinFile extends StatefulWidget {
  String url;
  IzinFile({required this.url});
  @override
  State<IzinFile> createState() => _IzinFileState();
}

class _IzinFileState extends State<IzinFile> {
  bool loading = true;
  String url = "";
  String ext = "aa";
  Future getData() async {
    var urlFull = widget.url;
    var urlArr = urlFull.split(".");
    setState(() {
      ext = urlArr[urlArr.length - 1];
      url = urlFull;
      if (ext == 'pdf') {
        // url =
        //     "https://drive.google.com/viewerng/viewer?embedded=true&url=${urlFull}";
      }
      loading = false;
      print("============EXT");
      print(ext);
    });
    print(url);
  }

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
          title: Text("Lampiran"),
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
        body: ext == 'pdf'
            ? Column(
                children: [
                  // Text(ext),
                  Expanded(
                    child: Container(
                        child: PDF().cachedFromUrl(
                      url,
                      maxAgeCacheObject: Duration(days: 30), //duration of cache
                      placeholder: (progress) =>
                          Center(child: Text('$progress %')),
                      errorWidget: (error) =>
                          Center(child: Text(error.toString())),
                    )),
                  ),
                ],
              )
            : Column(
                children: [
                  // Text(ext),
                  Expanded(
                    child: InAppWebView(
                      initialUrlRequest: URLRequest(url: Uri.parse(url)),
                    ),
                  ),
                ],
              ));
  }
}
