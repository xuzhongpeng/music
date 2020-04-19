import 'package:flutter/material.dart';
import 'package:music/components/UI/music_list.dart';
import 'package:music/components/neumorphism/shadow.dart';
import 'package:music/provider/player_model.dart';
import 'package:music/stores/store.dart';

class MusicListDrawer extends StatefulWidget {
  @override
  _MusicListDrawerState createState() => _MusicListDrawerState();
}

class _MusicListDrawerState extends State<MusicListDrawer> {
  PlayerModel get _playModel => Store.value<PlayerModel>(context);

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: new ListView(
        children: _playModel.musics
            .map(
              (song) => GestureDetector(
                child: MusicItem(
                  song: song,
                  trailing: Container(
                      margin: EdgeInsets.only(left: 10),
                      child: OutShadow(
                        radius: 5,
                        padding: EdgeInsets.all(5),
                        child: GestureDetector(
                          child: Icon(
                            Icons.close,
                            size: 18,
                            color: Theme.of(context).primaryIconTheme.color,
                          ),
                          // padding: EdgeInsets.only(left: 10),
                          onTap: () {
                            _playModel.deleteMusic(song);
                          },
                        ),
                      )),
                ),
                onTap: () {
                  _playModel.playingMusic(song);
                },
              ),
            )
            .toList(),
      ),
    );
  }
}
