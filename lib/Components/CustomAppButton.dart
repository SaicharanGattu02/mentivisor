import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CustomAppButton extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  final Color? color;
  final Color? textcolor;
  final double? width;
  final double? height;
  final VoidCallback? onPlusTap;
  CustomAppButton({
    Key? key,
    required this.text,
    required this.onPlusTap,
    this.color,
    this.textcolor,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return SizedBox(
      width: width ?? w,
      height: height ?? 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: color,
          foregroundColor: color,
          disabledBackgroundColor: color,
          disabledForegroundColor: color,
          shadowColor: Colors.transparent,
          overlayColor: Colors.transparent,
        ),
        onPressed: onPlusTap,
        child: Text(
          text,
          style: TextStyle(
            color: textcolor ?? Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => throw UnimplementedError();
}

class CustomAppButton1 extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  final Color? color;
  final double? width;
  final double? height;
  final Color? textcolor;
  final VoidCallback? onPlusTap;
  final bool isLoading;
  CustomAppButton1({
    Key? key,
    required this.text,
    required this.onPlusTap,
    this.color,
    this.textcolor,
    this.height,
    this.width,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return SizedBox(
      width: width ?? w,
      height: height ?? 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          backgroundColor: color,
          foregroundColor: color,
          disabledBackgroundColor: color,
          disabledForegroundColor: color,
          shadowColor: Colors.transparent,
          overlayColor: Colors.transparent,
        ),
        onPressed: isLoading ? null : onPlusTap,
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2,
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  color: textcolor ?? Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
      ),
    );
  }

  @override
  Size get preferredSize => throw UnimplementedError();
}
