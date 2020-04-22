import 'package:flutter/material.dart';
import 'package:music/components/modal_alert.dart';
import 'package:music/components/neumorphism/shadow.dart';

import 'input_type_group.dart';

class SureUserInfo {
  static show(BuildContext context, callBack) {
    String qq = "";
    return Modal.show(
      context,
      child: EnterUserInfo(),
    );
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
        color: Colors.black26,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 400,
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
                  child: Text(
                    '确认',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        decoration: TextDecoration.none),
                  )),
              InputTypeGroup(
                width: 180,
                controller: _controller,
                placeHold: '输入QQ号',
                keyboardType: TextInputType.number,
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: OutShadow(
                  width: 60,
                  height: 40,
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      '确定',
                      style: TextStyle(
                          color: Theme.of(context).textTheme.body1.color,
                          decoration: TextDecoration.none,
                          fontSize: 17),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// Center(
//                 child: Column(children: [
//                   Material(
//                     child: TextField(
//                       onChanged: (text) {
//                         qq = text;
//                       },
//                     ),
//                   ),
//                   RaisedButton(
//                     child: Text('确定'),
//                     onPressed: () {
//                       if (qq == '') qq = '1452754335';
//                       Navigator.of(context).pop();
//                       callBack(qq);
//                     },
//                   )
//                 ]),
//               )
