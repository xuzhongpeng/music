import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music/components/lyric_panel.dart';
import 'package:music/model/player_model.dart';
import 'package:music/stores/store.dart';
// import 'package:music/model/lyric.dart';
// import 'package:music/utils.dart';

class Player extends StatefulWidget {
  const Player();

  @override
  State<StatefulWidget> createState() {
    return new PlayerState();
  }
}

class PlayerState extends State<Player> {
  PlayerModel get _playerModel => Store.value<PlayerModel>(context);
  // AudioPlayer audioPlayer;
  // bool isPlaying = false;
  // Duration duration;
  // Duration position;
  // double sliderValue;
  // Lyric lyric;
  // LyricPanel panel;
  // PositionChangeHandler handler;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   init();
    // });
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  String _formatDuration(Duration d) {
    int minute = d.inMinutes;
    int second = (d.inSeconds > 60) ? (d.inSeconds % 60) : d.inSeconds;
    print(d.inMinutes.toString() + "======" + d.inSeconds.toString());
    String format = ((minute < 10) ? "0$minute" : "$minute") +
        ":" +
        ((second < 10) ? "0$second" : "$second");
    return format;
  }

  // StreamSubscription<Duration> onDurationChanged;
  // StreamSubscription<Duration> onAudioPositionChanged;
  // StreamSubscription<void> onPlayerCompletion;
  // @override
  // dispose() {
  //   super.dispose();
  //   onDurationChanged.cancel();
  //   onAudioPositionChanged.cancel();
  //   onPlayerCompletion.cancel();
  //   print('dispose');
  // }

  // @override
  // void init() {
  //   // TODO: implement didChangeDependencies
  //   audioPlayer = _playerModel.audioPlayer;
  //   // Utils.getLyricFromTxt().then((Lyric lyric) {
  //   //   print("getLyricFromTxt:" + lyric.slices.length.toString());
  //   //   setState(() {
  //   //     this.lyric = lyric;
  //   //     panel = new LyricPanel(this.lyric);
  //   //   });
  //   // });

  //   onDurationChanged =
  //       _playerModel.audioPlayer.onDurationChanged.listen((duration) {
  //     setState(() {
  //       this.duration = duration;

  //       if (position != null) {
  //         this.sliderValue = (position.inSeconds / duration.inSeconds);
  //       }
  //     });
  //   });
  //   onAudioPositionChanged =
  //       _playerModel.audioPlayer.onAudioPositionChanged.listen((position) {
  //     setState(() {
  //       this.position = position;

  //       // if (panel != null) {
  //       //   panel.handler(position.inSeconds);
  //       // }

  //       if (duration != null) {
  //         this.sliderValue = (position.inSeconds / duration.inSeconds);
  //       }
  //     });
  //   });
  //   onPlayerCompletion =
  //       _playerModel.audioPlayer.onPlayerCompletion.listen((_) {
  //     setState(() {
  //       this.isPlaying = false;
  //     });
  //   });
  //   setState(() {
  //     isPlaying = _playerModel.audioPlayer.state == AudioPlayerState.PLAYING;
  //   });
  // }

  Color color = Colors.white;

  @override
  Widget build(BuildContext context) {
    return
        // Scaffold(
        //   body: Container(
        //     color: Colors.white,
        //     child: SafeArea(
        //       child:
        new Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.end,
      children: _controllers(context),
      // ),
      //   ),
      // ),
    );
  }

  Widget _timer(BuildContext context) {
    var style = new TextStyle(color: color, fontSize: 13);
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        new Text(
          _playerModel.position == null
              ? "00:00"
              : _formatDuration(_playerModel.position),
          key: Key(_playerModel.position.toString()),
          style: style,
        ),
        new Text(
          _playerModel.duration == null
              ? "00:00"
              : _formatDuration(_playerModel.duration),
          style: style,
        ),
      ],
    );
  }

  List<Widget> _controllers(BuildContext context) {
    print("_controllers");
    return [
      // lyric != null ? panel : Container(),
      Divider(color: Colors.transparent),
      Divider(
        color: Colors.transparent,
        height: 32.0,
      ),
      new Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new IconButton(
              iconSize: 45,
              onPressed: () {
                _playerModel.last(context);
              },
              icon: new Icon(
                Icons.skip_previous,
                // size: 45.0,
                color: color,
              ),
            ),
            new IconButton(
              iconSize: 60,
              onPressed: () async {
                if (_playerModel.isPlaying) {
                  _playerModel.pause();
                } else {
                  _playerModel.resume();
                }
              },
              padding: const EdgeInsets.all(0.0),
              icon: new Icon(
                _playerModel.isPlaying ? Icons.pause : Icons.play_arrow,
                // size: 60.0,
                color: color,
              ),
            ),
            new IconButton(
              iconSize: 45,
              onPressed: () {
                //next
                _playerModel.next();
              },
              icon: new Icon(
                Icons.skip_next,
                color: color,
              ),
            ),
          ],
        ),
      ),
      new Slider(
        key: Key(_playerModel.sliderValue.toString()),
        onChanged: (newValue) {
          _playerModel.seek(newValue);
        },
        value: _playerModel.sliderValue ?? 0.0,
        activeColor: color,
      ),
      Container(
        height: 40,
        child: new Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          child: _timer(context),
        ),
      ),
    ];
  }
}
