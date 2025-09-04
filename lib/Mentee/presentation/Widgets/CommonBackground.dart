import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  final String? bgImagePath;
  final Color? bgColor;

  const Background({
    super.key,
    required this.child,
    this.bgImagePath,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Positioned.fill(
          child: Opacity(
            opacity: 0.15,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFFAF5FF),
                    Color(0xFFF5F6FF),
                    Color(0xFFEFF6FF),
                  ],
                ),
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class Background1 extends StatelessWidget {
  final Widget child;
  final String? bgImagePath;
  final Color? bgColor;
  final Gradient? gradient; // ✅ new

  const Background1({
    super.key,
    required this.child,
    this.bgImagePath,
    this.bgColor,
    this.gradient, // ✅ new
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Positioned.fill(
          child: Opacity(
            opacity: 0.15,
            child: Container(
              decoration: BoxDecoration(
                gradient: gradient,
                color: gradient == null
                    ? (bgColor ?? const Color(0xffFFF8EC))
                    : null,
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class Background3 extends StatelessWidget {
  final Widget child;
  final String? bgImagePath;
  final Color? bgColor;

  const Background3({
    super.key,
    required this.child,
    this.bgImagePath,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Full-screen gradient, no extra Stack, no Opacity
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFFFAF5FF),
            Color(0xFFF5F6FF),
            Color(0xFFEFF6FF),
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: child,
    );
  }
}
