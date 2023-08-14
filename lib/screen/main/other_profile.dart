// ignore_for_file: unused_local_variable
import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matching_app/common.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matching_app/screen/main/layouts/basic_info.dart';
import 'package:matching_app/screen/main/layouts/intro_widget.dart';
import 'package:matching_app/screen/main/layouts/introductory_badge_widget.dart';
import 'package:matching_app/screen/main/layouts/my_community_widget.dart';
import 'package:matching_app/screen/main/layouts/thumb_up_modal.dart';
import 'package:matching_app/screen/main/pay_screen.dart';
import 'package:matching_app/screen/main/profile_screen.dart';
import 'package:matching_app/utile/index.dart';
import 'package:matching_app/bloc/cubit.dart';
import 'package:matching_app/screen/main/layouts/profile_badge.dart';
import 'package:matching_app/communcation/category_people/people_item.dart';
import 'package:matching_app/controller/auth_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../../services/chat/chat_service.dart';
import '../verify_screen/identity_verify.dart';

// ignore: use_key_in_widget_constructors
class OtherProfile extends ConsumerStatefulWidget {
  final String? info;

  const OtherProfile({super.key, required this.info});

  @override
  // ignore: library_private_types_in_public_api
  ConsumerState<OtherProfile> createState() => _OtherProfileScreenState();
}

class _OtherProfileScreenState extends ConsumerState<OtherProfile> {
  List<dynamic> items = [];
  List<BadgeObject> badgeList = [];

  // ignore: unused_field
  late int _current = 0;
  bool isModalShow = false;
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();

  @override
  void initState() {
    String? info = widget.info;
    super.initState();
    BlocProvider.of<AppCubit>(context).fetchProfileInfo1(info.toString());
    AppCubit appCubit = AppCubit.get(context);
    setState(() {
      items = [
        if (appCubit.user.photo1 != "http://192.168.142.55:8000//uploads/null") appCubit.user.photo1,
        if (appCubit.user.photo2!= "http://192.168.142.55:8000//uploads/null") appCubit.user.photo2,
        if (appCubit.user.photo3!= "http://192.168.142.55:8000//uploads/null") appCubit.user.photo3,
        if (appCubit.user.photo4!= "http://192.168.142.55:8000//uploads/null") appCubit.user.photo4,
        if (appCubit.user.photo5!= "http://192.168.142.55:8000//uploads/null") appCubit.user.photo5,
        if (appCubit.user.photo6!= "http://192.168.142.55:8000//uploads/null") appCubit.user.photo6,
      ];
    });

    badgeList = [
      BadgeObject("とにかく話したい", false, 1),
      BadgeObject("いつでも", false, 2),
      BadgeObject("鉄板焼き", false, 3),
    ];
    
  }
  
  @override
  Widget build(BuildContext context) {
    String? info = widget.info;

    BlocProvider.of<AppCubit>(context).fetchProfileInfo1(info.toString());
    AppCubit appCubit = AppCubit.get(context);
    String UserId;
    String MyPhoneToken;
    String Iden;
    void sendMessage() async {
    // only send message if there is something to send
      SharedPreferences prefs = await SharedPreferences.getInstance();
      UserId = await prefs.getString("UserId").toString();
      MyPhoneToken = await prefs.getString("Phone_token").toString();
      Iden = await prefs.getString("identify_verify").toString();
      print(appCubit.user.identityState);

      if (appCubit.userInfo_indentity != "承認") {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            // Update Iden here if necessary
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
                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 13),
                      backgroundColor: BUTTON_MAIN,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => IdentityVerify()),
                      );
                    },
                    child: const Text('本人確認する'),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.only(top: 10, bottom: 20, left: 50, right: 50),
                  width: double.infinity,
                  child: TextButton(
                    style: ElevatedButton.styleFrom(
                      disabledForegroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      textStyle: const TextStyle(fontSize: 15),
                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 13),
                      backgroundColor: Colors.transparent,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfileScreen()),
                      );
                    },
                    child: const Text('まだしない', style: TextStyle(color: BUTTON_MAIN)),
                  ),
                ),
              ],
              shape: roundedRectangleBorder,
              content: Container(
                padding: const EdgeInsets.only(top: 20),
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
                        letterSpacing: -2,
                      ),
                    ),
                    Image(
                      width: vww(context, 40),
                      image: const AssetImage("assets/images/main/unidentified.png"),
                    ),
                  ],
                ),
              ),
            );
            
            return dialog;
          },
        );
      }
       if (appCubit.userInfo_indentity == "承認" && appCubit.userInfo_paycheck != "1") {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            // Update Iden here if necessary
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
                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 13),
                      backgroundColor: BUTTON_MAIN,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PayScreen()),
                      );
                    },
                    child: const Text('有料会員に登録する'),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.only(top: 10, bottom: 20, left: 50, right: 50),
                  width: double.infinity,
                  child: TextButton(
                    style: ElevatedButton.styleFrom(
                      disabledForegroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      textStyle: const TextStyle(fontSize: 15),
                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 13),
                      backgroundColor: Colors.transparent,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfileScreen()),
                      );
                    },
                    child: const Text('まだしない', style: TextStyle(color: BUTTON_MAIN)),
                  ),
                ),
              ],
              shape: roundedRectangleBorder,
              content: Container(
                padding: const EdgeInsets.only(top: 20),
                height: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      "メッセージ機能には\n有料会員登録が必要です。",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: PRIMARY_FONT_COLOR,
                        fontSize: 18,
                        letterSpacing: -2,
                      ),
                    ),
                    Image(
                      width: vww(context, 100),
                      image: const AssetImage("assets/images/pay.png"),
                    ),
                  ],
                ),
              ),
            );
            
            return dialog;
          },
        );
      }
      else{
        String msg = _messageController.text;
        _messageController.clear();
        if(msg.isNotEmpty) {
          final result = await _chatService.sendMessage(   
            appCubit.user.phone_token, msg, UserId);
            // clear the text controller after sending the message
            
        }
        DateTime currentTime = DateTime.now();
        String formattedTime = DateFormat('hh:mm').format(currentTime);
        final controller = ref.read(AuthProvider.notifier);
        controller.doChatting(UserId, appCubit.user.phone_token, msg, formattedTime).then(
          (value) {
          },
        );
      }
    }
    return BlocBuilder<AppCubit, AppState>(builder: (context, state) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverList(
                delegate:
                    SliverChildBuilderDelegate((BuildContext context, int index) {
              return Column(
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
                                  child: Container(
                                    height: double.infinity,
                                    width: double.infinity,
                                    child: appCubit.user.matching_check !="1"? appCubit.user.private_age == "1" || appCubit.user.private_matching == "1" ? ShaderMask(
                                      shaderCallback: (rect) {
                                        return LinearGradient(
                                          colors: [Colors.transparent, Colors.transparent, Colors.black],
                                          stops: [0, 0.001, 0.001],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ).createShader(rect);
                                      },
                                      blendMode: BlendMode.dstIn,
                                      child: Stack(
                                        children: [
                                          Image.network(
                                            item,
                                            fit: BoxFit.cover,
                                          ),
                                          Container(
                                            color: Colors.grey.withOpacity(0.95),
                                          ),
                                        ],
                                      ),
                                    ):Image.network(
                                      item,
                                      fit: BoxFit.cover,
                                    ):Image.network(
                                      item,
                                      fit: BoxFit.cover,
                                    )
                                  )
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
                                          Navigator.pop(context);
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
                    IntroWidget(),
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
        
        floatingActionButton: appCubit.user.matching_check != "1"? Container(
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
                        Navigator.pop(context);
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
                        final controller = ref.read(AuthProvider.notifier);
                          controller.doPeopleRecom(widget.info.toString()).then(
                            (value) {
                              if(value == true)
                              {
                              }
                          },
                        );
                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.zero),
                      ),
                      child: const Icon(Icons.thumb_up,
                          color: BUTTON_MAIN, size: 35),
                    )),
              ]),
                ):Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    GestureDetector(
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                           ),
                      ),
                    ),
                    SizedBox(width: 15,),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                        ),
                        child:TextFormField(
                        maxLines: null,
                        controller: _messageController,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "メッセージを入力",
                          hintStyle: TextStyle(
                              color: Color.fromARGB(255, 193, 192, 201)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 193, 192, 201))),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 193, 192, 201)),
                          ),
                          contentPadding: EdgeInsets.all(10),
                        ),
                      ),
                    )),
                    Material(
                      color: Colors.transparent,
                      child: IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () { sendMessage(); },
                        color: BUTTON_MAIN,
                      ),
                    ),
                  ],
                ),
      );
    });
  }
}
