import 'package:client/app_logger.dart';
import 'package:flutter/material.dart';

class StatusMessage extends StatelessWidget {
  const StatusMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
        stream: AppLogger.statusSubject,
        builder: (BuildContext context, AsyncSnapshot<String> msg) {
          print('[StatusMessage] ${msg.data}');
          return Text(msg.data ?? '',
              key: UniqueKey(),
              style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 12, overflow: TextOverflow.ellipsis));
        });
  }
}
