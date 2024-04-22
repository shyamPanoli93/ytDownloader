
import 'package:flutter/material.dart';
import 'package:ytdownloader/pages/saved_yt_screen.dart';
import 'package:ytdownloader/pages/ytdownloadScreen.dart';

final Map<String, WidgetBuilder> routes = {
  Routes.downloaderScreen: (context) => const DownloadYoutubeVideoScreen(),
  Routes.savedVideoScreen: (context) => const SavedVideoScreen(),
};

class Routes {
  static const String downloaderScreen = '/videoDownloaderScreen';
  static const String savedVideoScreen = '/savedVideoScreen';
}