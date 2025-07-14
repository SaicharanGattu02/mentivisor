import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ChartScreen.dart';
class ReportBottomSheet extends StatefulWidget {
  const ReportBottomSheet({Key? key}) : super(key: key);

  @override
  _ReportBottomSheetState createState() => _ReportBottomSheetState();
}

class _ReportBottomSheetState extends State<ReportBottomSheet> {
  String? _selected;
  final TextEditingController _customController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: SizedBox(
              width: 40,
              child: Divider(thickness: 4, height: 24),
            ),
          ),
          const Text('Post Report',
              style: TextStyle(fontSize: 20, fontFamily: 'segeo',fontWeight: FontWeight.w600,color: Color(0xff444444))),
          const SizedBox(height: 12),
          ...['Copied', 'Scam or Fraud', 'Abusing Post', 'Other',]
              .map(
                (opt) => RadioListTile<String>(
              value: opt,
              groupValue: _selected,
              title: Text(opt),
              onChanged: (v) => setState(() => _selected = v),
            ),
          )
              .toList(),
          if (_selected == 'Other') ...[
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _customController,
                maxLines: 3,

                decoration: const InputDecoration.collapsed(
                    hintText: 'Custom / Explain your reason here'),
              ),
            ),
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChartScreen()),
                );
              },
              borderRadius: BorderRadius.circular(24),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFA258F7),
                      Color(0xFF726CF7),
                      Color(0xFF4280F6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Center(
                  child: Text(
                    'Submit',

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'segeo',

                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}