import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matching_app/bloc/cubit.dart';
import 'package:matching_app/common.dart';
import 'package:matching_app/components/Header.dart';
import 'package:matching_app/screen/main/layouts/basic_info.dart';
import 'package:matching_app/screen/main/layouts/bottom_nav_bar.dart';
import 'package:matching_app/screen/main/layouts/introduction_widget.dart';
import 'package:matching_app/screen/main/layouts/my_community_widget.dart';
import 'package:matching_app/screen/main/layouts/following_widget.dart';
import 'package:matching_app/screen/main/layouts/profile_badge.dart';
import 'package:matching_app/screen/main/layouts/profile_main_info.dart';
import 'package:matching_app/screen/main/layouts/settings_widget.dart';
import 'package:matching_app/utile/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matching_app/controller/auth_controllers.dart';

// ignore: use_key_in_widget_constructors
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  String? userId;
  String? get uid => userId;
  String? isShow = "true";
  set setUid(String str) {
    this.userId = str;
  }
  void getData() async {
    BlocProvider.of<AppCubit>(context).fetchProfileInfo();
  }

  @override
  void initState(){
    super.initState();
    AppCubit appCubit = AppCubit.get(context);
    BlocProvider.of<AppCubit>(context).fetchProfileInfo();
    appCubit.intro_text != "" ?isShow = "true": isShow = "false";
  }
  void dispose() {
    super.dispose();
  }

  final int _currentIndex = 4;
  @override
  Widget build(BuildContext context) {
    AppCubit appCubit = AppCubit.get(context);
    // BlocProvider.of<AppCubit>(context).fetchProfileInfo();
      if (isShow == "false" && appCubit.UserId=="0") {
        final AlertDialog dialog = AlertDialog(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          titlePadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.zero,
          actionsPadding: EdgeInsets.zero,
          actions: [
            Container(
                padding: const EdgeInsets.only(
                    top: 10, bottom: 40, left: 40, right: 40),
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      disabledForegroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      textStyle: const TextStyle(fontSize: 15),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 13),
                      backgroundColor: BUTTON_MAIN),
                  onPressed: () {
                    Navigator.pushNamed(context, "/self_introduction");
                  },
                  child: const Text('つぎへ'),
                ))
          ],
          shape: roundedRectangleBorder,
          content: Container(
              height: 300,
              padding: const EdgeInsets.only(
                  top: 30, bottom: 20, left: 20, right: 20),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "自己紹介文を記入して\n魅力的なプロフィールにしてみましょう",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: PRIMARY_FONT_COLOR,
                        fontSize: 18,
                        letterSpacing: -2),
                  ),
                  Image(
                      image: AssetImage("assets/images/main/tutorial.png"),
                      height: 160)
                ],
              )));
              
      Future.delayed(const Duration(milliseconds: 1000), () {
        showDialog(context: context, builder: (context) => dialog);
      });
    }

    return BlocBuilder<AppCubit, AppState>(builder: (context, state) {
      if (appCubit.user.id == -1) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      isShow = appCubit.user.introduce == ""?"false":"true";
      return Scaffold(
          body: RefreshIndicator(
            onRefresh: () async {
              getData();
            },
            backgroundColor: Colors.white,
            child: CustomScrollView(
              slivers: <Widget>[
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                        padding: EdgeInsets.only(
                            top: vhh(context, 8),
                            left: vww(context, 5),
                            right: vww(context, 5)),
                        child: const Text("マイページ",
                            style: TextStyle(fontSize: 21))),
                        Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: vhh(context, 2),
                                horizontal: vww(context, 6)),
                            child: ProfileMainInfo(
                                identityState: appCubit.user.identityState,
                                photo: appCubit.user.photo1,
                                age: DateTime.now().year -
                                    int.parse(appCubit.user.bday.split("-")[0]),
                                name: appCubit.user.nickname)),
                        FolloingWidget(likesRate: appCubit.user.likesRate, resCount: appCubit.user.res_count),
                        appCubit.user.identityState == "承認"
                            ? Container()
                            : TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, "/identity_verify");
                                },
                                child: Padding(
                                    padding: EdgeInsets.all(vww(context, 4)),
                                    child: const Image(
                                        image: AssetImage(
                                            "assets/images/main/set-introduction.png")))),
                        SettingsWidget(planType: appCubit.user.planType, todays: appCubit.user.today_recom, availDate: appCubit.user.avail_date, payUser: appCubit.user.pay_user),
                        MyCommunityWidget(
                            communityObjects: appCubit.user.community),
                        IntroductionWidget(introduce: appCubit.user.introduce),
                        Padding(padding: EdgeInsets.only(
                          left: vww(context, 6),
                          right: vww(context, 6),
                          bottom: vhh(context, 3)),
                        child: ProfileBadgeWidget(badges: appCubit.user.introBadge),
                        ),
                        
                        BasicInfo(
                            height: appCubit.user.height,
                            annualIncome: appCubit.user.annualIncome,
                            blood: appCubit.user.bloodType,
                            bodyType: appCubit.user.bodytype,
                            cigarette: appCubit.user.cigarette,
                            purpose: appCubit.user.usePurpose),
                      ]);
                }, childCount: 1)),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavBar(currentIndex: _currentIndex));
  });
  }
}
