import 'package:client/app_logger.dart';
import 'package:client/models/module_models.dart';
import 'package:client/modules/photos/services/photos_repository.dart';
import 'package:client/repositories/realm_repository.dart';
import 'package:client/services/rx_service.dart';

class PhotosByDateService extends RxService<PhotosByDateServiceCommand, Map<String, List<File>>> {
  final AppLogger logger = AppLogger();

  static final PhotosByDateService _instance = PhotosByDateService();
  static get instance => _instance;

  @override
  Future<Map<String, List<File>>> invoke(PhotosByDateServiceCommand command) async {
    isLoading.add(true);
    PhotosRepository repo = PhotosRepository(RealmRepository.instance.database);

    //load files and folders from db
    Map<String, List<File>> photos = repo.photosByDate();
    sink.add(photos);
    isLoading.add(false);

    return Future(() => photos);
  }
}

class PhotosByDateServiceCommand extends RxCommand {}
