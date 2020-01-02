import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music/components/UI/input_type_group.dart';
import 'package:music/components/UI/loading.dart';
import 'package:music/components/UI/music_bottom_bar.dart';
import 'package:music/components/UI/music_list.dart';
import 'package:music/components/UI/page_route.dart';
import 'package:music/entities/musics.dart';
import 'package:music/model/music_model.dart';
import 'package:music/model/player_model.dart';
import 'package:music/stores/store.dart';

import 'mian_player.dart';

class SearchSongs extends StatefulWidget {
  @override
  _SearchSongsState createState() => _SearchSongsState();
}

class _SearchSongsState extends State<SearchSongs> {
  PlayerModel get _model => Store.value<PlayerModel>(context);
  PlayerModel get _playModel => Store.value<PlayerModel>(context);
  String searchStr = '';
  TextEditingController _controller = TextEditingController();
  List<MusicEntity> musics = List();
  bool isLoad = false;
  Timer timer;
  //焦点
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
              Hero(
                tag: 'search',
                child: Material(
                  child: InputTypeGroup.customTextField(
                      width: size.width * 0.80,
                      placeHold: "搜索",
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
                ),
              ),
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
      bottomNavigationBar: MusicBottomBar(),
    );
  }
}
