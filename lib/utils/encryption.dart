import 'package:encrypt/encrypt.dart';

class Encryption {
  final key = Key.fromUtf8('MobBtY4kngvR823B'); //32 chars
  final iv = IV.fromUtf8('bSgitSOFTpvtLtdC'); //16 chars

 static String encryptMyData(String text) {
    final key = Key.fromUtf8('MobBtY4kngvR823B'); //32 chars
    final iv = IV.fromUtf8('bSgitSOFTpvtLtdC');
    final e = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted_data = e.encrypt(text, iv: iv);
    return encrypted_data.base64;
  }

//dycrypt
  String decryptMyData(String text) {
    final e = Encrypter(AES(key, mode: AESMode.cbc));
    final decrypted_data = e.decrypt(Encrypted.fromBase64(text), iv: iv);
    return decrypted_data;
  }


}
