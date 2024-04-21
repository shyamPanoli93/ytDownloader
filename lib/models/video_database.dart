import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ytdownloader/models/video.dart';

class VideoDatabase extends ChangeNotifier {
  static late Isar isar;

  // I N I T I A L I Z E - D A T A B A S E
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([VideoDetailsSchema], directory: dir.path);
  }

  //list of videos
  final List<VideoDetails> currentVideos = [];

  //C R E A T E - a videoDetails and save to db
  Future<void> addVideos(VideoDetails videoDetails) async {
    //create a new video object
    /*  final newVideo = VideoDetails(filePath: filePath,title: title,videoId: videoId,isEncrypted: isEncrypted);*/

    //save to db
    try {
      await isar.writeTxn(() => isar.videoDetails.put(videoDetails));
      print("Successfully Download and Save");
    } catch (e) {
      print('Error saving item to Isar: $e');
    }

    //re-read from db
    fetchVideos();
  }

  //R E A D - videoDetails from db
  Future<List<VideoDetails>> fetchVideos() async {
    List<VideoDetails> fetchedVideos =
        await isar.videoDetails.where().findAll();
    currentVideos.clear();
    currentVideos.addAll(fetchedVideos);
    notifyListeners();
    return fetchedVideos;
  }

  //U P D A T E - a videoDetails in db
  Future<void> updateVideos(int id, String newFilepath) async {
    final existingVideo = await isar.videoDetails.get(id);
    if (existingVideo != null) {
      existingVideo.filePath = newFilepath;
      await isar.writeTxn(() => isar.videoDetails.put(existingVideo));
      await fetchVideos();
    }
  }

  //D E L E T E - a videoDetails from db
  Future<void> deleteVideos(int id) async {
    await isar.writeTxn(() => isar.videoDetails.delete(id));
    await fetchVideos();
  }
}
