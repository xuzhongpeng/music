import 'package:flutter/material.dart';
import 'package:music/components/modal_alert.dart';
import 'package:music/components/neumorphism/shadow.dart';
import 'package:music/services/api/user_service.dart';
import 'package:music/utils/utils.dart';

import 'input_type_group.dart';

class SureUserInfo {
  static show(BuildContext context, callBack) async {
    String qq = "";
    return Modal.show(
      context,
      child: EnterUserInfo(),
    ).then((params) {
      callBack(params);
    });
  }
}

class EnterUserInfo extends StatefulWidget {
  @override
  _EnterUserInfoState createState() => _EnterUserInfoState();
}

class _EnterUserInfoState extends State<EnterUserInfo> {
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        color: Colors.black12,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () {},
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 320,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20),
                  alignment: Alignment.centerLeft,
                  child: Column(children: <Widget>[
                    Text(
                      '确认',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          decoration: TextDecoration.none),
                    ),
                    Text(
                      'confirm',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          decoration: TextDecoration.none),
                    ),
                  ]),
                ),
                Container(
                    child: OutShadow(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    '此软件只做学习交流，不做商业用途！\n输入QQ号不做存储，只为获取用户歌单',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        decoration: TextDecoration.none),
                  ),
                )),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: InputTypeGroup(
                    width: 180,
                    controller: _controller,
                    placeHold: '输入QQ号',
                    keyboardType: TextInputType.number,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          // UserService.getVersions();
                          Utils().checkVersions(context);
                          // Navigator.of(context).pop();
                        },
                        child: OutShadow(
                          width: 60,
                          height: 40,
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              '取消',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).textTheme.body1.color,
                                  decoration: TextDecoration.none,
                                  fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop(_controller.text);
                          },
                          child: OutShadow(
                            width: 60,
                            height: 40,
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                '确定',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).textTheme.body1.color,
                                    decoration: TextDecoration.none,
                                    fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
