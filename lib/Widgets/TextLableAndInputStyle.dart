import 'package:flutter/material.dart';

import '../Components/ShakeWidget.dart';
import '../utils/color_constants.dart'; // adjust path


class CommonPasswordTextField extends StatefulWidget {
  final String hint;
  final bool isPassword;
  final IconData? icon;
  final TextEditingController controller;
  final bool showError;
  final String errorKey;
  final String errorMsg;

  const CommonPasswordTextField({
    super.key,
    required this.hint,
    required this.isPassword,
    this.icon,
    required this.controller,
    required this.showError,
    required this.errorKey,
    required this.errorMsg,
  });

  @override
  State<CommonPasswordTextField> createState() => _CommonPasswordTextFieldState();
}

class _CommonPasswordTextFieldState extends State<CommonPasswordTextField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.hint.isNotEmpty)
            Text(
              widget.hint,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          const SizedBox(height: 8),
          TextFormField(
            controller: widget.controller,
            obscureText: widget.isPassword ? _obscureText : false,
            cursorColor: Colors.black,
            style: const TextStyle(fontFamily: 'segeo', fontSize: 14),
            decoration: InputDecoration(
              hintText: widget.hint,
              prefixIcon: widget.icon != null ? Icon(widget.icon, color: Colors.black26) : null,
              suffixIcon: widget.isPassword
                  ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.black45,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
                  : null,
            ),
          ),
          if (widget.showError)
            ShakeWidget(
              key: Key(widget.errorKey),
              duration: const Duration(milliseconds: 700),
              child: Text(
                widget.errorMsg,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}



class Textlableandinputstyle {
  static Text buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'segeo',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
    );
  }

  static TextStyle inputTextStyle() {
    return TextStyle(
      color: Colors.black,
      fontSize: 14,
      fontFamily: "Poppins",
      fontWeight: FontWeight.w400,
    );
  }
}
