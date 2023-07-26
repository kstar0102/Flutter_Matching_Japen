import 'dart:math';
import 'dart:core';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:matching_app/common.dart';
import 'package:matching_app/utile/index.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matching_app/controller/board_controller.dart';

// ignore: use_key_in_widget_constructors
class DateSelectWidget extends ConsumerStatefulWidget {

  const DateSelectWidget({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DateSelectWidgetState createState() => _DateSelectWidgetState();
}
// ignore: must_be_immutable
class _DateSelectWidgetState extends ConsumerState<DateSelectWidget> {
  DateTime? now;
  int? currentYear;
  int? month;
  List<Map<String, dynamic>> dateList = [];
  List<dynamic> selectedItems = [];
  @override
  void initState() {
    super.initState();
    initializeDateList();
  }

  void initializeDateList() {
    final now = DateTime.now() ;
    currentYear = now.year;
    month = now.month;

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
    return Padding(
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
                                      e["isSelected"]
                                          ? BUTTON_MAIN
                                          : const Color.fromARGB(255, 248, 248, 249),
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
                                      e["isSelected"] = !e["isSelected"];
                                      
                                      if (e["isSelected"]) {
                                        selectedItems.add(e); // Add the item to the selectedItems list
                                      } else {
                                        selectedItems.removeWhere((item) => item["date"] == e["date"]); // Remove the item from the selectedItems list
                                      }
                                    });
                                     final controller = ref.read(boardProvider.notifier);
                                      controller.doFetchNotifs().then(
                                        (value) {
                                          
                                        },
                                      );

                                      print(selectedItems);
                                  },
                                  child: Text(
                                    e["date"],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: e["isSelected"]
                                          ? Colors.white
                                          : const Color.fromARGB(255, 134, 142, 157),
                                    ),
                                  ),
                                ),
                              );
                            }).toList())
                      ],
                    )))));
  }
}
