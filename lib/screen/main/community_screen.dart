// ignore_for_file: unused_local_variable

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:matching_app/common.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matching_app/components/main_community_widget.dart';
import 'package:matching_app/screen/main/layouts/bottom_nav_bar.dart';
import 'package:matching_app/screen/main/layouts/community_bottom_modal.dart';
import 'package:matching_app/utile/index.dart';
import 'package:matching_app/communcation/home_commun/communicate_controller.dart';
import 'package:matching_app/components/dialogs.dart';
import 'package:matching_app/utile/async_value_ui.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:matching_app/communcation/home_commun/communicate_card.dart';

// ignore: use_key_in_widget_constructors
class CommunityScreen extends ConsumerStatefulWidget {
   @override
  ConsumerState<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen> {
  List<dynamic> items = [];

  bool isModalShow = false;

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
    print(coms);
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
                        child: const Text("コミュニティー",
                            style: TextStyle(fontSize: 21))),
                    Padding(
                        padding: EdgeInsets.only(
                            top: vhh(context, 3),
                            left: vww(context, 5),
                            right: vww(context, 5)),
                        child: const Image(
                            image: AssetImage(
                                "assets/images/main/community-1.png"))),
                    SizedBox(height: 20,),
                    SizedBox(
                      child:Column(
                        children: [
                          CarouselSlider(
                            items: [
                              Container(
                                margin: EdgeInsets.only(
                                    right: vww(context, 10), top: 0),
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
                    Container(
                      height: 320,
                      child: RefreshIndicator(
                        onRefresh: () async {
                          getData();
                        },
                        child: coms != null && coms.isNotEmpty
                            ? ListView.builder(
                                itemCount: coms.length,
                                itemBuilder: (context, index) {
                                  final communicateItem = coms[index];

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
                                                "http://192.168.142.55:8000/uploads/category/" +
                                                    communicateItem.category_image,
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
                                                .where((item) => item.category_id == communicateItem.category_id)
                                                .map<Widget>((childItem) => CommunicateCard(
                                                      info: childItem,
                                                      onPressed: () {},
                                                    ))
                                                .toList(),
                                          ),
                                        ),
                                        SizedBox(height: 20,)
                                        // if (index < coms.length - 1 &&
                                        //     communicateItem.category_id !=
                                        //         coms[index + 1].category_id)
                                        //   Divider(),
                                      ],
                                    );
                                  } else {
                                    return Container();
                                  }
                                },
                              )
                            : Center(child: Text("No data")),
                      ),
                    ),
                    SizedBox(height: 20,),
                  ]
                );
            }, childCount: 1)),
          ],
        ),
        bottomNavigationBar: BottomNavBar(currentIndex: _currentIndex));
        
  }
}
