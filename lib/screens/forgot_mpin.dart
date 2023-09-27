import 'package:flutter/material.dart';
import 'package:flutter_soft_token/common_widgets/common_text_form_field.dart';
import 'package:flutter_soft_token/dio/api_constants.dart';
import 'package:flutter_soft_token/dio/dio_client.dart';
import 'package:flutter_soft_token/screens/confirm_forgot_mpin.dart';
import 'package:flutter_soft_token/res/strings.dart';
import 'package:flutter_soft_token/utils/common_function.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unique_identifier/unique_identifier.dart';

import '../common_widgets/rounded_button.dart';
import '../utils/encryption.dart';

import '../utils/progressbar.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMassenger = GlobalKey();

class ForgotPassword extends StatelessWidget {
  final String data;

  ForgotPassword({required this.data});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final DioClient _apiClient = DioClient();
  bool loading = false;
  var userId;

  Future<void> registerUser() async {
    if (await CommonFunction.checkNetwork()) {
      if (emailController.text == "" && passwordController.text == "") {
        Fluttertoast.showToast(
          msg: Strings.validation_enter_custid_pass,
          backgroundColor: Colors.white,
        );
        return;
      } else {
        setState(() => loading = true);
        // CommonFunction.showLoadingDialog(context);
        String? deviceId = await UniqueIdentifier.serial;

        dynamic response = await _apiClient.forgotPassword(
            Encryption.encryptMyData(emailController.text),
            Encryption.encryptMyData(passwordController.text),
            Encryption.encryptMyData("${deviceId!}_${emailController.text}"),
            Encryption.encryptMyData("CRED"));

        String data = response.toString();
        print(data);
        setState(() => loading = false);
        // Navigator.pop(context);
        clearFields();
        if (response['response_code'] == 0) {
          // _settingModalBottomSheet(response['response_message']);
          CommonFunction.settingModalBottomSheet(
              response['response_message'], context);
        } else if (response['response_code'] == 1) {
          dynamic userId = response['results'][0]['userId'];
          dynamic token = response['results'][0]['token'];
          ApiConstants.token = token;

          print(userId);
          print(token);

          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('userId', userId);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConfirmForgotMpin(),
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

  void clearFields() {
    emailController.clear();
    passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
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
                      height: 40,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        Strings.bank_name,
                        style: TextStyle(
                          fontSize: 20.0,
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CommonTextFormField(
                            obscureText: false,
                            keyboardType: TextInputType.text,
                            hintText: Strings.employee_id,
                            prefixIcon: "assets/images/users.png",
                            controller: emailController),
                        const SizedBox(
                          height: 20.0,
                        ),
                        CommonTextFormField(
                            obscureText: true,
                            keyboardType: TextInputType.text,
                            hintText: Strings.password,
                            prefixIcon: "assets/images/mpin.png",
                            controller: passwordController),
                        const SizedBox(
                          height: 40,
                        ),
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: RoundedCornerButton(
                            text: Strings.submit,
                            onPressed: () => registerUser(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
