import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:matching_app/communcation/home_commun/communicate_repository.dart';
import 'package:matching_app/communcation/home_commun/communicate_item.dart';

class CommunicateController extends StateNotifier<AsyncValue<CommunicateItemList>> {
  CommunicateController({required this.notifRepo}) : super(const AsyncData([]));

  final CommunicationRepository notifRepo;

 Future<void> doGetCommunicateData() async {
    // state = const AsyncValue.loading();
    final newState = await AsyncValue.guard(() => notifRepo.doGetCommunicateData());
    if (mounted) {
      state = newState;
    }
    return;
  }
}

final communicateProvider = StateNotifierProvider.autoDispose<CommunicateController,
    AsyncValue<CommunicateItemList>>((ref) {
  return CommunicateController(notifRepo: ref.watch(CommunicateProvider));
});
