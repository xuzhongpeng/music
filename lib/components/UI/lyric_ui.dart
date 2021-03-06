import 'dart:ui';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music/components/color/theme.dart';
import 'package:music/entities/lyric.dart';

class LyricWidget extends CustomPainter with ChangeNotifier {
  Lyric lyric;
  List<TextPainter> lyricPaints = []; // 其他歌词
  double _offsetY = 0;
  int curLine = 1;
  Paint linePaint;
  bool isDragging = false; // 是否正在人为拖动
  double totalHeight = 0; // 总长度
  TextPainter draggingLineTimeTextPainter; // 正在拖动中当前行的时间
  Size canvasSize = Size.zero;
  int dragLineTime;

  get offsetY => _offsetY;
  //时间颜色
  TextStyle smallGrayTextStyle =
      TextStyle(color: JUTheme().theme.textTheme.body2.color);
  //歌词颜色
  TextStyle commonGrayTextStyle =
      TextStyle(color: JUTheme().theme.textTheme.body2.color);
  //当前行颜色
  TextStyle commonWhiteTextStyle =
      TextStyle(color: JUTheme().theme.textTheme.body1.color, fontSize: 18);
  //拖动状态颜色
  TextStyle commonWhite70TextStyle =
      TextStyle(color: JUTheme().theme.textTheme.body1.color);
  set offsetY(double value) {
    // 判断如果是在拖动状态下
    if (isDragging) {
      // 不能小于最开始的位置
      if (_offsetY.abs() < lyricPaints[0].height + ScreenUtil().setWidth(30)) {
        _offsetY = (lyricPaints[0].height + ScreenUtil().setWidth(30)) * -1;
      } else if (_offsetY.abs() >
          (totalHeight + lyricPaints[0].height + ScreenUtil().setWidth(30))) {
        // 不能大于最大位置
        _offsetY =
            (totalHeight + lyricPaints[0].height + ScreenUtil().setWidth(30)) *
                -1;
      } else {
        _offsetY = value;
      }
    } else {
      _offsetY = value;
    }
    notifyListeners();
  }

  LyricWidget(this.lyric, this.curLine) {
    linePaint = Paint()
      ..color = Color.fromRGBO(1, 1, 1, 0)
      ..strokeWidth = ScreenUtil().setWidth(1);
    lyricPaints.addAll(lyric != null
        ? lyric.slices
            .map((l) => TextPainter(
                text: TextSpan(text: l.slice, style: commonGrayTextStyle),
                textDirection: TextDirection.ltr))
            .toList()
        : []);
    // 首先对TextPainter 进行 layout，否则会报错
    _layoutTextPainters();
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvasSize = size;
    var y = _offsetY + size.height / 2 + lyricPaints[0].height / 2;

    for (int i = 0; i < lyric.slices.length; i++) {
      if (y > size.height || y < (0 - lyricPaints[i].height / 2)) {
      } else {
        // 画每一行歌词
        if (curLine == i) {
          // 如果是当前行
          lyricPaints[i].text = TextSpan(
              text: lyric.slices[i].slice, style: commonWhiteTextStyle);
          lyricPaints[i].layout();
        } else if (isDragging &&
            i ==
                (_offsetY / (lyricPaints[0].height + ScreenUtil().setWidth(30)))
                        .abs()
                        .round() -
                    1) {
          // 如果是拖动状态中的当前行
          lyricPaints[i].text = TextSpan(
              text: lyric.slices[i].slice, style: commonWhite70TextStyle);
          lyricPaints[i].layout();
        } else {
          lyricPaints[i].text =
              TextSpan(text: lyric.slices[i].slice, style: commonGrayTextStyle);
          lyricPaints[i].layout();
        }

        lyricPaints[i].paint(
          canvas,
          Offset((size.width - lyricPaints[i].width) / 2, y),
        );
      }
      // 计算偏移量
      y += lyricPaints[i].height + ScreenUtil().setWidth(30);
      lyric.offset = y;
    }

    // 拖动状态下显示的东西
    if (isDragging) {
      // 画 icon
      final icon = Icons.play_arrow;
      var builder = ParagraphBuilder(ParagraphStyle(
        fontFamily: icon.fontFamily,
        fontSize: ScreenUtil().setWidth(60),
      ))
        ..addText(String.fromCharCode(icon.codePoint));
      var para = builder.build();
      para.layout(ParagraphConstraints(
        width: ScreenUtil().setWidth(60),
      ));
      canvas.drawParagraph(
          para,
          Offset(ScreenUtil().setWidth(10),
              size.height / 2 - ScreenUtil().setWidth(60)));

      // 画线
      canvas.drawLine(
          Offset(ScreenUtil().setWidth(80),
              size.height / 2 - ScreenUtil().setWidth(30)),
          Offset(size.width - ScreenUtil().setWidth(120),
              size.height / 2 - ScreenUtil().setWidth(30)),
          linePaint);
      // 画当前行的时间
      dragLineTime = lyric
          .slices[
              (_offsetY / (lyricPaints[0].height + ScreenUtil().setWidth(30)))
                      .abs()
                      .round() -
                  1]
          .startTime;
      draggingLineTimeTextPainter = TextPainter(
        text: TextSpan(
            text: DateUtil.formatDateMs(dragLineTime, format: "mm:ss"),
            style: smallGrayTextStyle),
        textDirection: TextDirection.ltr,
      );
      draggingLineTimeTextPainter.layout();
      draggingLineTimeTextPainter.paint(
          canvas,
          Offset(size.width - ScreenUtil().setWidth(80) - 20,
              size.height / 2 - ScreenUtil().setWidth(45)));
    }
  }

  /// 计算传入行和第一行的偏移量
  double computeScrollY(int curLine) {
    return (lyricPaints[0].height + ScreenUtil().setWidth(30)) * (curLine + 1);
  }

  void _layoutTextPainters() {
    lyricPaints.forEach((lp) => lp.layout());

    // 延迟一下计算总高度
    Future.delayed(Duration(milliseconds: 300), () {
      totalHeight = (lyricPaints[0].height + ScreenUtil().setWidth(30)) *
          (lyricPaints.length - 1);
    });
  }

  @override
  bool shouldRepaint(LyricWidget oldDelegate) {
    return oldDelegate._offsetY != _offsetY ||
        oldDelegate.isDragging != isDragging;
  }
}
