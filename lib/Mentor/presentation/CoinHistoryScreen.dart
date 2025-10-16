import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import 'package:mentivisor/Mentor/presentation/widgets/CoinHistoryShimmerLoader.dart';
import 'package:mentivisor/utils/media_query_helper.dart';

import '../../Components/CommonLoader.dart';
import '../../Components/CustomAppButton.dart';
import '../data/Cubits/CoinsHistory/coin_history_cubit.dart';
import '../data/Cubits/CoinsHistory/coin_history_states.dart';

class CoinHistoryScreen extends StatefulWidget {
  const CoinHistoryScreen({Key? key}) : super(key: key);

  @override
  State<CoinHistoryScreen> createState() => _CoinHistoryScreenState();
}

class _CoinHistoryScreenState extends State<CoinHistoryScreen> {
  /// Store API key of current filter: all | week | month | quarter
  String _selectedKey = 'all';

  @override
  void initState() {
    super.initState();
    // Initial load: pass '' (your API treats as All Time) or pass 'all'
    context.read<CoinHistoryCubit>().getCoinHistory(
      _selectedKey == 'all' ? '' : _selectedKey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar1(title: 'Coin History', actions: const []),
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
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: [
                      const Text(
                        'Recent',
                        style: TextStyle(
                          fontFamily: 'segeo',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF121212),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: _openFilterSheet,
                        tooltip: 'Filter',
                        icon: Image.asset(
                          "assets/images/filterimg.png",
                          color: const Color(0xFF4076ED),
                          height: 32,
                          width: 32,
                        ),
                      ),
                      const SizedBox(width: 4),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 12)),

              BlocBuilder<CoinHistoryCubit, CoinHistoryStates>(
                builder: (context, state) {
                  if (state is CoinhistoryLoading) {
                    return const CoinHistoryShimmerLoader(itemCount: 6);
                  }

                  if (state is CoinhistoryFailure) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 40, 16, 24),
                        child: _EmptyState(
                          title: "Couldn't load history",
                          subtitle: state.error ?? 'Please try again.',
                        ),
                      ),
                    );
                  }

                  if (state is CoinhistoryLoaded) {
                    final items = state.coinHistoryModel.data ?? [];
                    if (items.isEmpty) {
                      return const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(16, 40, 16, 24),
                          child: _EmptyState(
                            title: 'No transactions yet',
                            subtitle: 'Your coin activity will appear here.',
                          ),
                        ),
                      );
                    }

                    return SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final item = items[index];

                          // Map your dynamic fields here:
                          final title = _titleOf(
                            item,
                          ); // prefers item['activity']
                          final dateLabel = _dateLabelOf(
                            item,
                          ); // prefers item['date']
                          final coins = _coinsOf(item); // prefers item['coins']

                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: index == items.length - 1 ? 0 : 12,
                            ),
                            child: _CoinRowCard(
                              title: title,
                              dateLabel: dateLabel,
                              coinsText: coins,
                            ),
                          );
                        }, childCount: items.length),
                      ),
                    );
                  }

                  // Fallback
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Opens bottom sheet that returns an API key: all | week | month | quarter
  void _openFilterSheet() async {
    final selectedKey = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0x99000000),
      isScrollControlled: false,
      builder: (context) => _FilterSheet(
        initialValue: _selectedKey, // pass current key (e.g., 'week')
        onApply: (key) => Navigator.of(context).pop(key), // return key
      ),
    );

    if (selectedKey != null && selectedKey != _selectedKey) {
      setState(() => _selectedKey = selectedKey);
      // Pass '' for all-time if your API expects empty for "All"
      context.read<CoinHistoryCubit>().getCoinHistory(
        _selectedKey == 'all' ? '' : _selectedKey,
      );
    }
  }
}

class _CoinRowCard extends StatelessWidget {
  const _CoinRowCard({
    required this.title,
    required this.dateLabel,
    required this.coinsText,
  });

  final String title;
  final String dateLabel;
  final String coinsText;

  @override
  Widget build(BuildContext context) {
    return Container(
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Image.asset(
                      "assets/images/Radiocalenderimg.png",
                      height: 16,
                      width: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      dateLabel,
                      style: const TextStyle(
                        fontFamily: 'segeo',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF575757),
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
                coinsText,
                style: const TextStyle(
                  fontFamily: 'segeo',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  // fontWeight: FontWeight.w700,
                  color: Color(0xFF121212),
                ),
              ),
              const SizedBox(width: 6),
              Image.asset("assets/images/GoldCoins.png", height: 24, width: 24),
            ],
          ),
        ],
      ),
    );
  }
}

/// Bottom sheet with FIXED labels → API keys mapping,
/// returns API key immediately when user taps an option.
class _FilterSheet extends StatefulWidget {
  const _FilterSheet({required this.initialValue, required this.onApply});

  /// Accept a key (all|week|month|quarter) or a label ("This Week") — both supported.
  final String initialValue;
  final ValueChanged<String> onApply;

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  // UI labels list (shown to the user)
  final List<String> options = const [
    'All Time',
    'This Week',
    'This Month',
    'This Quarter',
  ];

  // Label -> API key
  static const Map<String, String> _labelToKey = {
    'All Time': 'all',
    'This Week': 'week',
    'This Month': 'month',
    'This Quarter': 'quarter',
  };

  // API key -> Label
  static const Map<String, String> _keyToLabel = {
    'all': 'All Time',
    'week': 'This Week',
    'month': 'This Month',
    'quarter': 'This Quarter',
  };

  late String selectedLabel;

  @override
  void initState() {
    super.initState();
    // Resolve initialValue: accept label or key
    if (options.contains(widget.initialValue)) {
      selectedLabel = widget.initialValue; // label
    } else if (_keyToLabel.containsKey(widget.initialValue)) {
      selectedLabel = _keyToLabel[widget.initialValue]!;
    } else {
      selectedLabel = 'All Time';
    }
  }

  void _onPick(String label) {
    setState(() => selectedLabel = label);
    final key = _labelToKey[label] ?? 'all';
    widget.onApply(key); // parent pops the sheet
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
              checked: selectedLabel == o,
              onChanged: (_) => _onPick(o),
            ),
          ),
          const SizedBox(height: 6),
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

String _titleOf(dynamic item) {
  try {
    final t =
        (item?.activity ?? // preferred
                item?.title ??
                item?.reason ??
                item?.description ??
                (item is Map
                    ? (item['activity'] ??
                          item['title'] ??
                          item['reason'] ??
                          item['description'])
                    : null))
            ?.toString();
    return (t == null || t.isEmpty) ? 'Coins update' : t;
  } catch (_) {
    return 'Coins update';
  }
}

String _dateLabelOf(dynamic item) {
  try {
    final raw =
        (item?.date ?? // preferred
                item?.createdAt ??
                (item is Map ? (item['date'] ?? item['created_at']) : null))
            ?.toString();
    if (raw == null || raw.isEmpty) return '—';
    return _formatAsDdMmmYy(raw);
  } catch (_) {
    return '—';
  }
}

String _coinsOf(dynamic item) {
  try {
    final v =
        (item?.coins ?? // preferred
        item?.amount ??
        item?.value ??
        (item is Map
            ? (item['coins'] ?? item['amount'] ?? item['value'])
            : null));

    if (v == null) return '+0';

    final s = v.toString().trim();

    // If server already sends with sign like "+1380" or "-50", use as-is
    if (RegExp(r'^[\+\-]\s*\d').hasMatch(s)) return s;

    // Otherwise try to parse and add a sign for positives
    final n = num.tryParse(s);
    if (n == null) return s; // not numeric, show raw
    return n >= 0 ? '+${n.toStringAsFixed(0)}' : n.toStringAsFixed(0);
  } catch (_) {
    return '+0';
  }
}

/// If it's already "02 Sep 25", keep it.
/// If it's ISO like "2025-09-02T13:45:00Z", render "02 Sep 25".
String _formatAsDdMmmYy(String raw) {
  final already = RegExp(r'^\d{1,2}\s+[A-Za-z]{3}\s+\d{2}$');
  if (already.hasMatch(raw)) return raw;

  final dt = DateTime.tryParse(raw);
  if (dt == null) return raw;

  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  final d = dt.day.toString().padLeft(2, '0');
  final mon = months[dt.month - 1];
  final yy = (dt.year % 100).toString().padLeft(2, '0');
  return '$d $mon $yy';
}

/// Simple empty-state widget
class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.title, required this.subtitle});
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.history, size: 42, color: Color(0xFF98A2B3)),
        const SizedBox(height: 10),
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'segeo',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF222222),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'segeo',
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF7B7F8C),
          ),
        ),
      ],
    );
  }
}
