import 'package:flutter/material.dart';
import 'package:matching_app/common.dart';
import 'package:matching_app/utile/index.dart';
import 'package:matching_app/screen/main/setting/board_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matching_app/controller/auth_controllers.dart';
import 'package:matching_app/screen/main/board_function.dart';

class BoardMessageModal extends ConsumerStatefulWidget {
  const BoardMessageModal({
    Key? key,
    required this.info,
  });
  final Board info;
  @override
  // ignore: library_private_types_in_public_api
  ConsumerState<BoardMessageModal> createState() => _BoardMessageModalState();
}

class _BoardMessageModalState extends ConsumerState<BoardMessageModal> {
  String message = "";

  final RoundedRectangleBorder roundedRectangleBorder = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
  );
  @override
  Widget build(BuildContext context) {
    Board boardInfo = widget.info;
    String avatar = boardInfo.photo1;
    return SingleChildScrollView(
      padding: EdgeInsets.only(
          left: vww(context, 3),
          right: vww(context, 3),
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
          height: vhh(context, 35),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(50)),
                            border: Border.all(color: Colors.black45)),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage("http://192.168.142.55:8000/uploads/"+avatar),
                          onBackgroundImageError: (exception, stackTrace) {
                            setState(() {
                              avatar =
                                  "http://192.168.142.55:8000/uploads/1.png";
                            });
                          },
                          backgroundColor: Colors.transparent,
                        )),
                      Container(width: 5),
                        Text('${boardInfo.user_nickname??"TSUABA"}',
                          style: TextStyle(
                              fontSize: 14,
                              color: PRIMARY_FONT_COLOR))
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                       "${boardInfo.age+"歳"??"-"}",
                        style: TextStyle(
                            fontSize: 13,
                            color: Color.fromARGB(255, 151, 157, 170)),
                      ),
                      Container(width: 10),
                      Text(
                       "${boardInfo.residence??"NO"}",
                        style: TextStyle(
                            fontSize: 13,
                            color: Color.fromARGB(255, 151, 157, 170)),
                      ),
                      Container(width: 10),
                    ],
                  ),
                  SizedBox(
                      height: 35,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            disabledBackgroundColor:
                                const Color.fromARGB(255, 127, 228, 206),
                            disabledForegroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            textStyle: const TextStyle(fontSize: 13),
                            backgroundColor: BUTTON_MAIN,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30)),
                        onPressed: message.isEmpty ? null : () {
                          final controller = ref.read(AuthProvider.notifier);
                          controller.doBoardReply(boardInfo.user_id, boardInfo.id, message).then(
                            (value) {
                              // go home only if login success.
                              if (value == true) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => BoardFunction()),);
                              } else {}
                               Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => BoardFunction()),);

                            },
                          );
                          print(boardInfo.user_id + boardInfo.id);

                        },
                        child: const Text("送信", style: TextStyle(fontSize: 13)),
                      ))
                ],
              ),
              Expanded(
                  child: TextField(
                maxLines: 10,
                minLines: 4,
                decoration: InputDecoration(
                    hintText: "簡単な挨拶や趣味、休日の過ごし方、お相手の希望などを書いてみましょう。",
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10))),
                style: const TextStyle(
                  fontSize: 15,
                ),
                cursorColor: BUTTON_MAIN,
                onChanged: (value) {
                  setState(() {
                    message = value;
                  });
                },
              ))
            ],
          )),
    );
  }
}
