import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_soft_token/utils/sharedpreference.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import '../res/strings.dart';

enum DialogsAction { yes, cancel }

class CommonFunction {
  late BuildContext context;

  CommonFunction(this.context);

  static versioncode(String versioncode) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    versioncode = packageInfo.version;
  }

  static Future<bool> checkNetwork() async {
    bool isConnected = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isConnected = true;
      }
    } on SocketException catch (_) {
      isConnected = false;
      return false;
    }
    return isConnected;
  }

  static void settingModalBottomSheet(String data, BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                children: <Widget>[
                  const Text(
                    Strings.bank_name_long,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    data,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            Strings.ok,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  static Future<DialogsAction> yesCancelDialog(
    BuildContext context,
    String title,
    String body,
  ) async {
    final action = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Text(title),
          content: Text(body),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(DialogsAction.cancel),
              child: const Text(
                'No',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            // Spacer(
            //   flex: 10,
            // ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(DialogsAction.yes),
              child: const Text(
                'Yes',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
              ),
            )
          ],
        );
      },
    );
    return (action != null) ? action : DialogsAction.cancel;
  }

  static Future<void> showLoadingDialog(
    BuildContext context,
  ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: const SimpleDialog(
            backgroundColor: Colors.white,
            children: <Widget>[
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Please Wait....",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<void> requestPermissions() async {
    // await UtilSharedPreferences.setVersionCode(_packageInfo.buildNumber);
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
    } else if (permissionStatuses[Permission.locationWhenInUse]!.isDenied ||
        permissionStatuses[Permission.locationWhenInUse]!.isPermanentlyDenied) {
      Fluttertoast.showToast(
        msg: 'Please Allow All Permissions',
        backgroundColor: Colors.white,
      );
    }
  }

}
