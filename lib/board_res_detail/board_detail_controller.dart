import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:matching_app/board_res_detail/board_detail_repository.dart';
import 'package:matching_app/board_res_detail/board_detail_item.dart';

class BoardDetailController extends StateNotifier<AsyncValue<BoardDetailItemList>> {
  BoardDetailController({required this.notifRepo}) : super(const AsyncData([]));

  final BoardDetailRepository notifRepo;

 Future<void> doFetchResData(String datavalue) async {
    // state = const AsyncValue.loading();
    final newState = await AsyncValue.guard(() => notifRepo.doFetchResData(datavalue));
    if (mounted) {
      state = newState;
    }
    return;
  }
}

final boardProvider = StateNotifierProvider.autoDispose<BoardDetailController,
    AsyncValue<BoardDetailItemList>>((ref) {
  return BoardDetailController(notifRepo: ref.watch(BoardProvider));
});
