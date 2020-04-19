import 'package:flutter/material.dart';

import 'insertShadow.dart';

class OutShadow extends StatelessWidget {
  final double width;
  final double height;
  // final Color color;
  final double radius;
  final EdgeInsetsGeometry padding;
  final Widget child;
  OutShadow(
      {this.width, this.height, this.radius = 5, this.padding, this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          stops: [0.0, 0.02, 0.02, 0.02],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.grey[200],
            Colors.grey[200],
            Colors.grey[200]
          ],
          tileMode: TileMode.clamp,
        ),
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        boxShadow: [
          BoxShadow(
            color: Colors.white,
            blurRadius: 4.0,
            spreadRadius: 0.0,
            offset: Offset(
              -2.0,
              -2.0,
            ),
          ),
          BoxShadow(
            color: Colors.grey[300],
            blurRadius: 2.0,
            spreadRadius: 0.0,
            offset: Offset(
              2.0,
              2.0,
            ),
          )
        ],
      ),
      child: child,
    );
  }
}

class InnerShadow extends StatelessWidget {
  final double width;
  final double height;
  final EdgeInsetsGeometry padding;
  // final Color color;
  final double radius;
  final Widget child;
  InnerShadow(
      {this.width = 100,
      this.height = 100,
      this.radius = 25,
      this.child,
      this.padding});
  @override
  Widget build(BuildContext context) {
    return InnerShadowWidget(
      color: Colors.grey[400],
      offset: Offset(3, 3),
      blur: 5,
      child: Container(
        padding: padding,
        // width: width,
        // height: height,
        // color: Colors.grey[100],
        decoration: BoxDecoration(
          color: Color.fromRGBO(241, 242, 246, 1),
          gradient: LinearGradient(
            // stops: [0.02, 0.02],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.grey[300], Colors.white],
            tileMode: TileMode.clamp,
          ),
          borderRadius: BorderRadius.all(Radius.circular(radius)),
        ),
        child: child,
      ),
    );
  }
}
