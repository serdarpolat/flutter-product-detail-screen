import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:guitar/sprite.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<int> anim;

  Size get s => MediaQuery.of(context).size;
  Color beige = Color(0xffefe7d6);
  double pageOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600))
          ..addListener(() {
            setState(() {});
          });
    _controller
      ..addListener(() {
        setState(() {});
      });
    anim = StepTween(begin: 0, end: 62).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double lerp(double min, double max) =>
      lerpDouble(min, max, _controller.value);

  @override
  Widget build(BuildContext context) {
    return ListenableProvider.value(
      value: _controller,
      child: Scaffold(
        backgroundColor: beige,
        body: GestureDetector(
          onHorizontalDragUpdate: _onHorizontalDragUpdate,
          onHorizontalDragEnd: _onHorizontalDragEnd,
          child: Stack(
            children: [
              Container(
                color: Colors.black45,
              ),
              FenderText(),
              Guitar(
                anim: anim.value.toDouble(),
              ),
              Menu(),
              CustomAppBar(
                onTap: _toggle,
              ),
              BottomInfo(),
            ],
          ),
        ),
      ),
    );
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _controller.value += details.primaryDelta / s.width;
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_controller.isAnimating ||
        _controller.status == AnimationStatus.completed) return;

    _controller.fling(velocity: _controller.value < 0.5 ? -1.0 : 1.0);
  }

  void _toggle() {
    final bool isOpen = _controller.status == AnimationStatus.completed;
    _controller.fling(velocity: isOpen ? -1 : 1);
  }
}

class CustomAppBar extends StatelessWidget {
  final Function onTap;

  const CustomAppBar({Key key, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;
    return Consumer<AnimationController>(
      builder: (context, ctrl, child) {
        return Positioned(
          top: 40,
          left: s.width * ctrl.value * 0.8 + 20,
          child: child,
        );
      },
      child: Container(
        width: s.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: s.width / 3,
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(Icons.menu),
                onPressed: onTap,
                iconSize: 40,
              ),
            ),
            Container(
              width: s.width / 3,
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 4),
              child: Text(
                "PRODUCT DETAIL",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              width: s.width / 3,
            ),
          ],
        ),
      ),
    );
  }
}

class FenderText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;
    Color beige = Color(0xffefe7d6);
    return Consumer<AnimationController>(
      builder: (context, ctrl, child) {
        return Positioned(
          top: 0,
          left: 0 + s.width * 0.8 * ctrl.value,
          child: Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY((-pi / 2) * ctrl.value),
            origin: Offset(0, 0),
            alignment: Alignment.centerLeft,
            child: child,
          ),
        );
      },
      child: Container(
        width: s.width,
        height: s.height,
        color: beige,
        child: Stack(
          children: [
            Positioned(
              left: -10,
              top: s.height * 0.15,
              child: RotatedBox(
                quarterTurns: 1,
                child: Text(
                  "FENDER",
                  style: TextStyle(
                    color: Color(0xffB6ADA5),
                    fontWeight: FontWeight.w900,
                    fontSize: 130,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;
    Color beige = Color(0xffefe7d6);
    return Consumer<AnimationController>(
      builder: (context, ctrl, child) {
        return Positioned(
          top: -s.height * 0.05,
          left: -s.width * 0.8 * (1 - ctrl.value) - s.width * 0.2,
          child: Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(pi / 2 * (1 - ctrl.value)),
            alignment: Alignment.centerRight,
            child: child,
          ),
        );
      },
      child: Container(
        width: s.width,
        height: s.height * 1.1,
        padding: EdgeInsets.only(left: s.width * 0.2 + 30, top: 110),
        color: beige,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              "assets/images/brand.png",
              height: 50,
            ),
            Spacer(),
            Text(
              "GUITARS",
              style: TextStyle(
                color: Color(0xff8F1600),
                fontSize: 36,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
                height: 1.5,
              ),
            ),
            Text(
              "BASSES",
              style: TextStyle(
                color: Colors.black,
                fontSize: 36,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
                height: 1.5,
              ),
            ),
            Text(
              "AMPS",
              style: TextStyle(
                color: Colors.black,
                fontSize: 36,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
                height: 1.5,
              ),
            ),
            Text(
              "PEDALS",
              style: TextStyle(
                color: Colors.black,
                fontSize: 36,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
                height: 1.5,
              ),
            ),
            Text(
              "OTHERS",
              style: TextStyle(
                color: Colors.black,
                fontSize: 36,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
                height: 1.5,
              ),
            ),
            Spacer(),
            Text(
              "ABOUT",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                height: 1.5,
              ),
            ),
            Text(
              "SUPPORT",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                height: 1.5,
              ),
            ),
            Text(
              "TERMS",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                height: 1.5,
              ),
            ),
            Text(
              "FAQS",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                height: 1.5,
              ),
            ),
            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

class Guitar extends StatelessWidget {
  final double anim;

  const Guitar({Key key, this.anim}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;
    return Consumer<AnimationController>(
      builder: (context, ctrl, child) {
        return Positioned(
          top: 0,
          left: s.width * 0.3 * ctrl.value,
          child: IgnorePointer(
            child: Container(
              width: s.width,
              height: s.height,
              color: Colors.transparent,
              child: Stack(
                children: [
                  Positioned(
                    top: s.height / 2.07,
                    left: (s.width - (s.width / 4)) / 2,
                    child: Container(
                      width: s.width / 4,
                      height: s.height / 4,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 60),
                            blurRadius: 50,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Sprite(
                    frameHeight: s.height,
                    frameWidth: s.width,
                    anim: anim,
                    frame: 63,
                    img: "assets/images/guitar_comp.png",
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class BottomInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;
    return Consumer<AnimationController>(
      builder: (context, ctrl, child) {
        return Positioned(
          left: s.width * 0.85 * ctrl.value,
          bottom: 30,
          child: Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY((-pi / 2) * ctrl.value),
            alignment: Alignment.centerLeft,
            child: child,
          ),
        );
      },
      child: Container(
        width: s.width,
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "Fender\nAmerican\nElite Strat",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 36,
                height: 1.1,
              ),
            ),
            Row(
              children: [
                Text(
                  "Spec",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    height: 1,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
