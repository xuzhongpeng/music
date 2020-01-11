import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music/components/UI/lyric_ui.dart';
import 'package:music/entities/lyric.dart';
import 'package:music/provider/player_model.dart';
import 'package:music/stores/store.dart';
import 'package:music/utils/utils.dart';

class Application {
  static double screenWidth;
  static double screenHeight;
  static double statusBarHeight;
}

class LyricPage extends StatefulWidget {
  LyricPage({this.lyric});
  final Lyric lyric;

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
    _lyricWidget = LyricWidget(widget.lyric, 1);
    dragEndFunc = () {
      if (_lyricWidget.isDragging) {
        setState(() {
          _lyricWidget.isDragging = false;
        });
      }
    };
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    dragEndTimer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    Application.screenWidth = MediaQuery.of(context).size.width;
    Application.screenHeight = MediaQuery.of(context).size.height;
    Application.statusBarHeight = 100;
    return Scaffold(
        backgroundColor: Colors.grey[800],
        body: widget.lyric == null
            ? Container(
                alignment: Alignment.center,
                child: Text(
                  '歌词加载中...',
                  style: commonWhiteTextStyle,
                ),
              )
            : GestureDetector(
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
                          Store.value<PlayerModel>(context)
                              .seekPlayer(_lyricWidget.dragLineTime);
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
                child: StreamBuilder<Duration>(
                  stream: Store.value<PlayerModel>(context)
                      .audioPlayer
                      .onAudioPositionChanged,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var curTime = snapshot.data.inSeconds;
                      // 获取当前在哪一行
                      int curLine =
                          Utils.findLyricIndex(curTime, widget.lyric.slices);
                      if (!_lyricWidget.isDragging) {
                        startLineAnim(curLine);
                      }
                      // 给 customPaint 赋值当前行
                      _lyricWidget.curLine = 6;
                      return CustomPaint(
                        size: Size(
                            Application.screenWidth,
                            Application.screenHeight -
                                kToolbarHeight -
                                ScreenUtil().setWidth(150) -
                                ScreenUtil().setWidth(50) -
                                Application.statusBarHeight -
                                ScreenUtil().setWidth(120)),
                        painter: _lyricWidget,
                      );
                    } else {
                      return Container();
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
