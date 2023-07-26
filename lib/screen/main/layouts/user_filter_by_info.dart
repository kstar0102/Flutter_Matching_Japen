import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matching_app/common.dart';
import 'package:matching_app/components/filter_badges.dart';
import 'package:matching_app/screen/main/layouts/users_bottom_modal.dart';
import 'package:matching_app/utile/index.dart';
import 'package:matching_app/bloc/cubit.dart';

class UserFilterByInfo extends StatefulWidget {
  final String info_id;
  final String live_info;
  const UserFilterByInfo({super.key,  required this.info_id, required this.live_info, });

  @override
  // ignore: library_private_types_in_public_api
  _UserFilterByInfoState createState() => _UserFilterByInfoState();
}

class _UserFilterByInfoState extends State<UserFilterByInfo> {
  // ignore: constant_identifier_names
  String get liveInfo => widget.live_info;
  static const double MIN_AGE = 18,
      // ignore: constant_identifier_names
      MAX_AGE = 60,
      // ignore: constant_identifier_names
      MIN_HEIGHT = 130,
      // ignore: constant_identifier_names
      MAX_HEIGHT = 210;
  double sliderValue = 18;
  // ignore: non_constant_identifier_names
  RangeValues _age_values = const RangeValues(18, 60);
  // ignore: non_constant_identifier_names
  RangeValues _height_values = const RangeValues(130, 210);

  List<BodyTypeObject> bodyTypes = [];
  List<dynamic> selectedBody = [];

  List<Map<String, dynamic>> holidays = [
    {"isChecked": false, "text": "平日"},
      {"isChecked": false, "text": "土日"},
    {"isChecked": false, "text": "祝日"},
    {"isChecked": false, "text": "不定期"},
  ];

  List<dynamic> selectedHoliday = [];

  List<PurposeTypeObject> purposes = [];

  List<dynamic> selectedPurpose = [];

  List<Map<String, dynamic>> cigarettes = [
    {"isChecked": false, "text": "吸わない"},
    {"isChecked": false, "text": "たまに"},
    {"isChecked": false, "text": "吸う"},
  ];

  List<dynamic> selectedCigarettes = [];

  List<Map<String, dynamic>> sake = [
    {"isChecked": false, "text": "飲まない"},
    {"isChecked": false, "text": "たまに"},
    {"isChecked": false, "text": "飲む"},
  ];

  List<dynamic> selectedSake = [];

  bool _isVerifyChecked = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AppCubit>(context).fetchBodyTypeList();
    BlocProvider.of<AppCubit>(context).fetchPurposeList();
  }

  final RoundedRectangleBorder roundedRectangleBorder = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
  );
  @override
  Widget build(BuildContext context) {
    AppCubit appCubit = AppCubit.get(context);
   return BlocBuilder<AppCubit, AppState>(builder: (context, state) {
    return Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(
              horizontal: vww(context, 3), vertical: vhh(context, 3)),
          child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                  delegate: SliverChildBuilderDelegate(
                childCount: 1,
                (context, index) {
                  return Column(
                    children: [
                      SizedBox(
                          width: vw(context, 100),
                          height: vhh(context, 10),
                          child: Column(children: [
                            Expanded(child: Container()),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    alignment: Alignment.centerLeft,
                                    width: 100,
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          iconColor: PRIMARY_FONT_COLOR),
                                      child: const Icon(
                                        Icons.arrow_back_ios,
                                        size: 28,
                                      ),
                                    )),
                                const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    child: Column(
                                      children: [
                                        Text("検索条件",
                                            style: TextStyle(
                                                color: PRIMARY_FONT_COLOR,
                                                fontSize: 14))
                                      ],
                                    )),
                                const SizedBox(
                                  width: 100,
                                  child: Text("条件をリセット",
                                      style: TextStyle(
                                          fontSize: 14, color: BUTTON_MAIN)),
                                )
                              ],
                            ),
                          ])),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: vww(context, 3)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("年齢",
                                      style: TextStyle(
                                          color: PRIMARY_FONT_COLOR,
                                          fontSize: 14)),
                                  Text('${_age_values.start.toInt()} - ${_age_values.end.toInt()}',
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 155, 155, 155),
                                          fontSize: 17))
                                ],
                              )),
                          RangeSlider(
                            min: MIN_AGE,
                            max: MAX_AGE,
                            activeColor: const Color.fromARGB(255, 0, 199, 155),
                            inactiveColor:
                                const Color.fromARGB(255, 239, 239, 239),
                            values: _age_values,
                            onChanged: (RangeValues value) {
                              setState(() {
                                _age_values = value;
                              });
                            },
                          ),
                          const SizedBox(height: 10),
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: vww(context, 3)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("身長",
                                      style: TextStyle(
                                          color: PRIMARY_FONT_COLOR,
                                          fontSize: 14)),
                                  Text('${_height_values.start.toInt().toString()} ~ ${_height_values.end.toInt()}',
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 155, 155, 155),
                                          fontSize: 17))
                                ],
                              )),
                          RangeSlider(
                            min: MIN_HEIGHT,
                            max: MAX_HEIGHT,
                            activeColor: const Color.fromARGB(255, 0, 199, 155),
                            inactiveColor:
                                const Color.fromARGB(255, 239, 239, 239),
                            values: _height_values,
                            onChanged: (RangeValues value) {
                              setState(() {
                                _height_values = value;
                              });
                            },
                          ),
                          const SizedBox(height: 10),
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: vww(context, 3)),
                              child:  Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("居住地",
                                      style: TextStyle(
                                          color: PRIMARY_FONT_COLOR,
                                          fontSize: 14)),
                                  SizedBox(
                                    width: 150,
                                    child: Text(
                                      liveInfo == "[]"?"":liveInfo,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Color.fromARGB(
                                              255, 155, 155, 155)),
                                    ),
                                  )
                                ],
                              )),
                          const SizedBox(height: 10),
                          Padding( padding: EdgeInsets.only(
                                  left:12),
                            child: Column(children: [
                            SizedBox(
                                child:Text("体型"),),
                            ])
                          ),
                          Padding( padding: EdgeInsets.only(
                                  left:12),
                            child: Column(children: [
                              Wrap(
                                spacing: 4,
                                runSpacing: -8,
                                children: appCubit.bodyTypeList.map((BodyTypeObject e) {
                                  return FilterChip(
                                      label: Text(e.title,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: e.isChecked
                                                  ? Colors.white
                                                  : BUTTON_MAIN)),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        side: const BorderSide(
                                            color: BUTTON_MAIN, width: 1.0),
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      backgroundColor:
                                          e.isChecked ? BUTTON_MAIN : Colors.white,
                                      selectedColor: BUTTON_MAIN,
                                    onSelected: (isSelected) => setState(() {
                                      e.isChecked = !e.isChecked;
                                      if (e.isChecked) {
                                        selectedBody.add(e.title);
                                      } else {
                                        selectedBody.remove(e.title);
                                      }
                                      print(selectedBody);
                                    }));
                              }).toList()),
                            ]),        
                          ),
                          const SizedBox(height: 10),
                          FilterBadges(
                            text: "休日",
                            onChanged: (List<Map<String, dynamic>> list) {
                              setState(() {
                                holidays = list;
                                
                                // Clear the selectedHoliday array before adding new values
                                selectedHoliday.clear();
                                
                                // Add the text values for which isChecked is true to the selectedHoliday array
                                for (var holiday in holidays) {
                                  if (holiday['isChecked']) {
                                    selectedHoliday.add(holiday['text']);
                                  }
                                }
                                
                                print(selectedHoliday);
                              });
                            },
                            list: holidays,
                          ),
                          const SizedBox(height: 10),
                          Padding( padding: EdgeInsets.only(
                                  left:12),
                            child: Column(children: [
                            SizedBox(
                                child:Text("利用目的"),),
                            ])
                          ),
                          Padding( padding: EdgeInsets.only(
                                  left:12),
                            child: Column(children: [
                              Wrap(
                                spacing: 4,
                                runSpacing: -8,
                                children: appCubit.purposeList.map((PurposeTypeObject e) {
                                  return FilterChip(
                                      label: Text(e.title,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: e.isChecked
                                                  ? Colors.white
                                                  : BUTTON_MAIN)),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        side: const BorderSide(
                                            color: BUTTON_MAIN, width: 1.0),
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      backgroundColor:
                                          e.isChecked ? BUTTON_MAIN : Colors.white,
                                      selectedColor: BUTTON_MAIN,
                                    onSelected: (isSelected) => setState(() {
                                      e.isChecked = !e.isChecked;
                                      if (e.isChecked) {
                                        selectedPurpose.add(e.id);
                                      } else {
                                        selectedPurpose.remove(e.id);
                                      }
                                      print(selectedPurpose);
                                    }));
                              }).toList()),
                            ]),        
                          ),
                          
                          const SizedBox(height: 10),
                          FilterBadges(
                            text: "タバコ",
                            onChanged: (List<Map<String, dynamic>> list) {
                              setState(() {
                                cigarettes = list;
                                
                                // Clear the selectedHoliday array before adding new values
                                selectedCigarettes.clear();
                                
                                // Add the text values for which isChecked is true to the selectedHoliday array
                                for (var ciga in cigarettes) {
                                  if (ciga['isChecked']) {
                                    selectedCigarettes.add(ciga['text']);
                                  }
                                }
                                
                                print(selectedCigarettes);
                              });
                            },
                            list: cigarettes,
                          ),
                          
                          const SizedBox(height: 10),

                          FilterBadges(
                            text: "お酒",
                            onChanged: (List<Map<String, dynamic>> list) {
                              setState(() {
                                sake = list;
                                
                                // Clear the selectedHoliday array before adding new values
                                selectedSake.clear();
                                
                                // Add the text values for which isChecked is true to the selectedHoliday array
                                for (var sakes in sake) {
                                  if (sakes['isChecked']) {
                                    selectedSake.add(sakes['text']);
                                  }
                                }
                                
                                print(selectedSake);
                              });
                            },
                            list: sake,
                          ),
                          const SizedBox(height: 10),
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: vww(context, 3)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "本人確認しているユーザーのみ",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: PRIMARY_FONT_COLOR),
                                  ),
                                  Switch(
                                    value: _isVerifyChecked,
                                    activeColor: Colors.green,
                                    onChanged: (value) {
                                      setState(() {
                                        _isVerifyChecked = value;
                                        // Perform some action based on whether the switch is on or off
                                      });
                                      print(_isVerifyChecked);
                                    },
                                  )
                                ],
                              ))
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      )
                    ],
                  );
                },
              ))
            ],
          ),
        ),
        floatingActionButton: Container(
            padding: EdgeInsets.only(left: vww(context, 10)),
            alignment: Alignment.bottomCenter,
            width: vww(context, 100),
            child: SizedBox(
              width: 200,
              child: TextButton(
                  onPressed: () {
                    String age_start = _age_values.start.toInt().toString();
                    String age_end = _age_values.end.toInt().toString();
                    String height_start= _height_values.start.toInt().toString();
                    String height_end = _height_values.end.toInt().toString();
                    String body_value = selectedBody.toString() == []?"":selectedBody.toString();
                    String bodyNamesString = body_value;
                    bodyNamesString = bodyNamesString.substring(1, bodyNamesString.length - 1);
                    bodyNamesString = bodyNamesString.split(',').map((e) => e.trim()).join(',');
                    String holi_value = selectedHoliday.toString() == []?"":selectedHoliday.toString();
                    String holidayString = holi_value;
                    holidayString = holidayString.substring(1, holidayString.length - 1);
                    holidayString = holidayString.split(',').map((e) => e.trim()).join(',');
                    String purpose_value = selectedPurpose.toString() == []?"":selectedPurpose.toString();
                    String purposeString = purpose_value;
                    purposeString = purposeString.substring(1, purposeString.length - 1);
                    purposeString = purposeString.split(',').map((e) => e.trim()).join(',');

                    String ciga_value = selectedCigarettes.toString() == []?"":selectedCigarettes.toString();
                    String cigaString = ciga_value;
                    cigaString = cigaString.substring(1, cigaString.length - 1);
                    cigaString = cigaString.split(',').map((e) => e.trim()).join(',');
                    
                    String sake_value = selectedSake.toString() == []?"":selectedSake.toString();
                    String sakeString = sake_value;
                    sakeString = sakeString.substring(1, sakeString.length - 1);
                    sakeString = sakeString.split(',').map((e) => e.trim()).join(',');

                    String live_value = liveInfo.toString() == []?"":liveInfo.toString();
                    String liveString = live_value;
                    liveString = liveString.substring(1, liveString.length - 1);
                    liveString = liveString.split(',').map((e) => e.trim()).join(',');

                    String verifyCheck = _isVerifyChecked == false?"0":"1";
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(25),
                          ),
                        ),
                        builder: (context) {
                          appCubit.searchFilter(age_start,age_end,height_start,height_end,bodyNamesString.toString(),holidayString.toString(),purposeString.toString(),cigaString.toString(),sakeString.toString(), liveString.toString(), verifyCheck.toString());
                              
                          return UsersBottomModal(sub_id: widget.info_id);
                        });
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all(BUTTON_MAIN)),
                  child: const Text(
                    "検索",
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  )),
            )));
   });
  }
}
