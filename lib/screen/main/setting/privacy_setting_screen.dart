import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:matching_app/common.dart';
import 'package:matching_app/screen/main/layouts/setting_header.dart';
import 'package:matching_app/utile/index.dart';

import '../../../bloc/cubit.dart';

// ignore: use_key_in_widget_constructors
class PrivacySettingScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _PrivacySettingScreenState createState() => _PrivacySettingScreenState();
}

class _PrivacySettingScreenState extends State<PrivacySettingScreen>
    with SingleTickerProviderStateMixin {
      final List _title = ["年齢認証していない人", "マッチしていない人"];


  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    AppCubit appCubit = AppCubit.get(context);
    final List _value = [appCubit.user.private_age =="1"?true:false,appCubit.user.private_matching=="1"?true:false];
    return BlocBuilder<AppCubit, AppState>(builder: (context, state) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverPersistentHeader(
                delegate: SettingHeader("プライバシー設定"), pinned: true),
            SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
              return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: vww(context, vww(context, 1))),
                  child: Column(
                    children: [
                      TextButton(
                        style: ButtonStyle(
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                                  EdgeInsets.zero),
                        ),
                        onPressed: null,
                        child: Container(
                          padding:const EdgeInsets.symmetric(vertical: 15),
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1,
                                      color:
                                          Color.fromARGB(255, 237, 237, 237)))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_title[index],
                                  style: const TextStyle(
                                      color: PRIMARY_FONT_COLOR)),
                                  appCubit.user.identityState == "承認"?
                                  Switch(
                                    value: _value[index],
                                    activeColor: Colors.green,
                                    onChanged: (value) {
                                      setState(() {
                                        _value[index] = value;
                                        int isVal = 0;
                                        if(_value[index] == true)
                                        {
                                          isVal = 1;
                                        }
                                        appCubit.changePrivate(index.toString(), isVal.toString());
                                        
                                      });
                                    }
                                  ):
                                  Switch(
                                    value: _value[index],
                                    activeColor: Colors.green,
                                    onChanged: (value) {
                                      Fluttertoast.showToast(
                                        msg: "この機能は利用できません。",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                      );
                                    }
                                  )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ));
            }, childCount: 2)),
          ],
        ));
    });
  }
}
