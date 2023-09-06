import 'package:flutter/material.dart';
import 'package:matching_app/common.dart';
import 'package:matching_app/utile/index.dart';
import 'package:wheel_chooser/wheel_chooser.dart';
import 'package:matching_app/bloc/cubit.dart';

typedef OnPressed = void Function(bool state);


class ProfileInfoBodyType extends StatefulWidget {
	final String title, value;

	final bool isShowWheel;
	final OnPressed onPressed;
  final List<dynamic>? list;
	const ProfileInfoBodyType(
			{Key? key,
			required this.title,
			required this.value,
			required this.isShowWheel, required this.onPressed, this.list}): super(key: key);
  @override
  _ProfileInfoBodyTypeState createState() => _ProfileInfoBodyTypeState();
}

class _ProfileInfoBodyTypeState extends State<ProfileInfoBodyType> {
	@override
	Widget build(BuildContext context) {
    String body_info = "";
    String body_id = "";
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
                                  // appCubit.user.bodytype,
																	style: TextStyle(
																			fontSize: 14, color: Color.fromARGB(255, 0, 202, 157)),
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
                          onValueChanged: (id) { body_info = widget.list![id].title.toString(); body_id = (widget.list![id].id).toString();},
                          children: List.generate(
                            widget.list!.length,
                            (index) {
                              return Text(widget.list![index].title);
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
                          if(body_info == "")
                          {
                            body_info = "細め";
                          }
                          if(body_id == ""){
                            body_id = "1";
                          }
                          appCubit.changeBody(body_info, body_id.toString());
                          
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
