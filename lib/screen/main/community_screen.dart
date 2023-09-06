// ignore_for_file: unused_local_variable

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:matching_app/common.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matching_app/components/main_community_widget.dart';
import 'package:matching_app/screen/main/layouts/bottom_nav_bar.dart';
import 'package:matching_app/screen/main/layouts/community_bottom_modal.dart';
import 'package:matching_app/screen/main/pay_screen.dart';
import 'package:matching_app/utile/index.dart';
import 'package:matching_app/communcation/home_commun/communicate_controller.dart';
import 'package:matching_app/components/dialogs.dart';
import 'package:matching_app/utile/async_value_ui.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:matching_app/communcation/home_commun/communicate_card.dart';

import 'layouts/users_bottom_modal.dart';

// ignore: use_key_in_widget_constructors
class CommunityScreen extends ConsumerStatefulWidget {
   @override
  ConsumerState<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen> {
  List<dynamic> items = [];

  bool isModalShow = false;
  bool _dataFetched = false;
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    ref.read(communicateProvider.notifier).doGetCommunicateData();
  }

  int _currentIndex = 1;
  final RoundedRectangleBorder roundedRectangleBorder = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
  );
  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(communicateProvider.select((state) => state),
    (_, state) => state.showAlertDialogOnError(context));

    final state = ref.watch(communicateProvider);
    final coms = state?.value ?? [];
    return Scaffold(
      backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: vhh(context, 0),
                  left: vww(context, 5),
                  right: vww(context, 5),
                ),
                child: const Text(
                  "コミュニティー",
                  style: TextStyle(fontSize: 21),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: vww(context, 3),
                            right: vww(context, 3),
                            top: 1,
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: SizedBox(
                            child: Column(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => PayScreen()),
                                    );
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      top: vhh(context, 3),
                                      left: vww(context, 5),
                                      right: vww(context, 5),
                                    ),
                                    child: Image(
                                      image: AssetImage("assets/images/main/community-1.png"),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20,),
                                SizedBox(
                                  child:Column(
                                    children: [
                                      CarouselSlider(
                                        items: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                right: vww(context, 10), top: 0),
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context, 
                                                  MaterialPageRoute(
                                                    builder: (context) => UsersBottomModal(sub_id: "0", sub_name:"新人集合"),
                                                ));
                                              },
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10.0),
                                              image: const DecorationImage(
                                                image: AssetImage(
                                                    "assets/images/main/community-2.png"),
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                right: vww(context, 10), top: 0),
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.pushNamed(context, '/profile_screen');
                                              },
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10.0),
                                              image: const DecorationImage(
                                                image: AssetImage(
                                                    "assets/images/main/community-3.png"),
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                        ],
                                        options: CarouselOptions(
                                            enableInfiniteScroll: true, height: 150),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10,),
                                SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Container(
                                        height: MediaQuery.of(context).size.height / 5.5,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemCount: coms.length,
                                          itemBuilder: (context, index) {
                                            final communicateItem = coms[0];
                                            print(communicateItem.entry_community);
                                            final bool isDifferentCategory =
                                                index == 0 || communicateItem.category_id != coms[0].category_id;
                                            if (isDifferentCategory) {
                                              return Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                Row(
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                        left: vww(context, 5),
                                                        right: vww(context, 5)),
                                                      child: Text(
                                                        "参加中",
                                                        style: TextStyle(fontSize: 17),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(left: vww(context, 0)),
                                                      child: Image.asset(
                                                        "assets/images/community/participation.png",
                                                        width: 25,
                                                        height: 25,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                  Padding(
                                                    padding: EdgeInsets.only(left: 25,),
                                                    child: Wrap(
                                                      spacing: 5,
                                                      runSpacing: 10,
                                                      children: coms
                                                          .where((item) => item.entry_community == "1")
                                                          .map<Widget>((childItem) => CommunicateCard(
                                                                info: childItem,
                                                                onPressed: () {},
                                                              ))
                                                          .toList(),
                                                    ),
                                                  ),
                                                  SizedBox(height: 20,)
                                                ],
                                              );
                                            } else {
                                              return Container();
                                            }
                                          },
                                        )
                                      ),
                                      SizedBox(height: 10,),
                                      Container(
                                        height: MediaQuery.of(context).size.height / 1.2,
                                        child: Column(children: [
                                          Expanded(
                                            child: coms != null && coms.isNotEmpty
                                                ? ListView.builder(
                                              shrinkWrap: true,
                                              physics: NeverScrollableScrollPhysics(),
                                              itemCount: coms.length,
                                              itemBuilder: (context, index) {
                                                final communicateItem = coms[index];
                                                print(communicateItem.entry_community);
                                                final bool isDifferentCategory =
                                                    index == 0 || communicateItem.category_id != coms[index - 1].category_id;
                                                if (isDifferentCategory) {
                                                  return Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets.only(
                                                              left: vww(context, 5),
                                                              right: vww(context, 5)),
                                                            child: Text(
                                                              communicateItem.category_name.toString(),
                                                              style: TextStyle(fontSize: 17),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.only(left: vww(context, 0)),
                                                            child: Image.network(
                                                              "http://greeme.net/uploads/category/" +
                                                                  communicateItem.category_image,
                                                              width: 25,
                                                              height: 25,
                                                              loadingBuilder: (context, child, loadingProgress) {
                                                              if (loadingProgress == null) return child;
                                                                return Center(
                                                                  child: CircularProgressIndicator(
                                                                    value: loadingProgress.expectedTotalBytes != null
                                                                        ? loadingProgress.cumulativeBytesLoaded /
                                                                            loadingProgress.expectedTotalBytes!
                                                                        : null,
                                                                  ),
                                                                );
                                                              }
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.only(left: 25,),
                                                        child: Wrap(
                                                          spacing: 5,
                                                          runSpacing: 10,
                                                          children: coms
                                                              .where((item) => item.category_id == communicateItem.category_id && item.entry_community == "0")
                                                              .map<Widget>((childItem) => CommunicateCard(
                                                                    info: childItem,
                                                                    onPressed: () {},
                                                                  ))
                                                              .toList(),
                                                        ),
                                                      ),
                                                      SizedBox(height: 20,)
                                                    ],
                                                  );
                                                } else {
                                                  return Container();
                                                }
                                              },
                                            )
                                            : Center(child: Text("No data")),
                                          )
                                        ],)
                                      ),
                                    ],
                                  ),
                                )
                                
                              ]
                            )
                        )
                      )
                    ]
                  )
                )
              )
            ],
          ),
        ),
      bottomNavigationBar: BottomNavBar(currentIndex: _currentIndex)
    );   
  }
}
