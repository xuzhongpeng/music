//关于软件
import 'package:flutter/material.dart';
import 'package:music/components/neumorphism/shadow.dart';

class JUDialog extends StatelessWidget {
  final bool hasCommonBack;
  final bool hasCancel;
  final String msg;
  final String title;
  final String subTitle;
  final String sureText;
  final String cancelText;
  final VoidCallback callback;
  final VoidCallback cancelBack;
  JUDialog(
      {this.hasCommonBack = true,
      this.hasCancel = false,
      this.msg = '',
      this.title = '',
      this.cancelText = '取消',
      this.subTitle = '',
      this.sureText = '确认',
      this.cancelBack,
      this.callback});
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: GestureDetector(
        onTap: () {
          if (hasCommonBack) Navigator.of(context).pop();
        },
        child: Container(
          color: Colors.black26,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(20),
                    alignment: Alignment.centerLeft,
                    child: Column(children: <Widget>[
                      Text(
                        this.title,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            decoration: TextDecoration.none),
                      ),
                      Text(
                        this.subTitle,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            decoration: TextDecoration.none),
                      ),
                    ]),
                  ),
                  Container(
                      child: OutShadow(
                    width: 250,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      this.msg,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          decoration: TextDecoration.none),
                    ),
                  )),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          hasCancel
                              ? GestureDetector(
                                  onTap: () {
                                    if (cancelBack != null)
                                      cancelBack();
                                    else {
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  child: OutShadow(
                                    // width: 60,
                                    height: 40,
                                    padding: EdgeInsets.all(10),
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        cancelText,
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                .color,
                                            decoration: TextDecoration.none,
                                            fontSize: 15),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: GestureDetector(
                              onTap: () {
                                if (callback != null)
                                  callback();
                                else
                                  Navigator.of(context).pop();
                              },
                              child: OutShadow(
                                width: 60,
                                height: 40,
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    this.sureText,
                                    style: TextStyle(
                                        color: Colors.black,
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
