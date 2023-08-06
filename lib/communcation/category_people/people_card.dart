import 'package:flutter/material.dart';
import 'package:matching_app/common.dart';
import 'package:matching_app/communcation/category_people/people_item.dart';
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
import 'package:matching_app/screen/main/profile_people_screen.dart';

// ignore: use_key_in_widget_constructors
class PeopleCard extends ConsumerStatefulWidget {
  const PeopleCard({
    Key? key,
    required this.info,
    required this.onPressed,
  }) : super(key: key);
  
  final PeopleItem info;
  final VoidCallback onPressed;
  @override
  ConsumerState<PeopleCard> createState() => _PeopleCardState();
}


// ignore: must_be_immutable
class _PeopleCardState extends ConsumerState<PeopleCard> {
  PeopleItem? boardInfo;
  String? avatar;
   BoardDetailItem? myAncestorWidget;
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
    PeopleItem boardInfo = widget.info;
    String avatar = boardInfo!.photo1;
    String badge_name = boardInfo.badge_name;
    List<String> numberArray = badge_name.split(",");
    List<String> badgeArray = boardInfo.badge_color.split(",");
    print(boardInfo.badge_color);
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ProfilePeopleScreen(info : boardInfo.user_id)),);
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              "http://192.168.144.61:8000/uploads/" + avatar,
                              width: 165,
                              height: 165,
                            ),
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
                            Image.network("http://192.168.144.61:8000/uploads/status/on.png", width: 15, height: 15,):
                            Container()
                          ],)
                        ),
                        SizedBox(
                          height: 50,
                          width: 150,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Wrap(
                              spacing: 5,
                              runSpacing: 8,
                              children: badgeList.map((BadgeItemObject e) {
                                String textColor = e.color;
                                return FilterChip(
                                  label: Text(e.title,
                                      style: TextStyle(
                                          fontSize: 10,
                                          color:
                                          Color(int.parse(textColor.substring(2, 7),
                                                      radix: 16) +
                                                  0xFF000000))),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    side: BorderSide(
                                        color: Color(int.parse(textColor.substring(2, 7),
                                                radix: 16) +
                                            0xFF000000),
                                        width: 1.0),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  backgroundColor: Colors.white,
                                  selectedColor: Color(
                                      int.parse(textColor.substring(2, 7), radix: 16) +
                                          0xFF000000),
                                  onSelected: (bool value) {},
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
        SizedBox(height: 30, width: 10,),
      ]);
    }
  }
