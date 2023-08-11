import 'package:flutter/material.dart';
import 'package:matching_app/common.dart';
import 'package:matching_app/components/chat_user_item.dart';
import 'package:matching_app/components/user_info_items.dart';
import 'package:matching_app/screen/main/layouts/bottom_nav_bar.dart';
import 'package:matching_app/screen/main/layouts/pined_header.dart';
import 'package:matching_app/utile/async_value_ui.dart';
import 'package:matching_app/utile/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matching_app/communcation/category_people/people_controller.dart';
import 'package:matching_app/communcation/category_people/people_card.dart';
import 'dart:async';
import '../../bloc/cubit.dart';
import 'package:matching_app/components/radius_button.dart';
import '../../communcation/category_people/people_item.dart';
// ignore: use_key_in_widget_constructors
class ChatScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<UsersObject> items = <UsersObject>[];

  final int _currentIndex = 3;
  Timer? _timer;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
    getData();
    ref.read(peopleProvider.notifier).doGetChattingData();
    // startTimer();
  }

  void getData() async {
    ref.read(peopleProvider.notifier).doGetChattingData();
    // print("Success");
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    _tabController.dispose();
  }

  void onTabTap(int index) {
    setState(() {
      _tabController.index = index;
    });
  }

  void startTimer() {
    const duration = Duration(seconds: 2);
    _timer = Timer.periodic(duration, (timer) {
      getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(peopleProvider.select((state) => state),
    (_, state) => state.showAlertDialogOnError(context));

    final state = ref.watch(peopleProvider);
    final peoples = state.value;
    // print(peoples);
    AppCubit appCubit = AppCubit.get(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverPersistentHeader(
                delegate: PinedHeader(_tabController, onTabTap), pinned: true),
            SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
              return _tabController.index == 0
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      child: Container(
                        height: 590,
                        child: peoples != null && peoples.isNotEmpty
                          ? SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Wrap(
                                spacing: 20,
                                runSpacing: 20,
                                children: peoples.where((childItem) => childItem.status == "0").map<Widget>((childItem) => UserInfoItems(
                                    info: childItem,
                                    onPressed: () {},
                                )).toList(),
                              ),
                            )
                          : Center(child: Text("No data")),
                          
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: vww(context, vww(context, 1))),
                            child: Container(
                              height: 590,
                              child: peoples != null && peoples.isNotEmpty
                                ? SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Wrap(
                                      spacing: 20,
                                      runSpacing: 20,
                                      children: peoples.where((childItem) => childItem.status == "1").map<Widget>((childItem) => ChatUserItem(
                                          info: childItem,
                                          onPressed: () {},
                                      )).toList(),
                                    ),
                                  )
                                : Center(
                                    child: Column(
                                      children: [
                                        SizedBox(height: 80,),
                                        Image.asset("assets/images/user.png"),
                                        SizedBox(height: 20,),
                                        Text("まだ一致する相手はいません。",
                                          style: TextStyle(color: Colors.red,
                                                  fontWeight: FontWeight.bold),),
                                        SizedBox(height: 20,),
                                        Text("まずはたくさん"),
                                        SizedBox(height: 10,),
                                        Text("好きです。"),
                                         SizedBox(height: 120,),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 5),
                                          child: SizedBox(
                                            width: MediaQuery.of(context).size.width,
                                            child: Align(
                                              alignment: Alignment.bottomCenter,
                                              child: RadiusButton(
                                                id: 0,
                                                color: BUTTON_MAIN,
                                                text: "探す",
                                                goNavigation: (id) {
                                                  Navigator.pushNamed(context, "/following_users");
                                                },
                                                isDisabled: false,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ),
                            ),
                          ),
                        ]);
            }, childCount: 1)),
          ],
        ),
        bottomNavigationBar: BottomNavBar(currentIndex: _currentIndex));
  }
}
