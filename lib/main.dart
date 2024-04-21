import 'package:flutter/material.dart';
import 'package:ytdownloader/models/video_database.dart';
import 'package:provider/provider.dart';
import 'package:ytdownloader/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await VideoDatabase.initialize();
  runApp(
    ChangeNotifierProvider(
      create: (context) => VideoDatabase(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YTDownloader',
      debugShowCheckedModeBanner: false,
      routes: routes,
      initialRoute: Routes.downloaderScreen,
    );
  }
}
