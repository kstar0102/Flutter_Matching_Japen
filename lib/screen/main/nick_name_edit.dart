import 'package:flutter/material.dart';
import 'package:matching_app/components/check_input.dart';
import 'package:matching_app/utile/index.dart';
// import 'package:flutter_redux/flutter_redux.dart';
import 'package:matching_app/common.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matching_app/controller/auth_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matching_app/controller/profile_controller.dart';
import 'package:matching_app/bloc/cubit.dart';

class NickNameEdit extends ConsumerStatefulWidget {
  const NickNameEdit({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  ConsumerState<NickNameEdit> createState() => _NickNameEditState();
}

class _NickNameEditState extends ConsumerState<NickNameEdit> {
  String nick_name = '';
  String _uID = "";
  @override
  void initState() {
    super.initState();
    getNickData();
  }
  getNickData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey("UserId")) {
      _uID = prefs.getString("UserId")!;
    } else {
      print("========== UserId key not found");
    }
    ref.read(homeAccountCtrProvider.notifier).doGetIntro(_uID);
  }
  @override
  Widget build(BuildContext context) {
    AppCubit appCubit = AppCubit.get(context);

    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
            constraints: BoxConstraints(
              minHeight: vh(context, 90), // Set the minimum height here
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: getDeviceWidth(context) / 47 * 1,
                      right: getDeviceWidth(context) / 47 * 1),
                  child: SizedBox(
        width: vw(context, 100),
        height: vh(context, 13),
        child: Column(children: [
          Expanded(child: Container()),
          Row(
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero, iconColor: PRIMARY_FONT_COLOR),
                child: const Icon(
                  Icons.arrow_back_ios,
                  size: 28,
                ),
              ),
              Expanded(child: Container()),
              Text("ニックネーム変更",
                  style:
                      const TextStyle(color: PRIMARY_FONT_COLOR, fontSize: 17)),
                      Expanded(child: Container()),
                      Container(
                        decoration: BoxDecoration(
                            color: BUTTON_MAIN,
                            borderRadius: BorderRadius.circular(50)),
                        width: 70,
                        height: 35,
                        child: TextButton(
                          onPressed: () {
                            if(nick_name.isEmpty){
                              showOkAlertDialog(context, "情報を入力してください。");
                              return;
                            }
                            appCubit.changeNick(nick_name);
                            final controller =
                                ref.read(AuthProvider.notifier);
                            controller
                                .doNickname(_uID,nick_name)
                                .then(
                              (value) {
                                // go home only if login success.
                                if (value == true) {
                                    Navigator.pop(context);
                                } else {}
                              },
                            );
                          }, child: const Text("保存", style: TextStyle(fontSize: 12, color: Colors.white),)
                        ),
                      )
                    ],
                  ),
                ])),
                ),
                Padding(
                    padding: EdgeInsets.only(
                      top: vhh(context, 22),
                        left: getDeviceWidth(context) / 47 * 3,
                        right: getDeviceWidth(context) / 47 * 3),
                    child: CheckInput(
                      onChanged: (value) {
                        setState(() {
                          nick_name = value;
                        });
                      },
                      isEnabled: true,
                      isChecked: nick_name.isNotEmpty,
                      text: nick_name,
                    )),
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
              ],
            )));
  }

    Future<void> showOkAlertDialog(BuildContext context, String title) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.zero,
          actionsPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          shape: roundedRectangleBorder,
          title: Container(
              padding: const EdgeInsets.symmetric(vertical: 30),
              width: double.infinity,
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Color.fromARGB(255, 112, 112, 112),
                          width: 1))),
              child: Text(title,
                  style:
                      const TextStyle(fontSize: 18, color: PRIMARY_FONT_COLOR),
                  textAlign: TextAlign.center)),
          actions: <Widget>[
            Container(
              width: double.infinity,
              child: TextButton(
                child: const Text(
                  'OK',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            )
          ],
        );
      },
    );
  }
}
