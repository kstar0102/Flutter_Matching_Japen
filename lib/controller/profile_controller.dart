import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:matching_app/controller/profile_info.dart';
import 'package:matching_app/controller/profile_repository.dart';
import 'dart:developer' as developer;

import 'package:shared_preferences/shared_preferences.dart';

// * ---------------------------------------------------------------------------
// * HomeAccountController
// * ---------------------------------------------------------------------------

class HomeAccountController extends StateNotifier<AsyncValue<ProfileInfo?>> {
  HomeAccountController({required this.profileRepo})
      : super(const AsyncData(null));

  final ProfileRepository profileRepo;
  ProfileInfo? get currProfile => profileRepo.currProfile;

  Future<void> doGetIntro(String uid) async {
    state = const AsyncValue.loading();
    final newState = await AsyncValue.guard(() => profileRepo.doGetIntro(uid));
    if (mounted) {
      state = newState;
    }
  }
}

final homeAccountCtrProvider = StateNotifierProvider.autoDispose<
    HomeAccountController, AsyncValue<ProfileInfo?>>((ref) {
  return HomeAccountController(
      profileRepo: ref.watch(profileRepositoryProvider));
});
