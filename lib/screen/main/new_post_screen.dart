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
import 'package:matching_app/controller/auth_controllers.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:matching_app/screen/main/board_function.dart';

class NewPostScreen extends ConsumerStatefulWidget {
  const NewPostScreen({super.key});

  @override
  ConsumerState<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends ConsumerState<NewPostScreen> {
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
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileHeader(
                        title: "作成画面",
                        text: "投稿",
                        isDisabled: text.isEmpty,
                        onPressed: () {
                          if (text.isNotEmpty) {
                              final now = DateTime.now();
                              final selectedDates = selectedItems.map((item) {
                                final dateParts = item['date'].split('/');
                                final month = int.parse(dateParts[0]);
                                final day = int.parse(dateParts[1]);

                                final dateTime = DateTime(now.year, month, day);
                                return DateFormat('yyyy-MM-dd').format(dateTime);
                              }).toList();

                              if (selectedDates.isNotEmpty) {
                                final random = Random();
                                final randomIndex = random.nextInt(selectedDates.length);

                                selectedDates.clear();
                                selectedDates.add(selectedItems[randomIndex]['date']);
                              }
                            String arrayValue = selectedDates.toString();
                            int currentYear = now.year;

                            // Remove square brackets from the arrayValue
                            String formattedArrayValue = arrayValue.replaceAll('[', '').replaceAll(']', '');

                            String dateString = '$currentYear-$formattedArrayValue';
                            DateFormat inputFormat = DateFormat('yyyy-M/d');
                            DateFormat outputFormat = DateFormat('yyyy-MM-dd');

                            DateTime parsedDate = inputFormat.parse(dateString);
                            String formattedDate = outputFormat.format(parsedDate);

                            final controller = ref.read(AuthProvider.notifier);
                              controller.addBoardData(formattedDate.toString(), text).then(
                                (value) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => BoardFunction()),);
                                },
                            );
                            // BlocProvider.of<AppCubit>(context).fetchProfileInfo();

                            Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => BoardFunction()),);
                          } else {
                            showOkAlertDialog(context, "ちょっとでも\n文章を入力してみよう");
                          }
                        }),
                    // DateSelectNoShadow(),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: vhh(context, 2), horizontal: vww(context, 6)),
                      child: Container(
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 3,
                                blurRadius: 8,
                                offset: const Offset(0, 6))
                          ], borderRadius: BorderRadius.circular(10)),
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(bottom: 10),
                                        child: Text(
                                          "日付",
                                          style: TextStyle(
                                              fontSize: 12, color: PRIMARY_FONT_COLOR),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: dateList.map((e) {
                                        return Container(
                                          width: 40,
                                          height: 40,
                                          alignment: Alignment.center,
                                          child: TextButton(
                                            style: ButtonStyle(
                                              backgroundColor: MaterialStateProperty.all(
                                                e["isSelected"] ? BUTTON_MAIN : const Color.fromARGB(255, 248, 248, 249),
                                              ),
                                              padding: MaterialStateProperty.all(EdgeInsets.zero),
                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(50),
                                                ),
                                              ),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                if (!e["isSelected"]) {
                                                  // Deselect all dates
                                                  dateList.forEach((date) {
                                                    date["isSelected"] = false;
                                                  });

                                                  // Select the current date
                                                  e["isSelected"] = true;
                                                } else {
                                                  // Deselect the current date
                                                  e["isSelected"] = false;
                                                }

                                                selectedItems.clear(); // Clear the selectedItems list

                                                // Add the selected item to the selectedItems list
                                                if (e["isSelected"]) {
                                                  selectedItems.add(e);
                                                }
                                              });
                                            },
                                            child: Text(
                                              e["date"],
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: e["isSelected"] ? Colors.white : const Color.fromARGB(255, 134, 142, 157),
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    )

                                      // Row(
                                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      //     children: dateList.map((e) {
                                      //       return Container(
                                      //         width: 40,
                                      //         height: 40,
                                      //         alignment: Alignment.center,
                                      //         child: TextButton(
                                      //           style: ButtonStyle(
                                      //             backgroundColor: MaterialStateProperty.all(
                                      //               e["isSelected"]
                                      //                   ? BUTTON_MAIN
                                      //                   : const Color.fromARGB(255, 248, 248, 249),
                                      //             ),
                                      //             padding: MaterialStateProperty.all(EdgeInsets.zero),
                                      //             shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      //               RoundedRectangleBorder(
                                      //                 borderRadius: BorderRadius.circular(50),
                                      //               ),
                                      //             ),
                                      //           ),
                                      //           onPressed: () {
                                      //             setState(() {
                                      //               e["isSelected"] = !e["isSelected"];
                                                    
                                      //               if (e["isSelected"]) {
                                      //                 selectedItems.add(e); // Add the item to the selectedItems list
                                      //               } else {
                                      //                 selectedItems.removeWhere((item) => item["date"] == e["date"]); // Remove the item from the selectedItems list
                                      //               }
                                      //             });
                                      //           },
                                      //           child: Text(
                                      //             e["date"],
                                      //             style: TextStyle(
                                      //               fontSize: 12,
                                      //               color: e["isSelected"]
                                      //                   ? Colors.white
                                      //                   : const Color.fromARGB(255, 134, 142, 157),
                                      //             ),
                                      //           ),
                                      //         ),
                                      //       );
                                      //     }).toList())
                                    ],
                                  )
                                )
                              )
                            )
                        ),
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Color.fromARGB(255, 112, 112, 112),
                            width: 0.5,
                          ),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: vww(context, 3),
                          vertical: vhh(context, 1)),
                      child: TextField(
                          minLines: 3,
                          maxLines: 10,
                          style: const TextStyle(
                              fontSize: 16, color: PRIMARY_FONT_COLOR),
                          cursorColor: BUTTON_MAIN,
                          autofocus: true,
                          onChanged: (value) {
                            setState(() {
                              text = value;
                            });
                            print(text);
                          },
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
