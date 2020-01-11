import 'package:flutter/material.dart';
import 'package:music/components/iconfont/iconfont.dart';
import 'package:music/entities/musics.dart';
import 'package:music/provider/music_model.dart';
import 'package:music/provider/player_model.dart';
import 'package:music/stores/store.dart';

typedef Future<void> OnTapMusic(MusicEntity list);

class MusicList extends StatelessWidget {
  final List<MusicEntity> musics;
  final OnTapMusic onTap;
  MusicList({this.musics, this.onTap});
  @override
  Widget build(BuildContext context) {
    PlayerModel _model = Store.value<PlayerModel>(context);
    return ListView(
        children: musics
            .map((song) => GestureDetector(
                onTap: () {
                  onTap(song);
                },
                child: MusicItem(
                  song: song,
                )))
            .toList());
  }
}

class MusicItem extends StatelessWidget {
  final MusicEntity song;
  final Widget trailing;
  MusicItem({this.song, this.trailing});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    PlayerModel _model = Store.value<PlayerModel>(context);
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
            width: size.width * 0.16,
            alignment: Alignment.center,
            child: Container(
              alignment: Alignment.center,
              height: 35,
              width: 35,
              child: Image.network(song?.headerImg ?? "", fit: BoxFit.cover),
            ),
          ),
          Expanded(
            child: Container(
              // width: size.width * 0.5,
              padding: EdgeInsets.only(left: 0),
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
          ),
          Container(
              // width: size.width * 0.3,
              // color: Colors.blue,
              padding: EdgeInsets.only(right: 15),
              alignment: Alignment.centerRight,
              child: Row(
                children: <Widget>[
                  Icon(
                    _model.play?.id == song.id
                        ? IconFont.iconzanting
                        : IconFont.iconbofang,
                    color: Color.fromRGBO(119, 119, 119, 1),
                  ),
                  trailing != null ? trailing : Container()
                ],
              ))
        ],
      ),
    );
  }
}
