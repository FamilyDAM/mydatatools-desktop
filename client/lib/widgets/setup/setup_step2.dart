import 'dart:io';

import 'package:client/app_router.dart';
import 'package:client/models/tables/app_user.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class SetupStep2 extends StatefulWidget {
  const SetupStep2({super.key, required this.appUser, required this.onCancel, required this.onSubmit});

  final AppUser? appUser;
  final VoidCallback onCancel;
  final void Function(AppUser) onSubmit;

  @override
  State<SetupStep2> createState() => _SetupStep2State();
}

class _SetupStep2State extends State<SetupStep2> {
  String? errorMessage;

  final storageForm = FormGroup({
    'storageLocation': FormControl<String>(validators: [Validators.required]),
  });

  onStepCancelHandler() {
    widget.onCancel();
  }

  onStepContinueHandler(BuildContext context) async {
    var appUser = widget.appUser;

    if (storageForm.valid && appUser != null) {
      var supportDir = AppRouter.supportDirectory.value;
      appUser.localStoragePath = (supportDir is Directory) ? supportDir.path : supportDir;

      try {
        errorMessage = null;
        //Check directories as needed
        var dir = Directory(appUser.localStoragePath);
        var keysDir = Directory("${appUser.localStoragePath}${Platform.pathSeparator}keys");
        var dbDir = Directory("${appUser.localStoragePath}${Platform.pathSeparator}data");
        var repoDir = Directory("${appUser.localStoragePath}${Platform.pathSeparator}files");
        if (!dir.existsSync()) {
          dir.createSync(recursive: true);
        }
        if (!keysDir.existsSync()) {
          keysDir.createSync(recursive: true);
        }
        if (!dbDir.existsSync()) {
          dbDir.createSync(recursive: true);
        }
        if (!repoDir.existsSync()) {
          repoDir.createSync(recursive: true);
        }

        //call callback and proceed to next step
        widget.onSubmit(appUser);
      } catch (e) {
        //Missing permissions required to use folder
        storageForm.findControl('storageLocation')?.value = '';
        errorMessage = 'Missing permissions required to use folder';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //handle async setup for validators
    var dir = AppRouter.supportDirectory.value;
    var field = storageForm.findControl('storageLocation');
    if (field != null) {
      field.value = (dir is String) ? dir : dir.path;
    }

    return ReactiveForm(
      formGroup: storageForm,
      child: Column(children: <Widget>[
        ReactiveTextField(
          readOnly: true,
          formControlName: 'storageLocation',
          decoration: const InputDecoration(
            label: Text('Storage Location'),
            prefixIcon: Icon(Icons.folder_open),
          ),
        ),
        TextButton(
            onPressed: () async {
              String? result = await FilePicker.platform.getDirectoryPath();
              if (result != null) {
                storageForm.findControl('storageLocation')?.value = result;
                AppRouter.databaseDirectory.add(result);
              } else {
                // User canceled the picker, do nothing
              }
            },
            child: const Text("Browse")),
        Container(height: 16),
        errorMessage != null
            ? Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red),
              )
            : Container(),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
              'Select a directory, on your LARGEST DRIVE, to store all metadata and the local backup of all cloud drives, email attachements, and social media posts.',
              textAlign: TextAlign.left),
        ),
        Container(height: 8),
        const Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Text('Default: ', textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold)),
              Text('OS Application Support Directory', textAlign: TextAlign.left),
            ],
          ),
        ),
        Container(height: 16),
        ReactiveFormConsumer(
          builder: (context, form, child) {
            return Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 170,
                height: 54,
                child: Row(
                  children: <Widget>[
                    TextButton(
                      onPressed: () => onStepCancelHandler(),
                      child: const Text('Back'),
                    ),
                    OutlinedButton(
                      onPressed: storageForm.valid ? () => onStepContinueHandler(context) : null,
                      style: ButtonStyle(
                        backgroundColor: storageForm.valid
                            ? MaterialStateProperty.all<Color>(Colors.green)
                            : MaterialStateProperty.all<Color>(Colors.grey),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      child: const Text('Continue'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ]),
    );
  }
}
