import 'package:flutter/material.dart';
import 'package:matching_app/common.dart';
import 'package:matching_app/following_user/following_item.dart';
import 'package:matching_app/screen/main/user_profile_screen.dart';
import 'package:matching_app/utile/index.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:matching_app/board_res_detail/board_detail_item.dart';
import 'package:matching_app/constants/app_constants.dart';
import 'package:matching_app/constants/app_styles.dart';
import 'dart:core';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matching_app/controller/auth_controllers.dart';
import 'package:matching_app/screen/main/board_res_detail.dart';
import 'package:matching_app/screen/main/board_res_list.dart';
import 'package:matching_app/screen/main/layouts/profile_badge.dart';
import 'package:matching_app/screen/main/other_profile.dart';

import '../bloc/cubit.dart';

// ignore: use_key_in_widget_constructors
class FollowingCard extends ConsumerStatefulWidget {
  const FollowingCard({
    Key? key,
    required this.info,
    required this.onPressed,
  }) : super(key: key);
  
  final FollowingItem info;
  final VoidCallback onPressed;
  @override
  ConsumerState<FollowingCard> createState() => _FollowingCardState();
}


// ignore: must_be_immutable
class _FollowingCardState extends ConsumerState<FollowingCard> {
  FollowingItem? boardInfo;
  String? avatar;
  void initState() {
     boardInfo = widget.info;
     avatar = boardInfo!.photo1;
  }  

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

  }

  @override
  void dispose() {
    // You can safely use myAncestorWidget here
    super.dispose();
  }
  


  @override
  Widget build(BuildContext context) {
    FollowingItem boardInfo = widget.info;
    String avatar = boardInfo!.photo1;
    String badge_name = boardInfo.badge_name;
    List<String> numberArray = badge_name.split(",");
    List<String> badgeArray = boardInfo.badge_color.split(",");
    AppCubit appCubit = AppCubit.get(context);
    print(avatar);
    if (avatar == "http://192.168.142.55:8000/uploads/") {
      avatar = "http://192.168.142.55:8000/uploads/good1.png";
    }
    Widget image = avatar == null || avatar == "null.png"
    ? SizedBox( width: 170,
        height: 175, child: Text("Image Loading..."),)
    : Image.network(
        "http://192.168.142.55:8000/uploads/" + avatar ?? "http://192.168.142.55:8000/uploads/good1.png",
        width: 170,
        height: 175,
      );
    List<BadgeItemObject> badgeList = [];
    for (var i = 0; i < numberArray.length; i++) {
      badgeList.add(BadgeItemObject(i, numberArray[i], false, badgeArray[i]));
    }
    
    return Wrap(
          children: [
            Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.7),
                  spreadRadius: 3,
                  blurRadius: 8,
                  offset: const Offset(0, 3))
            ], borderRadius: BorderRadius.circular(10)),
            child: Container(
            decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10)),
              child: SizedBox(
                child:Wrap(
                  children: [
                    Column(
                      children: [
                        InkWell(
                          onTap: (){
                            appCubit.changePreview(boardInfo.user_id);
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => OtherProfile(info : boardInfo.user_id, matching_data: "",)),);
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: boardInfo.matching_check !="1" ? boardInfo.private_age == "1" || boardInfo.private_matching == "1" ? ShaderMask(
                              shaderCallback: (rect) {
                                return LinearGradient(
                                  colors: [Colors.transparent, Colors.transparent, Colors.black],
                                  stops: [0, 0.1, 1],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ).createShader(rect);
                              },
                              blendMode: BlendMode.dstIn,
                              child: Stack(
                                children: [
                                  Image.network(
                                    "http://192.168.142.55:8000/uploads/" + avatar,
                                    width: 165,
                                    height: 165,
                                  ),
                                  Container(
                                    width: 165,
                                    height: 165,
                                    color: Colors.grey.withOpacity(0.9),
                                  ),
                                ],
                              ),
                            ):Image.network(
                              "http://192.168.142.55:8000/uploads/" + avatar,
                              width: 165,
                              height: 165,
                            ):Image.network(
                              "http://192.168.142.55:8000/uploads/" + avatar,
                              width: 165,
                              height: 165,
                            )
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          child: Row(children: [
                            SizedBox(width: 10,),
                            Text(boardInfo.age+" 歳",
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                            SizedBox(width: 30,),
                            Text(boardInfo.residence, 
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                            boardInfo.identity_state == "1"?
                            Image.network("http://192.168.142.55:8000/uploads/status/on.png", width: 15, height: 15,):
                            Container()
                          ],)
                        ),
                        SizedBox(height: 5,),
                        SizedBox(
                          width: 150, // Set the width statically
                          child: IntrinsicWidth(
                            child: Wrap(
                              spacing: 2,
                              runSpacing: 2,
                              direction: Axis.horizontal, // Set the wrapDirection to horizontal
                              children: badgeList.map((BadgeItemObject e) {
                                String textColor = e.color;
                                String textName = e.title;
                                return Container(
                                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(width: 1, color: Color(int.parse(textColor.replaceAll('#', '0xFF'))),),
                                    color: Color(int.parse(textColor.replaceAll('#', '0xFF'))).withOpacity(0.2)
                                  ),
                                  child: Text(
                                    "${textName}",
                                    style: TextStyle(fontSize: 12, color: Color(int.parse(textColor.replaceAll('#', '0xFF')))),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        )
                      ],
                  ),])
                )     
            )
          ),     
      ]);
    }
  }
