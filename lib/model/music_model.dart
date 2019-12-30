// import 'package:flutter/material.dart';
// import 'package:music/entities/musics.dart';
// import 'package:music/model/player_model.dart';
// import 'package:music/services/songs_service.dart';
// import 'package:music/stores/provider.dart';
// import 'package:music/stores/store.dart';
// import 'package:music/utils/json_manager.dart';

// class MusicModel extends MuProvider {
//   List<MusicEntity> _musics = List(); // 播放列表
//   List<MusicEntity> get musics => _musics;
//   MusicEntity _play; //当前播放
//   MusicEntity get play => _play;

//   init(BuildContext context) async {
//     _musics = await JsonManager.getMusicList();
//     _play = await JsonManager.getPlaying();
//     PlayerModel playerModel = Store.value<PlayerModel>(context);
//     playerModel.play(context, _play);
//     playerModel.pause();
//   }

//   Future<List<MusicEntity>> search(String key) {
//     return SongService().searchQQ(key);
//   }

//   Future<String> getDetail(MusicEntity musics) async {
//     return await SongService().getDetail(musics);
//   }

//   setPlayingSong(MusicEntity music) {
//     _play = music;
//     if (!_musics.contains(music)) _musics.add(music);
//     JsonManager.saveMusicList(_musics);
//     JsonManager.savePlaying(_play);
//   }
// }
