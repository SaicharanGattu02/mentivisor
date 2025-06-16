import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../utils/color_constants.dart';

class CustomAppBar1 extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget> actions;

  const CustomAppBar1({Key? key, required this.title, required this.actions})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xff1A1A1A),
      centerTitle: true,
      leading: IconButton(
        visualDensity: VisualDensity.compact,
        onPressed: () {
          context.pop(true);
        },
        icon: const Icon(Icons.arrow_back, size: 24, color: Colors.white),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: actions,
    );

  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
