import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music/components/UI/dialog.dart';
import 'package:music/components/modal_alert.dart';
import 'package:music/services/api/user_service.dart';
import 'package:music/services/q/songs_service.dart';
import 'package:music/utils/json_manager.dart';
import 'package:music/utils/version.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

import '../entities/lyric.dart';

class Utils {
  static Future<Lyric> getLyricFromTxt(String id) async {
    List<LyricSlice> slices = new List();
    return SongService().getLyric(id).then((String result) {
      // String result = str;
      List<String> list = result.split("\n");
      // print("lines:" + list.length.toString() + "");
      Lyric lyric = new Lyric();
      for (String line in list) {
        print(line);
        if (line.startsWith("[")) {
          if (line.contains('ti:')) {
            lyric.ti = line.substring(4, line.length - 1);
          } else if (line.contains('ar:')) {
            lyric.ar = line.substring(4, line.length - 1);
          } else if (line.contains('al:')) {
            lyric.al = line.substring(4, line.length - 1);
          } else if (line.contains('by:')) {
            lyric.by = line.substring(4, line.length - 1);
          } else if (line.contains('offset:')) {
            lyric.offset = double.tryParse(line.substring(4, line.length - 1));
          } else {
            LyricSlice s = getLyricSlice(line, lyric);

            if (s != null) {
              slices.add(s);
            }
          }
        }
      }
      for (int i = 0; i < slices.length - 1; i++) {
        slices[i].endTime = slices[i + 1].startTime;
      }
      slices[slices.length - 1].endTime = Duration(hours: 1).inSeconds;
      lyric.slices = slices;
      return lyric;
    });
  }

  static LyricSlice getLyricSlice(String line, Lyric lyric) {
    LyricSlice lyricSlice = new LyricSlice();
    if (RegExp(r"\d{2}:\d{2}").hasMatch(line)) {
      lyricSlice.slice = line.substring(10);
      lyricSlice.startTime = int.parse(line.substring(1, 3)) * 60 +
          int.parse(line.substring(4, 6));
      // print(lyricSlice.in_second.toString() + "-----" + lyricSlice.slice);
      return lyricSlice;
    }
    return null;
  }

  /// 查找歌词
  static int findLyricIndex(int curDuration, List<LyricSlice> lyrics) {
    for (int i = 0; i < lyrics.length; i++) {
      if (curDuration >= lyrics[i].startTime &&
          curDuration <= lyrics[i].endTime) {
        return i;
      }
    }
    return 0;
  }

  //版本检查
  static checkVersions(BuildContext context) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    Map versionInfo = (await UserService.getVersions());
    print(versionInfo);
    String newVersion = versionInfo['version'];
    if (Version.parse(newVersion) > (Version.parse(version))) {
      String url = versionInfo['url'];
      String msg = versionInfo['msg'];
      int level = versionInfo['level'];
      var temp = await JsonManager.getLocation('version');
      if (temp == version && level != 1) {
        return;
      }
      print('版本过低');
      Modal.show(
        context,
        child: JUDialog(
          hasCancel: true,
          hasCommonBack: false,
          title: level == 1 ? '强制更新' : '更新',
          subTitle: 'Upgrade',
          cancelText: level == 1 ? '退出' : '跳过此版本',
          msg: "当前版本:$newVersion\n更新提示:$msg",
          callback: () async {
            print('升级了');
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not launch $url';
            }
          },
          cancelBack: () {
            print('取消了');
            if (level == 1) {
              SystemNavigator.pop();
            } else {
              JsonManager.setLocation('version', version);
              Navigator.of(context).pop();
            }
          },
        ),
      );
    }
  }
}
