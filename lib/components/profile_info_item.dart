import 'package:flutter/material.dart';
import 'package:matching_app/common.dart';
import 'package:matching_app/utile/index.dart';
import 'package:wheel_chooser/wheel_chooser.dart';
import 'package:matching_app/bloc/cubit.dart';

typedef OnPressed = void Function(bool state);


class ProfileInfoItem extends StatefulWidget {
	final String title, value;

	final bool isShowWheel;
	final OnPressed onPressed;
  final List<dynamic>? list;
	const ProfileInfoItem(
			{super.key,
			required this.title,
			required this.value,
			required this.isShowWheel, required this.onPressed, this.list});

  @override
  _ProfileInfoItemState createState() => _ProfileInfoItemState();
}

class _ProfileInfoItemState extends State<ProfileInfoItem> {
	@override
	Widget build(BuildContext context) {
    String al_info = "";
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
																			fontSize: 14, color: BUTTON_MAIN),
																)),
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
                          onValueChanged: (id) { al_info = widget.list![id];},
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
                          if(al_info == "")
                          {
                            al_info = "選択しない";
                          }
                          appCubit.changeAlcohol(al_info);
                          
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
