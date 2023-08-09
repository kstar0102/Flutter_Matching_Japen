import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:matching_app/controller/board_repository.dart';
import 'package:matching_app/screen/main/setting/board_list.dart';

class BoardController extends StateNotifier<AsyncValue<BoardList>> {
  BoardController({required this.notifRepo}) : super(const AsyncData([]));

  final BoardRepository notifRepo;

  // AsyncValue<BoardList?> _state = const AsyncValue.loading();

  Future<BoardList?> doFetchNotifs() async {
    state = const AsyncValue.loading();
    final newState = await AsyncValue.guard(() => notifRepo.doFetchNotifs());
    if (mounted) {
      state = newState;
    }
    // if (newState.hasError) {
      
    //   return newState.value;
    // } else {
    //   return newState.value;
    // }
  }
}

final boardProvider = StateNotifierProvider.autoDispose<BoardController,
    AsyncValue<BoardList?>>((ref) {
  return BoardController(notifRepo: ref.watch(BoardProvider));
});
