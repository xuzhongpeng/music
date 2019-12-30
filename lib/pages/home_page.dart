import 'package:flutter/material.dart';
import 'package:music/components/UI/input_type_group.dart';
import 'package:music/components/UI/loading.dart';
import 'package:music/components/UI/music_bottom_bar.dart';
import 'package:music/components/UI/page_route.dart';
import 'package:music/model/music_model.dart';
import 'package:music/model/player_model.dart';
import 'package:music/pages/search_songs.dart';
import 'package:music/stores/store.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // Store.value<PlayerModel>(context, listen: false).init();
    // Store.value<PlayerModel>(context, listen: false).init(context);
    return Scaffold(
      body: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
            alignment: Alignment.center,
            width: size.width,
            // padding: EdgeInsets.symmetric(horizontal: 10),
            child: Hero(
              tag: 'search',
              child: Material(
                child: InputTypeGroup.customTextField(
                    textAlian: TextAlign.center,
                    width: size.width * 0.95,
                    placeHold: "搜索",
                    onTap: () {
                      Navigator.of(context)
                          .push(FadeRoute(page: SearchSongs()));
                    }),
              ),
            ),
          ),
          Container(width: size.width, height: 100, color: Colors.blue)
        ]),
      ),
      bottomNavigationBar: MusicBottomBar(),
    );
  }
}
