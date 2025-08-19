import 'dart:convert';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';
import 'package:fvf_flutter/app/data/config/logger.dart';


/// Secret key and IV for AES encryption
Uint8List secretKey = Uint8List.fromList(
    <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]);

/// Secret IV for AES encryption
Uint8List secretIv = Uint8List.fromList(
    <int>[21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36]);

/// App encryption utility class
class AppEncryption {

  /// Key
  static final Key key = Key(secretKey);
  /// Initialization Vector (IV)
  static final IV iv = IV(secretIv);

  /// Encrypter instance for AES encryption
  static final Encrypter encrypter = Encrypter(AES(
    key,
    mode: AESMode.ctr,
    padding: null,
  ));

  /// Encrypts the given plain text using AES encryption
  static String encrypt({required String plainText}) {
    final Encrypted encrypted = encrypter.encrypt(plainText, iv: iv);

    return encrypted.base16;
  }

  /// Decrypts the given cipher text using AES decryption
  static String decrypt({required String cipherText}) {
    final String decrypted = encrypter.decrypt16(cipherText, iv: iv);

    return decrypted;
  }

  /// Test encryption and decryption
  static void testEncryption() {
    final String plainText = jsonEncode(<String, dynamic>{
      'name': '',
      'username': 'test',
      'email': '',
      'phone': '',
      'country': '',
      'city': '',
      'bio': '',
      'current_location': '',
      'first_name': '',
      'last_name': '',
      'address_line1': '',
      'address_line2': '',
      'is_verified': false,
      'job_post': '',
      'password': 'passwordpasswordpasswordpasswordpassword',
    });


    /// Log the plain text
    final Encrypted encrypted = encrypter.encrypt(plainText, iv: iv);

    /// Log the encrypted text
    final String decrypted = encrypter.decrypt(encrypted, iv: iv);

    logI('Decrypted :: $decrypted');
    logI('base16 :: ${encrypted.base16}');
    logI('base64 :: ${encrypted.base64}');

    String? separator;
    int? wrap;
    final Uint8List bytes = encrypted.bytes;
    int len = 0;
    final StringBuffer buf = StringBuffer();
    for (final int b in bytes) {
      final String s = b.toRadixString(16);
      if (buf.isNotEmpty && separator != null) {
        buf.write(separator);
        len += separator.length;
      }

      if (wrap != null && wrap < len + 2) {
        buf.write('\n');
        len = 0;
      }

      buf.write('${(s.length == 1) ? '0' : ''}$s');
      len += 2;
    }
    logI('bytes to base16 :: $buf');
  }
}
