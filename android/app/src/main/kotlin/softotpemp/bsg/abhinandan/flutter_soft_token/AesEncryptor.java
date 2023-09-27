package softotpemp.bsg.abhinandan.flutter_soft_token;

import android.util.Base64;

import java.nio.charset.StandardCharsets;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

public class AesEncryptor {

    IvParameterSpec iv;
    SecretKeySpec skeySpec;
    public AesEncryptor(String key, String initVector) {
        try {
            key = "MobBtY4kngvR823B";
            initVector = "bSgitSOFTpvtLtdC";
            iv = new IvParameterSpec(initVector.getBytes(StandardCharsets.UTF_8));
            skeySpec = new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "AES");
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }
    public String encrypt(String value) {
        try {
            Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5PADDING");
            cipher.init(Cipher.ENCRYPT_MODE, skeySpec, iv);
            byte[] encrypted = cipher.doFinal(value.getBytes());
            //System.out.println("encrypted string: "
            //+ Base64.encodeBase64String(encrypted));
            return Base64.encodeToString(encrypted,Base64.NO_WRAP);//Base64.encodeBase64String(encrypted);
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return null;
    }
    public String decrypt(String encrypted) {
        try {
            Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5PADDING");
            cipher.init(Cipher.DECRYPT_MODE, skeySpec, iv);
            byte[] original = cipher.doFinal(Base64.decode(encrypted,Base64.DEFAULT));
            //cipher.doFinal(Base64.decodeBase64(encrypted));
            return new String(original);
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return null;
    }


}
