import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music/components/iconfont/iconfont.dart';
import 'package:music/model/music_model.dart';
import 'package:music/model/player_model.dart';
import 'package:music/stores/store.dart';

class MusicBottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double imgWidth = 35;
    return Store.connect<MusicModel>(builder: (context, model, _) {
      PlayerModel _playModel = Store.value<PlayerModel>(context);
      return model.play != null
          ? Container(
              height: 60,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(250, 250, 250, 1),
                  border: Border(
                      top: BorderSide(
                          width: 1, color: Color.fromRGBO(222, 226, 230, 1)))),
              child: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(right: 10),
                    child: Container(
                        width: imgWidth,
                        height: imgWidth,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.circular(imgWidth / 2)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(imgWidth / 2),
                          child: Image.network(model.play?.headerImg,
                              fit: BoxFit.cover),
                        )),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        height: 25,
                        child: Text(model.play?.name ?? '',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontSize: 14,
                                fontWeight: FontWeight.w300)),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        height: 15,
                        child: Text(model.play?.singer ?? '',
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
                          child: IconButton(
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
                        )),
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
