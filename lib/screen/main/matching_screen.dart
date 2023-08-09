import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matching_app/bloc/cubit.dart';
import 'package:matching_app/common.dart';
import 'package:matching_app/screen/main/layouts/date_select_no_shadow.dart';
import 'package:matching_app/screen/main/layouts/profile_header.dart';
import 'package:matching_app/utile/index.dart';
import 'package:intl/intl.dart';
import 'dart:core';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:matching_app/components/radius_button.dart';

class MatchingScreen extends ConsumerStatefulWidget {
  final String receiverUserPhone;
  final String receiverUserToken;
  final String receiverUserId;
  final String receiverUserAvatar;
  final String receiverUserName;
  final String receiverUserBadgeName;
  final String receiverUserBadgeColor;
  final String senderUserId;
  final String tab_val;
  
  const MatchingScreen({super.key, required this.receiverUserPhone, required this.receiverUserToken, required this.receiverUserId, required this.receiverUserAvatar, required this.receiverUserName, required this.receiverUserBadgeName, required this.receiverUserBadgeColor, required this.senderUserId, required this.tab_val});

  @override
  ConsumerState<MatchingScreen> createState() => _MatchingScreenState();
}

class _MatchingScreenState extends ConsumerState<MatchingScreen> {
  String text = "";
  List<Map<String, dynamic>> dateList = [];
  List<dynamic> selectedItems = [];
  DateTime? now;
  int? currentYear;
  int? month;
  List<UsersObject> items = [];
  final RoundedRectangleBorder roundedRectangleBorder = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
  );

  void initState() {
    super.initState();
    initializeDateList();
  }

  void initializeDateList() {
    final now = DateTime.now() ;
    currentYear = now.year;
    month = now.month;
// shaved pussy 
    for (int i = 5; i >= 0; i--) {
      try {
        // Create a new DateTime object by subtracting 'i' days from 'now'
        DateTime date = now.subtract(Duration(days: i));

        // Format the date as "M/d"
        String formattedDate = DateFormat('M/d').format(date);
        
        // Add the date to the dateList array with isSelected set to false
        dateList.add({"isSelected": false, "date": formattedDate});
      } catch (e) {
        // Invalid date, skip to the next iteration
        continue;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 202, 157),
        body: Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).size.height * 0.15,
              left:  MediaQuery.of(context).size.width * 0.09,
              child: Image.asset(
                "assets/images/Ribbons.png",
                width: MediaQuery.of(context).size.width / 1.2,
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.22,
              left: MediaQuery.of(context).size.width * 0.34,
              child: Container(
                width: 120.0,
                height: 120.0,
                child: CircleAvatar(
                  backgroundImage:
                      NetworkImage('http://192.168.142.55:8000/uploads/' +widget.receiverUserAvatar),
                  radius: 100,
                  backgroundColor: Colors.white,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.33,
              left: MediaQuery.of(context).size.width * 0.12,
              child: Image.asset(
                "assets/images/matching_style.png",
                width: MediaQuery.of(context).size.width / 1.3,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: getDeviceWidth(context) / 47 * 3),
                child: SizedBox(
                height: 400,
                width: MediaQuery.of(context).size.width,
                child: Align(
                  alignment: Alignment.bottomCenter,
                 child: Text(
                      "${widget.receiverUserName}さんとマッチングしました",
                      style: TextStyle(color: Colors.white, fontSize: 17, letterSpacing:5, ),)
                ))),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: getDeviceWidth(context) / 47 * 3),
                child: SizedBox(
                height: 430,
                width: MediaQuery.of(context).size.width,
                child: Align(
                  alignment: Alignment.bottomCenter,
                 child: Text(
                      "早速メッセージしてみましょう",
                      style: TextStyle(color: Colors.white, fontSize: 17, letterSpacing:2, ),)
                ))),
           
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getDeviceWidth(context) / 47 * 3),
              child: SizedBox(
                  height: 650,
                  width: MediaQuery.of(context).size.width,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: const BorderRadius.all(Radius.circular(100)),
                          ),
                          child: SizedBox(
                            width: 350,
                            height: 50,
                            child: Container(
                              width: 400,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  width: 1,
                                  color: Colors.white
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              shape: const StadiumBorder(),
                              foregroundColor: Color.fromARGB(255, 0, 202, 157),
                              textStyle: TextStyle(
                                fontFamily: 'LeyendoDEMO',
                                fontWeight: FontWeight.w600,
                                fontSize: 17,
                              ),
                            ),
                            onPressed:() {
                              BlocProvider.of<AppCubit>(context).addMatching(widget.receiverUserToken);
                              Navigator.pushNamed(context, "/chat_screen");
                            },
                            child: Text("メッセージする"),
                          ),
                        ),
                      ],
                    ),
                  ))),

            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getDeviceWidth(context) / 47 * 3),
              child: SizedBox(
                  height: 720,
                  width: MediaQuery.of(context).size.width,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: const BorderRadius.all(Radius.circular(100)),
                          ),
                          child: SizedBox(
                            width: 350,
                            height: 50,
                            child: Container(
                              width: 400,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 0, 202, 157),
                                border: Border.all(
                                  width: 1,
                                  color: Color.fromARGB(255, 0, 202, 157)
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              shape: const StadiumBorder(),
                              foregroundColor: Color.fromARGB(255, 233, 232, 232),
                              textStyle: TextStyle(
                                fontFamily: 'LeyendoDEMO',
                                fontWeight: FontWeight.w600,
                                fontSize: 17,
                              ),
                            ),
                            onPressed:() {
                              Navigator.pop(context);
                            },
                            child: Text("とじる"),
                          ),
                        ),
                      ],
                    ),
                  ))),
          ],
        ),
      );
  }
}
