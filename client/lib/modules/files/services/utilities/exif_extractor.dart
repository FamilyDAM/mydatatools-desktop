import 'dart:io' as io;
import 'package:client/models/module_models.dart';
import 'package:client/modules/files/files_constants.dart';
import 'package:exif/exif.dart';

class ExifExtractor {
  Future<Map<String, dynamic>?> extractLatLng(File file) async {
    Map<String, dynamic> metadata = {};

    if (file.contentType == FilesConstants.mimeTypeImage) {
      var localFile = io.File(file.path);
      if (localFile.existsSync()) {
        Map<String, IfdTag> exif = await readExifFromFile(io.File(file.path));
        if (exif.containsKey('GPS GPSLatitude') && exif.containsKey('GPS GPSLongitude')) {
          var lat = exifGPSToLatitude(exif);
          var lng = exifGPSToLongitude(exif);
          metadata['latitude'] = lat;
          metadata['longitude'] = lng;
        }
      }
    }
    print(metadata);
    return Future(() => metadata);
  }

  double exifGPSToLatitude(Map<String, IfdTag> tags) {
    final latitudeValue = tags['GPS GPSLatitude']!
        .values
        .toList()
        .map<double>((item) => (item.numerator.toDouble() / item.denominator.toDouble()))
        .toList();
    final latitudeSignal = tags['GPS GPSLatitudeRef']!.printable;

    double latitude = latitudeValue[0] + (latitudeValue[1] / 60) + (latitudeValue[2] / 3600);

    if (latitudeSignal == 'S') latitude = -latitude;

    return latitude;
  }

  double exifGPSToLongitude(Map<String, IfdTag> tags) {
    final longitudeValue = tags['GPS GPSLongitude']!
        .values
        .toList()
        .map<double>((item) => (item.numerator.toDouble() / item.denominator.toDouble()))
        .toList();
    final longitudeSignal = tags['GPS GPSLongitudeRef']!.printable;

    double longitude = longitudeValue[0] + (longitudeValue[1] / 60) + (longitudeValue[2] / 3600);

    if (longitudeSignal == 'W') longitude = -longitude;

    return longitude;
  }
}
