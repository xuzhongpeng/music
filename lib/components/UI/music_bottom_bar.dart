// import 'package:audioplayers/audioplayers.dart';
import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:music/components/UI/page_route.dart';
import 'package:music/components/iconfont/iconfont.dart';
import 'package:music/components/neumorphism/shadow.dart';
import 'package:music/entities/musics.dart';
import 'package:music/provider/music_model.dart';
import 'package:music/provider/player_model.dart';
import 'package:music/pages/mian_player.dart';
import 'package:music/stores/store.dart';
import 'package:music/utils/auto_player.dart';
import 'package:music/utils/auto_player_task.dart';
import 'package:rxdart/rxdart.dart';

class MusicBottomBar extends StatefulWidget {
  final GlobalKey<ScaffoldState> globalKeyState;
  MusicBottomBar({@required this.globalKeyState});

  @override
  _MusicBottomBarState createState() => _MusicBottomBarState();
}

class _MusicBottomBarState extends State<MusicBottomBar> {
  PlayerModel get _model => Store.value<PlayerModel>(context);
  @override
  Widget build(BuildContext context) {
    double imgWidth = 35;
    return Builder(builder: (context) {
      final mediaItem = _model.play;
      final processingState = _model.processingState;
      return mediaItem != null
          ? SafeArea(
              child: Container(
                height: 60,
                padding: EdgeInsets.all(0),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(250, 250, 250, 1),
                    border: Border(
                        top: BorderSide(
                            width: 1,
                            color: Color.fromRGBO(222, 226, 230, 1)))),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 2,
                      width: MediaQuery.of(context).size.width,
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.grey[100],
                        valueColor: AlwaysStoppedAnimation(Colors.blue),
                        value: _model.sliderValue,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: <Widget>[
                            GestureDetector(
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(right: 10, left: 15),
                                child: Hero(
                                  tag: mediaItem?.id ?? "image",
                                  child: Material(
                                      child: Container(
                                    width: imgWidth,
                                    height: imgWidth,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.white, width: 1),
                                        borderRadius: BorderRadius.circular(
                                            imgWidth / 2)),
                                    child: OutShadow(
                                        radius: imgWidth / 2,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              imgWidth / 2),
                                          child: CachedNetworkImage(
                                              imageUrl: mediaItem?.headerImg,
                                              fit: BoxFit.cover),
                                        )),
                                  )),
                                ),
                              ),
                              onTap: () {
                                Navigator.push(context,
                                    FadeRoute(page: MusicPlayerExample()));
                              },
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.centerLeft,
                                  height: 25,
                                  width: 170,
                                  child: Text(mediaItem?.name ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          // color: Color.fromRGBO(0, 0, 0, 1),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w300)),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  height: 15,
                                  child: Text(mediaItem?.singer ?? '',
                                      style: TextStyle(
                                          // color: Color.fromRGBO(119, 119, 119, 1),
                                          fontSize: 10)),
                                )
                              ],
                            ),
                            Expanded(
                              child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    padding: EdgeInsets.only(right: 20),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        OutShadow(
                                          radius: 5,
                                          child: SizedBox(
                                            height: 35,
                                            width: 35,
                                            child: new IconButton(
                                              iconSize: 20,
                                              onPressed: () {
                                                //next
                                                // _playModel.next();
                                                AudioService.skipToNext();
                                              },
                                              icon: new Icon(
                                                Icons.skip_next,
                                                color: Theme.of(context)
                                                    .primaryIconTheme
                                                    .color,
                                                // color: Color.fromRGBO(119, 119, 119, 1),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: OutShadow(
                                            radius: 5,
                                            child: SizedBox(
                                              height: 35,
                                              width: 35,
                                              child: IconButton(
                                                icon: Icon(_model.isPlaying
                                                    ? IconFont.iconzanting
                                                    : IconFont.iconbofang),
                                                color: Theme.of(context)
                                                    .primaryIconTheme
                                                    .color,
                                                iconSize: 20,
                                                onPressed: () {
                                                  if (_model.isPlaying)
                                                    AudioService.pause();
                                                  else {
                                                    _model.playing();
                                                  }
                                                  // if (_playModel
                                                  //         .screenState
                                                  //         .playbackState
                                                  //         .basicState ==
                                                  //     BasicPlaybackState
                                                  //         .playing) {
                                                  //   _playModel.pause();
                                                  // } else {
                                                  // }
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: OutShadow(
                                            radius: 5,
                                            child: SizedBox(
                                              height: 35,
                                              width: 35,
                                              child: IconButton(
                                                icon: Icon(
                                                  Icons.menu,
                                                  size: 17,
                                                ),
                                                color: Theme.of(context)
                                                    .primaryIconTheme
                                                    .color,
                                                onPressed: () {
                                                  widget.globalKeyState
                                                      .currentState
                                                      .openEndDrawer();
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Container(
              height: 0,
            );
    });
  }
}
