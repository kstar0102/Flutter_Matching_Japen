import 'package:flutter/material.dart';
import 'package:matching_app/common.dart';
import 'package:matching_app/utile/index.dart';
import 'package:wheel_chooser/wheel_chooser.dart';
import 'package:matching_app/bloc/cubit.dart';

typedef OnPressed = void Function(bool state);


class ProfileCigaType extends StatefulWidget {
	final String title, value;

	final bool isShowWheel;
	final OnPressed onPressed;
  final List<dynamic>? list;
	const ProfileCigaType(
			{Key? key,
			required this.title,
			required this.value,
			required this.isShowWheel, required this.onPressed, this.list}): super(key: key);

  @override
  _ProfileCigaTypeState createState() => _ProfileCigaTypeState();
}

class _ProfileCigaTypeState extends State<ProfileCigaType> {
	@override
	Widget build(BuildContext context) {
    String ciga = "";
    AppCubit appCubit = AppCubit.get(context);
		return Container(
				decoration: const BoxDecoration(
					border: Border(
						bottom: BorderSide(
							color: Color.fromARGB(255, 237, 237, 237),
							width: 2.0,
						),
					),
				),
				padding: const EdgeInsets.symmetric(vertical: 5),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Padding(
								padding: const EdgeInsets.only(bottom: 7, top: 7),
								child: Row(
									children: [
										Expanded(
											flex: 3,
											child: Text(
												widget.title,
												style: const TextStyle(
														fontSize: 14, color: PRIMARY_FONT_COLOR),
											),
										),
										Expanded(
											flex: 2,
											child: GestureDetector(
													onTap: () {
														widget.onPressed(!widget.isShowWheel);
													},
													child: widget.value != ""
															? Text(
																	widget.value,
																	style: const TextStyle(
																			fontSize: 14,
																			color:
																					Color.fromARGB(255, 155, 155, 155)),
																)
															: Text(
                                  "未設定",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: BUTTON_MAIN,
                                  ),)),
										),
									],
								)),
						widget.isShowWheel == true
								? Column(
                    children: [
                      SizedBox(
                        height: 150,
                        width: vww(context, 100),
                        child: WheelChooser.custom(
                          onValueChanged: (id) { ciga = widget.list![id];},
                          children: List.generate(
                            widget.list!.length,
                            (index) {
                              return Text(widget.list![index]);
                            },
                          ),
                        ),
                      ),

                      // Add your button here
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            widget.onPressed(false);
                          });
                           if(ciga == "")
                          {
                            ciga = "選択しない";
                          }
                          appCubit.changeCiga(ciga);
                          
                        },
                        child: Text('保管'),
                      ),
                    ],
                  )
								: Container()
					],
				));
	}
}
