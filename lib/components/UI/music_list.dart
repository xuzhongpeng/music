import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:music/components/iconfont/iconfont.dart';
import 'package:music/components/neumorphism/shadow.dart';
import 'package:music/entities/musics.dart';
import 'package:music/provider/music_model.dart';
import 'package:music/provider/player_model.dart';
import 'package:music/stores/store.dart';
import 'package:music/utils/auto_player.dart';
import 'package:music/utils/auto_player_task.dart';

typedef Future<void> OnTapMusic(MusicEntity list);

class MusicList extends StatelessWidget {
  final List<MusicEntity> musics;
  final OnTapMusic onTap;
  MusicList({this.musics, this.onTap});
  @override
  Widget build(BuildContext context) {
    // PlayerModel _model = Store.value<PlayerModel>(context);
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
    final basicState = _model?.processingState ?? AudioProcessingState.none;
    return Container(
      width: size.width,
      height: 80,
      color: Colors.white10,
      // decoration: BoxDecoration(
      //     border: Border(
      //         bottom: BorderSide(
      //             width: 1,
      //             color: Colors.white))), //Color.fromRGBO(222, 226, 230, 1)
      child: Row(
        children: <Widget>[
          Container(
            width: size.width * 0.25,
            alignment: Alignment.center,
            child: OutShadow(
              radius: 10,
              padding: EdgeInsets.all(0.5),
              child: Container(
                alignment: Alignment.center,
                height: 60,
                width: 60,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                      imageUrl: song?.headerImg ?? "", fit: BoxFit.cover),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              // width: size.width * 0.5,
              padding: EdgeInsets.only(left: 0, top: 10),
              // color: Colors.red,
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 30,
                    child: Text(song.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            // color: Color.fromRGBO(0, 0, 0, 1),
                            fontSize: 16,
                            fontWeight: FontWeight.w300)),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 20,
                    child: Text(song.singer,
                        style: TextStyle(
                            color: Theme.of(context).textTheme.body2.color,
                            // color: Color.fromRGBO(119, 119, 119, 1),
                            fontSize: 12)),
                  )
                ],
              ),
            ),
          ),
          Container(
              padding: EdgeInsets.only(right: 15),
              alignment: Alignment.centerRight,
              child: Row(
                children: <Widget>[
                  _model.play?.id == song.id && _model.isPlaying
                      ? InnerShadow(
                          radius: 5,
                          padding: EdgeInsets.all(8),
                          child: Icon(IconFont.iconzanting,
                              color: Theme.of(context).primaryIconTheme.color),
                        )
                      : OutShadow(
                          radius: 5,
                          padding: EdgeInsets.all(8),
                          child: Icon(IconFont.iconbofang,
                              color: Theme.of(context).primaryIconTheme.color),
                        ),
                  trailing != null ? trailing : Container()
                ],
              ))
        ],
      ),
    );
  }
}
