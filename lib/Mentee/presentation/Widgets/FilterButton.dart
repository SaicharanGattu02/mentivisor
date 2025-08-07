import 'package:flutter/material.dart';
import 'package:mentivisor/utils/color_constants.dart';

class FilterButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onPressed;

  const FilterButton({
    required this.text,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected
              ? primarycolor1.withOpacity(0.1)
              : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          shadowColor: Colors.transparent,
          overlayColor: Colors.transparent,
          elevation: 0,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,fontFamily: 'segeo',
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? primarycolor1 : Color(0xff666666),
          ),
        ),
      ),
    );
  }
}
