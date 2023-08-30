import 'dart:io';

import 'package:client/helpers/encryption_form_validator.dart';
import 'package:client/helpers/encryption_helper.dart';
import 'package:client/models/app_models.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:reactive_forms/reactive_forms.dart';

class SetupStep3 extends StatefulWidget {
  const SetupStep3({super.key, required this.appUser, required this.onCancel, required this.onSubmit});

  final AppUser? appUser;
  final VoidCallback onCancel;
  final void Function(AppUser) onSubmit;

  @override
  State<SetupStep3> createState() => _SetupStep3State();
}

class _SetupStep3State extends State<SetupStep3> {
  final EncryptionHelper encHelper = EncryptionHelper();
  final Logger logger = Logger();

  final encryptionForm = FormGroup({
    'publicKey': FormControl<String>(value: '', validators: [Validators.required]),
    'privateKey': FormControl<String>(value: '', validators: [Validators.required]),
  }, validators: [
    EncryptionFormValidator('publicKey', 'privateKey')
  ]);

  //async method to load os data and initialize form
  AppUser initForm(AppUser appUser) {
    if (appUser.localStoragePath.isNotEmpty) {
      //check storage location for existing public & private pem files to use
      var keysDir = Directory("${appUser.localStoragePath}${Platform.pathSeparator}keys");
      var pubFile = File("${keysDir.path}${Platform.pathSeparator}public.pem");
      var priFile = File("${keysDir.path}${Platform.pathSeparator}private.pem");

      if (pubFile.existsSync() && priFile.existsSync()) {
        appUser.publicKey = pubFile.readAsStringSync();
        appUser.privateKey = priFile.readAsStringSync();
      }
      //if existing files don't exists, generate new keys
      else if (appUser.publicKey.isEmpty) {
        var encHelper = EncryptionHelper();
        AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> keys = encHelper.generateRSAkeyPair();
        appUser.publicKey = encHelper.encodePublicKeyToPemPKCS1(keys.publicKey);
        appUser.privateKey = encHelper.encodePrivateKeyToPemPKCS1(keys.privateKey);
      }
      return appUser;
    }
    return appUser;
  }

  onResetKeysHandler() {
    encryptionForm.findControl('publicKey')?.value = '';
    encryptionForm.findControl('privateKey')?.value = '';

    AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> keys = encHelper.generateRSAkeyPair();
    encryptionForm.findControl('publicKey')?.value = encHelper.encodePublicKeyToPemPKCS1(keys.publicKey);
    encryptionForm.findControl('privateKey')?.value = encHelper.encodePrivateKeyToPemPKCS1(keys.privateKey);
  }

  onStepContinueHandler(BuildContext context, AppUser user) {
    //Do something with this information
    logger.d('setup step 3 is complete');

    if (encryptionForm.valid) {
      var privateKey = encryptionForm.findControl('privateKey')?.value;
      var publicKey = encryptionForm.findControl('publicKey')?.value;

      user.publicKey = publicKey;
      user.privateKey = privateKey;
      //callback with updated properties
      //ref.watch(setupAppUserProvider.notifier).state = appUser;

      widget.onSubmit(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    var appUserClone = widget.appUser!;
    //handle async setup for validators
    if (appUserClone.publicKey.isEmpty || appUserClone.privateKey.isEmpty) {
      appUserClone = initForm(appUserClone);
      //set form values
      encryptionForm.updateValue({'publicKey': appUserClone.publicKey, 'privateKey': appUserClone.privateKey});
    }

    if (appUserClone.publicKey.isEmpty) {
      return Container();
    }

    return ReactiveForm(
      formGroup: encryptionForm,
      child: Column(children: <Widget>[
        ReactiveTextField(
          formControlName: 'publicKey',
          minLines: 5,
          maxLines: 10,
          decoration: const InputDecoration(
              label: Text('Public Key'),
              prefixIcon: Icon(Icons.key),
              border: OutlineInputBorder(borderSide: BorderSide(width: 2))),
        ),
        Container(height: 16),
        ReactiveTextField(
          formControlName: 'privateKey',
          minLines: 5,
          maxLines: 10,
          decoration: const InputDecoration(
              label: Text('Private Key'),
              prefixIcon: Icon(Icons.key),
              border: OutlineInputBorder(borderSide: BorderSide(width: 2))),
        ),
        Container(height: 16),
        ReactiveFormConsumer(
          builder: (context, form, child) {
            return Row(
              children: <Widget>[
                TextButton(
                  onPressed: () => onResetKeysHandler(),
                  child: const Text('regenerate keys'),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => widget.onCancel(),
                  child: const Text('Back'),
                ),
                OutlinedButton(
                  onPressed: encryptionForm.valid ? () => onStepContinueHandler(context, appUserClone) : null,
                  style: ButtonStyle(
                    backgroundColor: encryptionForm.valid
                        ? MaterialStateProperty.all<Color>(Colors.green)
                        : MaterialStateProperty.all<Color>(Colors.grey),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: const Text('Complete Setup'),
                ),
              ],
            );
          },
        ),
      ]),
    );
  }
}
