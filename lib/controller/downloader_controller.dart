import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:ytdownloader/controller/saved_video_controller.dart';
import 'package:ytdownloader/models/video.dart';
import 'package:path_provider/path_provider.dart' as p;

import '../models/video_database.dart';
import '../routes.dart';
import '../widget.dart';

class DownloaderController extends GetxController {
  // Rx variable for tracking download progress (value from 0.0 to 1.0)
  RxInt progress = 0.obs;

  // Rx variable for tracking download count
  RxInt count = 0.obs;
  final ytdURLController = TextEditingController();
  late StreamSubscription<List<int>>? _downloadSubscription;
  final VideoDatabase videoDatabase = VideoDatabase();
  final formKey = GlobalKey<FormState>();
  var autoValidate = AutovalidateMode.disabled;

  @override
  void onClose() {
    ytdURLController.dispose();
    _downloadSubscription?.cancel();
    super.onClose();
  }

  Future<List<Directory>?> _getExternalStoragePath() {
    return p.getExternalStorageDirectories(type: p.StorageDirectory.downloads);
  }

  Future<void> downloadVideo(BuildContext context) async {
    ProgressDialog pd = ProgressDialog(context: context);
    print("Selected Url:---${ytdURLController.text.trim()}");
    try {
      pd.show(
        max: 100,
        msg: 'File Downloading...',
        progressBgColor: Colors.transparent,
      );
      var yt = YoutubeExplode();
      var video = await yt.videos.get(ytdURLController.text.trim());
      var streamInfo = await yt.videos.streamsClient
          .getManifest(ytdURLController.text.trim());
      final videoFile = streamInfo.muxed.withHighestBitrate();

      /*final dir = await _getExternalStoragePath();*/
      final dir = await p.getApplicationDocumentsDirectory();
      final filePath =
          path.join(/*dir![0].path*/dir.path, '${video.title}.${videoFile.container.name}');

      final file = File(filePath);
      if (file.existsSync()) {
        file.deleteSync();
      }

      final videoStream = yt.videos.streamsClient.get(videoFile);
      final fileStream = file.openWrite();

      final len = videoFile.size.totalBytes;
      int downloadedBytes = 0;
      VideoDetails videoDetails = VideoDetails(
          videoId: '${video.id}', title: video.title, filePath: file.path);
      await for (var data in videoStream) {
        fileStream.add(data);
        downloadedBytes += data.length;
        double progressValue = downloadedBytes / len;
        progress.value = (progressValue * 100).toInt();
        pd.update(value: progress.value);

      }
      ytdURLController.text = "";
      FocusManager.instance.primaryFocus?.unfocus();
      await fileStream.flush();
      await fileStream.close();


      if(file.existsSync()){
        await videoDatabase.addVideos(videoDetails);
        pd.close();
        ScaffoldMessenger.of(context).showSnackBar(snackBarWhenSuccess('Video downloaded successfully'));
        Navigator.of(context).pushNamed(Routes.savedVideoScreen);
      }else{
        ScaffoldMessenger.of(context).showSnackBar(snackBarWhenFail("File not saved properly"));
        Navigator.of(context).pushNamed(Routes.downloaderScreen);
        //throw FileSystemException("File not saved properly");
      }

    } catch (e) {
      print(e);
      pd.close();
      return null;
    }
  }
}
