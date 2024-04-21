import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:ytdownloader/assets.dart';

Widget emptyFileScreenWidget() {
  return Column(
    children: [
      Lottie.asset(fileNotFound, fit: BoxFit.cover),
      const SizedBox(
        height: 10,
      ),
      const Center(
        child: Text(
          'No Data Found',
          style: TextStyle(
              color: Colors.red, fontSize: 30, fontWeight: FontWeight.w300),
        ),
      ),
    ],
  );
}

SnackBar snackBarWhenSuccess(String message) {
  return SnackBar(
    content: Row(
      children: [
        const Icon(
          Iconsax.tick_circle,
          color: Colors.green,
        ),
        const SizedBox(width: 5),
        Text(message),
      ],
    ),
    backgroundColor: Colors.black,
  );
}
