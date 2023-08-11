import 'package:flutter/material.dart';
import 'package:matching_app/common.dart';
import 'package:matching_app/components/user_info_items.dart';
import 'package:matching_app/following_user/following_card.dart';
import 'package:matching_app/following_user/following_item.dart';
import 'package:matching_app/screen/main/layouts/bottom_nav_bar.dart';
import 'package:matching_app/utile/index.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matching_app/following_user/following_controller.dart';
import 'package:matching_app/components/dialogs.dart';
import 'package:matching_app/utile/async_value_ui.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:matching_app/bloc/cubit.dart';
class FollowingUser extends ConsumerStatefulWidget {

  @override
  ConsumerState<FollowingUser> createState() => _FollowingUserState();
}

class _FollowingUserState extends ConsumerState<FollowingUser> {
  List<UsersObject> items = [];

  bool isFollowing = true;
  bool isViewShowFive = false;
  String viewShow = "";
  @override
  void initState() {
    super.initState();
    getData();
    viewShow = "";
  }

  void getData() async {
    ref.read(followingProvider.notifier).doGetLikeData();
    viewShow = "";
  }

  final int _currentIndex = 2;
  final RoundedRectangleBorder roundedRectangleBorder = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
  );
  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    ref.listen<AsyncValue>(followingProvider.select((state) => state),
    (_, state) => state.showAlertDialogOnError(context));

    final state = ref.watch(followingProvider);
    final follows = state.value;
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
                        child: const Text("いいねをしてくれた人",
                            style: TextStyle(fontSize: 21))),
                    Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: vww(context, 5), vertical: 15),
                        decoration: isFollowing
                            ? const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey, width: 0.5)))
                            : null,
                        child: TextButton(
                            style: ButtonStyle(
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                                      EdgeInsets.zero),
                            ),
                            onPressed: () {
                              setState(() {
                                isFollowing = !isFollowing;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1.0,
                                  style: BorderStyle.none,
                                ),
                                borderRadius: BorderRadius.circular(10),
                                color: const Color.fromRGBO(229, 250, 245, 1),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 1.0,
                                            style: BorderStyle.none,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: BUTTON_MAIN,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(follows!.length.toString(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15)),
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.only(left: 7),
                                          child: Text("すべて",
                                              style: TextStyle(
                                                  color: BUTTON_MAIN)))
                                    ],
                                  ),
                                  Icon(
                                    isFollowing
                                        ? Icons.keyboard_arrow_down
                                        : Icons.keyboard_arrow_up,
                                    color: BUTTON_MAIN,
                                  )
                                ],
                              ),
                            ))),
                    !isFollowing
                        ? Container(
                            padding: EdgeInsets.only(
                                left: vww(context, 5),
                                right: vww(context, 5),
                                bottom: 15),
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey, width: 0.5))),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1.0,
                                  style: BorderStyle.none,
                                ),
                                borderRadius: BorderRadius.circular(10),
                                color: const Color.fromARGB(255, 230, 230, 230),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    // Toggle the value of isViewShowFive and set viewShow accordingly
                                    if (isViewShowFive) {
                                      viewShow = ''; // Set viewShow to an empty string
                                    } else {
                                      viewShow = '5'; // Set viewShow to 5
                                    }
                                    isViewShowFive = !isViewShowFive; // Toggle the value of isViewShowFive
                                  });
                                  print(viewShow);
                                },
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 8),
                                      child: Icon(
                                        Icons.remove_red_eye,
                                        color: isViewShowFive ? Color.fromARGB(255, 193, 192, 201) : Color.fromARGB(255, 0, 202, 157),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 15),
                                      child: Text(
                                        "住まいが同じ人",
                                        style: TextStyle(color: PRIMARY_FONT_COLOR),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ))
                        : Container(),
                        Padding(
                          padding: EdgeInsets.symmetric(
                          vertical: vhh(context, 1),
                              horizontal: vww(context, 5),
                          ),
                          child: Container(
                            height: MediaQuery.of(context).size.height /1.5,
                            child: follows != null && follows.isNotEmpty
                              ? SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Wrap(
                                    spacing:10,
                                    runSpacing: 10,
                                    children: <Widget>[
                                      for (var i = 0; i < follows.length; i++)
                                        if (viewShow == '5' || i < 5)
                                          if (i < 4) // Display data from the database up to the 4th position
                                            FollowingCard(
                                              info: follows[i],
                                              onPressed: () {},
                                            )
                                          else if (i == 4 || viewShow != '5')
                                            Wrap(
                                            children: [
                                              SizedBox(
                                                height: 190,
                                                child: Image.asset(
                                                  "assets/images/users/paid_plan_users.png",
                                                  fit: BoxFit.fitWidth,
                                                ),
                                              ),
                                              SizedBox(width: 10,),
                                              FollowingCard(
                                                info: follows[i],
                                                onPressed: () {},
                                              ),
                                            ],
                                          )
                                          else if (i == 14 || viewShow != '5')
                                            Wrap(
                                            children: [
                                              SizedBox(
                                                height: 190,
                                                child: Image.asset(
                                                  "assets/images/users/unpaid_plan_users.png",
                                                  fit: BoxFit.fitWidth,
                                                ),
                                              ),
                                            ],
                                          )
                                          else if (i == 19 || viewShow != '5')
                                            Wrap(
                                            children: [
                                              SizedBox(
                                                height: 190,
                                                child: Image.asset(
                                                  "assets/images/users/paid_plan_users.png",
                                                  fit: BoxFit.fitWidth,
                                                ),
                                              ),
                                              SizedBox(width: 10,),
                                              FollowingCard(
                                                info: follows[i],
                                                onPressed: () {},
                                              ),
                                            ],
                                          )
                                          else if (i == 29 || viewShow != '5')
                                            Wrap(
                                            children: [
                                              SizedBox(
                                                height: 190,
                                                child: Image.asset(
                                                  "assets/images/users/unpaid_plan_users.png",
                                                  fit: BoxFit.fitWidth,
                                                ),
                                              ),
                                            ],
                                          )
                                          else if (i == 36 || viewShow != '5')
                                            Wrap(
                                            children: [
                                              SizedBox(
                                                height: 190,
                                                child: Image.asset(
                                                  "assets/images/users/paid_plan_users.png",
                                                  fit: BoxFit.fitWidth,
                                                ),
                                              ),
                                              SizedBox(width: 10,),
                                            ],
                                          )
                                          else if ((i - 1) % 18 == 0 || viewShow != '5')
                                            Wrap(
                                              children: [
                                                FollowingCard(
                                                  info: follows[i],
                                                  onPressed: () {},
                                                ),
                                              ],
                                            )
                                          else if ((i - 1) % 29 == 0 || viewShow != '5')
                                            Wrap(
                                              children: [
                                                FollowingCard(
                                                  info: follows[i],
                                                  onPressed: () {},
                                                ),
                                              ],
                                            )
                                          else // Display data from the database after the picture position
                                             Wrap(
                                              children: [
                                                FollowingCard(
                                                  info: follows[i],
                                                  onPressed: () {},
                                                ),
                                              ],
                                            )
                                    ],
                                  ),
                                )
                              : Text("No data"),
                          ),
                        ),
                      const SizedBox(
                        height: 40,
                      )
                  ]);
            }, childCount: 1)),  
          ],
        ),
        
        bottomNavigationBar: BottomNavBar(currentIndex: _currentIndex));
  }
}
