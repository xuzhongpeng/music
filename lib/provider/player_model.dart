import 'dart:async';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:music/components/UI/loading.dart';
import 'package:music/entities/lyric.dart';
import 'package:music/entities/musics.dart';
import 'package:music/entities/q/user_detail.dart';
import 'package:music/services/q/songs_service.dart';
import 'package:music/stores/provider.dart';
import 'package:music/utils/utils.dart';
import 'package:music/utils/json_manager.dart';
import 'package:music_notification/music_notification.dart';
import 'package:toast/toast.dart';

class PlayerModel extends MuProvider {
  //**************播放器相关 */
  AudioPlayer _audioPlayer = AudioPlayer();
  AudioPlayer get audioPlayer => _audioPlayer;
  //当前播放音乐的时间长度
  Duration duration;
  //当前播放音乐定位
  Duration position;

  ///给Slider组件用的百分比
  double sliderValue;

  //****************音乐相关 */

  String qq;
  UserDetail userDetail;
  List<MusicEntity> _musics = List(); // 播放列表
  List<MusicEntity> _love = List();
  List<MusicEntity> get musics => _musics;
  List<MusicEntity> get love => _love;
  MusicEntity _play; //当前播放
  MusicEntity get play => _play;

  //给系统发出通知用
  MusicNotification notification;
  //*************方法 */
  PlayerModel() {
    initMusic();
    initPlayer();
    initNotification();
  }
  initMusic() async {
    _parse(await JsonManager.getMusicList());
    String id = await JsonManager.getPlaying();
    List temp = _musics.where((test) {
      return id == test.id;
    }).toList();
    if (temp.length == 1) {
      _play = temp.first;
    }
    if (_play != null) {
      await _audioPlayer.setUrl(_play.url.minUrl);
    }
  }

  initNotification() {
    MusicNotification.lastStream.listen((_) {
      last();
    });
    MusicNotification.nextStream.listen((_) {
      next();
    });
    MusicNotification.stateChangeStream.listen((PlayerState state) {
      if (isPlaying) {
        pause();
      } else {
        resume();
      }
    });
  }

  Future<List<MusicEntity>> search(String key) {
    return SongService().searchQQ(key);
  }

  Future<String> getDetail(MusicEntity musics) async {
    return await SongService().getDetail(musics);
  }

  setPlayingSong(MusicEntity music) {
    _play = music;
    setNotification(isPlaying: true);
    if (_musics.where((m) => m.id == music.id).length == 0) _musics.add(music);
    JsonManager.saveMusicList(_dataToJson());
    JsonManager.savePlaying(_play);
  }

  String n = "0";

  ///是否在播放
  bool isPlaying = false;
  initPlayer() {
    //播放总时间变化时
    audioPlayer.onDurationChanged.listen((duration) {
      this.duration = duration;
      _changeSlider();
      notifyListeners();
    });
    //播放时间变化时
    audioPlayer.onAudioPositionChanged.listen((position) {
      // if (n != position.inSeconds.toString()) {
      //   n = position.inSeconds.toString();
      // }
      this.position = position;
      _changeSlider();
      notifyListeners();
    });
    audioPlayer.onPlayerStateChanged.listen((AudioPlayerState state) {
      isPlaying = state == AudioPlayerState.PLAYING ? true : false;
      notifyListeners();
    });
    audioPlayer.onPlayerCompletion.listen((_) {
      // this.isPlaying = false;
      print('播放完成,下一首');
      next();
      notifyListeners();
    });
  }

//如果下一首5s内没播放 那么自动跳转
  _awaitTime() {
    Future.delayed(Duration(milliseconds: 5000), () {
      if (_audioPlayer.state != AudioPlayerState.PLAYING) {
        next();
      }
    });
  }

  //播放新音乐+下载音乐链接+
  Future<void> playingMusic(MusicEntity song) async {
    song.url = Song.fromQQ(minUrl: await getDetail(song));
    if (song.url != null) {
      await playing(song);
    } else {
      print('没有权限');
    }
  }

  //播放新音乐
  Future<bool> playing(MusicEntity music) async {
    if (play?.id != music.id) {
      await _audioPlayer.stop();
      if (music.url == null) {
        playingMusic(music);
      } else {
        int result = await _audioPlayer.play(music.url.midUrl, stayAwake: true);
        if (music.lyric == null) {
          getLyric(music).then((Lyric lyric) {
            music.lyric = lyric;
            notifyListeners();
          });
        }
        setPlayingSong(music);
        notifyListeners();
        return result == 1;
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

  deleteMusic(MusicEntity music) {
    _musics.remove(music);
    JsonManager.saveMusicList(_dataToJson());
    notifyListeners();
  }

  //暂停
  pause() {
    _audioPlayer.pause();
    setNotification(isPlaying: false);
    notifyListeners();
  }

  //播放
  resume() {
    _audioPlayer.resume();
    setNotification(isPlaying: true);
    notifyListeners();
  }

  next() {
    List musics = _musics;
    int index = musics.indexOf(play);
    MusicEntity music;
    if (musics.length - 1 > index) {
      music = musics[index + 1];
    } else {
      music = musics[0];
    }
    playing(music);
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
    playing(music);
  }

  Timer timer;

  ///跳过
  seek(double newValue) {
    timer?.cancel();
    sliderValue = newValue;
    notifyListeners();
    timer = new Timer(Duration(milliseconds: 300), () {
      //搜索函数
      print('sliver');
      if (duration != null) {
        int seconds = (duration.inSeconds * newValue).round();
        // print("audioPlayer.seek: $seconds");
        seekPlayer(seconds);
      }
    });
  }

  seekPlayer(int seekValue) {
    audioPlayer.seek(new Duration(seconds: seekValue));
    notifyListeners();
  }

  //改变进度条
  _changeSlider() {
    if (duration != null && position != null) {
      new Timer(Duration(milliseconds: 400), () {
        this.sliderValue = (position.inSeconds / duration.inSeconds);
      });
    }
  }

  setNotification({bool isPlaying}) async {
    if (this._play != null) {
      String imageUrl = this.play?.headerImg;
      Response<List<int>> list = await Dio().get<List<int>>(
        imageUrl,
        options: Options(responseType: ResponseType.bytes), //设置接收类型为bytes
      );
      MusicNotification.start(NotifiParams(
          imgUrl: Uint8List.fromList(list.data),
          singer: play.singer,
          musicName: play.name,
          isPlaying: isPlaying));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _audioPlayer.dispose();
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
  _parse(Map<String, dynamic> map) {
    if (map != null && map.isNotEmpty) {
      var musicData = map['musicData'];
      if (musicData['music'] != null) {
        qq = musicData['qq'];
        _musics = List<MusicEntity>.from(
            musicData['music'].map((m) => MusicEntity.fromJson(m)).toList());
      }
      if (musicData['love'] != null)
        _love = List<MusicEntity>.from(
            musicData['love'].map((m) => MusicEntity.fromJson(m)).toList());
      var playing = map['playing'];
      if (playing != null) _play = MusicEntity.fromJson(playing);
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
