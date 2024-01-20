import 'package:client/app_logger.dart';
import 'package:client/main.dart';
import 'package:client/models/tables/file.dart';
import 'package:client/modules/photos/services/photos_repository.dart';
import 'package:client/repositories/database_repository.dart';
import 'package:client/services/rx_service.dart';

class PhotosByDateService extends RxService<PhotosByDateServiceCommand, Map<String, List<File>>> {
  final AppLogger logger = AppLogger(null);

  static final PhotosByDateService _instance = PhotosByDateService();
  static get instance => _instance;

  AppDatabase? database;

  PhotosByDateService() {
    MainApp.appDatabase.listen((value) {
      database = value;
    });
  }

  @override
  Future<Map<String, List<File>>> invoke(PhotosByDateServiceCommand command) async {
    if (database == null) return Future(() => {});

    isLoading.add(true);
    PhotosRepository repo = PhotosRepository();

    //load files and folders from db
    Map<String, List<File>> photos = await repo.photosByDate();
    sink.add(photos);
    isLoading.add(false);

    return Future(() => photos);
  }
}

class PhotosByDateServiceCommand extends RxCommand {}
