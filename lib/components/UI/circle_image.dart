import 'package:flutter/material.dart';

class CircleImage extends StatelessWidget {
  final double width;
  final dynamic child;
  CircleImage({@required this.child, this.width = 50});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: width,
      height: width,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1),
          borderRadius: BorderRadius.circular(width / 2)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(width / 2),
        child: child is String
            ? (child is String && child != ''
                ? Image.network(child)
                : Container(color: Colors.blue))
            : child,
      ),
    );
  }
}
