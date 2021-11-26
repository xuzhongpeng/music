import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music/components/UI/input_type_group.dart';
import 'package:music/components/UI/js_scaffold.dart';
import 'package:music/components/UI/loading.dart';
import 'package:music/components/UI/music_list.dart';
import 'package:music/components/UI/page_route.dart';
import 'package:music/components/neumorphism/shadow.dart';
import 'package:music/entities/musics.dart';
import 'package:music/provider/player_model.dart';
import 'package:music/stores/store.dart';

import 'mian_player.dart';

class SearchSongs extends StatefulWidget {
  @override
  _SearchSongsState createState() => _SearchSongsState();
}

class _SearchSongsState extends State<SearchSongs> {
  PlayerModel get _model => Store.value<PlayerModel>(context, listen: false);
  PlayerModel get _playModel => Store.value<PlayerModel>(context, listen: false);
  String searchStr = '';
  TextEditingController _controller = TextEditingController();
  List<MusicEntity> musics = List();
  bool isLoad = false;
  Timer timer;
  //焦点
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return JsScaffold(
      body: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
            alignment: Alignment.center,
            width: size.width,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(children: <Widget>[
              Container(
                // width: size.width * 0.1,
                margin: EdgeInsets.all(10),
                child: OutShadow(
                  width: 35,
                  height: 35,
                  child: IconButton(
                    // padding: EdgeInsets.all(4),
                    icon: Icon(
                      Icons.expand_more,
                      size: 20,
                      color: Theme.of(context).primaryIconTheme.color,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
              InputTypeGroup(
                  width: size.width * 0.70,
                  height: 35,
                  placeHold: "周杰伦",
                  controller: _controller,
                  autofocus: true,
                  textFieldDidChanged: (text) {
                    timer?.cancel();
                    timer = new Timer(Duration(milliseconds: 500), () {
                      // Loading().show(context: context);
                      setState(() {
                        isLoad = true;
                      });
                      _model.search(text).then((songs) {
                        if (songs != null) {
                          musics = songs;
                        } else {
                          musics = List();
                        }
                        setState(() {
                          isLoad = false;
                        });
                      });
                    });
                  }),
            ]),
          ),
          Expanded(
            child: Loading().GMLoading(
              show: isLoad,
              color: Color.fromRGBO(20, 21, 21, 0),
              child: MusicList(
                musics: musics,
                onTap: (MusicEntity song) async {
                  await _playModel.playingMusic(song);
                  Navigator.push(
                      context, FadeRoute(page: MusicPlayerExample()));
                },
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
