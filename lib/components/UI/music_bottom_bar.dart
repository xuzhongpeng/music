import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music/components/UI/page_route.dart';
import 'package:music/components/iconfont/iconfont.dart';
import 'package:music/provider/music_model.dart';
import 'package:music/provider/player_model.dart';
import 'package:music/pages/mian_player.dart';
import 'package:music/stores/store.dart';

class MusicBottomBar extends StatelessWidget {
  final GlobalKey<ScaffoldState> globalKeyState;
  MusicBottomBar({@required this.globalKeyState});
  @override
  Widget build(BuildContext context) {
    double imgWidth = 35;
    return Store.connect<PlayerModel>(builder: (context, _playModel, _) {
      return _playModel.play != null
          ? Container(
              height: 60,
              padding: EdgeInsets.all(0),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(250, 250, 250, 1),
                  border: Border(
                      top: BorderSide(
                          width: 1, color: Color.fromRGBO(222, 226, 230, 1)))),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 2,
                    width: MediaQuery.of(context).size.width,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.grey[100],
                      valueColor: AlwaysStoppedAnimation(Colors.blue),
                      value: _playModel.sliderValue ?? 0.0,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      GestureDetector(
                        child: Container(
                          alignment: Alignment.topCenter,
                          padding: EdgeInsets.only(right: 10),
                          child: Hero(
                            tag: _playModel.play?.id ?? "image",
                            child: Material(
                              child: Container(
                                  width: imgWidth,
                                  height: imgWidth,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.white, width: 1),
                                      borderRadius:
                                          BorderRadius.circular(imgWidth / 2)),
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(imgWidth / 2),
                                    child: Image.network(
                                        _playModel.play?.headerImg,
                                        fit: BoxFit.cover),
                                  )),
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context, FadeRoute(page: MusicPlayerExample()));
                        },
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            height: 25,
                            width: 170,
                            child: Text(_playModel.play?.name ?? '',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300)),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            height: 15,
                            child: Text(_playModel.play?.singer ?? '',
                                style: TextStyle(
                                    color: Color.fromRGBO(119, 119, 119, 1),
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  new IconButton(
                                    iconSize: 35,
                                    onPressed: () {
                                      //next
                                      _playModel.next();
                                    },
                                    icon: new Icon(
                                      Icons.skip_next,
                                      color: Color.fromRGBO(119, 119, 119, 1),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(_playModel.audioPlayer.state ==
                                            AudioPlayerState.PLAYING
                                        ? IconFont.iconzanting
                                        : IconFont.iconbofang),
                                    color: Color.fromRGBO(119, 119, 119, 1),
                                    iconSize: 30,
                                    onPressed: () {
                                      if (_playModel.audioPlayer.state ==
                                          AudioPlayerState.PLAYING) {
                                        _playModel.pause();
                                      } else {
                                        _playModel.resume();
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.menu),
                                    onPressed: () {
                                      globalKeyState.currentState
                                          .openEndDrawer();
                                    },
                                  ),
                                ],
                              ),
                            )),
                      )
                    ],
                  )
                ],
              ),
            )
          : Container(
              height: 0,
            );
    });
  }
}
