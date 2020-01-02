import 'package:flutter/material.dart';
import 'package:music/components/UI/music_list.dart';
import 'package:music/model/player_model.dart';
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
                    trailing: GestureDetector(
                      child: Padding(
                        child: Icon(
                          Icons.close,
                          size: 18,
                          color: Color.fromRGBO(119, 119, 119, 1),
                        ),
                        padding: EdgeInsets.only(left: 10),
                      ),
                      onTap: () {
                        _playModel.deleteMusic(song);
                      },
                    )),
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
