import 'package:flutter/material.dart';

class Modal {
  static Future<void> show(BuildContext context,
      {Widget child, Color backGroundColor}) {
    return Navigator.of(context)
        .push(MoveRoute(
            opaque: false,
            barrierColor: backGroundColor ?? Colors.white30,
            builder: (_) => child))
        .then((onValue) => onValue);
  }
}

class MoveRoute extends PageRoute {
  MoveRoute({
    @required this.builder,
    this.transitionDuration = const Duration(milliseconds: 150),
    this.opaque = true,
    this.barrierDismissible = false,
    this.barrierColor,
    this.barrierLabel,
    this.maintainState = true,
  });

  final WidgetBuilder builder;

  @override
  final Duration transitionDuration;

  @override
  final bool opaque;

  @override
  final bool barrierDismissible;

  @override
  final Color barrierColor;

  @override
  final String barrierLabel;

  @override
  final bool maintainState;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) =>
      builder(context);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // final PageTransitionsTheme theme = Theme.of(context).pageTransitionsTheme;
    // return theme.buildTransitions(
    //     this, context, animation, secondaryAnimation, child);
    return ScaleTransition(
      scale: animation,
      child: child,
    );
  }
}

class GrowTransition extends StatelessWidget {
  GrowTransition({this.child, this.animation});

  final Widget child;
  final Animation<double> animation;

  Widget build(BuildContext context) {
    return new Center(
      child: new AnimatedBuilder(
          animation: animation,
          builder: (BuildContext context, Widget child) {
            return new Container(
                height: animation.value, width: animation.value, child: child);
          },
          child: child),
    );
  }
}
