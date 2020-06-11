// import 'dart:async';

// import 'package:audio_service/audio_service.dart';
// import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';

// class AudioPlayerTask222 extends BackgroundAudioTask {
//   AudioPlayerTask222() {}
//   List<MediaItem> _queue = <MediaItem>[
//     MediaItem(
//       id: "http://music.163.com/song/media/outer/url?id=1427051960.mp3",
//       album: "Science Friday",
//       title: "A Salute To Head-Scratching Science",
//       artist: "Science Friday and WNYC Studios",
//       duration: 5739820,
//       artUri:
//           "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
//     ),
//     MediaItem(
//       id: "http://music.163.com/song/media/outer/url?id=26305527.mp3",
//       album: "Science Friday",
//       title: "From Cat Rheology To Operatic Incompetence",
//       artist: "Science Friday and WNYC Studios",
//       duration: 2856950,
//       artUri:
//           "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
//     ),
//   ];
//   int _queueIndex = -1;
//   AudioPlayer _audioPlayer = new AudioPlayer();
//   Completer _completer = Completer();
//   BasicPlaybackState _skipState;
//   bool _playing;

//   //当前播放音乐的时间长度
//   Duration duration;
//   //当前播放音乐定位
//   Duration position;
//   bool isPlaying;
//   BasicPlaybackState state;
//   bool get hasNext => _queueIndex + 1 < _queue.length;

//   bool get hasPrevious => _queueIndex > 0;

//   MediaItem get mediaItem => _queue[_queueIndex];

//   BasicPlaybackState _eventToBasicState(AudioPlaybackEvent event) {
//     if (event.buffering) {
//       return BasicPlaybackState.buffering;
//     } else {
//       switch (event.state) {
//         case AudioPlaybackState.none:
//           return BasicPlaybackState.none;
//         case AudioPlaybackState.stopped:
//           return BasicPlaybackState.stopped;
//         case AudioPlaybackState.paused:
//           return BasicPlaybackState.paused;
//         case AudioPlaybackState.playing:
//           return BasicPlaybackState.playing;
//         case AudioPlaybackState.connecting:
//           return _skipState ?? BasicPlaybackState.connecting;
//         case AudioPlaybackState.completed:
//           return BasicPlaybackState.stopped;
//         default:
//           throw Exception("Illegal state");
//       }
//     }
//   }

//   @override
//   Future<void> onStart() async {
//     var playerStateSubscription = _audioPlayer.playbackStateStream
//         .where((state) => state == AudioPlaybackState.completed)
//         .listen((state) {
//       _handlePlaybackCompleted();
//     });
//     var eventSubscription = _audioPlayer.playbackEventStream.listen((event) {
//       final state = _eventToBasicState(event);
//       if (state != BasicPlaybackState.stopped) {
//         _setState(
//           state: state,
//           position: event.position.inMilliseconds,
//         );
//       }
//     });

//     AudioServiceBackground.setQueue(_queue);
//     await onSkipToNext();
//     await _completer.future;
//     playerStateSubscription.cancel();
//     eventSubscription.cancel();
//   }

//   void _handlePlaybackCompleted() {
//     if (hasNext) {
//       onSkipToNext();
//     } else {
//       onStop();
//     }
//   }

//   void playPause() {
//     if (AudioServiceBackground.state.basicState == BasicPlaybackState.playing)
//       onPause();
//     else
//       onPlay();
//   }

//   @override
//   Future<void> onSkipToNext() => _skip(1);

//   @override
//   Future<void> onSkipToPrevious() => _skip(-1);

//   Future<void> _skip(int offset) async {
//     final newPos = _queueIndex + offset;
//     if (!(newPos >= 0 && newPos < _queue.length)) return;
//     if (_playing == null) {
//       // First time, we want to start playing
//       _playing = true;
//     } else if (_playing) {
//       // Stop current item
//       await _audioPlayer.stop();
//     }
//     // Load next item
//     _queueIndex = newPos;
//     AudioServiceBackground.setMediaItem(mediaItem);
//     _skipState = offset > 0
//         ? BasicPlaybackState.skippingToNext
//         : BasicPlaybackState.skippingToPrevious;
//     await _audioPlayer.setUrl(mediaItem.id);
//     // _skipState = null;
//     // // Resume playback if we were playing
//     // if (_playing) {
//     //   onPlay();
//     // } else {
//     //   _setState(state: BasicPlaybackState.paused);
//     // }
//   }

//   @override
//   void onPlay() {
//     if (_skipState == null) {
//       _playing = true;
//       _audioPlayer.play();
//     }
//   }

//   @override
//   void onPause() {
//     if (_skipState == null) {
//       _playing = false;
//       _audioPlayer.pause();
//     }
//   }

//   @override
//   void onSeekTo(int position) {
//     _audioPlayer.seek(Duration(milliseconds: position));
//   }

//   @override
//   void onClick(MediaButton button) {
//     playPause();
//   }

//   @override
//   void onStop() {
//     _audioPlayer.stop();
//     _setState(state: BasicPlaybackState.stopped);
//     _completer.complete();
//   }

//   void _setState({@required BasicPlaybackState state, int position}) {
//     if (position == null) {
//       position = _audioPlayer.playbackEvent.position.inMilliseconds;
//     }
//     AudioServiceBackground.setState(
//       controls: getControls(state),
//       systemActions: [MediaAction.seekTo],
//       basicState: state,
//       position: position,
//     );
//   }

//   List<MediaControl> getControls(BasicPlaybackState state) {
//     if (_playing) {
//       return [
//         skipToPreviousControl,
//         pauseControl,
//         stopControl,
//         skipToNextControl
//       ];
//     } else {
//       return [
//         skipToPreviousControl,
//         playControl,
//         stopControl,
//         skipToNextControl
//       ];
//     }
//   }
// }

// MediaControl playControl = MediaControl(
//   androidIcon: 'drawable/ic_action_play_arrow',
//   label: 'Play',
//   action: MediaAction.play,
// );
// MediaControl pauseControl = MediaControl(
//   androidIcon: 'drawable/ic_action_pause',
//   label: 'Pause',
//   action: MediaAction.pause,
// );
// MediaControl skipToNextControl = MediaControl(
//   androidIcon: 'drawable/ic_action_skip_next',
//   label: 'Next',
//   action: MediaAction.skipToNext,
// );
// MediaControl skipToPreviousControl = MediaControl(
//   androidIcon: 'drawable/ic_action_skip_previous',
//   label: 'Previous',
//   action: MediaAction.skipToPrevious,
// );
// MediaControl stopControl = MediaControl(
//   androidIcon: 'drawable/ic_action_stop',
//   label: 'Stop',
//   action: MediaAction.stop,
// );

// class ScreenState {
//   final List<MediaItem> queue;
//   final MediaItem mediaItem;
//   final PlaybackState playbackState;

//   ScreenState(this.queue, this.mediaItem, this.playbackState);
// }
