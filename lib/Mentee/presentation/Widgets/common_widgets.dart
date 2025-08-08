import 'package:flutter/material.dart';

/// ✅ Reusable Custom TextFormField
Widget buildCustomTextField({
  required TextEditingController controller,
  required String hint,
  String? Function(String?)? validator,
  GestureTapCallback? onTap,
}) {
  return TextFormField(
    controller: controller,
    cursorColor: Colors.black,
    onTap: onTap,
    decoration: InputDecoration(
      hintText: hint,
      border: const OutlineInputBorder(),
    ),
    validator: validator,
  );
}

/// ✅ Reusable Custom Label Text
Widget buildCustomLabel(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
