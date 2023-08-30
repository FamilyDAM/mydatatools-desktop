import 'dart:convert';
import 'dart:typed_data';

import 'package:pointycastle/export.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';

class EncryptionHelper {
  RsaKeyHelper rsaKeyHelper = RsaKeyHelper();

  AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> generateRSAkeyPair({int bitLength = 2048}) {
    // Create an RSA key generator and initialize it
    SecureRandom secureRandom = rsaKeyHelper.getSecureRandom();

    final keyGen = RSAKeyGenerator()
      ..init(ParametersWithRandom(RSAKeyGeneratorParameters(BigInt.parse('65537'), bitLength, 64), secureRandom));

    // Use the generator

    final pair = keyGen.generateKeyPair();

    // Cast the generated key pair into the RSA key types

    final myPublic = pair.publicKey as RSAPublicKey;
    final myPrivate = pair.privateKey as RSAPrivateKey;

    return AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>(myPublic, myPrivate);
  }

  String encodePublicKeyToPemPKCS1(RSAPublicKey publicKey) {
    return rsaKeyHelper.encodePublicKeyToPemPKCS1(publicKey);
  }

  String encodePrivateKeyToPemPKCS1(RSAPrivateKey privateKey) {
    return rsaKeyHelper.encodePrivateKeyToPemPKCS1(privateKey);
  }

  Uint8List rsaEncrypt(PublicKey myPublic, Uint8List dataToEncrypt) {
    final encryptor = OAEPEncoding(RSAEngine())..init(true, PublicKeyParameter<RSAPublicKey>(myPublic)); // true=encrypt
    return _processInBlocks(encryptor, dataToEncrypt);
  }

  Uint8List rsaDecrypt(PrivateKey myPrivate, Uint8List cipherText) {
    final decryptor = OAEPEncoding(RSAEngine())
      ..init(false, PrivateKeyParameter<RSAPrivateKey>(myPrivate)); // false=decrypt
    return _processInBlocks(decryptor, cipherText);
  }

  String rsaDecryptAsString(PrivateKey myPrivate, Uint8List cipherText) {
    final decryptor = OAEPEncoding(RSAEngine())
      ..init(false, PrivateKeyParameter<RSAPrivateKey>(myPrivate)); // false=decrypt
    return utf8.decode(_processInBlocks(decryptor, cipherText));
  }

  Uint8List _processInBlocks(AsymmetricBlockCipher engine, Uint8List input) {
    final numBlocks = input.length ~/ engine.inputBlockSize + ((input.length % engine.inputBlockSize != 0) ? 1 : 0);

    final output = Uint8List(numBlocks * engine.outputBlockSize);

    var inputOffset = 0;
    var outputOffset = 0;
    while (inputOffset < input.length) {
      final chunkSize =
          (inputOffset + engine.inputBlockSize <= input.length) ? engine.inputBlockSize : input.length - inputOffset;

      outputOffset += engine.processBlock(input, inputOffset, chunkSize, output, outputOffset);

      inputOffset += chunkSize;
    }

    return (output.length == outputOffset) ? output : output.sublist(0, outputOffset);
  }
}
