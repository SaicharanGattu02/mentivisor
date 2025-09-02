import 'package:flutter/material.dart';

import '../../Components/CustomAppButton.dart';

class CoinHistoryScreen extends StatefulWidget {
  const CoinHistoryScreen({Key? key}) : super(key: key);

  @override
  State<CoinHistoryScreen> createState() => _CoinHistoryScreenState();
}

class _CoinHistoryScreenState extends State<CoinHistoryScreen> {
  String _selectedRange = 'All Time';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.8,
        shadowColor: const Color(0x11000000),
        leadingWidth: 56,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF222222),
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Coin History',
          style: TextStyle(
            fontFamily: 'segeo',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF121212),
          ),
        ),
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF6F8FF), Color(0xFFF4F5FA)],
          ),
        ),
        child: SafeArea(
          top: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              Row(
                children: [
                  const Text(
                    'Recent',
                    style: TextStyle(
                      fontFamily:
                          'segeo', // corrected "segeo" → "segeo" (check your font name)
                      fontSize: 18,

                      fontWeight: FontWeight.w700,
                      color: Color(0xFF121212),
                    ),
                  ),
                  Spacer(), // spacing between text & icon
                  IconButton(
                    onPressed: _openFilterSheet,
                    tooltip: 'Filter',
                    icon: Image.asset(
                      "assets/images/filterimg.png",
                      color: Color(0xFF4076ED),
                      height: 24, // optional, adjust size
                      width: 24,
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
              ),
              const SizedBox(height: 12),

              /// SINGLE CARD (example)
              const CoinHistoryCard(
                title: 'Session with Vijay',
                dateLabel: '11 Jun 25',
                coins: 50, // show as +50 on the right
              ),

              // ---- When you wire API + BlocBuilder, render multiple CoinHistoryCard() here ----
            ],
          ),
        ),
      ),
    );
  }

  void _openFilterSheet() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0x99000000),
      isScrollControlled: false,
      builder: (context) => _FilterSheet(
        initialValue: _selectedRange,
        onApply: (value) => Navigator.of(context).pop(value),
      ),
    );

    if (selected != null && selected != _selectedRange) {
      setState(() => _selectedRange = selected);
      // Apply your API filter with `_selectedRange` in your Bloc
    }
  }
}

/// Reusable single card widget
class CoinHistoryCard extends StatelessWidget {
  const CoinHistoryCard({
    super.key,
    required this.title,
    required this.dateLabel,
    required this.coins,
    this.onTap,
  });

  final String title;
  final String dateLabel;
  final int coins;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x140E1240),
              blurRadius: 14,
              offset: Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            // Left: Title + date
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'segeo',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF222222),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Image.asset("assets/images/Radiocalenderimg.png",height: 16,width: 16,),

                      // const Icon(
                      //   Icons.calendar_today_rounded,
                      //   size: 14,
                      //   color: Color(0xFF98A2B3),
                      // ),
                      const SizedBox(width: 6),
                      Text(
                        dateLabel,
                        style: const TextStyle(
                          fontFamily: 'segeo',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF7B7F8C),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Right: +XX 🪙
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '+$coins',
                  style: const TextStyle(
                    fontFamily: 'segeo',
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF222222),
                  ),
                ),
                const SizedBox(width: 6),
                Image.asset(
                  "assets/images/GoldCoins.png",
                  height: 24, // optional, adjust size
                  width: 24,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterSheet extends StatefulWidget {
  const _FilterSheet({required this.initialValue, required this.onApply});

  final String initialValue;
  final ValueChanged<String> onApply;

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  final List<String> options = const [
    'All Time',
    'This Week',
    'This Month',
    'This Quarter',
  ];
  late String selected;

  @override
  void initState() {
    super.initState();
    selected = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filter',
            style: TextStyle(
              fontFamily: 'segeo',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xff444444),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Time',
            style: TextStyle(
              fontFamily: 'segeo',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF444444),
            ),
          ),
          const SizedBox(height: 8),

          ...options.map(
            (o) => _CheckRow(
              label: o,
              checked: selected == o,
              onChanged: (_) => setState(() => selected = o),
            ),
          ),
          const SizedBox(height: 14),
          CustomAppButton1(text: "Apply", onPlusTap: () {}),
        ],
      ),
    );
  }
}

class _CheckRow extends StatelessWidget {
  const _CheckRow({
    required this.label,
    required this.checked,
    required this.onChanged,
  });

  final String label;
  final bool checked;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => onChanged(!checked),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Checkbox(
              value: checked,
              onChanged: (v) => onChanged(v ?? false),
              visualDensity: VisualDensity.compact,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              side: const BorderSide(color: Color(0xFF98A2B3), width: 1),
              activeColor: const Color(0xFF7F00FF),
              checkColor: Colors.white,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'segeo',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF444444),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
