import 'package:flutter/material.dart';

class DayCell extends StatelessWidget {
  final String dayAbbrev; // Mon/Tue
  final String dayNum;    // 11/12
  final String month;     // Aug/Jul
  final int slotCount;
  final bool selected;
  final VoidCallback onTap;

  const DayCell({
    required this.dayAbbrev,
    required this.dayNum,
    required this.month,
    required this.slotCount,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasSlots = slotCount > 0;

    final border = selected
        ? BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xffA258F7), Color(0xff726CF7), Color(0xff4280F6)],
      ),
      borderRadius: BorderRadius.circular(12),
    )
        : null;

    final inner = Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xffF5F5F5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Day name
          Text(
            dayAbbrev,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: selected ? const Color(0xff4F4F4F) : const Color(0xff6A6A6A),
            ),
          ),
          const SizedBox(height: 6),
          // Big day number
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: selected ? const Color(0xffEBF0FF) : Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              dayNum,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: selected ? const Color(0xff2D5BFF) : const Color(0xff333333),
              ),
            ),
          ),
          const SizedBox(height: 6),
          // Month + slot badge
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                month,
                style: const TextStyle(fontSize: 11, color: Color(0xff6A6A6A)),
              ),
              if (hasSlots) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xffE7F9EE),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '$slotCount',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff12834C),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );

    return Opacity(
      opacity: hasSlots ? 1.0 : 0.6,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: border != null
            ? Container(
          padding: const EdgeInsets.all(1.5),
          decoration: border,
          child: inner,
        )
            : inner,
      ),
    );
  }
}
