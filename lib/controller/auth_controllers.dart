import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:matching_app/controller/auth_repository.dart';
import 'package:matching_app/controller/profile_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class AuthController extends StateNotifier<AsyncValue<bool>> {
  AuthController({required this.authRepo}) : super(const AsyncData(false));

  final AuthRepository authRepo;
  late BuildContext context;
  ProfileInfo? get currProfile => authRepo.currProfile;
  //bool isAuthenticated() => authRepo.uid

  Future<bool> doIntroduce(String uID, String introText) async {
    state = const AsyncValue.loading();
    final newState =
        await AsyncValue.guard(() => authRepo.doIntroduce(uID, introText));

    if (mounted) {
      state = newState;
    }
    return newState.hasValue;
  }

  Future<bool> doNickname(String _uID, String nick_name) async {
    state = const AsyncValue.loading();
    final newState =
        await AsyncValue.guard(() => authRepo.doNickname(_uID, nick_name));

    if (mounted) {
      state = newState;
    }
    return newState.hasValue;
  }

  Future<bool> doPhoneVaild(String phone_number) async {
    state = const AsyncValue.loading();
    print("+++++++++++++"+phone_number);
    final newState =
        await AsyncValue.guard(() => authRepo.doPhoneVaild(phone_number));

    if (mounted) {
      state = newState;
    }
    return newState.hasValue;
  }

   Future<bool> doBoardReply(String userId, String Id, String message) async {
 
    state = const AsyncValue.loading();

    final newState =
        await AsyncValue.guard(() => authRepo.doBoardReply(userId, Id, message));

    // Check if the controller is mounted before setting the state to prevent:
    // Bad state: Tried to use Controller after `dispose` was called.
    if (mounted) {
      state = newState;
    }
    return newState.hasValue;
  }

  Future<bool> addBoardData(String selectedItems, String board_text) async {
 
    state = const AsyncValue.loading();

    final newState =
        await AsyncValue.guard(() => authRepo.addBoardData(selectedItems,board_text));

    // Check if the controller is mounted before setting the state to prevent:
    // Bad state: Tried to use Controller after `dispose` was called.
    if (mounted) {
      state = newState;
    }
    return newState.hasValue;
  }

  Future<bool> doDetailData(String res_id) async {
    state = const AsyncValue.loading();
    final newState =
        await AsyncValue.guard(() => authRepo.doDetailData(res_id));

    if (mounted) {
      state = newState;
    }
    return newState.hasValue;
  }

  Future<bool> doPeopleRecom(String receiver_id) async {
    state = const AsyncValue.loading();
    final newState =
        await AsyncValue.guard(() => authRepo.doPeopleRecom(receiver_id));

    if (mounted) {
      state = newState;
    }

    return newState.hasValue;
  }

  Future<bool> isLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLogin') ?? false;
  }

  // Future<String> getLoggedInID() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String str = prefs.getString('login_id') ?? 'not';
  //   authRepo.setUid = str;
  //   return str;
  // }

  Future<void> doLogout() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => authRepo.doLogout());
  }
}

final AuthProvider =
    StateNotifierProvider.autoDispose<AuthController, AsyncValue<bool>>((ref) {
  return AuthController(authRepo: ref.watch(authRepositoryProvider));
});
