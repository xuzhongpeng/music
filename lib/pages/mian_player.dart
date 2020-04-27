import 'dart:async';
import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:music/components/UI/loading.dart';
import 'package:music/components/UI/lyric_ui.dart';
import 'package:music/components/UI/player_page.dart';
import 'package:music/components/anims/needle_anim.dart';
import 'package:music/components/anims/record_anim.dart';
import 'package:music/components/color/theme.dart';
import 'package:music/components/neumorphism/shadow.dart';
import 'package:music/pages/lyric_page.dart';
import 'package:music/provider/music_model.dart';
import 'package:music/provider/player_model.dart';
import 'package:music/stores/store.dart';
import 'package:music/utils/auto_player_task.dart';

final GlobalKey<PlayerState> musicPlayerKey = new GlobalKey();

class MusicPlayerExample extends StatefulWidget {
  MusicPlayerExample();
  @override
  State<StatefulWidget> createState() {
    return new _MusicPlayerExampleState();
  }
}

class _MusicPlayerExampleState extends State<MusicPlayerExample>
    with TickerProviderStateMixin {
  //播放控制
  AnimationController controllerRecord;
  Animation<double> animationRecord;
  Animation<double> animationNeedle;
  AnimationController controllerNeedle;
  final _rotateTween = new Tween<double>(begin: -0.15, end: 0.0);
  final _commonTween = new Tween<double>(begin: 0.0, end: 1.0);
  // PlayerModel get _model => Store.value<PlayerModel>(context);
  StreamSubscription<ScreenState> stateStream;
  @override
  void initState() {
    super.initState();
    controllerRecord = new AnimationController(
        duration: const Duration(milliseconds: 10000), vsync: this);
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
    judeState(Store.value<PlayerModel>(context, listen: false).screenState);
    stateStream = Store.value<PlayerModel>(context, listen: false)
        .screenStateStream
        .listen((state) {
      judeState(state);
    });
  }

  judeState(ScreenState state) {
    setState(() {
      if (state.playbackState.basicState == BasicPlaybackState.playing) {
        controllerRecord.forward();
        controllerNeedle.forward();
      } else {
        controllerRecord.stop(canceled: false);
        controllerNeedle.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        Expanded(
          child: Stack(
            children: <Widget>[
              // Store.connect<PlayerModel>(
              //   builder: (_, _model, __) => new Container(
              //     decoration: new BoxDecoration(
              //         image: new DecorationImage(
              //       image: new NetworkImage(_model.play?.headerImg ?? ''),
              //       fit: BoxFit.cover,
              //       colorFilter: new ColorFilter.mode(
              //         Colors.black54,
              //         BlendMode.overlay,
              //       ),
              //     )),
              //   ),
              // ),
              // new Container(
              //     child: new BackdropFilter(
              //   filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              //   child: Opacity(
              //     opacity: 0.6,
              //     child: new Container(
              //       decoration: new BoxDecoration(
              //         color: Colors.grey.shade900,
              //       ),
              //     ),
              //   ),
              // )),
              new Scaffold(
                backgroundColor: JUTheme().theme.backgroundColor,
                appBar: new AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                  title: Container(
                    child: Store.connect<PlayerModel>(
                      builder: (_, _model, __) => Text(
                        _model.play?.name ?? '',
                        style: new TextStyle(
                            fontSize: 18.0,
                            color: JUTheme().theme.textTheme.body1.color),
                      ),
                    ),
                  ),
                  leading: Container(
                    padding: EdgeInsets.all(10),
                    child: OutShadow(
                      child: IconButton(
                        icon: Icon(
                          Icons.expand_more,
                          size: 22,
                          color: JUTheme().theme.primaryIconTheme.color,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                ),
                body: new Stack(
                  alignment: const FractionalOffset(0.5, 0.0),
                  children: <Widget>[
                    _body(),
                    new Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: new Player(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }

  Widget bodyWidget() {
    // return Container();
    return GestureDetector(
      onTap: () {
        setState(() {
          widget1 = lyricWidget();
        });
      },
      child: new Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
          ),
          Store.connect<PlayerModel>(
            builder: (_, _model, __) => Hero(
              tag: _model.play.id,
              child: Material(
                color: Color.fromRGBO(1, 1, 1, 0),
                child: new Container(
                  child: RotateRecord(
                      animation: _commonTween.animate(controllerRecord)),
                  margin: EdgeInsets.only(top: 100.0),
                ),
              ),
            ),
          ),
          new Container(
            child: new PivotTransition(
              turns: _rotateTween.animate(controllerNeedle),
              alignment: FractionalOffset.topLeft,
            ),
          ),
          Positioned(
            top: 400,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 400,
              child: Store.connect<PlayerModel>(
                builder: (_, _model, __) => _model.play.lyric != null
                    ? LyricPage(
                        height: 400,
                        lyric: _model.play.lyric,
                        onTap: () {
                          setState(() {
                            widget1 = lyricWidget();
                          });
                        },
                      )
                    : Container(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget lyricWidget() {
    var _model = Store.value<PlayerModel>(context, listen: false);
    if (_model.play.lyric != null) {
      return Store.connect<PlayerModel>(
          builder: (_, _model, __) => LyricPage(
                lyric: _model.play.lyric,
                onTap: () {
                  setState(() {
                    widget1 = bodyWidget();
                  });
                },
              ));
    } else {
      return Loading().defaultLoadingIndicator();
    }
  }

  Widget widget1;
  _body() {
    if (widget1 == null) {
      widget1 = bodyWidget();
    }
    return widget1;
  }

  @override
  void dispose() {
    controllerRecord.dispose();
    controllerNeedle.dispose();
    stateStream.cancel();
    super.dispose();
  }
}
