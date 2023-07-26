import 'package:flutter/material.dart';
import 'package:matching_app/common.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matching_app/components/radius_button.dart';
import 'package:matching_app/screen/login/layouts/header.dart';
import 'package:matching_app/utile/index.dart';
// import 'package:flutter_redux/flutter_redux.dart';
import 'package:matching_app/controller/auth_controllers.dart';

// ignore: use_key_in_widget_constructors
class LoginView extends ConsumerStatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  String phone_number = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Stack(children: [
            Container(
                constraints:
                    BoxConstraints(minHeight: getDeviceHeight(context) - 100),
                child: Column(children: [
                  const HeaderWidget(
                    title1: "電話番号を入力",
                    title2: "入力した電話番号に６桁の認証番号が届きます。",
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20),
                    child: TextField(
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 27),
                      // , letterSpacing: 5
                      maxLength: 11,
                      buildCounter: null,
                      onChanged: (value) {
                        setState(() {
                          phone_number = value;
                        });
                      },
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: PRIMARY_GREY,
                        contentPadding:
                            const EdgeInsets.only(top: 15, bottom: 15),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: Container(),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                          height: 100,
                          width: MediaQuery.of(context).size.width,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: RadiusButton(
                              id: 0,
                              color: BUTTON_MAIN,
                              text: "つぎへ",
                              goNavigation: (id) {
                                // print("object");
                                // final controller =
                                //     ref.read(AuthProvider.notifier);
                                // controller
                                //     .doPhoneVaild(phone_number)
                                //     .then(
                                //   (value) {
                                //     // go home only if login success.
                                //     if (value == true) {
                                //       // reloadData();
                                      
                                //     } else {}
                                //   },
                                // );
                                Navigator.pushNamed(context, "/check_code");
                                print(phone_number);
                              },
                              isDisabled: phone_number.length < 11,
                            ),
                          ))),
                  Expanded(
                    child: Container(),
                  )
                ]))
          ]),
        ));
  }
}