import 'package:client/models/module_models.dart';
import 'package:flutter/material.dart';

class EmailDetails extends StatefulWidget {
  const EmailDetails({Key? key, required this.email}) : super(key: key);

  final Email email;

  @override
  State<EmailDetails> createState() => _EmailDetails();
}

class _EmailDetails extends State<EmailDetails> {
  int sortColumnIndex = 0;
  String sortColumn = 'path';
  bool sortAsc = true;

  @override
  Widget build(BuildContext context) {
    //final theme = Theme.of(context);

    return Expanded(
        flex: 1,
        child: Container(
            constraints: const BoxConstraints.expand(),
            child: SingleChildScrollView(
              child: Text(widget.email.plainBody ?? '(empty)'),
            )));
  }
}
