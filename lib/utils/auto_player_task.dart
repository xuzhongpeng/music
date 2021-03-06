import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/widgets.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music/config/http.dart';
import 'package:music/entities/musics.dart';
import 'package:music/services/q/songs_service.dart';

class AudioPlayerTask extends BackgroundAudioTask {
  AudioPlayerTask({List<MediaItem> mediaItem}) {
    if (mediaItem != null) _queue.addAll(mediaItem);
  }
  List<MediaItem> _queue = <MediaItem>[];
  int _queueIndex = -1;
  AudioPlayer _audioPlayer = new AudioPlayer();
  AudioProcessingState _skipState;
  bool _playing;

  // bool get hasNext => _queueIndex + 1 < _queue.length;
  StreamSubscription<AudioPlaybackEvent> _eventSubscription;
  StreamSubscription<AudioPlaybackState> _playerStateSubscription;
  bool get hasPrevious => _queueIndex > 0;

  MediaItem get mediaItem => _queue[_queueIndex];

  // AudioProcessingState _eventToBasicState(AudioPlaybackEvent event) {
  //   if (event.buffering) {
  //     return AudioProcessingState.buffering;
  //   } else {
  //     switch (event.state) {
  //       case AudioPlaybackState.none:
  //         return AudioProcessingState.none;
  //       case AudioPlaybackState.stopped:
  //         return AudioProcessingState.stopped;
  //       case AudioPlaybackState.paused:
  //         return AudioProcessingState.p;
  //       case AudioPlaybackState.playing:
  //         return AudioProcessingState.playing;
  //       case AudioPlaybackState.connecting:
  //         return _skipState ?? AudioProcessingState.connecting;
  //       case AudioPlaybackState.completed:
  //         return AudioProcessingState.stopped;
  //       default:
  //         throw Exception("Illegal state");
  //     }
  //   }
  // }

  @override
  Future<void> onStart(Map<String, dynamic> params) async {
    // _audioPlayer.durationStream.listen((d) {
    //   AudioServiceBackground.setMediaItem(mediaItem);
    // });
    _playerStateSubscription = _audioPlayer.playbackStateStream
        .where((state) => state == AudioPlaybackState.completed)
        .listen((state) {
      onSkipToNext();
    });
    _eventSubscription = _audioPlayer.playbackEventStream.listen((event) {
      final bufferingState =
          event.buffering ? AudioProcessingState.buffering : null;
      switch (event.state) {
        case AudioPlaybackState.paused:
          _setState(
            processingState: bufferingState ?? AudioProcessingState.ready,
            position: event.position,
          );
          break;
        case AudioPlaybackState.playing:
          _setState(
            processingState: bufferingState ?? AudioProcessingState.ready,
            position: event.position,
          );
          break;
        case AudioPlaybackState.connecting:
          _setState(
            processingState: _skipState ?? AudioProcessingState.connecting,
            position: event.position,
          );
          break;
        default:
          break;
      }
    });
    AudioServiceBackground.setQueue(_queue);
    // await onSkipToNext();
  }

  // void _handlePlaybackCompleted() {
  //   if (hasNext) {
  //     onSkipToNext();
  //   } else {
  //     onStop();
  //   }
  // }

  void playPause() {
    if (AudioServiceBackground.state.playing)
      onPause();
    else
      onPlay();
  }

  @override
  Future<void> onSkipToNext() => _skip(1);

  @override
  Future<void> onSkipToPrevious() => _skip(-1);

  Future<void> _skip(int offset) async {
    var newPos = _queueIndex + offset;
    if (newPos < 0) {
      newPos = _queue.length - 1;
    } else if (newPos > _queue.length - 1) {
      newPos = 0;
    }
    _skipState = offset > 0
        ? AudioProcessingState.skippingToNext
        : AudioProcessingState.skippingToPrevious;
    _queueIndex = newPos;
    _beginPlay();
  }

  Future<void> _beginPlay() async {
    if (_playing == null) {
      _playing = true;
    } else if (_audioPlayer.playbackState == AudioPlaybackState.playing) {
      await _audioPlayer.stop();
    }
    Duration duration;
    if (mediaItem.id == null || mediaItem.id.startsWith('jsshou')) {
      await getNewUrl();
    }
    try {
      duration = await _audioPlayer.setUrl(mediaItem.id);
    } catch (e) {
      await getNewUrl();
      try {
        duration = await _audioPlayer.setUrl(mediaItem.id);
      } catch (e) {
        onSkipToNext();
        return;
      }
    }
    MediaItem item = mediaItem.copyWith(
      duration: duration,
    );
    AudioServiceBackground.setMediaItem(item);
    _skipState = null;
    // Resume playback if we were playing
    // if (_playing) {
    onPlay();
    // } else {
    //   _setState(processingState: AudioProcessingState.ready);
    // }
  }

  @override
  void onPlay() async {
    if (_skipState == null) {
      _playing = true;
      await _audioPlayer.play();
    }
  }

  @override
  void onPause() async {
    if (_skipState == null) {
      _playing = false;
      await _audioPlayer.pause();
      // await _setState(state: AudioProcessingState.paused);
    }
  }

  @override
  void onSeekTo(Duration position) {
    _audioPlayer.seek(position);
  }

  @override
  void onClick(MediaButton button) {
    playPause();
  }

  @override
  void onStop() async {
    await _audioPlayer.stop();
    await _audioPlayer.dispose();
    _playing = false;
    await _setState(processingState: AudioProcessingState.stopped);
  }

  @override
  void onAddQueueItem(MediaItem item) async {
    int i = _queue.indexWhere((_q) => _q.id == item.id);
    if (i == -1) {
      _queue.add(item);
      await AudioServiceBackground.setQueue(_queue);
    }
  }

  @override
  void onAddQueueItemAt(MediaItem mediaItem, int index) {
    _queue.insert(index, mediaItem);
  }

  @override
  void onRemoveQueueItem(MediaItem mediaItem) async {
    MediaItem item = _queue[
        _queue.indexWhere((_q) => _q.extras['cid'] == mediaItem.extras['cid'])];
    _queue.remove(item);
    await AudioServiceBackground.setQueue(_queue);
  }

//跳转到对应音乐
  @override
  void onPlayFromMediaId(String id) async {
    _queueIndex = _queue.indexWhere((_q) => _q.extras['cid'] == id);
    if (_queueIndex == -1) return;
    _beginPlay();
  }

  @override
  void onSkipToQueueItem(String id) async {}

  Future<void> _setState({
    AudioProcessingState processingState,
    Duration position,
    Duration bufferedPosition,
  }) async {
    if (position == null) {
      position = _audioPlayer.playbackEvent.position;
    }
    await AudioServiceBackground.setState(
      controls: getControls(),
      systemActions: [MediaAction.seekTo],
      processingState:
          processingState ?? AudioServiceBackground.state.processingState,
      playing: _playing,
      position: position,
      bufferedPosition: bufferedPosition ?? position,
      speed: _audioPlayer.speed,
    );
  }

  //动态获取最新的歌曲url
  Future<void> getNewUrl({VoidCallback callback}) async {
    MusicEntity song = MusicEntity.fromJson(mediaItem.extras);
    Http http = Http();
    if (http.dio == null) http.init();
    song.url = Song.fromQQ(minUrl: await SongService().getDetail(song));
    _queue[_queueIndex] = song.toMediaItem();
  }

  List<MediaControl> getControls() {
    if (_playing) {
      return [
        skipToPreviousControl,
        pauseControl,
        stopControl,
        skipToNextControl
      ];
    } else {
      return [
        skipToPreviousControl,
        playControl,
        stopControl,
        skipToNextControl
      ];
    }
  }
}

MediaControl playControl = MediaControl(
  androidIcon: 'drawable/ic_action_play_arrow',
  label: 'Play',
  action: MediaAction.play,
);
MediaControl pauseControl = MediaControl(
  androidIcon: 'drawable/ic_action_pause',
  label: 'Pause',
  action: MediaAction.pause,
);
MediaControl skipToNextControl = MediaControl(
  androidIcon: 'drawable/ic_action_skip_next',
  label: 'Next',
  action: MediaAction.skipToNext,
);
MediaControl skipToPreviousControl = MediaControl(
  androidIcon: 'drawable/ic_action_skip_previous',
  label: 'Previous',
  action: MediaAction.skipToPrevious,
);
MediaControl stopControl = MediaControl(
  androidIcon: 'drawable/ic_action_stop',
  label: 'Stop',
  action: MediaAction.stop,
);

class ScreenState {
  final List<MediaItem> queue;
  final MediaItem mediaItem;
  final PlaybackState playbackState;

  ScreenState(this.queue, this.mediaItem, this.playbackState);
}
