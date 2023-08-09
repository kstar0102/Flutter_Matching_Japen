import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matching_app/bloc/cubit.dart';

class ProfileMainInfo extends StatelessWidget {
  final String photo;
  final int age;
  final String name;
  
  final String identityState;
  const ProfileMainInfo({super.key, required this.photo, required this.age, required this.name, required this.identityState});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: [
          Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                  onTap: () {
                    // BlocProvider.of<AppCubit>(context).fetchProfileInfo();
                    Navigator.pushNamed(context, "/users_profile_screen");
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Image.network(photo,
                        loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    }, errorBuilder: (context, error, stackTrace) {
                      return const Text('Error loading image');
                    }),
                  ))),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Column(children: [
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(name == "" ? "サスケ" : name, style: const TextStyle(fontSize: 17))),
                Text("$age歳 東京都", style: const TextStyle(fontSize: 12)),
                const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
              ]))
        ]),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(children: [
                  identityState == "ブロック"
                  ?Container():
                  Container(
                    child:Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Image(
                        image: AssetImage("assets/images/status/on.png"),
                        width: 20),
                      Padding(
                          padding: const EdgeInsets.only(right: 50),
                          child: Text("本人確認完了", style: const TextStyle(fontSize: 12))),
                      ])),
                    ],),
                  ),
                 
            GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/profile_edit_screen");
                },
                child: Container(
                    padding: const EdgeInsets.only(
                        top: 5, bottom: 5, left: 10, right: 15),
                    width: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: const Color.fromARGB(255, 229, 250, 245),
                    ),
                    child: const Text("プロフィール編集",
                        style: TextStyle(
                            letterSpacing: -1.5,
                            fontSize: 12,
                            color: Color.fromARGB(255, 0, 202, 157)))))
          ],
        )
      ],
    );
  }
}
