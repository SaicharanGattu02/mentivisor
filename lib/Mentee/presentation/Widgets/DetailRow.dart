import 'package:flutter/material.dart';

class DetailRow extends StatelessWidget {
  final String asset;
  final Color bgColor;
  final String text;

  const DetailRow({
    required this.asset,
    required this.bgColor,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(asset,width: 14,height: 15,),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'segeo',
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: Color(0xff666666),
            ),
          ),
        ),
      ],
    );
  }
}