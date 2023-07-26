import 'package:flutter/material.dart';
import 'package:matching_app/common.dart';
import 'package:matching_app/utile/index.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:matching_app/screen/main/setting/board_res_item.dart';
import 'package:matching_app/screen/main/board_res_detail.dart';
import 'package:matching_app/constants/app_constants.dart';
import 'package:matching_app/constants/app_styles.dart';
import 'dart:core';
import 'package:intl/intl.dart';
// ignore: use_key_in_widget_constructors
class BoardResCard extends StatefulWidget {
  const BoardResCard({
    Key? key,
    required this.info,
    required this.onPressed,
  }) : super(key: key);
  
  final BoardItem info;
  final VoidCallback onPressed;
  @override
  // ignore: library_private_types_in_public_api
  _BoardResCardState createState() => _BoardResCardState();
}


// ignore: must_be_immutable
class _BoardResCardState extends State<BoardResCard> {

  Future<void> showOkAlertDialog(BuildContext context, String title) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.zero,
          actionsPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          shape: roundedRectangleBorder,
          title: Container(
              padding: const EdgeInsets.symmetric(vertical: 30),
              width: double.infinity,
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Color.fromARGB(255, 112, 112, 112),
                          width: 1))),
              child: Text(title,
                  style:
                      const TextStyle(fontSize: 18, color: PRIMARY_FONT_COLOR),
                  textAlign: TextAlign.center)),
          actions: <Widget>[
            Container(
              width: double.infinity,
              child: TextButton(
                child: const Text(
                  'OK',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    BoardItem boardInfo = widget.info;
    String originalDate = boardInfo.created_date;
    String modifiedDate = originalDate.substring(5).replaceAll('-', '/');
    return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: vww(context, 4)),
          child:Column(
            children: [
              InkWell(
                onTap: (){
                    if(boardInfo.article_count == "0")
                    {
                        showOkAlertDialog(
                          context, "このボードに関する\nメッセージはありません。");
                        return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BoardResDetail(data: boardInfo.article_id),
                      ),
                    );
                },
                child:Container(
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
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
                          SizedBox(height: 15,),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Text(
                              "${boardInfo.board_content??""}",
                              style: TextStyle(
                                  fontSize: 13, color: PRIMARY_FONT_COLOR),
                            ),
                          ),
                          SizedBox(height: 15,),
                          Padding(
                              padding: EdgeInsets.only(bottom: 10, right: 1),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                    SizedBox(width: 20,),
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
                                          ],),    
                                          ),
                                      ],
                                    ),
                                    SizedBox(width: 20,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          // alignment: Alignment.bottomRight,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 5),
                                          decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 255, 236, 236),
                                              border: Border.all(style: BorderStyle.none),
                                              borderRadius: BorderRadius.circular(5)),
                                          child:Row(children: [
                                              const Image(
                                                image: AssetImage(
                                                    "assets/images/icons/like.png"),
                                                width: 20),
                                            Container(width: 10),
                                            // const Text("指定なし",
                                            //     style: TextStyle(
                                            //         color: BUTTON_MAIN, fontSize: 12))
                                            Text(boardInfo.article_count+"件",
                                                style: TextStyle(
                                                    color: Color.fromARGB(255, 255, 40, 40), fontSize: 12))
                                          ],),    
                                          ),
                                      ],
                                    ),
                                ],
                              )),
                       
                        ]))
                      ),
                   
                  ),
                  SizedBox(height: 20,),     
                ],
              )       
        );
  }
}
