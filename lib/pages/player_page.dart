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
  AudioPlayer audioPlayer;
  bool isPlaying = false;
  AudioCache audioCache = AudioCache();
  Duration duration;
  Duration position;
  double sliderValue;
  // Lyric lyric;
  // LyricPanel panel;
  PositionChangeHandler handler;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
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

  StreamSubscription<Duration> onDurationChanged;
  StreamSubscription<Duration> onAudioPositionChanged;
  StreamSubscription<void> onPlayerCompletion;
  @override
  dispose() {
    super.dispose();
    onDurationChanged.cancel();
    onAudioPositionChanged.cancel();
    onPlayerCompletion.cancel();
    print('dispose');
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    audioPlayer = _playerModel.audioPlayer;
    // Utils.getLyricFromTxt().then((Lyric lyric) {
    //   print("getLyricFromTxt:" + lyric.slices.length.toString());
    //   setState(() {
    //     this.lyric = lyric;
    //     panel = new LyricPanel(this.lyric);
    //   });
    // });

    onDurationChanged = audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        this.duration = duration;

        if (position != null) {
          this.sliderValue = (position.inSeconds / duration.inSeconds);
        }
      });
    });
    onAudioPositionChanged =
        audioPlayer.onAudioPositionChanged.listen((position) {
      setState(() {
        this.position = position;

        // if (panel != null) {
        //   panel.handler(position.inSeconds);
        // }

        if (duration != null) {
          this.sliderValue = (position.inSeconds / duration.inSeconds);
        }
      });
    });
    onPlayerCompletion = audioPlayer.onPlayerCompletion.listen((_) {
      setState(() {
        this.isPlaying = true;
      });
    });
    setState(() {
      isPlaying = audioPlayer.state == AudioPlayerState.PLAYING;
    });
  }

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
    var style = new TextStyle(color: color);
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        new Text(
          position == null ? "00:00" : _formatDuration(position),
          key: Key(position.toString()),
          style: style,
        ),
        new Text(
          duration == null ? "00:00" : _formatDuration(duration),
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
              onPressed: () {},
              icon: new Icon(
                Icons.skip_previous,
                size: 32.0,
                color: color,
              ),
            ),
            new IconButton(
              onPressed: () async {
                if (isPlaying) {
                  audioPlayer.pause();
                } else {
                  audioPlayer.resume();
                }
                setState(() {
                  isPlaying = !isPlaying;
                });
              },
              padding: const EdgeInsets.all(0.0),
              icon: new Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                size: 48.0,
                color: color,
              ),
            ),
            new IconButton(
              onPressed: () {
                //next
              },
              icon: new Icon(
                Icons.skip_next,
                size: 32.0,
                color: color,
              ),
            ),
          ],
        ),
      ),
      new Slider(
        key: Key(sliderValue.toString()),
        onChanged: (newValue) {
          if (duration != null) {
            int seconds = (duration.inSeconds * newValue).round();
            print("audioPlayer.seek: $seconds");
            audioPlayer.seek(new Duration(seconds: seconds));
          }
        },
        value: sliderValue ?? 0.0,
        activeColor: color,
      ),
      new Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        child: _timer(context),
      ),
    ];
  }
}
