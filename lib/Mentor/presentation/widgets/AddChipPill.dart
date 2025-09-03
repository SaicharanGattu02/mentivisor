import 'package:flutter/material.dart';

class AddChipPill extends StatelessWidget {
  const AddChipPill({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF9C5BF7),
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add_rounded, size: 16, color: Colors.white),
              SizedBox(width: 6),
              Text(
                'Add',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: "segeo",
                  fontWeight: FontWeight.w800,
                  letterSpacing: .2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}