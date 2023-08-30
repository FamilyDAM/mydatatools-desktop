import 'dart:convert';
import 'dart:typed_data';

import 'package:client/helpers/encryption_helper.dart';
import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:reactive_forms/reactive_forms.dart';

class EncryptionFormValidator extends Validator<dynamic> {
  final String controlName;
  final String compareControlName;

  EncryptionHelper helper = EncryptionHelper();
  RSAKeyParser parser = RSAKeyParser();

  /// Constructs an instance of the validator.
  ///
  /// The arguments [controlName], [compareControlName]
  /// must not be null.
  EncryptionFormValidator(
    this.controlName,
    this.compareControlName,
  );

  @override
  Map<String, dynamic>? validate(AbstractControl<dynamic> control) {
    if (control is! FormGroup) {
      // Maybe throw an exception is better
      return <String, dynamic>{ValidationMessage.compare: true};
    }

    final pubKeyControl = control.control(controlName);
    final priKeyControl = control.control(compareControlName);

    if (pubKeyControl.value.toString().isEmpty || priKeyControl.value.toString().isEmpty) {
      final error = {
        ValidationMessage.required: 'Fields are required',
      };
      return error;
    }

    //parse strings from file
    try {
      RSAPublicKey publicKeyFromDisk = parser.parse(pubKeyControl.value) as RSAPublicKey;
      RSAPrivateKey privateKeyFromDisk = parser.parse(priKeyControl.value) as RSAPrivateKey;

      //do a simple encrypt/decrypt to make sure it works
      var encryptedString = helper.rsaEncrypt(publicKeyFromDisk, Uint8List.fromList(utf8.encode('Hello World')));
      var decryptedString = helper.rsaDecryptAsString(privateKeyFromDisk, encryptedString);

      if (decryptedString != 'Hello World') {
        final error = {
          ValidationMessage.required: 'Fields are required',
        };
        return error;
      }

      return null;
    } catch (e) {
      final error = {
        ValidationMessage.required: 'Fields are required',
      };
      return error;
    }
  }
}
