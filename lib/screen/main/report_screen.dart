// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:matching_app/common.dart';
import 'package:matching_app/components/Header.dart';
import 'package:matching_app/components/radius_button.dart';
import 'package:matching_app/screen/main/report_success.dart';
import 'package:matching_app/utile/index.dart';

// ignore: use_key_in_widget_constructors
class ReportScreen extends StatefulWidget {
  final String user_name;
  final String user_id;
  final String avatar;
  final String receiver_id;
  final String address;
  final String age;

  const ReportScreen({super.key, required this.user_name, required this.avatar, required this.user_id,  required this.receiver_id,  required this.address,  required this.age});

  @override
  // ignore: library_private_types_in_public_api
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const HeaderWidget(title: "違反報告"),
            Padding(
                padding: EdgeInsets.only(top: vhh(context, 8)),
                child: const Text("下記のユーザーを違反報告しますか？",
                    style: TextStyle(fontSize: 14, color: PRIMARY_FONT_COLOR))),
            Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image(
                      image: NetworkImage("http://greeme.net/uploads/"+ widget.avatar),
                      height: 80,
                      width: 80,
                    ))),
            Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text("${widget.user_name}",
                    style: TextStyle(fontSize: 16, color: PRIMARY_FONT_COLOR))),
            Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text("${widget.address + " "+ widget.age +"歳"}",
                    style: TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(255, 151, 157, 170)))),
            Padding(
                padding: EdgeInsets.only(top: vhh(context, 8)),
                child: const Text("報告後に運営サポートにより\nユーザー調査を行います",
                    style: TextStyle(fontSize: 14, color: PRIMARY_FONT_COLOR))),
            Expanded(child: Container()),
            Padding(
                padding: EdgeInsets.only(left: vww(context, 5), right: vww(context, 5), bottom: vhh(context, 10)),
                child: RadiusButton(
                    isDisabled: false,
                    text: "通報する",
                    color: BUTTON_MAIN,
                    goNavigation: (id) {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => ReportSuccess(
                            receiver_id: widget.receiver_id,
                        ),
                      ));
                      // Navigator.pushNamed(context, "/report_success");
                    },
                    id: 0)),
          ],
        ));
  }
}
