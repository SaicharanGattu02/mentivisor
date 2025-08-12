import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../Components/ShakeWidget.dart';



class CommonPasswordTextField extends StatefulWidget {
  final String hint;
  final bool isPassword;
  final IconData? icon;
  final TextEditingController controller;
  final bool showError;
  final String errorKey;
  final String errorMsg;
  final TextCapitalization textCapitalization;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const CommonPasswordTextField({
    super.key,
    required this.hint,
    required this.isPassword,
    this.icon,
    this.keyboardType,
    required this.controller,
    required this.showError,
    required this.errorKey,
    required this.errorMsg,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
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
    return Column(
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
          inputFormatters: widget.inputFormatters,
          keyboardType: widget.keyboardType,
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
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Color(0xffE5E7EB),
                width: 1,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Color(0xffE5E7EB),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Color(0xffE5E7EB),
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Color(0xffE5E7EB),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Color(0xffE5E7EB),
                width: 1,
              ),
            ),
            errorStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ),
        ),
        if (widget.showError)
          ShakeWidget(
            key: Key(widget.errorKey),
            duration: const Duration(milliseconds: 700),
            child: Text(
              widget.errorMsg,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
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
