import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeWidget extends StatelessWidget {
  const TimeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => StreamBuilder(
        stream: Stream.periodic(const Duration(seconds: 1)),
        builder: (BuildContext context, AsyncSnapshot<Object?> snapshot) =>
            Center(
          child: Row(
            children: <Widget>[
              const Icon(
                Icons.access_time,
                color: Colors.white,
                size: 48,
              ),
              const SizedBox(width: 4),
              Text(
                DateFormat('hh:mm a').format(DateTime.now()),
                style: const TextStyle(fontSize: 40, color: Colors.white),
              ),
            ],
          ),
        ),
      );
}
