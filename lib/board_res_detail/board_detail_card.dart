import 'package:flutter/material.dart';
import 'package:matching_app/common.dart';
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

// ignore: use_key_in_widget_constructors
class BoardDetailCard extends ConsumerStatefulWidget {
  const BoardDetailCard({
    Key? key,
    required this.info,
    required this.onPressed,
  }) : super(key: key);
  
  final BoardDetailItem info;
  final VoidCallback onPressed;
  @override
  ConsumerState<BoardDetailCard> createState() => _BoardDetailCardState();
}


// ignore: must_be_immutable
class _BoardDetailCardState extends ConsumerState<BoardDetailCard> {
  BoardDetailItem? boardInfo;
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
    BoardDetailItem boardInfo = widget.info;
    String avatar = boardInfo!.photo1;
    return Padding(
        padding: EdgeInsets.symmetric(
        horizontal: vww(context, 0)),
        child:Column(
          children: [
            Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 3,
                  blurRadius: 8,
                  offset: const Offset(0, 3))
            ], borderRadius: BorderRadius.circular(10)),
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 10),
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: PRIMARY_GREY, width: 1))),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                   Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              const BorderRadius.all(Radius.circular(50)),
                                          border: Border.all(color: Colors.black45)),
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage("http://192.168.142.55:8000/uploads/"+avatar),
                                        onBackgroundImageError: (exception, stackTrace) {
                                          setState(() {
                                            avatar =
                                                "http://192.168.142.55:8000/uploads/1.png";
                                          });
                                        },
                                        backgroundColor: Colors.transparent,
                                      )),
                                    Container(width: 5),
                                      Text('${boardInfo.user_nickname??"TSUABA"}',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: PRIMARY_FONT_COLOR))
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "${boardInfo.age+"歳"??"-"}",
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: Color.fromARGB(
                                              255, 151, 157, 170)),
                                    ),
                                    Container(width: 10),
                                    Text(
                                      "${boardInfo.residence??"NO"}",
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: Color.fromARGB(
                                              255, 151, 157, 170)),
                                    ),
                                    Container(width: 10),
                                  ],
                                )
                              ])),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Text(
                          "${boardInfo.res_board_content??""}",
                          style: TextStyle(
                              fontSize: 13, color: PRIMARY_FONT_COLOR),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(bottom: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(width: 120,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                disabledBackgroundColor: BUTTON_MAIN,
                                                disabledForegroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(30.0),
                                                ),
                                                textStyle: const TextStyle(fontSize: 13),
                                                backgroundColor: BUTTON_MAIN,
                                                padding:
                                                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5)),
                                            onPressed: () {
                                              final controller = ref.read(AuthProvider.notifier);
                                                controller.doDetailData(boardInfo!.res_id).then(
                                                  (value) {
                                                    print(value);
                                                    if(value == true)
                                                    {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => BoardResList()),);
                                                      
                                                    }
                                                     Navigator.push(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => BoardResList()),);
                                                      
                                                },
                                              );
                                              // Navigator.pushNamed(context, "/new_post_screen");
                                            },
                                            child: const Text("投稿する"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                            ],
                          )),      
                      ]
                    )
                  ),                  
                ),  
                SizedBox(height: 30,),
              ]),
            );
    }
  }
