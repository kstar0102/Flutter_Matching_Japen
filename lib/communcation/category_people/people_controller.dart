import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:matching_app/communcation/category_people/people_repository.dart';
import 'package:matching_app/communcation/category_people/people_item.dart';

class PeopleController extends StateNotifier<AsyncValue<PeopleItemList>> {
  PeopleController({required this.notifRepo}) : super(const AsyncData([]));

  final PeopleRepository notifRepo;

  AsyncValue<PeopleItemList?> _state = const AsyncValue.loading();
  // set state(AsyncValue<PeopleItemList?> value) => _state = value;

  Future<PeopleItemList?> doGetPeopleData(String sub_id) async {
    state = const AsyncValue.loading();
    final newState = await AsyncValue.guard(() => notifRepo.doGetPeopleData(sub_id));
    if (mounted) {
      state = newState;
    }

    if (newState.hasError) {
      return [];
    } else {
      return newState.value;
    }
  }

  Future<PeopleItemList?> doGetChattingData() async {
    state = const AsyncValue.loading();
    final newState = await AsyncValue.guard(() => notifRepo.doGetChattingData());
    if (mounted) {
      state = newState;
    }

    if (newState.hasError) {
      return [];
    } else {
      return newState.value;
    }
  }

  Future<PeopleItemList?> doGetLikeData() async {
    state = const AsyncValue.loading();
    final newState = await AsyncValue.guard(() => notifRepo.doGetLikeData());
    if (mounted) {
      state = newState;
    }

    if (newState.hasError) {
      return [];
    } else {
      return newState.value;
    }
  }
}

final peopleProvider = StateNotifierProvider.autoDispose<PeopleController,
    AsyncValue<PeopleItemList>>((ref) {
  return PeopleController(notifRepo: ref.watch(PeopleProvider));
});
