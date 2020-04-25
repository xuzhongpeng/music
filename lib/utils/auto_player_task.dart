import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioPlayerTask extends BackgroundAudioTask {
  final _queue = <MediaItem>[
    MediaItem(
      id: "http://122.226.161.16/amobile.music.tc.qq.com/C4000006aAaN4WFln8.m4a?guid=2796982635&vkey=462CEE5D3579E8A019B9F1F397C973FDC8DADDA3CD1F4FD68DB836A9A0E01F1FFE18D250423ED108803A5C3ABAE69E895DBFAD6346294C3B&uin=1899&fromtag=66",
      album: "Science Friday",
      title: "A Salute To Head-Scratching Science",
      artist: "Science Friday and WNYC Studios",
      // duration: 5739820,
      artUri:
          "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
    ),
    MediaItem(
      id: "http://122.226.161.16/amobile.music.tc.qq.com/C400003iXNJf1aKtxn.m4a?guid=2796982635&vkey=4A73184E06344878A2D7FB5862245B165B933E7521BBCF333096F84434336E03C84625DCE9C973FB6489462E4C9F8992CEB78F48414C6E72&uin=1899&fromtag=66",
      album: "Science Friday",
      title: "From Cat Rheology To Operatic Incompetence",
      artist: "Science Friday and WNYC Studios",
      // duration: 2856950,
      artUri:
          "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
    ),
  ];
  int _queueIndex = -1;
  AudioPlayer _audioPlayer = new AudioPlayer();
  Completer _completer = Completer();
  BasicPlaybackState _skipState;
  bool _playing;

  //当前播放音乐的时间长度
  Duration duration;
  //当前播放音乐定位
  Duration position;
  bool isPlaying;
  BasicPlaybackState state;
  bool get hasNext => _queueIndex + 1 < _queue.length;

  bool get hasPrevious => _queueIndex > 0;

  MediaItem get mediaItem => _queue[_queueIndex];

  BasicPlaybackState _eventToBasicState(AudioPlayerState event) {
    // if (event.) {
    //   return BasicPlaybackState.buffering;
    // } else {
    switch (event) {
      case AudioPlayerState.STOPPED:
        return BasicPlaybackState.stopped;
      case AudioPlayerState.PAUSED:
        return BasicPlaybackState.paused;
      case AudioPlayerState.PLAYING:
        return BasicPlaybackState.playing;
      case AudioPlayerState.COMPLETED:
        return BasicPlaybackState.stopped;
      default:
        throw Exception("Illegal state");
    }
    // }
  }

  @override
  Future<void> onStart() async {
    // var playerStateSubscription = _audioPlayer.playbackStateStream
    //     .where((state) => state == AudioPlayerState.COMPLETED)
    //     .listen((state) {
    //   _handlePlaybackCompleted();
    // });
    var eventSubscription = _audioPlayer.onPlayerStateChanged.listen((event) {
      if (state != BasicPlaybackState.stopped) {
        _setState(
          state: state,
          position: position.inMilliseconds,
        );
      }
    });

    AudioServiceBackground.setQueue(_queue);
    await onSkipToNext();
    await _completer.future;
    initPlayer();
    // playerStateSubscription.cancel();
    eventSubscription.cancel();
  }

  initPlayer() {
    //播放总时间变化时
    _audioPlayer.onDurationChanged.listen((duration) {
      this.duration = duration;
    });
    //播放时间变化时
    _audioPlayer.onAudioPositionChanged.listen((position) {
      this.position = position;
      _changeServiceState();
    });
    _audioPlayer.onPlayerStateChanged.listen((AudioPlayerState event) {
      state = _eventToBasicState(event);
      _changeServiceState();
    });
    _audioPlayer.onPlayerCompletion.listen((_) {
      // this.isPlaying = false;
      print('播放完成,下一首');
      _handlePlaybackCompleted();
    });
  }

  _changeServiceState() {
    if (state != BasicPlaybackState.stopped) {
      _setState(
        state: state,
        position: position.inMilliseconds,
      );
    }
  }

  void _handlePlaybackCompleted() {
    if (hasNext) {
      onSkipToNext();
    } else {
      onStop();
    }
  }

  void playPause() {
    if (AudioServiceBackground.state.basicState == BasicPlaybackState.playing)
      onPause();
    else
      onPlay();
  }

  @override
  Future<void> onSkipToNext() => _skip(1);

  @override
  Future<void> onSkipToPrevious() => _skip(-1);

  Future<void> _skip(int offset) async {
    final newPos = _queueIndex + offset;
    if (!(newPos >= 0 && newPos < _queue.length)) return;
    if (_playing == null) {
      // First time, we want to start playing
      _playing = true;
    } else if (_playing) {
      // Stop current item
      await _audioPlayer.stop();
    }
    // Load next item
    _queueIndex = newPos;
    AudioServiceBackground.setMediaItem(mediaItem);
    _skipState = offset > 0
        ? BasicPlaybackState.skippingToNext
        : BasicPlaybackState.skippingToPrevious;
    await _audioPlayer.setUrl(mediaItem.id);
    _skipState = null;
    // Resume playback if we were playing
    if (_playing) {
      onPlay();
    } else {
      _setState(state: BasicPlaybackState.paused);
    }
  }

  @override
  void onPlay() {
    if (_skipState == null) {
      _playing = true;
      _audioPlayer.play(mediaItem.id);
    }
  }

  @override
  void onPause() {
    if (_skipState == null) {
      _playing = false;
      _audioPlayer.pause();
    }
  }

  @override
  void onSeekTo(int position) {
    _audioPlayer.seek(Duration(milliseconds: position));
  }

  @override
  void onClick(MediaButton button) {
    playPause();
  }

  @override
  void onStop() {
    _audioPlayer.stop();
    _setState(state: BasicPlaybackState.stopped);
    _completer.complete();
  }

  void _setState({@required BasicPlaybackState state, int position}) {
    if (position == null) {
      // position = _audioPlayer;
    }
    AudioServiceBackground.setState(
      controls: getControls(state),
      systemActions: [MediaAction.seekTo],
      basicState: state,
      position: position,
    );
  }

  List<MediaControl> getControls(BasicPlaybackState state) {
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
