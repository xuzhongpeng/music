import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music/entities/musics.dart';
import 'package:music/model/music_model.dart';
import 'package:music/stores/provider.dart';
import 'package:music/stores/store.dart' as s;

class PlayerModel extends MuProvider {
  AudioPlayer _audioPlayer = AudioPlayer();
  AudioPlayer get audioPlayer => _audioPlayer;
  MusicModel _musicModel;
  //播放音乐
  Future<bool> play(BuildContext context, Musics music) async {
    int result = await _audioPlayer.play(music.url.midUrl);
    _musicModel = s.Store.value(context);
    _musicModel.play = music;
    notifyListeners();
    return result == 1;
  }
}
