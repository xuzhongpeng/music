import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter/widgets.dart';

enum LoadingType { defaultLoding }
const double _kDefaultIndicatorRadius = 10.0;

class Loading {
  static final Loading _instance = Loading._singleton();
  factory Loading() {
    return _instance;
  }
  Loading._singleton();

  BuildContext _weakContext;

  String _pairKey; //对称key，show的时候传什么，dis的时候就需要传什么

  bool _canDissmiss = false;

  defaultLoadingIndicator() {
    return _instance._cupertinoActivity();
  }

  void dismiss({String pairKey}) {
    if (_canDissmiss && _weakContext != null && pairKey == _pairKey) {
      Navigator?.of(_weakContext, rootNavigator: true)?.pop();
      _canDissmiss = !_canDissmiss;
      _pairKey = null;
    }
  }

  Future<T> show<T>({
    @required BuildContext context,

    ///一定是成对出现的
    String pairKey,
    LoadingType type = LoadingType.defaultLoding,
    Color barrierColor = const Color(0x000001),
  }) {
    dismiss(pairKey: _pairKey);
    _pairKey = pairKey;
    _weakContext = context;
    _canDissmiss = _weakContext != null;
    return showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: barrierColor,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return _cupertinoActivity();
      },
      transitionBuilder: _buildCupertinoDialogTransitions,
    );
  }

  Widget _buildCupertinoDialogTransitions(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    final CurvedAnimation fadeAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeInOut,
    );
    if (animation.status == AnimationStatus.reverse) {
      return FadeTransition(
        opacity: fadeAnimation,
        child: child,
      );
    }
    return FadeTransition(
      opacity: fadeAnimation,
      child: ScaleTransition(
        child: child,
        scale: animation.drive(_dialogTween),
      ),
    );
  }

  final Animatable<double> _dialogTween = Tween<double>(begin: 0.0, end: 1.0)
      .chain(CurveTween(curve: Curves.fastOutSlowIn));
  Widget _cupertinoActivity() {
    return Center(
        child: Material(
      color: Color.fromRGBO(225, 225, 225, 0.6),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GMCupertinoActivityIndicator(radius: 16),
      ),
    ));
  }

  Widget GMLoading(
      {Widget child,
      bool show = false,
      double width,
      double height,
      Color color}) {
    return Stack(alignment: Alignment.center, children: <Widget>[
      child,
      show
          ? Container(
              width: width ?? null,
              height: height ?? null,
              color: color ?? Color.fromRGBO(51, 51, 51, 0.5),
              child: _cupertinoActivity(),
            )
          : Container()
    ]);
  }
}

class GMCupertinoActivityIndicator extends StatefulWidget {
  /// Creates an iOS-style activity indicator.
  const GMCupertinoActivityIndicator({
    Key key,
    this.animating = true,
    this.radius = _kDefaultIndicatorRadius,
  })  : assert(animating != null),
        assert(radius != null),
        assert(radius > 0),
        super(key: key);

  /// Whether the activity indicator is running its animation.
  ///
  /// Defaults to true.
  final bool animating;

  /// Radius of the spinner widget.
  ///
  /// Defaults to 10px. Must be positive and cannot be null.
  final double radius;

  @override
  _CupertinoActivityIndicatorState createState() =>
      _CupertinoActivityIndicatorState();
}

class _CupertinoActivityIndicatorState
    extends State<GMCupertinoActivityIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    if (widget.animating) _controller.repeat();
  }

  @override
  void didUpdateWidget(GMCupertinoActivityIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animating != oldWidget.animating) {
      if (widget.animating)
        _controller.repeat();
      else
        _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.radius * 2,
      width: widget.radius * 2,
      child: CustomPaint(
        painter: _CupertinoActivityIndicatorPainter(
          position: _controller,
          radius: widget.radius,
        ),
      ),
    );
  }
}

const double _kTwoPI = math.pi * 2.0;
const int _kTickCount = 12;
const int _kHalfTickCount = _kTickCount ~/ 2;
// const Color _kTickColor = Color(0xFFE5E5EA);
// const Color _kActiveTickColor = Color(0xFF9D9D9D);
const Color _kTickColor = Color.fromRGBO(160, 160, 160, 1.0);
const Color _kActiveTickColor = Color.fromRGBO(90, 90, 90, 1.0);

class _CupertinoActivityIndicatorPainter extends CustomPainter {
  _CupertinoActivityIndicatorPainter({
    this.position,
    double radius,
  })  : tickFundamentalRRect = RRect.fromLTRBXY(
          -radius,
          1.0 * radius / _kDefaultIndicatorRadius,
          -radius / 2.0,
          -1.0 * radius / _kDefaultIndicatorRadius,
          1.5,
          1.5,
        ),
        super(repaint: position);

  final Animation<double> position;
  final RRect tickFundamentalRRect;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();

    canvas.save();
    canvas.translate(size.width / 2.0, size.height / 2.0);

    final int activeTick = (_kTickCount * position.value).floor();

    for (int i = 0; i < _kTickCount; ++i) {
      final double t =
          (((i + activeTick) % _kTickCount) / _kHalfTickCount).clamp(0.0, 1.0);
      paint.color = Color.lerp(_kActiveTickColor, _kTickColor, t);
      canvas.drawRRect(tickFundamentalRRect, paint);
      canvas.rotate(-_kTwoPI / _kTickCount);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(_CupertinoActivityIndicatorPainter oldPainter) {
    return oldPainter.position != position;
  }
}
