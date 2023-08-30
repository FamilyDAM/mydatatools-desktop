import "dart:convert";
import "dart:io" as io;
import "dart:typed_data";

import 'package:flutter_test/flutter_test.dart';
import "package:pointycastle/pointycastle.dart";
import "package:pointycastle/export.dart";
import 'package:encrypt/encrypt.dart';
import "package:client/helpers/encryption_helper.dart";

/// Test the RSA key generation
void main() {
  //WidgetsFlutterBinding.ensureInitialized();
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Test 2048 RSA Key Generation', () async {
    var start = DateTime.now();
    var helper = EncryptionHelper();
    AsymmetricKeyPair<PublicKey, PrivateKey> keys = helper.generateRSAkeyPair();
    print("Key generation took ${DateTime.now().difference(start).inMilliseconds} ms");

    expect(keys.publicKey, isNotNull);
    expect(keys.publicKey, isA<RSAPublicKey>());

    expect(keys.privateKey, isNotNull);
    expect(keys.privateKey, isA<RSAPrivateKey>());
  });

  test('Test 4096 RSA Key Generation', () async {
    var start = DateTime.now();
    var helper = EncryptionHelper();
    AsymmetricKeyPair<PublicKey, PrivateKey> keys = helper.generateRSAkeyPair(bitLength: 4096);
    print("Key generation took ${DateTime.now().difference(start).inMilliseconds} ms");

    expect(keys.publicKey, isNotNull);
    expect(keys.publicKey, isA<RSAPublicKey>());

    expect(keys.privateKey, isNotNull);
    expect(keys.privateKey, isA<RSAPrivateKey>());
  });

  test('Test toString of Public RSA Key', () async {
    var start = DateTime.now();
    var helper = EncryptionHelper();
    AsymmetricKeyPair<PublicKey, PrivateKey> keys = helper.generateRSAkeyPair();
    print("Key generation took ${DateTime.now().difference(start).inMilliseconds} ms");

    var pkeyString = helper.encodePublicKeyToPemPKCS1(keys.publicKey as RSAPublicKey);
    expect(pkeyString, isNotNull);
    expect(pkeyString, startsWith('-----BEGIN RSA PUBLIC KEY-----'));
  });

  test('Test toString of Private RSA Key', () async {
    var start = DateTime.now();
    var helper = EncryptionHelper();
    AsymmetricKeyPair<PublicKey, PrivateKey> keys = helper.generateRSAkeyPair();
    print("Key generation took ${DateTime.now().difference(start).inMilliseconds} ms");

    var pkeyString = helper.encodePrivateKeyToPemPKCS1(keys.privateKey as RSAPrivateKey);
    expect(pkeyString, isNotNull);
    expect(pkeyString, startsWith('-----BEGIN RSA PRIVATE KEY-----'));
  });

  test('Test load key Files', () async {
    var start = DateTime.now();
    var helper = EncryptionHelper();
    AsymmetricKeyPair<PublicKey, PrivateKey> keys = helper.generateRSAkeyPair();
    print("Key generation took ${DateTime.now().difference(start).inMilliseconds} ms");

    var publickeyString = helper.encodePublicKeyToPemPKCS1(keys.publicKey as RSAPublicKey);
    var privatekeyString = helper.encodePrivateKeyToPemPKCS1(keys.privateKey as RSAPrivateKey);

    //write to temp folder
    var publicFile = await io.File('test_resources/public.pem').writeAsString(publickeyString);
    var privateFile = await io.File('test_resources/private.pem').writeAsString(privatekeyString);

    //read from disk / temp folder
    String pubKey = io.File(publicFile.path).readAsStringSync();
    String priKey = io.File(privateFile.path).readAsStringSync();

    //parse strings from file
    RSAKeyParser parser = RSAKeyParser();
    RSAPublicKey publicKeyFromDisk = parser.parse(pubKey) as RSAPublicKey;
    RSAPrivateKey privateKeyFromDisk = parser.parse(priKey) as RSAPrivateKey;

    //do a simple encrypt/decrypt to make sure it works
    var encryptedString = helper.rsaEncrypt(publicKeyFromDisk, Uint8List.fromList(utf8.encode('Hello World')));
    var decryptedString = helper.rsaDecryptAsString(privateKeyFromDisk, encryptedString);

    expect(decryptedString, equals('Hello World'));

    //parse pem string to public key
    //see https://stackoverflow.com/questions/63321302/how-can-i-decode-a-string-from-base64-to-binary-to-decrypt-it-with-rsa-in-flutte

    publicFile.delete();
    privateFile.delete();
  });

  test('Test encrypt string', () async {
    var start = DateTime.now();
    var helper = EncryptionHelper();
    AsymmetricKeyPair<PublicKey, PrivateKey> keys = helper.generateRSAkeyPair();
    print("Key generation took ${DateTime.now().difference(start).inMilliseconds} ms");

    //var encryptedString = rsaEncrypt(keys.publicKey, Uint8List.fromList('Hello World'.codeUnits));
    var encryptedString = helper.rsaEncrypt(keys.publicKey, Uint8List.fromList(utf8.encode('Hello World')));
    expect(encryptedString, isNotNull);
    print(encryptedString);
  });

  test('Test decrypt string', () async {
    var start = DateTime.now();
    var helper = EncryptionHelper();
    AsymmetricKeyPair<PublicKey, PrivateKey> keys = helper.generateRSAkeyPair();
    print("Key generation took ${DateTime.now().difference(start).inMilliseconds} ms");

    var encryptedString = helper.rsaEncrypt(keys.publicKey, Uint8List.fromList('Hello World'.codeUnits));
    expect(encryptedString, isNotNull);

    var decryptedString = helper.rsaDecrypt(keys.privateKey, encryptedString);
    expect(decryptedString, isNotNull);

    ///expect(String.fromCharCodes(decryptedString), equals('Hello World'));
    expect(utf8.decode(decryptedString), equals('Hello World'));
    print(utf8.decode(decryptedString));
  });

  test('Test encrypt & decrypt image', () async {
    var start = DateTime.now();
    var helper = EncryptionHelper();
    AsymmetricKeyPair<PublicKey, PrivateKey> keys = helper.generateRSAkeyPair();
    print("Key generation took ${DateTime.now().difference(start).inMilliseconds} ms");

    String filePath = "test_resources/128-536x354-32kb.jpg";
    var fileBytes = await io.File(filePath).readAsBytes();
    Uint8List byteList = fileBytes.buffer.asUint8List();

    var startE = DateTime.now();
    var encryptedFile = helper.rsaEncrypt(keys.publicKey, byteList);
    print("Encryption took ${DateTime.now().difference(startE).inMilliseconds} ms");
    expect(encryptedFile, isNotNull);

    var startD = DateTime.now();
    var decryptedFile = helper.rsaDecrypt(keys.privateKey, encryptedFile);
    print("Decryption took ${DateTime.now().difference(startD).inMilliseconds} ms");
    expect(decryptedFile, equals(byteList));

    //print(base64.encode(byteList));
    //print(hex.encode(byteList));
    //io.File("test_resources/128-536x354-32kb_decrypted.jpg").writeAsBytes(decryptedFile);
  });
}
