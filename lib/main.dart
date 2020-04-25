import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music/config/http.dart';
import 'package:music/provider/player_model.dart';
import 'package:music/pages/home_page.dart';
import 'package:music/stores/store.dart';

import 'provider/music_model.dart';

void main() {
  Http http = Http();
  http.init();
  return runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  DateTime lastPopTime;
  @override
  Widget build(BuildContext context) {
    return Store.provider(
      providers: [
        ChangeNotifierProvider<PlayerModel>(create: (_) => PlayerModel()),
        ChangeNotifierProvider<MusicModel>(create: (_) => MusicModel())
      ],
      child:
          // WillPopScope(child:
          new MaterialApp(
        theme: new ThemeData(
            brightness: Brightness.light, //body颜色
            backgroundColor: Colors.grey[200],
            primaryColor: Colors.grey[500], //主题颜色
            accentColor: Colors.cyan[800], //按钮颜色
            dividerColor: Colors.grey[300],
            primaryIconTheme:
                IconThemeData(color: Color.fromRGBO(93, 124, 177, 1)),
            textTheme: TextTheme(
                body1: TextStyle(color: Color.fromRGBO(93, 124, 177, 1)),
                body2: TextStyle(
                  color: Color.fromRGBO(129, 152, 191, 1),
                )), //字体颜色
            fontFamily: 'alifont',
            buttonColor: Colors.black),
        home: AudioServiceWidget(child: new HomePage()),
      ),
    );
  }
}
