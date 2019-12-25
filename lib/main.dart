import 'package:flutter/material.dart';
import 'package:music/config/http.dart';
import 'package:music/model/player_model.dart';
import 'package:music/pages/search_songs.dart';
import 'package:music/stores/store.dart';

import 'model/music_model.dart';

void main() {
  Http http = Http();
  http.init();
  return runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Store.provider(
      providers: [
        ChangeNotifierProvider<MusicModel>(create: (_) => MusicModel()),
        ChangeNotifierProvider<PlayerModel>(create: (_) => PlayerModel())
      ],
      child: new MaterialApp(
        theme: new ThemeData(primarySwatch: Colors.blue, fontFamily: ''),
        home: new SearchSongs(),
      ),
    );
  }
}
