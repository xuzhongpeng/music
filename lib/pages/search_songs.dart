import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music/entities/musics.dart';
import 'package:music/model/music_model.dart';
import 'package:music/services/songs_service.dart';
import 'package:music/stores/store.dart';

class SearchSongs extends StatefulWidget {
  @override
  _SearchSongsState createState() => _SearchSongsState();
}

class _SearchSongsState extends State<SearchSongs> {
  MusicModel get _model => Store.value<MusicModel>(context);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: _model.musics
            .map(
              (song) => GestureDetector(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 55,
                  child: Text(song.name),
                ),
                onTap: () async {
                  song.url = Song.fromQQ(minUrl: await _model.getDetail(song));
                  _model.audioPlayer.play(song.url.minUrl);
                },
              ),
            )
            .toList(),
      ),
      floatingActionButton: CupertinoButton(
        child: Text("搜索"),
        onPressed: (() {
          _model.search('杰伦');
        }),
      ),
    );
  }
}
