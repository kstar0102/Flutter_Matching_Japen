import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:matching_app/common.dart';
import 'package:matching_app/utile/index.dart';
import 'package:matching_app/bloc/cubit.dart';

// ignore: must_be_immutable
class EditAvatarWidget extends StatelessWidget {
  final dynamic item;
  final dynamic item_id;

  final ImagePicker imgpicker = ImagePicker();
  File? imagefile;

  EditAvatarWidget({Key? key, required this.item, required this.item_id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppCubit appCubit = AppCubit.get(context);
    // return BlocBuilder<AppCubit, AppState>(builder: (context, state) {
    return FractionallySizedBox(
        widthFactor: 0.3,
        child: InkWell(
            child: item == "http://192.168.142.55:8000//uploads/null"
                ? GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return SizedBox(
                              height: 150,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  InkWell(
                                      onTap: () async{
                                        try {
                                        var pickedFile = await imgpicker.pickImage(
                                            source: ImageSource.camera);
                                        if (pickedFile != null) {
                                          final editedImage = await ImageCropper()
                                              .cropImage(
                                                  sourcePath: pickedFile.path,
                                                  aspectRatio: const CropAspectRatio(
                                                      ratioX: 1,
                                                      ratioY:
                                                          1), // Set the desired aspect ratio
                                                  compressQuality:
                                                      80, // Adjust the compressed image quality as per your needs
                                                  maxWidth:
                                                      800, // Adjust the maximum width of the cropped image
                                                  maxHeight: 800);
                                          if (editedImage != null) {
                                            appCubit.changeMultiAvatar(editedImage.path,item_id);
                                          }
                                        } 
                                      } catch (e) {
                                        print("error while picking file.");
                                      }
                                      },
                                      child: Row(
                                        children: [
                                          SizedBox(
                                              width: vw(context, 3),
                                              height: 10),
                                          
                                          const Image(
                                            image: AssetImage(
                                                "assets/images/identity/photo-camera-svgrepo-com.png"),
                                            height: 30,
                                          ),
                                          const Padding(
                                              padding:
                                                  EdgeInsets.only(left: 30),
                                              child: Text("写真を撮る",
                                                  style:
                                                      TextStyle(fontSize: 17)))
                                        ],
                                      )),
                                  InkWell(
                                      onTap: () async{
                                        try {
                                        var pickedFile = await imgpicker.pickImage(
                                            source: ImageSource.gallery);
                                        if (pickedFile != null) {
                                          final editedImage = await ImageCropper()
                                              .cropImage(
                                                  sourcePath: pickedFile.path,
                                                  aspectRatio: const CropAspectRatio(
                                                      ratioX: 1,
                                                      ratioY:
                                                          1), // Set the desired aspect ratio
                                                  compressQuality:
                                                      80, // Adjust the compressed image quality as per your needs
                                                  maxWidth:
                                                      800, // Adjust the maximum width of the cropped image
                                                  maxHeight: 800);
                                          if (editedImage != null) {
                                            appCubit.changeMultiAvatar(editedImage.path, item_id);
                                          }
                                        } 
                                      } catch (e) {
                                        print("error while picking file.");
                                      }
                                      },
                                      child: Row(
                                        children: [
                                          SizedBox(
                                              width: vw(context, 3),
                                              height: 10),
                                          const Image(
                                            image: AssetImage(
                                                "assets/images/identity/imagesmajor-svgrepo-com.png"),
                                            height: 30,
                                          ),
                                          const Padding(
                                              padding:
                                                  EdgeInsets.only(left: 30),
                                              child: Text("写真を撮る",
                                                  style:
                                                      TextStyle(fontSize: 17)))
                                        ],
                                      )),
                                  const SizedBox(height: 1)
                                ],
                              ),
                            );
                          });
                    },
                    child: Container(
                      height: 110,
                      width: 100,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(255, 190, 189, 198),
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(children: [
                        Container(
                          child: appCubit.avatarImages.length > 0 && !appCubit.avatarImages[item_id].isEmpty
                            ?  ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.file(File(appCubit.avatarImages[item_id]),
                                    fit: BoxFit.cover, height: 108,),
                              )
                            
                            : Column(children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 22),
                                  child:Image(
                                    image: AssetImage(
                                      "assets/images/main/icons-tabbar-discover.png"),
                                  width: 50,
                                ),
                            ),
                            Text("写真"+(item_id+1).toString(), style: TextStyle(
                                      fontSize: 11, color: PRIMARY_FONT_COLOR)),
                            ]),
                        ),
                      ]),
                    ))
                : Container(
                    width: 100,
                    height: 110,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(255, 190, 189, 198),
                        width: 1.0,
                      ),
                      color: PRIMARY_FONT_COLOR,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(
                        "${item}",
                        fit: BoxFit.cover,
                      ),
                    ))));
    // });
  }
}
