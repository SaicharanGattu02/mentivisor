import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import '../utils/color_constants.dart';

class CustomAppButton extends StatelessWidget {
  final String text;
  final Color? textcolor;
  final double? width;
  final double? height;
  final VoidCallback? onPlusTap;
  final IconData? icon;

  const CustomAppButton({
    Key? key,
    required this.text,
    required this.onPlusTap,
    this.textcolor,
    this.height,
    this.width,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width ?? w,
      height: height ?? 50,
      child: ElevatedButton(
        onPressed: onPlusTap,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xffA258F7), Color(0xff726CF7), Color(0xff4280F6)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    color: textcolor ?? Colors.white,
                    fontFamily: 'segeo',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (icon != null) ...[
                  const SizedBox(width: 8),
                  Icon(icon, color: textcolor ?? Colors.white, size: 18),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomAppButton1 extends StatelessWidget {
  final String text;
  final Color? textcolor;
  final double? width;
  final double? height;
  final VoidCallback? onPlusTap;
  final IconData? icon;
  final bool isLoading;
  final int? radius;

  const CustomAppButton1({
    Key? key,
    required this.text,
    required this.onPlusTap,
    this.textcolor,
    this.height,
    this.width,
    this.isLoading = false,
    this.icon,
    this.radius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double buttonWidth = width ?? MediaQuery.of(context).size.width;
    final double buttonHeight = height ?? 50;
    final int borderRadius = radius ?? 24;
    final Color textColor = textcolor ?? Colors.white;

    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPlusTap,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius.toDouble()),
          ),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xffa855f7), Color(0xff3b82f6)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(borderRadius.toDouble()),
          ),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading)
                  const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 1.5,
                    ),
                  )
                else
                  Text(
                    text,
                    style: TextStyle(
                      color: textColor,
                      fontFamily: 'segeo',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                if (!isLoading && icon != null) ...[
                  const SizedBox(width: 8),
                  Icon(icon, color: textColor, size: 18),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomOutlinedButton extends StatelessWidget {
  final String text;
  final Color? textColor;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool isLoading;
  final int? radius;

  const CustomOutlinedButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.textColor,
    this.width,
    this.height,
    this.icon,
    this.isLoading = false,
    this.radius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double buttonWidth = width ?? MediaQuery.of(context).size.width;
    final double buttonHeight = height ?? 48;
    final int borderRadius = radius ?? 12;
    final Color finalTextColor = textColor ?? const Color(0xFF6D6BFF);

    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,
      child: GestureDetector(
        onTap: isLoading ? null : onTap,
        child: Container(
          padding: const EdgeInsets.all(1.5), // border thickness
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xffa855f7), Color(0xff3b82f6)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(borderRadius.toDouble()),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white, // inner background
              borderRadius: BorderRadius.circular(borderRadius.toDouble()),
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isLoading)
                    const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Color(0xFF6D6BFF),
                        strokeWidth: 1.5,
                      ),
                    )
                  else
                    Text(
                      text,
                      style: TextStyle(
                        fontFamily: 'segeo',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: finalTextColor,
                      ),
                    ),
                  if (!isLoading && icon != null) ...[
                    const SizedBox(width: 8),
                    Icon(icon, color: finalTextColor, size: 18),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomAppButton2 extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  final Color? color;
  final double? width;
  final double? height;
  final Color? textcolor;
  final VoidCallback? onPlusTap;
  final bool isLoading;
  CustomAppButton2({
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
