import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/style/colors.dart';
import 'package:flutter_application_1/style/sizes.dart';

class ProfileCamera extends StatefulWidget {
  final List<CameraDescription> cameras;
  const ProfileCamera({Key? key, required this.cameras}) : super(key: key);

  @override
  State<ProfileCamera> createState() => _ProfileCameraState();
}

class _ProfileCameraState extends State<ProfileCamera> {
  bool loading = false;
  bool failed = false;
  String remakrs = '';
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  int selectedCamera = 1;

  initializeCamera(int cameraIndex) async {
    if (widget.cameras.length < 1) {
      cameraIndex = 0;
    }
    _controller = CameraController(
        widget.cameras[cameraIndex], ResolutionPreset.medium,
        enableAudio: false);
    _initializeControllerFuture = _controller.initialize();
    setState(() {
      loading = false;
    });
  }

  void ambilGambar() async {
    await _initializeControllerFuture;
    var xFile = await _controller.takePicture();
    File file = File(xFile.path);
    var bytes = file.readAsBytesSync();
    String base64Image = base64.encode(bytes);
    String extWidthBase64 = "ext/${file.path};${base64Image}";
    Navigator.pop(context, extWidthBase64);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    initializeCamera(selectedCamera);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Ambil Gambar"),
          elevation: 0,
          backgroundColor: ColorsTheme.primary1,
        ),
        body: loading
            ? Center(child: CupertinoActivityIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  FutureBuilder<void>(
                    future: _initializeControllerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return CameraPreview(_controller);
                      } else {
                        return Center(child: CupertinoActivityIndicator());
                      }
                    },
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: IconButton(
                              onPressed: () {
                                if (widget.cameras.length > 1) {
                                  setState(() {
                                    selectedCamera =
                                        selectedCamera == 0 ? 1 : 0;
                                    initializeCamera(selectedCamera);
                                  });
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text('No secondary camera found'),
                                    duration: const Duration(seconds: 2),
                                  ));
                                }
                              },
                              icon: Icon(Icons.switch_camera_rounded,
                                  color: ColorsTheme.primary1),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              ambilGambar();
                            },
                            child: Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: ColorsTheme.primary1,
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.1)
                        ],
                      ),
                    ),
                  ),
                ],
              ));
    ;
  }
}
