import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ytdownloader/controller/downloader_controller.dart';

import '../assets.dart';
import '../routes.dart';

class DownloadYoutubeVideoScreen extends StatefulWidget {
  const DownloadYoutubeVideoScreen({super.key});

  @override
  State<DownloadYoutubeVideoScreen> createState() =>
      _DownloadYoutubeVideoScreenState();
}

class _DownloadYoutubeVideoScreenState
    extends State<DownloadYoutubeVideoScreen> {
  final DownloaderController controller = Get.put(DownloaderController());


  onClick() {
    if (controller.formKey.currentState!.validate()) {
      controller.formKey.currentState?.save();
      checkStoragePermission();
     /* controller.downloadVideo(context);*/
    } else {
      setState(() {
        controller.autoValidate = AutovalidateMode.onUserInteraction;
      });
    }
  }

  Future<void> checkStoragePermission() async {
    // Check if the storage permission is granted
    var status = await Permission.storage.status;

    if (status.isGranted) {
      // Storage permission is already granted, proceed with your logic
      controller.downloadVideo(context);
    } else {
      // Storage permission is not granted, request permission
      var result = await Permission.storage.request();

      if (result.isGranted) {
        // Permission granted, proceed with your logic
        controller.downloadVideo(context);
      } else {
        // Permission denied, show a message or handle accordingly
        print('Storage permission denied');
        // You can show a snackbar, dialog, or other UI to inform the user
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Form(
                autovalidateMode: controller.autoValidate,
                key: controller.formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      ytAnimBg,
                      fit: BoxFit.cover,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        margin: const EdgeInsets.only(left: 20),
                        child: const Text('Enter Youtube URL Here',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 25)),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: TextFormField(
                        controller: controller.ytdURLController,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          hintText: 'Paste YouTube link here',
                          hintStyle:
                              TextStyle(color: Colors.grey.withOpacity(0.8)),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(20.0), // Stadium shape
                          ),
                        ),
                        validator: (value) {
                          if(value!.isEmpty){
                            return "Enter Youtube URL";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                              onPrimary: Colors.white,
                              elevation: 2,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    8), // Button border radius
                              ),
                            ),
                            onPressed: () => onClick(),
                            child: const Text('Download'),
                          ),
                        ),
                        const SizedBox(width: 16), // Add spacing between buttons
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue,
                              onPrimary: Colors.white,
                              elevation: 2,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    8), // Button border radius
                              ),
                            ),
                            onPressed: () {
                              setState(
                                () => Navigator.pushNamed(context, Routes.savedVideoScreen) ,
                              );
                            },
                            child: const Text('View'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

