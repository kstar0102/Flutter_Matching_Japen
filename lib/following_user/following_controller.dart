import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:matching_app/following_user/following_repository.dart';
import 'package:matching_app/following_user/following_item.dart';

class FollowingController extends StateNotifier<AsyncValue<FollowingItemList>> {
  FollowingController({required this.notifRepo}) : super(const AsyncData([]));

  final FollowingRepository notifRepo;

  Future<void> doGetLikeData() async {
    // state = const AsyncValue.loading();
    final newState = await AsyncValue.guard(() => notifRepo.doGetLikeData());
    if (mounted) {
      state = newState;
    }
    return;
  }
}

final followingProvider = StateNotifierProvider.autoDispose<FollowingController,
    AsyncValue<FollowingItemList>>((ref) {
  return FollowingController(notifRepo: ref.watch(FollowingProvider));
});
