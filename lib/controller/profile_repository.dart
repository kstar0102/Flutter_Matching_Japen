import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:matching_app/exceptions/app_exception.dart';
import 'package:matching_app/controller/auth_repository.dart';
import 'package:matching_app/controller/profile_info.dart';
import 'package:matching_app/model/dio_client.dart';
import 'package:matching_app/utile/in_memory_store.dart';

class ProfileRepository {
  ProfileRepository({required this.authRepo});

  final AuthRepository authRepo;
  //Profile? _profile;

  ProfileInfo? get currProfile => _profileState.value;

  final _profileState = InMemoryStore<ProfileInfo?>(null);
  Stream<ProfileInfo?> profileStateChanges() => _profileState.stream;

  // * -------------------------------------------------------------------------

  Future<ProfileInfo?> doGetIntro(String uid) async {
    final data = await DioClient.GetIntro(uid);
    // print(data);
    try {
      ProfileInfo profileData = ProfileInfo.fromMap(data);
      developer.log('doGetProfile222() returned: $profileData');
    } catch (e) {
      developer.log('doGetProfile222() error=$e');
    }
    try {
      _profileState.value = ProfileInfo.fromMap(data);
    } catch (e) {
      developer.log('doGetProfile() error=$e');
    }

    return _profileState.value;
  }
  
  Future<ProfileInfo?> doGetNickName(String uid) async {
    final data = await DioClient.GetIntro(uid);
    // print(data);
    try {
      ProfileInfo profileData = ProfileInfo.fromMap(data);
      developer.log('doGetProfile222() returned: $profileData');
    } catch (e) {
      developer.log('doGetProfile222() error=$e');
    }
    try {
      _profileState.value = ProfileInfo.fromMap(data);
    } catch (e) {
      developer.log('doGetProfile() error=$e');
    }

    return _profileState.value;
  }
}

final profileRepositoryProvider = StateProvider<ProfileRepository>((ref) {
  return ProfileRepository(authRepo: ref.watch(authRepositoryProvider));
});

final profileStateChangesProvider = StreamProvider<ProfileInfo?>((ref) {
  final profileRepo = ref.watch(profileRepositoryProvider);
  return profileRepo.profileStateChanges();
});
