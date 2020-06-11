import 'dart:async';

// import 'package:audioplayers/audioplayers.dart';
import 'package:audio_service/audio_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:music/components/UI/loading.dart';
import 'package:music/entities/lyric.dart';
import 'package:music/entities/musics.dart';
import 'package:music/entities/q/user_detail.dart';
// import 'package:music/pages/exmaple.dart';
import 'package:music/services/q/songs_service.dart';
import 'package:music/stores/provider.dart';
import 'package:music/utils/auto_player.dart';
import 'package:music/utils/auto_player_task.dart';
import 'package:music/utils/utils.dart';
import 'package:music/utils/json_manager.dart';
// import 'package:music_notification/music_notification.dart';
import 'package:toast/toast.dart';
// import 'package:music/utils/auto_player_task.dart';
import 'package:rxdart/rxdart.dart';

class PlayerModel extends MuProvider {
  //**************播放器相关 */
  // AudioPlayer _audioPlayer = AudioPlayer();
  // AudioPlayer get audioPlayer => _audioPlayer;
  //当前播放音乐的时间长度
  Duration duration;
  //当前播放音乐定位
  Duration position;

  ///给Slider组件用的百分比
  double sliderValue = 0.0;

  //****************音乐相关 */

  String qq;
  UserDetail userDetail;
  List<MusicEntity> _musics = List(); // 播放列表
  List<MusicEntity> _love = List();
  List<MusicEntity> get musics => _musics;
  List<MusicEntity> get love => _love;
  MusicEntity _play; //当前播放
  MusicEntity get play => _play;
  Map<String, Lyric> lyrics = Map();
  // AutoPlayer _autoPlayer = new AutoPlayer();
  // AutoPlayer get autoPlayer => _autoPlayer;
  //给系统发出通知用
  // MusicNotification notification;
  //*************方法 */
  PlayerModel() {
    initMusic();
    initPlayer();
    // initNotification();
  }
  initMusic() async {
    await AutoPlayer.start();
    await _parse(await JsonManager.getMusicList());
    String id = await JsonManager.getPlaying();
    List temp = _musics.where((test) {
      return id == test.id;
    }).toList();
    if (temp.length == 1) {
      _play = temp.first;
    }
    if (_play != null) {
      // await _audioPlayer.setUrl(_play.url.minUrl);
    }
  }

  //获取播放状态
  Stream<ScreenState> get screenStateStream =>
      Rx.combineLatest3<List<MediaItem>, MediaItem, PlaybackState, ScreenState>(
          AudioService.queueStream,
          AudioService.currentMediaItemStream,
          AudioService.playbackStateStream,
          (queue, mediaItem, playbackState) =>
              ScreenState(queue, mediaItem, playbackState));
  final BehaviorSubject<double> dragPositionSubject =
      BehaviorSubject.seeded(null);
  Stream<double> get _positionStream =>
      Rx.combineLatest2<double, double, double>(
          dragPositionSubject.stream,
          Stream.periodic(Duration(milliseconds: 200)),
          (dragPosition, _) => dragPosition);
  //获取当前播放时间
  // initNotification() {
  //   MusicNotification.lastStream.listen((_) {
  //     last();
  //   });
  //   MusicNotification.nextStream.listen((_) {
  //     next();
  //   });
  //   MusicNotification.stateChangeStream.listen((PlayerState state) {
  //     if (isPlaying) {
  //       pause();
  //     } else {
  //       resume();
  //     }
  //   });
  // }

  Future<List<MusicEntity>> search(String key) {
    return SongService().searchQQ(key);
  }

  Future<String> getDetail(MusicEntity musics) async {
    return await SongService().getDetail(musics);
  }

  setPlayingSong(MusicEntity music) {
    _play = music;
    // setNotification(isPlaying: true);
    int index = _musics.indexWhere((m) => m.id == music.id);
    if (index == -1)
      _musics.add(music);
    else
      _musics[index] = music;
    JsonManager.saveMusicList(_dataToJson());
    JsonManager.savePlaying(_play);
  }

  String n = "0";
  ScreenState screenState;
  AudioProcessingState processingState = AudioProcessingState.none;

  ///是否在播放
  bool isPlaying = false;
  StreamSubscription _screenSubscription;
  StreamSubscription _positionSubscription;
  initPlayer() async {
    _screenSubscription = AutoPlayer.screenStateStream.listen((state) {
      if (state != null && state.playbackState?.processingState != null) {
        screenState = state;
        if (screenState.mediaItem != null) {
          isPlaying = state.playbackState.playing;
          _play = screenState != null && screenState.mediaItem != null
              ? MusicEntity.fromJson(screenState.mediaItem.extras)
              : null;
          duration = screenState.mediaItem.duration;
          if (lyrics[_play.cid] == null) {
            getLyric(_play).then((Lyric lyric) {
              lyrics[_play.cid] = lyric;
              _play.lyric = lyric;
              notifyListeners();
            });
          } else {
            _play.lyric = lyrics[_play.cid];
          }

          //添加播放歌曲到本地
          if (isPlaying) {
            setPlayingSong(_play);
          }
        }
        processingState =
            state.playbackState?.processingState ?? AudioProcessingState.none;
        if (isPlaying) {
          _positionSubscription.resume();
          isPlaying = true;
        } else {
          // _positionSubscription?.pause();
          isPlaying = false;
        }
        notifyListeners();
      } else {
        isPlaying = false;
        // _positionSubscription?.pause();
        notifyListeners();
      }
    });

    _positionSubscription = _positionStream.listen((p) {
      if (screenState?.playbackState?.currentPosition != null &&
          duration != null) {
        this.position = screenState.playbackState.currentPosition;
        this.sliderValue = p ?? (this.position.inSeconds / duration.inSeconds);
        notifyListeners();
      }
    });
    //播放总时间变化时
    // audioPlayer.onDurationChanged.listen((duration) {
    //   this.duration = duration;
    //   _changeSlider();
    //   notifyListeners();
    // });
    // //播放时间变化时
    // audioPlayer.onAudioPositionChanged.listen((position) {
    //   // if (n != position.inSeconds.toString()) {
    //   //   n = position.inSeconds.toString();
    //   // }
    //   this.position = position;
    //   _changeSlider();
    //   notifyListeners();
    // });
    // audioPlayer.onPlayerStateChanged.listen((AudioPlayerState state) {
    //   isPlaying = state == AudioPlayerState.PLAYING ? true : false;
    //   notifyListeners();
    // });
    // audioPlayer.onPlayerCompletion.listen((_) {
    //   // this.isPlaying = false;
    //   print('播放完成,下一首');
    //   next();
    //   notifyListeners();
    // });
  }

//如果下一首5s内没播放 那么自动跳转
  _awaitTime() {
    Future.delayed(Duration(milliseconds: 5000), () {
      // if (_audioPlayer.state != AudioPlayerState.PLAYING) {
      //   next();
      // }
    });
  }

  //播放新音乐+下载音乐链接+
  Future<void> playingMusic(MusicEntity song) async {
    if (song.url == null) {
      int index = musics.indexWhere((m) => m.cid == song.cid);
      if (index != -1 && musics[index]?.url != null) {
        song.url = musics[index].url;
      } else
        song.url = Song.fromQQ(minUrl: await getDetail(song));
    }
    if (song.url != null) {
      await playing(music: song);
    } else {
      print('没有权限');
    }
  }

  //播放新音乐
  Future<void> playing({MusicEntity music}) async {
    if (music == null) {
      music = _play;
    }
    //新的跟旧的不等  或者 当前没有播放音乐
    if (play?.id != music.id || !isPlaying) {
      // if (music.url == null) {
      //   playingMusic(music);
      // } else
      {
        AutoPlayer.addItemAndPlay(music);
        if (lyrics[music.cid] == null) {
          getLyric(music).then((Lyric lyric) {
            lyrics[music.cid] = lyric;
            music.lyric = lyric;
            notifyListeners();
          });
        }
        notifyListeners();
        return true;
      }
    } else {
      return false;
    }
  }

  Future<Lyric> getLyric(MusicEntity music) async {
    if (music.lyric == null) {
      return await Utils.getLyricFromTxt(music.cid);
    } else {
      return music.lyric;
    }
  }

  //添加播放列表
  addPlayerList(List<MusicEntity> songList) {
    if (songList.length > 0) {
      _musics = songList;
      JsonManager.saveMusicList(_dataToJson());
      playingMusic(songList.first);
    }
  }

  deleteMusic(MediaItem music) {
    _musics.removeWhere((m) => m.cid == MusicEntity.fromJson(music.extras).cid);
    AudioService.removeQueueItem(music);
    JsonManager.saveMusicList(_dataToJson());
    notifyListeners();
  }

  //暂停
  // pause() {
  //   AudioService.pause();
  //   // setNotification(isPlaying: false);
  //   notifyListeners();
  // }

  //播放
  // resume() {
  //   AudioService.play();
  //   setNotification(isPlaying: true);
  //   notifyListeners();
  // }

  next1() {
    List musics = _musics;
    int index = musics.indexOf(play);
    MusicEntity music;
    if (musics.length - 1 > index) {
      music = musics[index + 1];
    } else {
      music = musics[0];
    }
    // playing(music);
    _awaitTime();
  }

  //切换上一首
  last() {
    List musics = _musics;
    int index = musics.indexOf(play);
    MusicEntity music;
    if (index == 0) {
      music = musics.last;
    } else {
      music = musics[index - 1];
    }
    // playing(music);
  }

  Timer timer;

  ///跳过
  seek(double newValue) async {
    if (timer != null) {
      timer.cancel();
    }
    timer = Timer(Duration(milliseconds: 300), () async {
      // print("audioPlayer.seek: $seconds");
      await AudioService.seekTo(Duration(
          milliseconds: (newValue * this.duration.inMilliseconds).toInt()));
      this.sliderValue = newValue;
      Timer(Duration(milliseconds: 200), () {
        dragPositionSubject.add(null);
      });
    });
  }

  //改变进度条
  _changeSlider() {
    if (duration != null && position != null) {
      new Timer(Duration(milliseconds: 400), () {
        this.sliderValue = (position.inSeconds / duration.inSeconds);
      });
    }
  }

  // setNotification({bool isPlaying}) async {
  //   if (this._play != null) {
  //     String imageUrl = this.play?.headerImg;
  //     Response<List<int>> list = await Dio().get<List<int>>(
  //       imageUrl,
  //       options: Options(responseType: ResponseType.bytes), //设置接收类型为bytes
  //     );
  //     // MusicNotification.start(NotifiParams(
  //     //     imgUrl: Uint8List.fromList(list.data),
  //     //     singer: play.singer,
  //     //     musicName: play.name,
  //     //     isPlaying: isPlaying));
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
    // _audioPlayer.dispose();
    AudioService.disconnect();
    AudioService.stop();
    _screenSubscription?.cancel();
    _positionSubscription?.cancel();
    dragPositionSubject?.close();
  }

  //获取需要缓存的数据
  Map<String, dynamic> _dataToJson() {
    Map<String, dynamic> map = {};
    map['qq'] = qq;
    map['music'] = musics.map((m) => m.toJson()).toList();
    map['love'] = love.map((m) => m.toJson()).toList();
    return map;
  }

  //获取需要缓存的数据
  _parse(Map<String, dynamic> map) async {
    if (map != null && map.isNotEmpty) {
      var musicData = map['musicData'];
      if (musicData['music'] != null) {
        qq = musicData['qq'];
        List musicList = musicData['music'];
        for (int i = 0; i < musicList.length; i++) {
          MusicEntity music = MusicEntity.fromJson(musicList[i]);
          if (music.url?.midUrl == null &&
              music.url?.minUrl == null &&
              music.url?.bigUrl == null) {
            //设置这个只是为了占位，因为这个因为是到播放的时候才开始去拉取歌曲url
            music.url?.midUrl = 'jsshou' + music.cid;
          }
          await AutoPlayer.addItem(music);
          _musics.add(music);
        }
      }
      if (musicData['love'] != null)
        _love = List<MusicEntity>.from(
            musicData['love'].map((m) => MusicEntity.fromJson(m)).toList());
      var playing = map['playing'];
      if (playing != null) _play = MusicEntity.fromJson(playing);
      notifyListeners();
    }
  }

  //获取用户信息
  saveUserInfo(String qq, BuildContext context) {
    Loading().show(context: context);
    this.qq = qq;
    SongService().getQSongListByQQ(qq: qq).then((result) {
      userDetail = result;
      JsonManager.saveUser(userDetail.toJson());
      Loading().dismiss();
      notifyListeners();
    }).catchError((onError) {
      Loading().dismiss();
      Toast.show(onError.toString(), context,
          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
    });
  }
}
