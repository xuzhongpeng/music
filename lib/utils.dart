import 'package:flutter/services.dart';
import 'package:music/services/q/songs_service.dart';

import 'entities/lyric.dart';

class Utils {
  static Future<Lyric> getLyricFromTxt(String id) async {
    List<LyricSlice> slices = new List();
    return SongService().getLyric(id).then((String result) {
      // String result = str;
      List<String> list = result.split("\n");
      // print("lines:" + list.length.toString() + "");
      for (String line in list) {
        print(line);
        if (line.startsWith("[")) {
          LyricSlice s = getLyricSlice(line);
          if (s != null) {
            slices.add(s);
          }
        }
      }
      Lyric lyric = new Lyric(slices);
      return lyric;
    });
  }

  static LyricSlice getLyricSlice(String line) {
    LyricSlice lyricSlice = new LyricSlice();
    if (line.contains('ti:')) {
      return LyricSlice(
          slice: line.substring(4, line.length - 1), in_second: 1);
    } else if (line.contains('ar:')) {
      return LyricSlice(
          slice: line.substring(4, line.length - 1), in_second: 2);
    } else if (RegExp(r"\d{2}:\d{2}").hasMatch(line)) {
      lyricSlice.slice = line.substring(10);
      lyricSlice.in_second = int.parse(line.substring(1, 3)) * 60 +
          int.parse(line.substring(4, 6));
      // print(lyricSlice.in_second.toString() + "-----" + lyricSlice.slice);
      return lyricSlice;
    }
    return null;
  }
}

String str = """[00:09.480]The club isn\'t the best place to find a lover
[00:11.750]So the bar is where I go
[00:14.590]Me and my friends at the table doing shots
[00:16.760]Drinking faster and then we talk slow
[00:19.500]You come over and start up a conversation with just me
[00:21.820]And trust me I\'ll give it a chance now
[00:24.420]Take my hand, stop, Put Van The Man on the jukebox
[00:26.880]And then we start to dance, and now I\'m singing like
[00:29.580]
[00:29.820]Girl, you know I want your love
[00:31.980]Your love was handmade for somebody like me
[00:34.970]Come on now, follow my lead
[00:37.010]I may be crazy, don\'t mind me, say
[00:39.550]Boy, let\'s not talk too much
[00:42.040]Grab on my waist and put that body on me
[00:45.100]Come on now, follow my lead
[00:46.880]Come—come on now, follow my lead
[00:48.740]
[00:50.460]I\'m in love with the shape of you
[00:52.820]We push and pull like a magnet do
[00:55.330]Although my heart is falling too
[00:57.800]I\'m in love with your body
[01:00.360]Last night you were in my room
[01:02.940]And now my bedsheets smell like you
[01:05.120]Every day discovering something brand new
[01:07.830]I\'m in love with your body
[01:09.590]Oh—i—oh—i—oh—i—oh—i
[01:12.790]I\'m in love with your body
[01:14.460]Oh—i—oh—i—oh—i—oh—i
[01:17.830]I\'m in love with your body
[01:19.420]Oh—i—oh—i—oh—i—oh—i
[01:22.820]I\'m in love with your body
[01:24.980]Every day discovering something brand new
[01:27.900]I\'m in love with the shape of you
[01:29.890]
[01:30.070]One week in we let the story begin
[01:31.750]We\'re going out on our first date
[01:34.500]But you and me are thrifty so go all you can eat
[01:36.730]Fill up your bag and I fill up a plate
[01:39.250]We talk for hours and hours about the sweet and the sour
[01:41.800]And how your family is doin\' okay
[01:44.340]And leave and get in a taxi, we kiss in the backseat
[01:46.990]Tell the driver make the radio play, and I\'m singing like
[01:49.370]
[01:49.610]Girl, you know I want your love
[01:51.830]Your love was handmade for somebody like me
[01:55.140]Come on now, follow my lead
[01:56.980]I may be crazy, don\'t mind me, say
[01:59.520]Boy, let\'s not talk too much
[02:02.050]Grab on my waist and put that body on me
[02:05.130]Come on now, follow my lead
[02:06.850]Come—come on now, follow my lead
[02:08.740]
[02:10.610]I\'m in love with the shape of you
[02:12.900]We push and pull like a magnet do
[02:15.360]Although my heart is falling too
[02:17.970]I\'m in love with your body
[02:20.570]Last night you were in my room
[02:22.940]And now my bedsheets smell like you
[02:25.140]Every day discovering something brand new
[02:28.050]I\'m in love with your body
[02:29.530]Oh—i—oh—i—oh—i—oh—i
[02:32.930]I\'m in love with your body
[02:34.470]Oh—i—oh—i—oh—i—oh—i
[02:37.790]I\'m in love with your body
[02:39.510]Oh—i—oh—i—oh—i—oh—i
[02:42.880]I\'m in love with your body
[02:44.990]Every day discovering something brand new
[02:48.200]I\'m in love with the shape of you
[02:49.950]
[02:50.150]Come on, be my baby, come on
[02:52.340]Come on, be my baby, come on
[02:54.840]Come on, be my baby, come on
[02:57.300]Come on, be my baby, come on
[02:59.820]Come on, be my baby, come on
[03:02.350]Come on, be my baby, come on
[03:04.820]Come on, be my baby, come on
[03:07.340]Come on, be my baby, come on
[03:09.410]
[03:10.760]I\'m in love with the shape of you
[03:12.820]We push and pull like a magnet too
[03:15.360]Although my heart is falling too
[03:17.960]I\'m in love with your body
[03:20.420]Last night you were in my room
[03:22.930]And now my bedsheets smell like you
[03:25.060]Every day discovering something brand new
[03:27.830] I\'m in love with your body
[03:29.550]Come on, be my baby, come on
[03:32.260]Come on, be my baby, come on
[03:33.530]I\'m in love with your body
[03:35.110]Come on, be my baby, come on
[03:37.190]Come on, be my baby, come on
[03:38.280]I\'m in love with your body
[03:39.990]Come on, be my baby, come on
[03:42.310]Come on, be my baby, come on
[03:43.330]I\'m in love with your body
[03:44.820]Every day discovering something brand new
[03:48.010]I\'m in love with the shape of you
[03:50.630]""";
