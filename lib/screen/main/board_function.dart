import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matching_app/common.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matching_app/screen/main/layouts/board_card.dart';
import 'package:matching_app/screen/main/layouts/board_message_modal.dart';
import 'package:matching_app/screen/main/layouts/bottom_nav_bar.dart';
import 'package:matching_app/screen/main/layouts/date_select_widget.dart';
import 'package:matching_app/utile/index.dart';
import 'package:matching_app/controller/board_controller.dart';
import 'package:matching_app/controller/board_repository.dart';
import 'package:matching_app/components/dialogs.dart';
import 'package:matching_app/utile/async_value_ui.dart';
import 'package:matching_app/screen/main/setting/board_list.dart';
import 'dart:core';
import 'package:matching_app/utile/index.dart';
import 'package:intl/intl.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:matching_app/bloc/cubit.dart';
// import 'package:matching_app/screen/main/layouts/unidentified_modal.dart';
import 'package:matching_app/screen/verify_screen/identity_verify.dart';

// ignore: use_key_in_widget_constructors
class BoardFunction extends ConsumerStatefulWidget {

  const BoardFunction({Key? key}) : super(key: key);

  @override
  ConsumerState<BoardFunction> createState() => _BoardFunctionState();
}

class _BoardFunctionState extends ConsumerState<BoardFunction> {
  List<UsersObject> items = [];
  List<BadgeObject> badgeList = [];
  String? board_id = "";
  bool isModalShow = false;
  DateTime? now;
  int? currentYear;
  int? month;
  List<Map<String, dynamic>> dateList = [];
  List<dynamic> selectedItems = [];
  final int _currentIndex = 0;
  bool dialogShown = false;
  @override
  void initState() {
    super.initState();
    ref.read(boardProvider.notifier).doFetchNotifs();
    initializeDateList();
    getData();
  }

  final RoundedRectangleBorder roundedRectangleBorder = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
  );

  void getData() async {
    BlocProvider.of<AppCubit>(context).fetchProfileInfo();
    ref.read(boardProvider.notifier).doFetchNotifs();
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
    
    AppCubit appCubit = AppCubit.get(context);
    BlocProvider.of<AppCubit>(context).fetchProfileInfo();

    if (!dialogShown && appCubit.user.identityState == "ブロック") {
        final AlertDialog dialog = AlertDialog(
          contentPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.zero,
          actionsPadding: EdgeInsets.zero,
          actions: [
            Container(
                padding: const EdgeInsets.only(top: 10, left: 50, right: 50),
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      disabledForegroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      textStyle: const TextStyle(fontSize: 15),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 13),
                      backgroundColor: BUTTON_MAIN),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => IdentityVerify()),
                    );
                  },
                  child: const Text('本人確認する'),
                )),
            Container(
                padding: const EdgeInsets.only(
                    top: 10, bottom: 20, left: 50, right: 50),
                width: double.infinity,
                child: TextButton(
                  style: ElevatedButton.styleFrom(
                      disabledForegroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      textStyle: const TextStyle(fontSize: 15),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 13),
                      backgroundColor: Colors.transparent),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('まだしない',
                      style: TextStyle(color: BUTTON_MAIN)),
                ))
          ],
          shape: roundedRectangleBorder,
          content: Container(
              padding: const EdgeInsets.only(
                  top: 20),
              height: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    "安心安全のため\n本人確認をしてください",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: PRIMARY_FONT_COLOR,
                        fontSize: 18,
                        letterSpacing: -2),
                  ),
                  Image(
                      width: vww(context, 40),
                      image: const AssetImage(
                          "assets/images/main/unidentified.png"))
                ],
        )));
      Future.delayed(const Duration(milliseconds: 1000), () {
        showDialog(context: context, builder: (context) => dialog);
      });
       dialogShown = true;
    }
    ref.listen<AsyncValue>(boardProvider.select((state) => state),
        (_, state) => state.showAlertDialogOnError(context));

    final state = ref.watch(boardProvider);
    final boards = state.value;

    return BlocBuilder<AppCubit, AppState>(builder: (context, state) {
     
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
                      Padding(
                          padding: EdgeInsets.only(
                              top: vhh(context, 8),
                              left: vww(context, 5),
                              right: vww(context, 5)),
                          child: const Text("ボード機能",
                              style: TextStyle(fontSize: 21))),
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
                                    )
                                  )
                                )
                              )
                          ),
                          Container(
                            height: 500, 
                            child: RefreshIndicator(
                              onRefresh: () async {
                                getData();
                              },
                            child: boards != null && boards.isNotEmpty
                              ? GroupedListView(
                                  order: GroupedListOrder.DESC,
                                  elements: boards.where((element) {
                                      final now = DateTime.now();
                                      final selectedDates = selectedItems.map((item) {
                                      final dateParts = item['date'].split('/');
                                      final month = int.parse(dateParts[0]);
                                      final day = int.parse(dateParts[1]);
                                      
                                      final dateTime = DateTime(now.year, month, day);
                                      return DateFormat('yyyy-MM-dd').format(dateTime);
                                    }).toList();

                                    if (selectedDates.isEmpty) {
                                      return true; // Show all elements if selectedDates is empty
                                    } else {
                                      return selectedDates.contains(element.created_date);
                                    }
                                  }).toList(),
                                  groupBy: (board) => board.id,
                                  groupSeparatorBuilder: (value) {
                                    return SizedBox();
                                  },
                                  itemBuilder: (context, element) {
                                    return InkWell(
                                      onTap: () {
                                        board_id = element.id.toString();
                                        showModalBottomSheet(
                                          isScrollControlled: true,
                                          context: context,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(25),
                                            ),
                                          ),
                                          builder: (context) {
                                            return BoardMessageModal(info: element);
                                          },
                                        );
                                      },
                                      child: Column(children: [
                                        BoardCard(
                                          info: element,
                                          onPressed: () {},
                                        ),
                                        SizedBox(height: 30,)
                                      ],)
                                    );
                                  },
                                )
                              : Center(
                                  child: Text(
                                    "No Data",
                                  )
                              ),
                        ),
                      ),
                    ]);
              }, childCount: 1)),
            ],
          ),
        
          floatingActionButton: ElevatedButton(
            style: ElevatedButton.styleFrom(
                disabledBackgroundColor: BUTTON_MAIN,
                disabledForegroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                textStyle: const TextStyle(fontSize: 15),
                backgroundColor: BUTTON_MAIN,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 13)),
            onPressed: () {
              Navigator.pushNamed(context, "/new_post_screen");
            },
            child: const Text("投稿する"),
          ),
          bottomNavigationBar: BottomNavBar(currentIndex: _currentIndex));
      }
    );
  }
}
