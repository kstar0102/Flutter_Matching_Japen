import 'package:flutter/material.dart';
import 'package:matching_app/common.dart';
import 'package:matching_app/utile/index.dart';
import 'package:matching_app/bloc/cubit.dart';

// ignore: must_be_immutable
class IntroWidget extends StatelessWidget {
  bool? isEditScreen = false;
  String? introduce = "";
  IntroWidget({super.key, this.isEditScreen, this.introduce});
  
  @override
  Widget build(BuildContext context) {
    AppCubit appCubit = AppCubit.get(context);

    List<String> lines = appCubit.user.introduce?.split('\n').take(4).toList() ?? [];
    String shortText = lines.join('\n');

    return Padding(
        padding: EdgeInsets.only(
            bottom: vhh(context, 3),
            left: vww(context, 6),
            right: vww(context, 6)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text("自己紹介",
                    style: TextStyle(fontSize: 16, color: PRIMARY_FONT_COLOR))
                    ),
            Text(shortText??appCubit.intro_text,
                overflow: TextOverflow.ellipsis, // Show "..." if text overflows container
                maxLines: 4,
                style:
                    const TextStyle(fontSize: 13, color: PRIMARY_FONT_COLOR)),
            // isEditScreen == true
            //     ? Container()
                 
          ],
        ));
  }
}
