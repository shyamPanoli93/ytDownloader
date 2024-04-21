import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ytdownloader/controller/saved_video_controller.dart';
import '../widget.dart';

class SavedVideoScreen extends StatefulWidget {
  const SavedVideoScreen({super.key});

  @override
  State<SavedVideoScreen> createState() => _SavedVideoScreenState();
}

class _SavedVideoScreenState extends State<SavedVideoScreen> {
  final SavedVideoController savedVideoController = Get.put(SavedVideoController());

 /* @override
  void initState() {
    savedVideoController.fetchVideos();
    super.initState();
  }*/

  @override
  void dispose() {
    savedVideoController.betterPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'YTD Videos',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Obx(() {
        if (savedVideoController.videosList.isEmpty) {
          return emptyFileScreenWidget();
        } else {
          return RefreshIndicator(
            child: ListView.builder(
              itemCount: savedVideoController.videosList.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 2,
                  margin:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 2,
                        child: BetterPlayerPlaylist(
                          betterPlayerConfiguration:
                              const BetterPlayerConfiguration(
                                  controlsConfiguration:
                                      BetterPlayerControlsConfiguration(
                            showControls: true,
                          )),
                          betterPlayerPlaylistConfiguration:
                              const BetterPlayerPlaylistConfiguration(
                            loopVideos: false,
                          ),
                          betterPlayerDataSourceList: [
                            BetterPlayerDataSource(
                              BetterPlayerDataSourceType.network,
                              savedVideoController.videosList[index].filePath,
                              notificationConfiguration:
                                  BetterPlayerNotificationConfiguration(
                                showNotification: false,
                                title: savedVideoController
                                    .videosList[index].title,
                                author: "Test",
                              ),
                              bufferingConfiguration:
                                  const BetterPlayerBufferingConfiguration(
                                      minBufferMs: 2000,
                                      maxBufferMs: 10000,
                                      bufferForPlaybackMs: 1000,
                                      bufferForPlaybackAfterRebufferMs: 2000),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(savedVideoController
                                    .videosList[index].title),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              // Handle delete action
                              savedVideoController.deleteVideos(
                                  savedVideoController.videosList[index].id);
                            },
                            icon:const  Icon(Icons.delete),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
            onRefresh: () => savedVideoController.fetchVideos(),
          );
        }
      }),
    );
  }
}
