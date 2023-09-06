import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:matching_app/common.dart';
import 'package:matching_app/components/radius_button.dart';
import 'package:matching_app/components/Header.dart';
import 'package:matching_app/utile/index.dart';

// ignore: use_key_in_widget_constructors
class IdentityVerifyFailed extends StatefulWidget {
	@override
	// ignore: library_private_types_in_public_api
	_IdentityVerifyFailedState createState() => _IdentityVerifyFailedState();
}

class _IdentityVerifyFailedState extends State<IdentityVerifyFailed> {
	
	final ImagePicker imgpicker = ImagePicker();
	File? imagefile;
	openImages(source) async {
		try {
			var pickedFile = await imgpicker.pickImage(source: source);
			if (pickedFile != null) {
				final editedImage = await ImageCropper().cropImage(
						sourcePath: pickedFile.path,
						aspectRatio: const CropAspectRatio(
								ratioX: 1, ratioY: 1),
						compressQuality:
								80,
						maxWidth: 800,
						maxHeight: 800);
				if (editedImage != null) {
					// ignore: use_build_context_synchronously
					Navigator.pushNamed(context, "/image_check", arguments: editedImage.path);
				}
			} else {
				print("No image is selected.");
			}
		} catch (e) {
			print("error while picking file.");
		}
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
				backgroundColor: Colors.white,
				body: Container(
						constraints: BoxConstraints(
							minHeight: vh(context, 90),
						),
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								Padding(
									padding: EdgeInsets.only(top: vh(context, 2.5)),
									child: 
                  SizedBox(
                    width: vw(context, 100),
                    height: vh(context, 13),
                    child: Column(children: [
                      Expanded(child: Container()),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/identity_verify");
                            },
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.zero, iconColor: PRIMARY_FONT_COLOR),
                            child: const Icon(
                              Icons.arrow_back_ios,
                              size: 28,
                            ),
                          ),
                          Expanded(child: Container()),
                          Text("本人確認",
                              style:
                                  const TextStyle(color: PRIMARY_FONT_COLOR, fontSize: 17)),
                          Expanded(child: Container()),
                          const SizedBox(
                            width: 70,
                          )
                        ],
                      ),
                    ])),
								),
                SizedBox(height: 30,),
								Padding(
									padding: EdgeInsets.only(
											left: vw(context, 3),
											right: vw(context, 3),
											top: vh(context, 2)),
									child: Container(
										decoration: BoxDecoration(
											borderRadius: BorderRadius.circular(10.0),
											color: const Color.fromARGB(255, 228, 249, 244),
										),
										width: double.infinity,
										child: Padding(
												padding: EdgeInsets.only(top: vh(context, 2)),
												child: Column(children: [
                          Padding(
														padding:
																EdgeInsets.symmetric(vertical: vh(context, 2)),
														child: Image(
																image: const AssetImage(
																		"assets/images/identity/warning.png"),
																width: vw(context, 15.844),
																height: vw(context, 10)),
													),
                          
                          Padding(
                            padding: EdgeInsets.only(left: 10,right: 10),
                            child: 
                              Center(
                                child: Text("ご提出いただいた公的書類では審査が完了できませんでした以下の点に注意して再度ご提出お願いいたします",
                                        style:
                                        TextStyle(color: Colors.black, fontSize: vhh(context, 1.5)),
                                        textAlign: TextAlign.center,),
                              )
                          ),
                          SizedBox(height: 50,),
												])),
									),
								),
                SizedBox(height: 20,),
								Padding(
										padding: EdgeInsets.symmetric(
												horizontal: vw(context, 3), vertical: vh(context, 2)),
										child: Center(
                      child: Text(
											"以下のような画像は認証されません",
											textAlign: TextAlign.center,
											style: TextStyle(
													fontSize: 13, color: PRIMARY_FONT_COLOR),
										  )
                    ) ),
								Stack(children: [
									Padding(
										padding: EdgeInsets.only(
												left: vw(context, 3),
												right: vw(context, 3),
												top: vh(context, 1)),
										child: Container(
												decoration: BoxDecoration(
													borderRadius: BorderRadius.circular(10.0),
												),
												width: double.infinity,
												child: Padding(
														padding: EdgeInsets.symmetric(
																vertical: vh(context, 1),
																horizontal: vw(context, 1)),
														child: Row(
                              children: [
                                Column(
                                  children: [
                                    Image(
                                      image: const AssetImage(
                                          "assets/images/identity/iden1.png"),
                                      ),
                                    Center(
                                      child: Text("不透明で\n読み取れない",
                                      style: TextStyle(
													              fontSize: 10, ), textAlign: TextAlign.center,),
                                    )
                                  ],
                                ),
                                
                                SizedBox(width: 10,),
                                Column(
                                  children: [
                                    Image(
                                      image: const AssetImage(
                                          "assets/images/identity/iden2.png"),
                                      ),
                                    Center(
                                      child: Text("画像が\n見切れている",
                                      style: TextStyle(
													              fontSize: 10, ), textAlign: TextAlign.center,),
                                    )
                                  ],
                                ),
                                SizedBox(width: 10,),
                                Column(
                                  children: [
                                    Stack(
                                      children: [
                                        Image.asset("assets/images/identity/iden3.png"),
                                        Positioned.fill(
                                          child: 
                                              Padding(padding: EdgeInsets.only(left: 60,top:10),
                                              child: Image.asset("assets/images/identity/line.png"),
                                            )
                                        ),
                                      ],
                                    ),
                                    Center(
                                      child: Text("隠されている\n部分がある",
                                      style: TextStyle(
													              fontSize: 10, ), textAlign: TextAlign.center,),
                                    )
                                  ],
                                ),
                              ],
                            ))),
									),
								]),
								Expanded(
									child: Container(),
								),
								Padding(
										padding: EdgeInsets.symmetric(
												horizontal: getDeviceWidth(context) / 47 * 3),
										child: SizedBox(
												width: MediaQuery.of(context).size.width,
												child: Align(
													alignment: Alignment.center,
													child: RadiusButton(
														id: 0,
														color: BUTTON_MAIN,
														text: "再審査する",
														goNavigation: (id) {
															Navigator.pushNamed(context, "/identity_verify");
														},
														isDisabled: false,
													),
												))),
                SizedBox(height: 20,)
							],
						)));
	}
}
