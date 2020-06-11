import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:music/components/UI/music_list.dart';
import 'package:music/components/neumorphism/shadow.dart';
import 'package:music/entities/musics.dart';
import 'package:music/provider/player_model.dart';
import 'package:music/stores/store.dart';
import 'package:music/utils/auto_player.dart';
import 'package:music/utils/auto_player_task.dart';

class MusicListDrawer extends StatefulWidget {
  @override
  _MusicListDrawerState createState() => _MusicListDrawerState();
}

class _MusicListDrawerState extends State<MusicListDrawer> {
  @override
  Widget build(BuildContext context) {
    var _model = Store.value<PlayerModel>(context);
    return new Drawer(
        child: StreamBuilder<ScreenState>(
            stream: AutoPlayer.screenStateStream,
            builder: (context, snapshot) {
              final screenState = snapshot.data;
              final musics = screenState?.queue ?? [];
              return ListView(
                children: musics.map((s) {
                  if (s.extras == null) {
                    return Container();
                  }
                  final song = MusicEntity.fromJson(s.extras);
                  return GestureDetector(
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
                                _model.deleteMusic(s);
                              },
                            ),
                          )),
                    ),
                    onTap: () {
                      AutoPlayer.addItemAndPlay(song);
                    },
                  );
                }).toList(),
              );
            }));
  }
}
