import 'package:better_player/better_player.dart';
import 'package:isar/isar.dart';

part 'video.g.dart';

@Collection()
class VideoDetails {
  Id id = Isar.autoIncrement;
  late String videoId;
  late String title;
  late String filePath;

  VideoDetails(
      {required this.videoId, required this.title, required this.filePath});

  BetterPlayerDataSource toDataSource() {
    return BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      filePath,
      subtitles: BetterPlayerSubtitlesSource.single(
        type: BetterPlayerSubtitlesSourceType.file,
        url: filePath,
        name: title.trim(),
        selectedByDefault: true,
      ),
    );
  }
}
