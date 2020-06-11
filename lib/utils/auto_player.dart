import 'package:audio_service/audio_service.dart';
import 'package:music/entities/lyric.dart';
import 'package:music/entities/musics.dart';
import 'package:music/utils/auto_player_task.dart';
import 'package:rxdart/rxdart.dart';

import 'utils.dart';

void _audioPlayerTaskEntrypoint() async {
  // AudioServiceBackground.run(() => AudioPlayerTask(mediaItem: []));
  AudioServiceBackground.run(() => AudioPlayerTask(mediaItem: [
        // MediaItem(
        //   id: "http://music.163.com/song/media/outer/url?id=1427051960.mp3",
        //   album: "Science Friday",
        //   title: "不要说话",
        //   artist: "Science Friday and WNYC Studios",
        //   artUri:
        //       "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
        // ),
        // MediaItem(
        //   id: "http://music.163.com/song/media/outer/url?id=1430912811.mp3",
        //   album: "Science Friday",
        //   title: "心墙",
        //   artist: "Science Friday and WNYC Studios",
        //   artUri:
        //       "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
        // ),
      ]));
}

class AutoPlayer {
  //开始
  static start() async {
    if (AudioService.playbackState?.processingState == null ||
        AudioService.playbackState?.processingState ==
            AudioProcessingState.none)
      await AudioService.start(
        backgroundTaskEntrypoint: _audioPlayerTaskEntrypoint,
        androidNotificationChannelName: 'JSSHOU音乐',
        androidNotificationColor: 0xFF2196f3,
        androidNotificationIcon: 'mipmap/ic_launcher',
        androidEnableQueue: true,
      );
  }

  ///添加歌曲 添加到待播放列表
  static addItems(List<MusicEntity> songList) async {
    for (int i = 0; i < songList.length; i++) {
      var song = songList[i];
      await AudioService.addQueueItem(song.toMediaItem());
    }
  }

  static addItem(MusicEntity song) async {
    await AudioService.addQueueItem(song.toMediaItem());
  }

  ///添加歌曲并播放
  static addItemAndPlay(MusicEntity song) async {
    await start();
    // if (AudioService.playbackState?.processingState != null &&
    //     AudioService.playbackState?.processingState == BasicPlaybackState.paused) {
    //   await AudioService.play();
    // } else {
    await AudioService.addQueueItem(song.toMediaItem());
    await AudioService.playFromMediaId(song.cid);
    // }
  }

  ///获取播放状态
  static Stream<ScreenState> get screenStateStream =>
      Rx.combineLatest3<List<MediaItem>, MediaItem, PlaybackState, ScreenState>(
          AudioService.queueStream,
          AudioService.currentMediaItemStream,
          AudioService.playbackStateStream,
          (queue, mediaItem, playbackState) =>
              ScreenState(queue, mediaItem, playbackState));

  static final BehaviorSubject<double> dragPositionSubject =
      BehaviorSubject.seeded(null);

  ///获取当前播放状态
  static Stream<double> get positionStream =>
      Rx.combineLatest2<double, double, double>(
          dragPositionSubject.stream,
          Stream.periodic(Duration(milliseconds: 200)),
          (dragPosition, _) => dragPosition);
}
