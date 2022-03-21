import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:image_picker/image_picker.dart';

class ImageData {
  late String res;
  Future<String> takeMedia(String folder, String name1) async {
    res = '';
    try {
      final XFile? media;
      media = await ImagePicker().pickImage(source: ImageSource.camera);
      if (media == null) {
        return "";
      }

      File image = File(media.path);
      String name = name1 + image.hashCode.toString() + '.png';
      try {
        firebase_storage.TaskSnapshot task = await firebase_storage
            .FirebaseStorage.instance
            .ref(folder + name)
            .putFile(image)
            .whenComplete(() {});
        var url;
        res = await task.ref.getDownloadURL();
        // print(res);
        // final snapshot = task.metadata;
      } on firebase_core.FirebaseException catch (e) {
        // e.g, e.code == 'canceled'
      }

      //Create a reference to the location you want to upload to in firebase
    } on PlatformException catch (e) {
      print(e);
    }
    return res;
  }
}
