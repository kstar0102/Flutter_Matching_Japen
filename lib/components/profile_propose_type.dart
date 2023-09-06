import 'package:flutter/material.dart';
import 'package:matching_app/common.dart';
import 'package:matching_app/utile/index.dart';
import 'package:wheel_chooser/wheel_chooser.dart';
import 'package:matching_app/bloc/cubit.dart';

typedef OnPressed = void Function(bool state);


class ProfileInfoProposeType extends StatefulWidget {
	final String title, value;

	final bool isShowWheel;
	final OnPressed onPressed;
  final List<dynamic>? list;
	const ProfileInfoProposeType(
			{Key? key,
			required this.title,
			required this.value,
			required this.isShowWheel, required this.onPressed, this.list}): super(key: key);
  @override
  _ProfileInfoProposeTypeState createState() => _ProfileInfoProposeTypeState();
}

class _ProfileInfoProposeTypeState extends State<ProfileInfoProposeType> {
	@override
	Widget build(BuildContext context) {
    String purpose_id = "";
    String purpose_info = "";
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
																	// "未設定",
                                  appCubit.user.usePurpose,
																	style: TextStyle(
																			fontSize: 14, color: Color.fromARGB(255, 155, 155, 155)),
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
                          onValueChanged: (id) { purpose_info = widget.list![id].title.toString(); purpose_id = (widget.list![id].id).toString();},
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
                            if(purpose_info == "")
                            {
                              purpose_info = "真剣";
                            }
                            if(purpose_id == ""){
                              purpose_id = "1";
                            }
                          appCubit.changePurposeInfo(purpose_info, purpose_id.toString());
                          
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
