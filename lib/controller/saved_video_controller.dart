import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ytdownloader/models/video.dart';

import '../models/video_database.dart';

class SavedVideoController extends GetxController{
  late BetterPlayerController betterPlayerController;
  final VideoDatabase videoDatabase = VideoDatabase();
  final RxList<VideoDetails> videosList = <VideoDetails>[].obs;

  @override
  void onInit() {
    fetchVideos();
    betterPlayerController = BetterPlayerController(
      const BetterPlayerConfiguration(
        autoPlay: false,
        looping: false,
        aspectRatio: 16 / 9,
        allowedScreenSleep: false,
        fullScreenByDefault: true,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          controlBarColor: Colors.black87,
          iconsColor: Colors.white,
        ),
      ),
    );
    super.onInit();
  }

  @override
  void onClose() {
    betterPlayerController.dispose();
    super.onClose();
  }


  Future<void> fetchVideos() async {
    final List<VideoDetails> videos = await videoDatabase.fetchVideos();
    videosList.assignAll(videos);
    fetchVideos();
  }

  Future<void> deleteVideos(int id) async {
    videoDatabase.deleteVideos(id);
    videosList.removeWhere((video) => video.id == id);
    videosList.refresh();
  }



}