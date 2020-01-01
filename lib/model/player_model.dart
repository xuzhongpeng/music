import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music/components/UI/page_route.dart';
import 'package:music/entities/musics.dart';
import 'package:music/pages/mian_player.dart';
import 'package:music/services/q/songs_service.dart';
import 'package:music/entities/personalized.dart';
import 'package:music/stores/provider.dart';
import 'package:music/utils/json_manager.dart';

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
  List<MusicEntity> _musics = List(); // 播放列表
  List<MusicEntity> get musics => _musics;
  MusicEntity _play; //当前播放
  MusicEntity get play => _play;

  //*************方法 */
  PlayerModel() {
    initMusic();
    initPlayer();
  }
  initMusic() async {
    _musics = await JsonManager.getMusicList();
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

  Future<List<MusicEntity>> search(String key) {
    return SongService().searchQQ(key);
  }

  Future<String> getDetail(MusicEntity musics) async {
    return await SongService().getDetail(musics);
  }

  setPlayingSong(MusicEntity music) {
    _play = music;
    if (!_musics.contains(music)) _musics.add(music);
    JsonManager.saveMusicList(_musics);
    JsonManager.savePlaying(_play);
  }

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

  //播放新音乐+下载音乐链接
  playingMusic(BuildContext context, MusicEntity song) async {
    song.url = Song.fromQQ(minUrl: await getDetail(song));
    await playing(song);
    Navigator.push(context, FadeRoute(page: MusicPlayerExample()));
  }

  //播放新音乐
  Future<bool> playing(MusicEntity music) async {
    if (play != music) {
      await _audioPlayer.stop();
      int result = await _audioPlayer.play(music.url.midUrl);
      setPlayingSong(music);
      notifyListeners();
      return result == 1;
    } else {
      return false;
    }
  }

  //暂停
  pause() {
    _audioPlayer.pause();
    notifyListeners();
  }

  //播放
  resume() {
    _audioPlayer.resume();
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
  }

  //切换上一首
  last(BuildContext context) {
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
        audioPlayer.seek(new Duration(seconds: seconds));
        notifyListeners();
      }
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

  @override
  void dispose() {
    super.dispose();
    _audioPlayer.dispose();
  }
}
