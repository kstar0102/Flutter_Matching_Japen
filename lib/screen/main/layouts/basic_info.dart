// ignore: depend_on_referenced_packages
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:matching_app/common.dart';
import 'package:matching_app/utile/index.dart';
import 'package:matching_app/bloc/cubit.dart';

class BasicInfo extends StatelessWidget {
  
  final double? height;
  final String? bodyType;
  final String? blood;
  final String? purpose;
  final String? annualIncome;
  final String? cigarette;

  const BasicInfo({super.key, this.height, this.bodyType, this.blood, this.purpose, this.annualIncome, this.cigarette});

  @override
  Widget build(BuildContext context) {
    String? height_res = height?.toStringAsFixed(0);
    AppCubit appCubit = AppCubit.get(context);
    return Padding(
        padding: EdgeInsets.only(
            left: vww(context, 6),
            right: vww(context, 6),
            bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: EdgeInsets.only(bottom: 17),
                child: Text("プロフィール",
                    style: TextStyle(fontSize: 16, color: PRIMARY_FONT_COLOR))),
            Padding(
                padding: EdgeInsets.only(
                  bottom: 15,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "身長",
                        style:
                            TextStyle(fontSize: 14, color: PRIMARY_FONT_COLOR),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        appCubit.tall_height == ""?
                        height_res.toString() + " cm":appCubit.tall_height.toString() + " cm",
                        style:
                            TextStyle(fontSize: 14, color: Color.fromARGB(255, 155, 155, 155)),
                      ),
                    )
                  ],
                )),
            Padding(
                padding: EdgeInsets.only(
                  bottom: 15,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "体型",
                        style:
                            TextStyle(fontSize: 14, color: PRIMARY_FONT_COLOR),
                      ),
                    ),
                    Expanded(
                      child: appCubit.user.bodytype==""? 
                      Text(
                            "未設定",
                            style: const TextStyle(
                                fontSize: 14,
                                color:
                                    Color.fromARGB(255, 0, 202, 157)),
                          )
                        : Text(
                            appCubit.user.bodytype.toString(),
                            // appCubit.user.bodytype,
                            style: TextStyle(
                                fontSize: 14, color: Color.fromARGB(255, 155, 155, 155)),
                      )),
                  ],
                )),
            Padding(
                padding: EdgeInsets.only(
                  bottom: 15,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "血液型",
                        style:
                            TextStyle(fontSize: 14, color: PRIMARY_FONT_COLOR),
                      ),
                    ),
                    Expanded(
                      child: appCubit.user.bloodType==""? 
                        Text(
                          "未設定",
                          style: const TextStyle(
                              fontSize: 14,
                              color:
                                  Color.fromARGB(255, 0, 202, 157)),
                        )
                      : Text(
                          appCubit.user.bloodType.toString(),
                          // appCubit.user.bodytype,
                          style: TextStyle(
                              fontSize: 14, color: Color.fromARGB(255, 155, 155, 155)),
                    )),
                  ],
                )),
            Padding(
                padding: EdgeInsets.only(
                  bottom: 15,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "利用目的",
                        style:
                            TextStyle(fontSize: 14, color: PRIMARY_FONT_COLOR),
                      ),
                    ),
                    Expanded(
                      child: appCubit.user.usePurpose==""? 
                        Text(
                          "未設定",
                          style: const TextStyle(
                              fontSize: 14,
                              color:
                                  Color.fromARGB(255, 0, 202, 157)),
                        )
                      : Text(
                          appCubit.user.usePurpose.toString(),
                          // appCubit.user.bodytype,
                          style: TextStyle(
                              fontSize: 14, color: Color.fromARGB(255, 155, 155, 155)),
                    )),
                  ],
                )),
            Padding(
                padding: EdgeInsets.only(
                  bottom: 15,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "年収",
                        style:
                            TextStyle(fontSize: 14, color: PRIMARY_FONT_COLOR),
                      ),
                    ),
                    Expanded(
                      child: appCubit.user.annualIncome==""? 
                        Text(
                          "未設定",
                          style: const TextStyle(
                              fontSize: 14,
                              color:
                                  Color.fromARGB(255, 0, 202, 157)),
                        )
                      : Text(
                          appCubit.user.annualIncome.toString(),
                          // appCubit.user.bodytype,
                          style: TextStyle(
                              fontSize: 14, color: Color.fromARGB(255, 155, 155, 155)),
                    )),
                  ],
                )),
            Padding(
                padding: EdgeInsets.only(
                  bottom: 15,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "タバコ",
                        style:
                            TextStyle(fontSize: 14, color: PRIMARY_FONT_COLOR),
                      ),
                    ),
                    Expanded(
                      child: appCubit.user.cigarette==""? 
                        Text(
                          "未設定",
                          style: const TextStyle(
                              fontSize: 14,
                              color:
                                  Color.fromARGB(255, 0, 202, 157)),
                        )
                      : Text(
                          appCubit.user.cigarette.toString(),
                          // appCubit.user.bodytype,
                          style: TextStyle(
                              fontSize: 14, color: Color.fromARGB(255, 155, 155, 155)),
                    )),
                  ],
                ))
          ],
        ));
  }
}
