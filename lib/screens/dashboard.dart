
import 'package:flutter/material.dart';
import 'package:flutter_soft_token/common_widgets/rounded_button.dart';
import 'package:flutter_soft_token/screens/login_page.dart';
import 'package:flutter_soft_token/res/strings.dart';
import 'package:flutter_soft_token/utils/common_function.dart';
import 'package:flutter_soft_token/utils/sharedpreference.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../dio/dio_client.dart';
import '../utils/progressbar.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _MyVerifyState();
}

class _MyVerifyState extends State<Dashboard> {
  final DioClient _apiClient = DioClient();
  TextEditingController controller = new TextEditingController(text: 'N/A');
  bool tappedYes = false;
  bool loading = false;

  @override
  void dispose() {
    // other dispose methods
    controller.dispose();
    super.dispose();
  }

  Future<void> getloginotp() async {
    if (await CommonFunction.checkNetwork()) {
      setState(() => loading = true);
      // CommonFunction.showLoadingDialog(context);
      dynamic response = await _apiClient
          .getloginotp(UtilSharedPreferences.getUserID().toString());
      setState(() => loading = false);
      // Navigator.pop(context);
      String data = response.toString();
      print(data);
      if (response['response_code'] == 0) {
        // _settingModalBottomSheet(response['response_message']);
        CommonFunction.settingModalBottomSheet(
            response['response_message'], context);
      } else if (response['response_code'] == 1) {
        setState(() {
          controller.text = response['response_message'];
        });
      }
    } else {
      Fluttertoast.showToast(
        msg: Strings.please_connect_to_internet,
        backgroundColor: Colors.white,
      );
    }
  }

  Future<dynamic> openLogoutDialoge() async {
    final action = await CommonFunction.yesCancelDialog(
        context, 'Do you wish to logout?', '');
    if (action == DialogsAction.yes) {
      setState(() {
        tappedYes = true;
        callLogoutApi();
      });
    } else {
      tappedYes = false;
    }
  }

  Future<dynamic> callLogoutApi() async {
    if (await CommonFunction.checkNetwork()) {
      setState(() => loading = true);
      // CommonFunction.showLoadingDialog(context);
      dynamic response = await _apiClient.logout();
      print(response.toString());
      setState(() => loading = false);
      // Navigator.pop(context);
      if (response['action'] == 'logout') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Login(),
          ),
        );
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
    return loading
        ? Loading()
        : WillPopScope(
            onWillPop: () async {
              openLogoutDialoge();
              return false;
            },
            child: MaterialApp(
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(width: 2),
                            shape: BoxShape.circle,
                            // You can use like this way or like the below line
                            //borderRadius: new BorderRadius.circular(30.0),
                            color: Colors.green,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  textAlign: TextAlign.center,
                                  controller: controller,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: RoundedCornerButton(
                            text: Strings.get_otp,
                            onPressed: () => getloginotp(),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: RoundedCornerButton(
                            text: Strings.logout,
                            onPressed: () => openLogoutDialoge(),
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
