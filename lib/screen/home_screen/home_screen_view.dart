import 'dart:async';

import 'package:flutter/material.dart';
import 'package:matching_app/components/background_widget.dart';
import 'package:matching_app/components/radius_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';

class HomeScreenView extends ConsumerStatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  ConsumerState<HomeScreenView> createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends ConsumerState<HomeScreenView> {
// ignore: use_key_in_widget_constructors
// class HomeScreenView extends StatelessWidget {
  String? user_id = "";
  
  @override
  void initState() {
    super.initState();
    GetData();
  }

  Future<void> GetData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id = prefs.getString('UserId');
    print("OUTPUT:"+ user_id.toString());
    if (user_id!= "0" || user_id!=null) {
      Timer(const Duration(microseconds: 1),
          () => Navigator.pushNamed(context, "/profile_screen"));
    } 
  }

  Future<void> _lineLogin(BuildContext context) async {
    try {
      final result = await LineSDK.instance.login(scopes: ['profile']);
      print(
          "result" + result.toString() + " :" + result.userProfile.toString());
    } catch (e) {
      print("error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    void goNavigation(int id) {
      switch (id) {
        case 0:
          break;
        case 1:
          _lineLogin(context);
          break;
        case 2:
          Navigator.pushNamed(context, "/phone_login");
          break;
        case 3:
          break;
      }
    }

    // ignore: unused_local_variable
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(children: [
          const Positioned.fill(
              child: BackgroundWidget(src: "assets/images/mainbg.png")),
          const Positioned.fill(
              child: BackgroundWidget(src: "assets/images/bg-white.png")),
          // const Center(
          //     child: Padding(
          //   padding: EdgeInsets.only(bottom: 100),
          //   child: Image(image: AssetImage("assets/images/match-text.png")),
          // )),
          const Center(
            child: Padding(
            padding: EdgeInsets.only(bottom: 130),
              child: Text(
            "Greeme",
            style: TextStyle(
                fontSize: 70,  color: Color.fromARGB(255, 129, 238, 211),

            ),),
                          
          )),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                    padding:
                        const EdgeInsets.only(bottom: 15, left: 30, right: 30),
                    child: RadiusButton(
                        text: "Appleでサインイン",
                        color: const Color.fromARGB(255, 0, 0, 0),
                        goNavigation: goNavigation,
                        id: 0,
                        isDisabled: false)),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 15, left: 30, right: 30),
                  child: RadiusButton(
                      text: "LINEでログイン",
                      color: const Color.fromARGB(255, 2, 158, 0),
                      goNavigation: goNavigation,
                      id: 1,
                      isDisabled: false),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 5, left: 30, right: 30),
                  child: RadiusButton(
                      text: "電話番号でサインイン",
                      color: const Color.fromARGB(255, 66, 165, 245),
                      goNavigation: goNavigation,
                      id: 2,
                      isDisabled: false),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 10, left: 30, right: 30),
                  child: RadiusButton(
                      text: "お問い合わせ",
                      color: const Color.fromARGB(0, 0, 0, 0),
                      goNavigation: goNavigation,
                      id: 3,
                      isDisabled: false),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
