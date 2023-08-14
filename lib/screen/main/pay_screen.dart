import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:matching_app/common.dart';
import 'package:matching_app/screen/main/layouts/setting_header.dart';
import 'package:matching_app/utile/index.dart';

import '../../../bloc/cubit.dart';

// ignore: use_key_in_widget_constructors
class PayScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _PayScreenState createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen>
    with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    AppCubit appCubit = AppCubit.get(context);
    final List _value = [appCubit.user.private_age =="1"?true:false,appCubit.user.private_matching=="1"?true:false];

    void payVaildation(int month) async{

      DateTime now = DateTime.now();

      // Add 3 months to the current month
      DateTime resultDate = DateTime(now.year, now.month + month, now.day);

      // Check if the resulting month has fewer days
      if (resultDate.day != now.day) {
        // Adjust the date to the first day of the next month
        resultDate = DateTime(resultDate.year, resultDate.month + 1, 1);
      }

      appCubit.doPayment(month, resultDate);
      Navigator.pushNamed(context, "/profile_screen");
    }

    return BlocBuilder<AppCubit, AppState>(builder: (context, state) {
      return Scaffold(
        backgroundColor: Color.fromARGB(255, 240, 255, 251),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverPersistentHeader(
                delegate: SettingHeader("有料プランの紹介"), pinned: true),
            SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
              return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: vww(context, vww(context, 1))),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10,right: 10),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Color.fromARGB(255, 0, 202, 157), width: 10),
                          ),
                          child: Center(
                            child: Column(children: [
                              Text(
                                '超特価',
                                style: TextStyle(fontSize: 24, color: Color.fromARGB(255, 0, 202, 157), fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'SALE',
                                style: TextStyle(fontSize: 40, color: Color.fromARGB(255, 0, 202, 157), fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '1ヶ月',
                                style: TextStyle(fontSize: 24, color: Color.fromARGB(255, 0, 202, 157), fontWeight: FontWeight.bold),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 30,right: 30),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Color.fromARGB(255, 0, 202, 157), width: 10),
                                    color: Color.fromARGB(255, 0, 202, 157),
                                  ),
                                  child: Center(
                                    child:Text(
                                      'ワンコイン',
                                      style: TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ))
                                ),
                                Text(
                                  '12ヶ月プランの場合',
                                  style: TextStyle(fontSize: 12, color: Color.fromARGB(255, 0, 202, 157), fontWeight: FontWeight.bold),
                                ),
                            ],)
                          ),
                        ),
                      ),
                      SizedBox(height: 25,),
                      Padding(
                        padding: EdgeInsets.only(left: 10,right: 10),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Color.fromARGB(255, 239, 254, 250), width: 1),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(255, 219, 219, 219).withOpacity(1),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 2), // changes position of shadow
                              ),
                            ],
                          ),
                          
                          child: Center(
                            child: Row(children: [
                              Container(
                                width: MediaQuery.of(context).size.width/5.5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Colors.red, width: 1),
                                  color: Colors.red,
                                ),
                                child: Center(
                                  child: Column(children: [
                                    SizedBox(height: 5,),
                                    Text(
                                      '72%',
                                      style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 5,),
                                    Text(
                                      'OFF',
                                      style: TextStyle(fontSize: 17, color: Colors.white),
                                    ),
                                    SizedBox(height: 5,),
                                  ]),),
                              ),
                              Container(
                                child: InkWell(
                                  onTap: (){
                                    int month= 12;
                                    payVaildation(month);
                                  },
                                  child: Column(children: [
                                    SizedBox(height: 5, width: 1,),
                                    Text(
                                      '12ヶ月プラン',
                                      style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10,right: 10),
                                      child:Container(
                                        child:Row(
                                          children: [
                                            Text(
                                              '¥',
                                              style: TextStyle(fontSize: 17, color: Colors.black),
                                            ),
                                            Text(
                                              ' 6,000 ',
                                              style: TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              '/ 1ヶ月',
                                              style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(width: 10,),
                                            Text(
                                              '¥ 500',
                                              style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        )
                                      )
                                    )
                                ]),
                                )
                                ),
                            ],)
                          ),
                        ),
                      ),
                      SizedBox(height: 25,),
                      Padding(
                        padding: EdgeInsets.only(left: 10,right: 10),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Color.fromARGB(255, 239, 254, 250), width: 1),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(255, 219, 219, 219).withOpacity(1),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 2), // changes position of shadow
                              ),
                            ],
                          ),
                          
                          child: Center(
                            child: Row(children: [
                              Container(
                                width: MediaQuery.of(context).size.width/5.5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Colors.red, width: 1),
                                  color: Colors.red,
                                ),
                                child: Center(
                                  child: Column(children: [
                                    SizedBox(height: 5,),
                                    Text(
                                      '55%',
                                      style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 5,),
                                    Text(
                                      'OFF',
                                      style: TextStyle(fontSize: 17, color: Colors.white),
                                    ),
                                    SizedBox(height: 5,),
                                  ]),),
                              ),
                              Container(
                                child: InkWell(
                                  onTap: (){
                                    int month= 6;
                                    payVaildation(month);
                                  },
                                  child: Column(children: [
                                    SizedBox(height: 5, width: 1,),
                                    Text(
                                      '6ヶ月プラン',
                                      style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10,right: 10),
                                      child:Container(
                                        child:Row(
                                          children: [
                                            Text(
                                              '¥',
                                              style: TextStyle(fontSize: 17, color: Colors.black),
                                            ),
                                            Text(
                                              ' 4,800 ',
                                              style: TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              '/ 1ヶ月',
                                              style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(width: 10,),
                                            Text(
                                              '¥ 800',
                                              style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        )
                                      )
                                    )
                                ]),
                                )
                                ),
                            ],)
                          ),
                        ),
                      ),
                      SizedBox(height: 25,),
                      Padding(
                        padding: EdgeInsets.only(left: 10,right: 10),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Color.fromARGB(255, 239, 254, 250), width: 1),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(255, 219, 219, 219).withOpacity(1),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 2), // changes position of shadow
                              ),
                            ],
                          ),
                          
                          child: Center(
                            child: Row(children: [
                              Container(
                                width: MediaQuery.of(context).size.width/5.5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Colors.red, width: 1),
                                  color: Colors.red,
                                ),
                                child: Center(
                                  child: Column(children: [
                                    SizedBox(height: 5,),
                                    Text(
                                      '44%',
                                      style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 5,),
                                    Text(
                                      'OFF',
                                      style: TextStyle(fontSize: 17, color: Colors.white),
                                    ),
                                    SizedBox(height: 5,),
                                  ]),),
                              ),
                              Container(
                                child: InkWell(
                                  onTap: (){
                                     int month= 3;
                                      payVaildation(month);
                                  },
                                  child: Column(children: [
                                    SizedBox(height: 5, width: 1,),
                                    Text(
                                      '3ヶ月プラン',
                                      style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10,right: 10),
                                      child:Container(
                                        child:Row(
                                          children: [
                                            Text(
                                              '¥',
                                              style: TextStyle(fontSize: 17, color: Colors.black),
                                            ),
                                            Text(
                                              ' 3,000 ',
                                              style: TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              '/ 1ヶ月',
                                              style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(width: 10,),
                                            Text(
                                              '¥ 100',
                                              style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        )
                                      )
                                    )
                                ]),
                                )
                                ),
                            ],)
                          ),
                        ),
                      ),
                      SizedBox(height: 30,),
                      Text(
                        '1ヶ月プラン 1,800円/月',
                        style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 0, 202, 157), fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 80,),
                      Text("このキャンペーンの超特価セールは2023年12月30日 になります。\n有料会員のフルバージョンは自動更新サービスなので、料金はお客様のios端末場合はiTunesアカウント、Androidの場合はGooglePlayで自動的に引き出します。 \n顧客はiTunesストアの設定ページで自動ドロップをキャンセルできます。\n 2.自動更新の解約をご希望の場合は、自動更新日の24時間以上前に終了手続きを行ってください。 キャンセル手順が完了していない場合、動的に契約が更新されます。\n 3. クリックして購入すると「個人情報保護方針」「規約」に同意したということです。\n 4.文字同更新日前に終了の手続きをした場合、残期間の働き月で返金しません。",style: TextStyle(fontSize: 15, color: Color.fromARGB(255, 160, 160, 160)),),
                      SizedBox(height: 50,),
                    ],
                  ));
            }, childCount: 1)),
          ],
        ));
    });
  }
}
