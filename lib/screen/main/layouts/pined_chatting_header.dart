import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matching_app/common.dart';
import 'package:matching_app/utile/index.dart';

import '../chat_screen.dart';

// ignore: unused_element
class PinedChattingHeader extends StatelessWidget {
  final String user_name;
  final String user_id;
  final String avatar;
  final String tab_v;
  const PinedChattingHeader({super.key, required this.user_name, required this.avatar, required this.user_id, required this.tab_v});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      child: Padding(
          padding: EdgeInsets.only(top: vhh(context, 6)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  TextButton(
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      onPressed: () {
                        if(tab_v == "0"){
                          // Navigator.push(
                          //   context, 
                          //   MaterialPageRoute(
                          //     builder: (context) => ChatScreen(),
                          // ));
                          Navigator.pop(context);
                        }
                        else{
                          // Navigator.push(
                          //   context, 
                          //   MaterialPageRoute(
                          //     builder: (context) => ChatScreen(),
                          // ));
                          Navigator.pop(context);
                        }                      
                      },
                      child: const Icon(Icons.keyboard_arrow_left,
                          color: PRIMARY_FONT_COLOR, size: 35)),
                  ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image(
                        image: NetworkImage("http://192.168.144.61:8000/uploads/" + avatar),
                        height: 60,
                      )),
                  Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text("${user_name}", style: TextStyle(fontSize: 17)))
                ],
              ),
              TextButton(
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  onPressed: () {
                    showAdaptiveActionSheet(
                      context: context,
                      androidBorderRadius: 30,
                      actions: <BottomSheetAction>[
                        BottomSheetAction(
                            title: const Text('違反報告する',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 54, 137, 232))),
                            onPressed: (context) {Navigator.pushNamed(context, "/report_screen");}),
                        BottomSheetAction(
                            title: const Text('ブロックする',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 70, 70))),
                            onPressed: (context) {
                              Navigator.pop(context);
                              showDialog(
                                  context: context,
                                  builder: (context) => CupertinoAlertDialog(
                                        content: const Text(
                                            'ブロックをしても\nよろしいですか？', style: TextStyle(fontSize: 16)),
                                        actions: <Widget>[
                                          TextButton(
                                              onPressed: () {
                                              Navigator.pop(
                                                  context);
                                              },
                                              child: const Text('キャンセル', style: TextStyle(fontSize: 15))),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pushNamed(context, "/chat_screen");
                                            },
                                            child: const Text('OK', style: TextStyle(fontSize: 15)),
                                          )
                                        ],
                                      ));
                            }),
                      ],
                      cancelAction: CancelAction(
                          title: const Text('キャンセル',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 54, 137, 232)))),
                    );
                  },
                  child: const Icon(
                    Icons.more_horiz,
                    color: BUTTON_MAIN,
                    size: 35,
                  ))
            ],
          )),
    );
  }
}
