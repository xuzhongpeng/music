import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:music/anims/needle_anim.dart';
import 'package:music/anims/record_anim.dart';
import 'package:music/pages/player_page.dart';

final GlobalKey<PlayerState> musicPlayerKey = new GlobalKey();

const String coverArt =
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQEKU9rkbdInt9fPTlJMjT_gbwlyBqbE60zELhHy_A2yMsJkBmDTw',
    mp3Url = 'http://music.163.com/song/media/outer/url?id=451703096.mp3';

class MusicPlayerExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _MusicPlayerExampleState();
  }
}

class _MusicPlayerExampleState extends State<MusicPlayerExample>
    with TickerProviderStateMixin {
  AnimationController controllerRecord;
  Animation<double> animationRecord;
  Animation<double> animationNeedle;
  AnimationController controllerNeedle;
  final _rotateTween = new Tween<double>(begin: -0.15, end: 0.0);
  final _commonTween = new Tween<double>(begin: 0.0, end: 1.0);

  @override
  void initState() {
    super.initState();
    controllerRecord = new AnimationController(
        duration: const Duration(milliseconds: 15000), vsync: this);
    animationRecord =
        new CurvedAnimation(parent: controllerRecord, curve: Curves.linear);

    controllerNeedle = new AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    animationNeedle =
        new CurvedAnimation(parent: controllerNeedle, curve: Curves.linear);

    animationRecord.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controllerRecord.repeat();
      } else if (status == AnimationStatus.dismissed) {
        controllerRecord.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        new Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new NetworkImage(coverArt),
              fit: BoxFit.cover,
              colorFilter: new ColorFilter.mode(
                Colors.black54,
                BlendMode.overlay,
              ),
            ),
          ),
        ),
        new Container(
            child: new BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Opacity(
            opacity: 0.6,
            child: new Container(
              decoration: new BoxDecoration(
                color: Colors.grey.shade900,
              ),
            ),
          ),
        )),
        new Scaffold(
          backgroundColor: Colors.transparent,
          appBar: new AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            title: Container(
              child: Text(
                'Shape of You - Ed Sheeran',
                style: new TextStyle(fontSize: 13.0),
              ),
            ),
          ),
          body: new Stack(
            alignment: const FractionalOffset(0.5, 0.0),
            children: <Widget>[
              new Stack(
                alignment: const FractionalOffset(0.7, 0.1),
                children: <Widget>[
                  new Container(
                    child: RotateRecord(
                        animation: _commonTween.animate(controllerRecord)),
                    margin: EdgeInsets.only(top: 100.0),
                  ),
                  new Container(
                    child: new PivotTransition(
                      turns: _rotateTween.animate(controllerNeedle),
                      alignment: FractionalOffset.topLeft,
                      child: new Container(
                        width: 100.0,
                        child: new Image.asset("images/play_needle.png"),
                      ),
                    ),
                  ),
                ],
              ),
              new Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: new Player(
                  onError: (e) {
                    Scaffold.of(context).showSnackBar(
                      new SnackBar(
                        content: new Text(e),
                      ),
                    );
                  },
                  onPrevious: () {},
                  onNext: () {},
                  onCompleted: () {},
                  onPlaying: (isPlaying) {
                    if (isPlaying) {
                      controllerRecord.forward();
                      controllerNeedle.forward();
                    } else {
                      controllerRecord.stop(canceled: false);
                      controllerNeedle.reverse();
                    }
                  },
                  key: musicPlayerKey,
                  color: Colors.white,
                  audioUrl: mp3Url,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    controllerRecord.dispose();
    controllerNeedle.dispose();
    super.dispose();
  }
}
