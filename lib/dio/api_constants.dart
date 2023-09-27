

class ApiConstants {


  //Base Url
  static String baseUrl = 'https://mobilebanking.incometaxbank.co.in:12720';

  //Token
  static String token = '';

  //app version
  static int version_code = 1;
  static String device_id = '';
  static String mobile_platform = '';

  // app platform
  static String plateform ='';

  //End Points
  static String login = '/softtoken/mob_user/login';
  static String logout = '/softtoken/mob_user/logout';
  static String setmpin = '/softtoken/mob_user/set_mpin';
  static String forgotmpin = '/softtoken/mob_user/forgot_mpin';
  static String registeruser = '/softtoken/mob_user/register_user';
  static String getotp = '/softtoken/mob_user/getLoginOtp';
  static String confirmforgotmpin = '/softtoken/mob_user/forgot_mpin_confrim';
}
