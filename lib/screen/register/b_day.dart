// ignore: depend_on_referenced_packages
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matching_app/bloc/cubit.dart';
import 'package:matching_app/common.dart';
import 'package:matching_app/components/check_input.dart';
import 'package:matching_app/components/radius_button.dart';
import 'package:matching_app/components/Header.dart';
import 'package:matching_app/utile/index.dart';

// import 'package:flutter_redux/flutter_redux.dart';
// ignore: use_key_in_widget_constructors
class BDay extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _BDayState createState() => _BDayState();
}

class _BDayState extends State<BDay> {
  // ignore: non_constant_identifier_names
  DateTime? _selectedDate;
  int currentYear = DateTime.now().year;
  void _selectDate(BuildContext context) {
    _selectedDate = _selectedDate ?? DateTime.now();

    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        AppCubit appCubit = AppCubit.get(context);
        return BlocBuilder<AppCubit, AppState>(builder: (context, state) {
          return Container(
            height: 260,
            color: const Color.fromARGB(255, 240, 240, 241),
            child: Column(
              children: [
                Expanded(
                  child: Container(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CupertinoButton(
                      child: const Text('消去'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    CupertinoButton(
                      child: const Text('完了'),
                      onPressed: () {
                        Navigator.of(context).pop(_selectedDate);
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 200.0,
                  child: CupertinoDatePicker(
                    // backgroundColor: Color.fromARGB(255, 209, 212, 217),
                    backgroundColor: const Color.fromARGB(255, 240, 240, 241),
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: _selectedDate,
                    minimumDate: DateTime(1900),
                    maximumDate: DateTime(2030),
                    onDateTimeChanged: (DateTime newDateTime) {
                      _selectedDate = newDateTime;
                      appCubit.changeBDay(
                          '${newDateTime.year}/${newDateTime.month}/${newDateTime.day}');
                    },
                  ),
                )
              ],
            ),
          );
        });
      },
    );
  }

  // Future<void> DialogModal() async {
  //   Widget continueButton = TextButton(
  //     child: Text(
  //       "OK",
  //       textAlign: TextAlign.center,
  //     ),
  //     onPressed: () {
  //       Navigator.pop(context);
  //     },
  //   );
  //   // set up the AlertDialog
  //   AlertDialog alert = AlertDialog(
  //     content: Text(
  //       "18歳未満の方は\n登録できません",
  //       textAlign: TextAlign.center,
  //     ),
  //     actions: [
  //       Center(child: continueButton),
  //     ],
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(
  //           10.0), // Adjust the radius as per your requirement
  //     ),
  //   );

  //   // show the dialog
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }

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

  @override
  Widget build(BuildContext context) {
    AppCubit appCubit = AppCubit.get(context);
    return BlocBuilder<AppCubit, AppState>(builder: (context, state) {
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
                    child: const HeaderWidget(title: "プロフィール登録"),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          top: vh(context, 3),
                          left: getDeviceWidth(context) / 47 * 3,
                          right: getDeviceWidth(context) / 47 * 3),
                      child: const Text("生年月日を教えてください",
                          style: TextStyle(
                              fontSize: 24, color: PRIMARY_FONT_COLOR))),
                  Padding(
                    padding: EdgeInsets.only(
                        top: vh(context, 1),
                        left: getDeviceWidth(context) / 47 * 3,
                        right: getDeviceWidth(context) / 47 * 3),
                    child: const Text(
                      "後から変更することはできません\n本人確認の際に照合するため、正しく入力してください",
                      style: TextStyle(fontSize: 12, color: PRIMARY_FONT_COLOR),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          top: vh(context, 4),
                          left: getDeviceWidth(context) / 47 * 3,
                          right: getDeviceWidth(context) / 47 * 3),
                      child: InkWell(
                          onTap: () {
                            _selectDate(context);
                          },
                          child: CheckInput(
                            isEnabled: false,
                            onChanged: (String value) {
                              appCubit.changeBDay(value);
                            },
                            isChecked: appCubit.bDay.isNotEmpty,
                            text: appCubit.bDay,
                          ))),
                  Expanded(
                    child: Container(),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: getDeviceWidth(context) / 47 * 3),
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
                                String yearString = appCubit.bDay.split('/')[0];
                                int year = int.parse(yearString);
                                if (year >= currentYear) {
                                  showOkAlertDialog(
                                      context, "18歳未満の方は\n登録できません");
                                } else if ((currentYear - year) >= 18) {
                                  Navigator.pushNamed(
                                      context, "/address_check");
                                } else {
                                  showOkAlertDialog(
                                      context, "18歳未満の方は\n登録できません");
                                }
                              },
                              isDisabled: appCubit.bDay.isEmpty,
                            ),
                          ))),
                  Expanded(
                    child: Container(),
                  )
                ],
              )));
    });
  }
}
