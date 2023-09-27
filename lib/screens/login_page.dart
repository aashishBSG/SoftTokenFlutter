import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_soft_token/common_widgets/rounded_button.dart';
import 'package:flutter_soft_token/screens/dashboard.dart';
import 'package:flutter_soft_token/screens/forgot_mpin.dart';
import 'package:flutter_soft_token/screens/register_user.dart';
import 'package:flutter_soft_token/res/strings.dart';
import 'package:flutter_soft_token/utils/common_function.dart';
import 'package:flutter_soft_token/utils/progressbar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unique_identifier/unique_identifier.dart';
import '../dio/api_constants.dart';
import '../dio/dio_client.dart';
import '../utils/encryption.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utils/sharedpreference.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _MyVerifyState();
}

class _MyVerifyState extends State<Login> {
  final DioClient _apiClient = DioClient();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String intentData = '';
  bool loading = false;
  bool permissionGranted = false;

  // String apitocall = '';
  // String activity = '';

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    ApiConstants.token = "";
    ApiConstants.mobile_platform = Platform.operatingSystem;
    requestPermissions();
    _initPackageInfo();
  }

  Future<void> requestPermissions() async {
    await UtilSharedPreferences.setVersionCode(_packageInfo.buildNumber);
    List<Permission> permissions = [
      Permission.phone,
      Permission.locationWhenInUse,

    ];

    Map<Permission, PermissionStatus> permissionStatuses =
        await permissions.request();
    if (permissionStatuses[Permission.phone]!.isDenied ||
        permissionStatuses[Permission.phone]!.isPermanentlyDenied) {
      Fluttertoast.showToast(
        msg: 'Please Allow All Permissions',
        backgroundColor: Colors.white,
      );
      SystemNavigator.pop();
    }
    if (permissionStatuses[Permission.locationWhenInUse]!.isDenied ||
        permissionStatuses[Permission.locationWhenInUse]!.isPermanentlyDenied) {
      Fluttertoast.showToast(
        msg: 'Please Allow All Permissions',
        backgroundColor: Colors.white,
      );
      SystemNavigator.pop();
    }
  }

  void clearFields() {
    emailController.clear();
    passwordController.clear();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  Future<void> login(String pin) async {
    if (await CommonFunction.checkNetwork()) {
      if (passwordController.text == "") {
        Fluttertoast.showToast(
          msg: Strings.validation_invalid_mpin,
          backgroundColor: Colors.white,
        );
        return;
      } else {
        setState(() => loading = true);
        // CommonFunction.showLoadingDialog(context);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? userId = prefs.getString('userId');
        String? deviceId = await UniqueIdentifier.serial;
        dynamic response = await _apiClient.login(
            Encryption.encryptMyData("NA"),
            Encryption.encryptMyData(passwordController.text),
            Encryption.encryptMyData("${deviceId!}_${userId}"),
            Encryption.encryptMyData("MPIN"));

        setState(() => loading = false);
        // Navigator.pop(context);
        Map responseBody = response;
        print(responseBody);
        if (response['response_code'] == 0) {
          // _settingModalBottomSheet();
          CommonFunction.settingModalBottomSheet(
              response['response_message'], context);
        } else if (response['response_code'] == 1) {
          dynamic userId = response['results'][0]['userId'];
          dynamic token = response['results'][0]['token'];

          ApiConstants.token = response['results'][0]['token'];
          await UtilSharedPreferences.setToken(token);

          print(userId);
          print(token);

          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('userId', userId);
          prefs.setString('token', token);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Dashboard(),
            ),
          );
        }
      }
    } else {
      Fluttertoast.showToast(
        msg: Strings.please_connect_to_internet,
        backgroundColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 40,
      textStyle: TextStyle(
          fontSize: 25,
          color: Color.fromRGBO(234, 239, 243, 1),
          fontWeight: FontWeight.bold),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
      // border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    // final submittedPinTheme = defaultPinTheme.copyWith(
    //   decoration: defaultPinTheme.decoration?.copyWith(
    //     color: const Color.fromRGBO(234, 239, 243, 1),
    //   ),
    // );

    return loading
        ? Loading()
        : MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              resizeToAvoidBottomInset: false,
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: Image.asset(
                        'assets/images/bank_logo.jpg',
                        fit: BoxFit.contain,
                        height: 80,
                        width: 80,
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        Strings.bank_name,
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Lato',
                        ),
                      ),
                    )
                  ],
                ),
                backgroundColor: Colors.transparent,
              ),
              body: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/bg.png'),
                      fit: BoxFit.fill),
                ),
                // margin: const EdgeInsets.only(left: 25, right: 25),
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Center(
                        child: Pinput(
                          length: 6,
                          defaultPinTheme: focusedPinTheme,
                          obscureText: true,
                          controller: passwordController,
                          showCursor: true,
                          onCompleted: (pin) => login(pin),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: RoundedCornerButton(
                          text: 'Login',
                          onPressed: () => login(passwordController.text),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForgotPassword(
                                  data: 'forgot',
                                ),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            splashFactory: NoSplash.splashFactory,
                            foregroundColor: Colors.white,

                          ),
                          child: const Text(
                            Strings.forgot_mpin,
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Lato',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      SizedBox(
                        height: 40,
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Register(
                                          data: 'register',
                                        )));
                          },
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              splashFactory: NoSplash.splashFactory),
                          child: const Text(
                            Strings.register_user,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Lato',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 120,
                      ),
                      Center(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              splashFactory: NoSplash.splashFactory,
                              foregroundColor: Colors.white,
                            ),
                            child: Text(
                              _packageInfo.version,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
