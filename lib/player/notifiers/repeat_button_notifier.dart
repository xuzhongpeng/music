import 'package:flutter/foundation.dart';

/// 重复模式
class RepeatButtonNotifier extends ValueNotifier<RepeatState> {
  RepeatButtonNotifier() : super(_initialValue);
  static const _initialValue = RepeatState.off;

  void nextState() {
    final next = (value.index + 1) % RepeatState.values.length;
    value = RepeatState.values[next];
  }
}

enum RepeatState {
  // 不重复，一首歌放完就停止了
  off,
  // 重复一首歌
  repeatSong,
  // 重复播放列表
  repeatPlaylist,
}
