import 'package:flutter/material.dart';
import 'package:flutter_soft_token/common_widgets/common_text_form_field.dart';
import 'package:flutter_soft_token/common_widgets/rounded_button.dart';
import 'package:flutter_soft_token/res/strings.dart';
import 'package:flutter_soft_token/screens/success.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unique_identifier/unique_identifier.dart';

import '../dio/dio_client.dart';
import '../utils/common_function.dart';
import '../utils/encryption.dart';
import '../utils/progressbar.dart';

class ConfirmForgotMpin extends StatefulWidget {
  const ConfirmForgotMpin();

  @override
  State<ConfirmForgotMpin> createState() => _ConfirmForgotMpinState();
}

class _ConfirmForgotMpinState extends State<ConfirmForgotMpin> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confPassController = TextEditingController();
  final DioClient _apiClient = DioClient();
  bool loading = false;

  Future<void> setMpin() async {
    if (await CommonFunction.checkNetwork()) {
      if (confPassController.text == "" && passwordController.text == "") {
        Fluttertoast.showToast(
          msg: Strings.validation_enter_mpin,
          backgroundColor: Colors.white,
        );
        return;
      } else if (passwordController.text.length < 6 &&
          confPassController.text.length < 6) {
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
        dynamic response = await _apiClient.confirmmpin(
            Encryption.encryptMyData(userId!),
            Encryption.encryptMyData(confPassController.text),
            // Encryption.encryptMyData(deviceId!),
            Encryption.encryptMyData("${deviceId!}_${userId}"),
            Encryption.encryptMyData("MPIN"));

        String data = response.toString();
        print(data);
        setState(() => loading = false);
        // Navigator.pop(context);
        if (response['response_code'] == 0) {
          // _settingModalBottomSheet(data);
          CommonFunction.settingModalBottomSheet(
              response['response_message'], context);
        } else if (response['response_code'] == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Success(),
            ),
          );
        }
      }
      // }
    } else {
      Fluttertoast.showToast(
        msg: Strings.please_connect_to_internet,
        backgroundColor: Colors.white,
      );
    }
  }

  Widget build(BuildContext context) {
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
                    Image.asset(
                      'assets/images/bank_logo.jpg',
                      fit: BoxFit.contain,
                      height: 32,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        Strings.bank_name_long,
                        style: TextStyle(
                          fontSize: 14.0,
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: CommonTextFormField(
                          obscureText: true,
                          keyboardType: TextInputType.number,
                          hintText: Strings.new_mpin,
                          prefixIcon: "assets/images/mpin.png",
                          controller: passwordController,
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Center(
                        child: CommonTextFormField(
                            obscureText: true,
                            keyboardType: TextInputType.number,
                            hintText: Strings.confirm_mpin,
                            prefixIcon: "assets/images/mpin.png",
                            controller: confPassController),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: RoundedCornerButton(
                          text: Strings.submit,
                          onPressed: () => setMpin(),
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
