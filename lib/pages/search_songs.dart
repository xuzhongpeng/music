import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music/components/UI/input_type_group.dart';
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
                      child: item(song),
                      onTap: () async {
                        print(Platform.isAndroid);
                        song.url =
                            Song.fromQQ(minUrl: await _model.getDetail(song));
                        _playModel.audioPlayer.play(song.url.minUrl);
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
    );
  }

  Widget item(Musics song) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: 60,
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  width: 1, color: Color.fromRGBO(222, 226, 230, 1)))),
      child: Row(
        children: <Widget>[
          Container(
            width: size.width * 0.7,
            padding: EdgeInsets.only(left: 10),
            // color: Colors.red,
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  height: 30,
                  child: Text(song.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontSize: 16,
                          fontWeight: FontWeight.w300)),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  height: 20,
                  child: Text(song.singer,
                      style: TextStyle(
                          color: Color.fromRGBO(119, 119, 119, 1),
                          fontSize: 12)),
                )
              ],
            ),
          ),
          Container(
            width: size.width * 0.3,
            // color: Colors.blue,
            padding: EdgeInsets.only(right: 15),
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.play_circle_outline,
              color: Color.fromRGBO(119, 119, 119, 1),
            ),
          )
        ],
      ),
    );
  }
}
