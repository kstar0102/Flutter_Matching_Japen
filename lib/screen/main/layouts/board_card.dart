import 'package:flutter/material.dart';
import 'package:matching_app/common.dart';
import 'package:matching_app/utile/index.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:matching_app/screen/main/setting/board_list.dart';
import 'package:matching_app/constants/app_constants.dart';
import 'package:matching_app/constants/app_styles.dart';
import 'dart:core';
import 'package:intl/intl.dart';
// ignore: use_key_in_widget_constructors
class BoardCard extends StatefulWidget {
  const BoardCard({
    Key? key,
    required this.info,
    required this.onPressed,
  }) : super(key: key);
  
  final Board info;
  final VoidCallback onPressed;
  @override
  // ignore: library_private_types_in_public_api
  _BoardCardState createState() => _BoardCardState();
}


// ignore: must_be_immutable
class _BoardCardState extends State<BoardCard> {
  @override
  Widget build(BuildContext context) {
    Board boardInfo = widget.info;
    String avatar = boardInfo.photo1;
    String originalDate = boardInfo.created_date;
    String modifiedDate = originalDate.substring(5).replaceAll('-', '/');
    final now = DateTime.now();
    final dateTime = DateTime(now.year, now.month, now.day);
    String currentDate =  DateFormat('yyyy-MM-dd').format(dateTime);
    return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: vww(context, 6)),
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
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
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
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.circular(20),
                                          child: boardInfo.matching_check !="1"? boardInfo.private_age == "1" || boardInfo.private_matching == "1" ? ShaderMask(
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
                                                  "http://greeme.net/uploads/" + avatar,
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
                                            "http://greeme.net/uploads/" + avatar,
                                            width: 165,
                                            height: 165,
                                          ):Image.network(
                                            "http://greeme.net/uploads/" + avatar,
                                            width: 165,
                                            height: 165,
                                          )
                                        ),
                                      ),
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
                            horizontal: 10, vertical: 10),
                        child: Text(
                          "${boardInfo.board_content??""}",
                          style: TextStyle(
                              fontSize: 13, color: PRIMARY_FONT_COLOR),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(bottom: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Container(
                              //   // alignment: Alignment.bottomRight,
                              //   padding: const EdgeInsets.symmetric(
                              //       horizontal: 5, vertical: 5),
                              //   decoration: BoxDecoration(
                              //       color: const Color.fromARGB(
                              //           255, 229, 250, 245),
                              //       border: Border.all(style: BorderStyle.none),
                              //       borderRadius: BorderRadius.circular(5)),
                                // width: 100,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    
                                    boardInfo.created_date == currentDate? 
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          // alignment: Alignment.bottomRight,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 1),
                                          decoration: BoxDecoration(
                                              color: const Color.fromARGB(255, 255, 157, 0),
                                              border: Border.all(style: BorderStyle.none),
                                              borderRadius: BorderRadius.circular(10)),
                                        child:  
                                         Text("New",
                                            style: TextStyle(
                                                color: Colors.white, fontSize: 12))    
                                        ),
                                       
                                      ],
                                    ):Container(),
                                    SizedBox(width: 220,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          // alignment: Alignment.bottomRight,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 5),
                                          decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 229, 250, 245),
                                              border: Border.all(style: BorderStyle.none),
                                              borderRadius: BorderRadius.circular(5)),
                                          child:Row(children: [
                                             const Image(
                                                image: AssetImage(
                                                    "assets/images/icons/time.png"),
                                                width: 20),
                                            Container(width: 10),
                                            // const Text("指定なし",
                                            //     style: TextStyle(
                                            //         color: BUTTON_MAIN, fontSize: 12))
                                            Text(modifiedDate,
                                                style: TextStyle(
                                                    color: BUTTON_MAIN, fontSize: 12))
                                          ],)    
                                          ),
                                       
                                      ],
                                    ),
                                  ],
                                ),
                            ],
                          )),
                          
                    ]))));
  }
}
