import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music/components/UI/input_type_group.dart';
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
  String searchStr = '';
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          InputTypeGroup.customTextField(
              width: 100,
              controller: _controller,
              textFieldDidChanged: (text) {
                _model.search(text);
              }),
          Expanded(
            child: ListView(
              children: _model.musics
                  .map(
                    (song) => GestureDetector(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 55,
                        child: Text(song.name),
                      ),
                      onTap: () async {
                        print(Platform.isAndroid);
                        song.url =
                            Song.fromQQ(minUrl: await _model.getDetail(song));
                        _model.audioPlayer.play(song.url.minUrl);
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
        ]),
      ),
      floatingActionButton: CupertinoButton(
        child: Text("搜索"),
        onPressed: (() {}),
      ),
    );
  }
}
