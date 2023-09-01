import 'dart:convert';
import 'dart:io' as io;
import 'package:client/models/module_models.dart';
import 'package:client/modules/files/files_constants.dart';
import 'package:image/image.dart' as img;

class ThumbnailGenerator {
  Future<String?> imageToBase64(File file) async {
    bool thumbGenerated = false;
    if (file.contentType == FilesConstants.mimeTypeImage) {
      var localFile = io.File(file.path);
      if (localFile.existsSync()) {
        // Read a image from file.
        img.Image? image = img.decodeImage(localFile.readAsBytesSync());
        if (image != null) {
          img.Image? thumb = image; //start with original image
          //resize to something around 320x240 (small enought to use as a thumbnail big enough to do other things, like phash or ml)
          if (image.height >= image.width && image.height > 240) {
            thumb = img.copyResize(image, height: 240);
          } else if (image.width >= image.height && image.width > 320) {
            thumb = img.copyResize(image, width: 320);

            //save as jpeg and encode to base64
            thumbGenerated = true;
            final jpg = img.encodeJpg(thumb);
            var enc = base64Encode(jpg);
            return Future(() => enc);
          }
        }
      }
    }

    if (!thumbGenerated) {
      //todo, check EXIF data and see if thumbnail exists in exif (TIF, JPG often have this)
    }

    return Future(() => null);
  }
}
