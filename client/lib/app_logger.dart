import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';

class AppLogger extends Logger {
  static PublishSubject<String> statusSubject = PublishSubject<String>();

  void s(dynamic message) {
    statusSubject.add(message);
  }
}
