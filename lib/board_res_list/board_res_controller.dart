import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:matching_app/board_res_list/board_res_repository.dart';
import 'package:matching_app/screen/main/setting/board_res_item.dart';

class BoardController extends StateNotifier<AsyncValue<BoardItemList>> {
  BoardController({required this.notifRepo}) : super(const AsyncData([]));

  final BoardRepository notifRepo;

 Future<void> doFetchResData() async {
    // state = const AsyncValue.loading();
    final newState = await AsyncValue.guard(() => notifRepo.doFetchResData());
    if (mounted) {
      state = newState;
    }
    return;
  }
}

final boardProvider = StateNotifierProvider.autoDispose<BoardController,
    AsyncValue<BoardItemList>>((ref) {
  return BoardController(notifRepo: ref.watch(BoardProvider));
});
