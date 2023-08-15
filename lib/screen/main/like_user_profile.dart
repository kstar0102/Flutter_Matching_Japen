// ignore_for_file: unused_local_variable
import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:matching_app/common.dart';
import 'package:matching_app/screen/main/layouts/basic_info.dart';
import 'package:matching_app/screen/main/layouts/introduction_widget.dart';
import 'package:matching_app/screen/main/layouts/introductory_badge_widget.dart';
import 'package:matching_app/screen/main/layouts/my_community_widget.dart';
import 'package:matching_app/screen/main/layouts/thumb_up_modal.dart';
import 'package:matching_app/utile/index.dart';
import 'package:matching_app/screen/main/layouts/profile_badge.dart';
import 'package:matching_app/communcation/category_people/people_item.dart';
import 'package:matching_app/controller/auth_controllers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matching_app/bloc/cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

// ignore: use_key_in_widget_constructors
class LikeUserProfile extends ConsumerStatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  ConsumerState<LikeUserProfile>  createState() => _LikeUserProfileState();
}

class _LikeUserProfileState extends ConsumerState<LikeUserProfile> {
   List<dynamic> items = [];
  List<BadgeObject> badgeList = [];
  int _seconds = 1;
  Timer? _timer;
  // ignore: unused_field
  late int _current = 0;
  bool isModalShow = false;
  int count = 0;
  @override
  void initState() {
    super.initState();
    BlocProvider.of<AppCubit>(context).fetchLikeRandom();
    AppCubit appCubit = AppCubit.get(context);
    items = [
       if (appCubit.user.photo1 != "http://greeme.net//uploads/null") appCubit.user.photo1,
        if (appCubit.user.photo2!= "http://greeme.net//uploads/null") appCubit.user.photo2,
        if (appCubit.user.photo3!= "http://greeme.net//uploads/null") appCubit.user.photo3,
        if (appCubit.user.photo4!= "http://greeme.net//uploads/null") appCubit.user.photo4,
        if (appCubit.user.photo5!= "http://greeme.net//uploads/null") appCubit.user.photo5,
        if (appCubit.user.photo6!= "http://greeme.net//uploads/null") appCubit.user.photo6,
    ];

    badgeList = [
      BadgeObject("とにかく話したい", false, 1),
      BadgeObject("いつでも", false, 2),
      BadgeObject("鉄板焼き", false, 3),
    ];

  }

  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

   void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        setState(() {
          if (_seconds < 1) {
            timer.cancel();
            // SystemNavigator.pop();
             Navigator.pushNamed(
              context, "/profile_screen");
              return;
          } else {
            _seconds = _seconds - 1;
          }
        });
      },
    );
  }

  dynamic addLikeData() async{
    AppCubit appCubit = AppCubit.get(context);
    if(count >= 5)
    {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('todayRecom',"true");
      Fluttertoast.showToast(
        msg: "今日のおすすめが終わりました。",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.yellow,
        textColor: Colors.black,
      );
      return;
    }
    dynamic result = await  appCubit.addTodayLikesData(appCubit.receiver_id.toString(), appCubit.UserId.toString());
    if(result == true)
    {
      Fluttertoast.showToast(
        msg: "成功",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
      );
     
      BlocProvider.of<AppCubit>(context).fetchLikeRandom();
    }
    else{
      Fluttertoast.showToast(
        msg: "推奨数不足",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    AppCubit appCubit = AppCubit.get(context);
    List<String> lines = appCubit.user.introduce?.split('\n').take(4).toList() ?? [];
    String shortText = lines.join('\n');
    print(appCubit.user.nickname);
    if(appCubit.user.nickname == "")
    {
       Fluttertoast.showToast(
          msg: "おすすめ相手はありません",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
      );
      startTimer();
    }
    return BlocBuilder<AppCubit, AppState>(builder: (context, state) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverList(
                delegate:
                    SliverChildBuilderDelegate((BuildContext context, int index) {
              return  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        SizedBox(
                          height: vhh(context, 49),
                          width: vww(context, 100),
                          child: ListView(children: [
                            CarouselSlider(
                              items: appCubit.avatarImages.map((item) { // Iterate over each item in the 'items' array
                                return Container(
                                  height: double.infinity,
                                  width: double.infinity,
                                  margin: EdgeInsets.zero,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(vww(context, 10)),
                                      bottomRight: Radius.circular(vww(context, 10)),
                                    ),
                                    image: DecorationImage(
                                      image: NetworkImage(item), // Use the current item from the array
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              }).toList(),
                              options: CarouselOptions(
                                enableInfiniteScroll: true,
                                height: vhh(context, 46),
                                scrollDirection: Axis.horizontal,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _current = index;
                                  });
                                },
                                viewportFraction: 1,
                              ),
                            ),
                          ]),
                        ),
                        Positioned(
                            bottom: 30,
                            child: CarouselIndicator(
                              count: items.length,
                              index: _current,
                              activeColor: BUTTON_MAIN,
                              color: const Color.fromARGB(255, 131, 131, 131),
                              height: 10,
                              width: 10,
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                top: 30,
                                left: vww(context, 4),
                                right: vww(context, 4)),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      width: 45,
                                      height: 45,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: const Color.fromARGB(
                                            50, 255, 255, 255),
                                      ),
                                      child: TextButton(
                                        onPressed: () {
                                           Navigator.pushNamed(
                                            context, "/profile_screen");
                                        },
                                        style: ButtonStyle(
                                          padding: MaterialStateProperty.all(
                                              EdgeInsets.zero),
                                        ),
                                        child: const Icon(Icons.close,
                                            color: Colors.white),
                                      )),
                                  Container(
                                      width: 45,
                                      height: 45,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: const Color.fromARGB(100, 0, 0, 0),
                                      ),
                                      child: TextButton(
                                          onPressed: () {},
                                          style: ButtonStyle(
                                            padding: MaterialStateProperty.all(
                                                EdgeInsets.zero),
                                          ),
                                          child: const Icon(Icons.more_horiz,
                                              color: Colors.white)))
                                ]))
                      ],
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: vhh(context, 2),
                            horizontal: vww(context, 6)),
                        child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Column(children: [
                              Row(children: [
                                Padding(
                                    padding: EdgeInsets.only(
                                        top: 5, bottom: 5, right: 20),
                                    child: Text(appCubit.user.nickname,
                                        style: TextStyle(fontSize: 17)
                                        )
                                      ),
                                appCubit.user.identityState == "承認"?
                                Image(
                                    image:
                                        AssetImage("assets/images/status/on.png"),
                                    width: 20): Container(),
                                appCubit.user.identityState == "承認"?
                                Padding(
                                    padding: EdgeInsets.only(right: 50),
                                    child: Text(" 本人確認済み",
                                        style: TextStyle(fontSize: 12))):
                                Container(),
                              ]),
                              Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Row(children: [
                                    Text(appCubit.user.residence,
                                        style: TextStyle(fontSize: 15)),
                                    Container(width: 20),
                                    Text("${appCubit.user.bday.toString()}歳",
                                        style: TextStyle(fontSize: 15)),
                                  ])),
                            ]))),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: vhh(context, 3),
                          left: vww(context, 6),
                          right: vww(context, 6)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Text("自己紹介",
                                  style: TextStyle(fontSize: 16, color: PRIMARY_FONT_COLOR))
                                  ),
                          Text(shortText??appCubit.intro_text,
                              overflow: TextOverflow.ellipsis, // Show "..." if text overflows container
                              maxLines: 4,
                              style:
                                  const TextStyle(fontSize: 13, color: PRIMARY_FONT_COLOR)),
                        ],
                      )),
                    MyCommunityWidget(
                              communityObjects: appCubit.user.community),
                    Padding(padding: EdgeInsets.only(
                      left: vww(context, 6),
                      right: vww(context, 6),
                      bottom: vhh(context, 3)),
                    child: ProfileBadgeWidget(badges: appCubit.user.introBadge),
                    ),
                    BasicInfo(
                      height: appCubit.user.height ?? 0,
                      annualIncome: appCubit.user.annualIncome == null? "": appCubit.user.annualIncome,
                      blood: appCubit.user.bloodType ?? "",
                      bodyType: appCubit.user.bodytype ?? "",
                      cigarette: appCubit.user.cigarette ?? "",
                      purpose: appCubit.user.usePurpose?? ""),
                  ]);
            }, childCount: 1)),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
          width: vww(context, 60),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                    width: 60,
                    height: 60,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white,
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                                            context, "/profile_screen");
                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.zero),
                      ),
                      child: const Icon(Icons.close,
                          color: Color.fromARGB(255, 193, 192, 201), size: 35),
                    )),
                Container(
                    width: 60,
                    height: 60,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white,
                    ),
                    child: TextButton(
                      onPressed: () {
                        addLikeData();
                        if(count < 5)
                        {
                          count ++;
                        }
                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.zero),
                      ),
                      child: const Icon(Icons.thumb_up,
                          color: BUTTON_MAIN, size: 35),
                    )),
              ]),
        ),
      );
    });
  }
}
