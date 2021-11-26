import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:music/components/UI/music_list.dart';
import 'package:music/components/neumorphism/shadow.dart';
import 'package:music/entities/musics.dart';
import 'package:music/player/notifiers/play_button_notifier.dart';
import 'package:music/player/page_manager.dart';
import 'package:music/player/services/service_locator.dart';
import 'package:music/provider/player_model.dart';
import 'package:music/stores/store.dart';
// import 'package:music/utils/auto_player_task.dart1';

class MusicListDrawer extends StatefulWidget {
  @override
  _MusicListDrawerState createState() => _MusicListDrawerState();
}

class _MusicListDrawerState extends State<MusicListDrawer> {
  var pageManager = getIt<PageManager>();
  @override
  Widget build(BuildContext context) {
    var _model = Store.value<PlayerModel>(context);

    return new Drawer(
        child: ValueListenableBuilder<List<MusicEntity>>(
            valueListenable: pageManager.playlistNotifier,
            builder: (context, value,_) {
              final musics = value ?? [];
              return ListView(
                children: musics.map((song) {
                  if (song == null) {
                    return Container();
                  }
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
                                _model.deleteMusic(song);
                              },
                            ),
                          )),
                    ),
                    onTap: () {
                      pageManager.addItemAndPlay(song);
                    },
                  );
                }).toList(),
              );
            }));
  }
}
