import 'package:flutter/material.dart';

class CustomChoiceChip extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  const CustomChoiceChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return RawChip(
      showCheckmark: false,
      labelPadding: const EdgeInsets.symmetric(horizontal: 12),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      label: Text(
        label,
        style: TextStyle(
          fontFamily: 'segeo',
          fontWeight: FontWeight.w700,
          fontSize: 12,
          color: selected ? const Color(0xFF4076ED) : Colors.black54,
        ),
      ),
      selected: selected,
      onSelected: onSelected,
      selectedColor: const Color(0xFF4076ED).withOpacity(0.1),
      backgroundColor: Colors.white,
      pressElevation: 0, // no elevation when pressed
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: selected
            ? const BorderSide(color: Color(0xFF4076ED))
            : const BorderSide(color: Colors.transparent),
      ),
    );
  }
}
