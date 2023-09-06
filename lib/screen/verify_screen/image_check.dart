import 'dart:io';

// ignore: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:matching_app/bloc/cubit.dart';
import 'package:matching_app/common.dart';
import 'package:matching_app/components/radius_button.dart';
import 'package:matching_app/components/Header.dart';
import 'package:matching_app/utile/index.dart';

// import 'package:flutter_redux/flutter_redux.dart';
// ignore: use_key_in_widget_constructors
class ImageCheck extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _ImageCheckState createState() => _ImageCheckState();
}

class _ImageCheckState extends State<ImageCheck> {
  File? imagefile;
  final ImagePicker imgpicker = ImagePicker();
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
    Object? imagePath = ModalRoute.of(context)!.settings.arguments;
    imagefile = File(imagePath.toString());
    AppCubit appCubit = AppCubit.get(context);
    return BlocBuilder<AppCubit, AppState>(builder: (context, state) {
      return Scaffold(
          backgroundColor: Colors.white,
          body: Container(
              constraints: BoxConstraints(
                minHeight: vh(context, 90), // Set the minimum height here
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: vh(context, 2.5)),
                    child: const HeaderWidget(title: "本人確認"),
                  ),
                  Center(
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: vw(context, 5),
                              vertical: vh(context, 10)),
                          child: SizedBox(
                            height: vh(context, 30),
                            width: double.infinity,
                            child: Image.file(
                              imagefile!,
                              fit: BoxFit.cover,
                            ),
                          ))),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: vw(context, 3)),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Align(
                        alignment: Alignment.center,
                        child: RadiusButton(
                          id: 0,
                          color: BUTTON_MAIN,
                          text: "提出",
                          goNavigation: (id) {
                            appCubit
                                .uploadIdentifyImage(imagePath.toString())
                                .then((value) => {
                                      print("asdasd"+value.toString()),
                                      if (value == 1)
                                        {
                                          Navigator.pushNamed(
                                              context, "/image_submit")
                                        }
                                    });
                          },
                          isDisabled: false,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: getDeviceWidth(context) / 47 * 3),
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: InkWell(
                              onTap: () { openImages(ImageSource.gallery);},
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      top: vh(context, 2),
                                      bottom: vh(context, 3)),
                                  child: const Text("撮り直す",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Color.fromARGB(
                                              255, 0, 202, 157))))))),
                ],
              )));
    });
  }
}
