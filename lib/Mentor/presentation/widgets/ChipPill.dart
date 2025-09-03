import 'package:flutter/material.dart';

class ChipPill extends StatelessWidget {
  const ChipPill({
    required this.label,
    this.showCancel = false,
    this.onCancel,
  });

  final String label;
  final bool showCancel;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE8ECF4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF121212),
            ),
          ),
          if (showCancel) ...[
            const SizedBox(width: 6),
            GestureDetector(
              onTap: onCancel,
              behavior: HitTestBehavior.opaque,
              child: const Icon(
                Icons.close_rounded,
                size: 16,
                color: Color(0xFF9AA3AF),
              ),
            ),
          ],
        ],
      ),
    );
  }
}