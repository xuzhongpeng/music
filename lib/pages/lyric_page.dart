import 'dart:async';
import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music/components/UI/lyric_ui.dart';
import 'package:music/components/color/theme.dart';
import 'package:music/entities/lyric.dart';
import 'package:music/provider/player_model.dart';
import 'package:music/stores/store.dart';
import 'package:music/utils/utils.dart';
import 'package:rxdart/rxdart.dart';

class Application {
  static double screenWidth;
  static double screenHeight;
  static double statusBarHeight;
}

class LyricPage extends StatefulWidget {
  LyricPage({this.lyric, this.onTap, this.height});
  final double height;
  final Lyric lyric;
  final VoidCallback onTap;
  @override
  _LyricPageState createState() => _LyricPageState();
}

class _LyricPageState extends State<LyricPage> with TickerProviderStateMixin {
  LyricWidget _lyricWidget;
  // LyricData _lyricData;
  // List<LyricSlice> lyrics;
  AnimationController _lyricOffsetYController;
  Timer dragEndTimer; // 拖动结束任务
  Function dragEndFunc;
  Duration dragEndDuration = Duration(milliseconds: 1000);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((call) {});

    _lyricWidget = LyricWidget(widget.lyric, 0);
    dragEndFunc = () {
      if (_lyricWidget.isDragging) {
        setState(() {
          _lyricWidget.isDragging = false;
        });
      }
    };
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print("didchagne**********");
    _lyricWidget.lyric = widget.lyric;
    _lyricWidget.curLine = 0;
  }

  final BehaviorSubject<double> _dragPositionSubject =
      BehaviorSubject.seeded(null);
  @override
  void dispose() {
    // TODO: implement dispose
    dragEndTimer?.cancel();
    _lyricOffsetYController?.dispose();
    super.dispose();
  }

  TextStyle commonWhiteTextStyle =
      TextStyle(color: JUTheme().theme.textTheme.bodyText1.color);
  @override
  Widget build(BuildContext context) {
    Application.screenWidth = MediaQuery.of(context).size.width;
    Application.screenHeight = widget.height != null
        ? widget.height
        : MediaQuery.of(context).size.height;
    Application.statusBarHeight = 100;
    return Scaffold(
        backgroundColor: JUTheme().theme.backgroundColor,
        body: widget.lyric == null ||
                widget.lyric.slices == null ||
                widget.lyric.slices.length == 0
            ? Container(
                alignment: Alignment.center,
                child: Text(
                  '歌词加载中...',
                  style: commonWhiteTextStyle,
                ),
              )
            : GestureDetector(
                onTap: widget.onTap,
                onTapDown: _lyricWidget.isDragging
                    ? (e) {
                        if (e.localPosition.dx > 0 &&
                            e.localPosition.dx < ScreenUtil().setWidth(100) &&
                            e.localPosition.dy >
                                _lyricWidget.canvasSize.height / 2 -
                                    ScreenUtil().setWidth(100) &&
                            e.localPosition.dy <
                                _lyricWidget.canvasSize.height / 2 +
                                    ScreenUtil().setWidth(100)) {
                          //跳转
                          // widget.model.seekPlay(_lyricWidget.dragLineTime);
                          AudioService.seekTo(Duration(
                              milliseconds: _lyricWidget.dragLineTime));
                        }
                      }
                    : null,
                onVerticalDragUpdate: (e) {
                  if (!_lyricWidget.isDragging) {
                    setState(() {
                      _lyricWidget.isDragging = true;
                    });
                  }
                  _lyricWidget.offsetY += e.delta.dy;
                },
                onVerticalDragEnd: (e) {
                  // 拖动防抖
                  cancelDragTimer();
                },
                child: StreamBuilder<double>(
                  stream: Rx.combineLatest2<double, double, double>(
                      _dragPositionSubject.stream,
                      Stream.periodic(Duration(milliseconds: 200)),
                      (dragPosition, _) => dragPosition),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var state =
                          Store.value<PlayerModel>(context, listen: false);
                      // int position = state
                      //     .screenState.playbackState.currentPosition
                      //     .inMilliseconds;

                      // int duration =
                      //     state.screenState.mediaItem?.duration?.inMilliseconds;
                      var curTime = snapshot.data;
                      // 获取当前在哪一行
                      int curLine = Utils.findLyricIndex(
                          curTime.toInt(), widget.lyric.slices);
                      if (!_lyricWidget.isDragging) {
                        startLineAnim(curLine);
                      }
                      // 给 customPaint 赋值当前行
                      _lyricWidget.curLine = curLine;

                      return CustomPaint(
                        size: Size(
                            Application.screenWidth,
                            Application.screenHeight -
                                kToolbarHeight -
                                ScreenUtil().setWidth(150) -
                                ScreenUtil().setWidth(50) -
                                Application.statusBarHeight -
                                ScreenUtil().setWidth(150)),
                        painter: _lyricWidget,
                      );
                    } else {
                      var curTime =
                          Store.value<PlayerModel>(context, listen: false)
                              .position
                              ?.inSeconds;
                      // 获取当前在哪一行
                      if (curTime == null) curTime = 0;
                      int curLine =
                          Utils.findLyricIndex(curTime, widget.lyric.slices);
                      if (!_lyricWidget.isDragging) {
                        startLineAnim(curLine);
                      }
                      // 给 customPaint 赋值当前行
                      _lyricWidget.curLine = curLine;
                      return CustomPaint(
                          size: Size(
                              Application.screenWidth,
                              Application.screenHeight -
                                  kToolbarHeight -
                                  ScreenUtil().setWidth(150) -
                                  ScreenUtil().setWidth(50) -
                                  Application.statusBarHeight -
                                  ScreenUtil().setWidth(150)),
                          painter: _lyricWidget);
                    }
                  },
                ),
              ));
  }

  //  CustomPaint(
  //       size: Size(
  //           Application.screenWidth,
  //           Application.screenHeight -
  //               kToolbarHeight -
  //               ScreenUtil().setWidth(150) -
  //               ScreenUtil().setWidth(50) -
  //               Application.statusBarHeight -
  //               ScreenUtil().setWidth(120)),
  //       painter: _lyricWidget,
  //     ),
  //   );
  // }
  void cancelDragTimer() {
    if (dragEndTimer != null) {
      if (dragEndTimer.isActive) {
        dragEndTimer.cancel();
        dragEndTimer = null;
      }
    }
    dragEndTimer = Timer(dragEndDuration, dragEndFunc);
  }

  /// 开始下一行动画
  void startLineAnim(int curLine) {
    // 判断当前行和 customPaint 里的当前行是否一致，不一致才做动画
    if (_lyricWidget.curLine != curLine) {
      // 如果动画控制器不是空，那么则证明上次的动画未完成，
      // 未完成的情况下直接 stop 当前动画，做下一次的动画
      if (_lyricOffsetYController != null) {
        _lyricOffsetYController.stop();
      }

      // 初始化动画控制器，切换歌词时间为300ms，并且添加状态监听，
      // 如果为 completed，则消除掉当前controller，并且置为空。
      _lyricOffsetYController = AnimationController(
          vsync: this, duration: Duration(milliseconds: 300))
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _lyricOffsetYController.dispose();
            _lyricOffsetYController = null;
          }
        });
      // 计算出来当前行的偏移量
      var end = _lyricWidget.computeScrollY(curLine) * -1;
      // 起始为当前偏移量，结束点为计算出来的偏移量
      Animation animation = Tween<double>(begin: _lyricWidget.offsetY, end: end)
          .animate(_lyricOffsetYController);
      // 添加监听，在动画做效果的时候给 offsetY 赋值
      _lyricOffsetYController.addListener(() {
        _lyricWidget.offsetY = animation.value;
      });
      // 启动动画
      _lyricOffsetYController.forward();
    }
  }
}
