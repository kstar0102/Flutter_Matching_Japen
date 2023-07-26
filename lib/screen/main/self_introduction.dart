import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:matching_app/common.dart';
import 'package:matching_app/screen/main/layouts/profile_header.dart';
import 'package:matching_app/utile/index.dart';
import 'package:matching_app/screen/main/profile_screen.dart';
import 'package:matching_app/controller/auth_controllers.dart';
import 'package:matching_app/controller/profile_controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matching_app/bloc/cubit.dart';
import 'package:matching_app/controller/profile_repository.dart';

class SelfIntroducion extends ConsumerStatefulWidget {
  const SelfIntroducion({Key? key}) : super(key: key);

  @override
  ConsumerState<SelfIntroducion> createState() => _SelfIntroducion();
}

class _SelfIntroducion extends ConsumerState<SelfIntroducion>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  String self_introduction = "";
  String _uID = "";
  TextEditingController textFieldController = TextEditingController();
  String get intro_text => textFieldController.text;

  final RoundedRectangleBorder roundedRectangleBorder = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
  );
  @override
  void initState() {
    super.initState();
    getIntroData();
  }
  
  void reloadData() async {
    BlocProvider.of<AppCubit>(context).fetchProfileInfo();
    Navigator.pushNamed(context, '/profile_screen');
  }

  getIntroData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey("UserId")) {
      _uID = prefs.getString("UserId")!;
    } else {
      print("========== UserId key not found");
    }
    ref.read(homeAccountCtrProvider.notifier).doGetIntro(_uID);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final introData = ref.watch(profileStateChangesProvider).value;
    
    if (introData != null) {
      self_introduction = introData.introduce;
    }
    textFieldController = TextEditingController(text: self_introduction);
    AppCubit appCubit = AppCubit.get(context);

    return Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Color.fromARGB(255, 112, 112, 112),
                                width: 1)),
                      ),
                      child: ProfileHeader(
                          title: "自己紹介入力",
                          text: "",
                          onPressed: () {
                            if (intro_text.isNotEmpty) {
                              // print("object");
                              // BlocProvider.of<AppCubit>(context)
                              //     .fetchProfileInfo();
                              // final controller =
                              //     ref.read(AuthProvider.notifier);
                              // controller
                              //     .doIntroduce(_uID, intro_text)
                              //     .then(
                              //   (value) {
                              //     // go home only if login success.
                              //     if (value == true) {
                              //       reloadData();
                                    
                              //     } else {}
                              //   },
                              // );
                              appCubit.postIntroduce(intro_text);
                              Navigator.pushNamed(context, '/profile_screen');

                            } else {
                              // showOkAlertDialog(context, "ちょっとでも\n文章を入力してみよう");
                            }
                          }),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: vww(context, 3),
                          vertical: vhh(context, 1)),
                      child: TextField(
                          controller: textFieldController,
                          minLines: 3,
                          maxLines: 10,
                          style: const TextStyle(
                              fontSize: 16, color: PRIMARY_FONT_COLOR),
                          cursorColor: BUTTON_MAIN,
                          autofocus: true,
                          // onChanged: (value) {
                          //   setState(() {
                          //     self_introduction = textFieldController;
                          //   });
                          // },
                          decoration: InputDecoration(
                              hintText: "簡単な挨拶や趣味、休日の過ごし方、お相手の希望などを書いてみましょう。",
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10)))),
                    )
                  ]);
            }, childCount: 1)),
          ],
        ));
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
