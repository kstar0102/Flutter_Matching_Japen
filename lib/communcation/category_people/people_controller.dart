import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:matching_app/communcation/category_people/people_repository.dart';
import 'package:matching_app/communcation/category_people/people_item.dart';

class PeopleController extends StateNotifier<AsyncValue<PeopleItemList>> {
  PeopleController({required this.notifRepo}) : super(const AsyncData([]));

  final PeopleRepository notifRepo;
  // set state(AsyncValue<PeopleItemList?> value) => _state = value;

  Future<void> doGetPeopleData(String sub_id) async {
    // state = const AsyncValue.loading();
    final newState = await AsyncValue.guard(() => notifRepo.doGetPeopleData(sub_id));
    // if (mounted) {
      state = newState;
    // }
    return;
  }

  Future<void> doGetChattingData() async {
    // state = const AsyncValue.loading();
    final newState = await AsyncValue.guard(() => notifRepo.doGetChattingData());

      state = newState;
      return;
  }

  Future<void> doGetLikeData() async {
    
    final newState = await AsyncValue.guard(() => notifRepo.doGetLikeData());
    
    state = newState;

    return;
  }
}

final peopleProvider = StateNotifierProvider.autoDispose<PeopleController,
    AsyncValue<PeopleItemList>>((ref) {
  return PeopleController(notifRepo: ref.watch(PeopleProvider));
});
