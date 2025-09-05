import 'package:flutter/material.dart';

class GradientFab extends StatelessWidget {
  final VoidCallback onPressed;
  final List<Color> colors;
  final IconData icon;
  final double size;

  const GradientFab({
    Key? key,
    required this.onPressed,
    required this.colors,
    this.icon = Icons.add,
    this.size = 56,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Icon(
          icon,
          size: size * 0.55,
          color: Colors.white,
        ),
      ),
    );
  }
}
