import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music/components/UI/input_type_group.dart';
import 'package:music/components/UI/music_bottom_bar.dart';
import 'package:music/components/UI/music_list.dart';
import 'package:music/entities/musics.dart';
import 'package:music/model/music_model.dart';
import 'package:music/model/player_model.dart';
import 'package:music/pages/player_page.dart';
import 'package:music/stores/store.dart';

class SearchSongs extends StatefulWidget {
  @override
  _SearchSongsState createState() => _SearchSongsState();
}

class _SearchSongsState extends State<SearchSongs> {
  MusicModel get _model => Store.value<MusicModel>(context);
  PlayerModel get _playModel => Store.value<PlayerModel>(context);
  String searchStr = '';
  TextEditingController _controller = TextEditingController();
  List<Musics> musics = List();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
            alignment: Alignment.center,
            width: size.width,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(children: <Widget>[
              Container(
                width: size.width * 0.1,
                child: IconButton(
                  padding: EdgeInsets.all(4),
                  icon: Icon(
                    Icons.expand_more,
                    size: 22,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              InputTypeGroup.customTextField(
                  width: size.width * 0.75,
                  placeHold: "搜索",
                  controller: _controller,
                  textFieldDidChanged: (text) {
                    _model.search(text).then((songs) {
                      setState(() {
                        musics = songs;
                      });
                    });
                  }),
            ]),
          ),
          Expanded(
            child: ListView(
              children: musics
                  .map(
                    (song) => GestureDetector(
                      child: MusicList(song: song),
                      onTap: () async {
                        print(Platform.isAndroid);
                        song.url =
                            Song.fromQQ(minUrl: await _model.getDetail(song));
                        _playModel.play(context, song);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => Player()));
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
        ]),
      ),
      bottomNavigationBar: MusicBottomBar(),
    );
  }
}
