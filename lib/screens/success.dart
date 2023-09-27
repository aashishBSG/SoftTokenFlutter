import 'package:flutter/material.dart';
import 'package:flutter_soft_token/screens/login_page.dart';
import 'package:lottie/lottie.dart';

import '../res/strings.dart';

class Success extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
                child: Text(
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
                image: AssetImage('assets/images/bg.png'), fit: BoxFit.fill),
          ),
          // margin: const EdgeInsets.only(left: 25, right: 25),

          child: Align(
            alignment: Alignment.bottomCenter,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        height: 350,
                      ),
                      Lottie.asset('assets/raw/done.json'),
                      SizedBox(
                        height: 150,
                      ),
                      Text(
                        'Success',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Lato',
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Login(),
                              ),
                            );
                          },
                          child: Text(
                            Strings.ok,
                            style: TextStyle(color: Colors.black, fontFamily: 'Lato',),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
