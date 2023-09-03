import 'dart:isolate';

import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';

class AppLogger extends Logger {
  SendPort? sendPort;

  AppLogger(SendPort? sendPort_) : super(printer: SimplePrinter()) {
    sendPort = sendPort_;
  }

  static PublishSubject<String> statusSubject = PublishSubject<String>();

  void s(dynamic message) async {
    //If we are in an Isolate we'll send the message out over the port and let the parent log it.
    if (sendPort != null) {
      sendPort!.send(message);
    } else {
      statusSubject.add(message);
    }
  }
}
