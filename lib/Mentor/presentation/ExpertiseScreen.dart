import 'package:flutter/material.dart';

class ExpertiseScreen extends StatefulWidget {
  const ExpertiseScreen({super.key});

  @override
  State<ExpertiseScreen> createState() => _ExpertiseScreenState();
}

class _ExpertiseScreenState extends State<ExpertiseScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;

  final List<String> approved = const ['React', 'Java', 'Python'];
  final List<String> pending = const ['React', 'Java', 'Python'];
  final List<String> rejected = const ['React', 'Java', 'Python'];

  // Seed data for the detail screen chips
  final Map<String, List<String>> expertiseMap = {
    'React': [
      'Components',
      'JSX',
      'React Router',
      'Context API',
      'Hooks',
      'State Mgmt',
    ],
    'Java': ['OOP', 'Streams', 'Collections', 'Spring', 'JPA'],
    'Python': ['Django', 'Flask', 'Pandas', 'NumPy', 'AsyncIO'],
  };

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bg = LinearGradient(
      colors: [Color(0xFFF6F7FF), Color(0xFFFFF5FF)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        leadingWidth: 44,
        leading: const Padding(
          padding: EdgeInsets.only(left: 8),
          child: BackButton(),
        ),
        centerTitle: true,
        title: const Text(
          'Expertise',
          style: TextStyle(
            fontSize: 18,
            fontFamily: "segeo",
            color: Color(0xff121212),
            fontWeight: FontWeight.w700,
            letterSpacing: .1,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: bg),
        child: Column(
          children: [
            const SizedBox(height: 6),
            _SegmentedTabs(controller: _tab),
            const SizedBox(height: 14),
            Expanded(
              child: TabBarView(
                controller: _tab,
                children: [
                  // APPROVED
                  _ExpertiseListTab(
                    title: 'List',
                    items: approved,
                    variant: TileVariant.approved,
                    showAddButton: true,
                    onItemTap: (label) {
                      final chips = List<String>.from(
                        expertiseMap[label] ?? const [],
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ExpertiseDetailScreen(
                            categoryTitle: label,
                            initialChips: chips,
                          ),
                        ),
                      );
                    },
                    onAdd: () {
                      // Optional: Add category from Approved header (if needed)
                    },
                  ),
                  // PENDING
                  _ExpertiseListTab(
                    title: 'List',
                    items: pending,
                    variant: TileVariant.pending,
                    showAddButton: false,
                    onItemTap: (_) {},
                  ),
                  // REJECTED
                  _ExpertiseListTab(
                    title: 'List',
                    items: rejected,
                    variant: TileVariant.rejected,
                    showAddButton: false,
                    onItemTap: (_) {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SegmentedTabs extends StatelessWidget {
  const _SegmentedTabs({required this.controller});
  final TabController controller;

  @override
  Widget build(BuildContext context) {
    const segBg = Color(0xFFEFF2FF);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 53,
        decoration: BoxDecoration(
          color: segBg,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: TabBar(
            controller: controller,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            labelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            labelColor: const Color(0xff4076ED),
            unselectedLabelColor: const Color(0xFF666666),
            indicator: BoxDecoration(
              color: const Color(0xff4076ED).withOpacity(0.1),
              borderRadius: BorderRadius.circular(100),
            ),
            tabs: const [
              Tab(text: 'Approved'),
              Tab(text: 'Pending'),
              Tab(text: 'Rejected'),
            ],
          ),
        ),
      ),
    );
  }
}

enum TileVariant { approved, pending, rejected }

class _ExpertiseListTab extends StatelessWidget {
  const _ExpertiseListTab({
    required this.title,
    required this.items,
    required this.variant,
    required this.onItemTap,
    this.showAddButton = false,
    this.onAdd,
  });

  final String title;
  final List<String> items;
  final TileVariant variant;
  final bool showAddButton;
  final VoidCallback? onAdd;
  final void Function(String) onItemTap;

  Color _tileColor() {
    switch (variant) {
      case TileVariant.approved:
        return Colors.white;
      case TileVariant.pending:
        return const Color(0xFFFFEFD5);
      case TileVariant.rejected:
        return const Color(0xFFFFD7D7);
    }
  }

  BoxBorder? _tileBorder() {
    if (variant == TileVariant.approved) {
      return Border.all(color: const Color(0xFFE6E6E9));
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final tileColor = _tileColor();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF121212),
                ),
              ),
              const Spacer(),
              if (showAddButton) const SizedBox(width: 8),
              if (showAddButton) AddChip(onPressed: onAdd ?? () {}),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.separated(
              itemCount: items.length,
              padding: const EdgeInsets.only(bottom: 8),
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final label = items[i];
                return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => onItemTap(label),
                  child: Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: tileColor,
                      borderRadius: BorderRadius.circular(12),
                      border: _tileBorder(),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            label,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded, size: 18),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Detail Page: shows chip boxes like the screenshot and an Add option.
/// No cancel/remove action on chips (kept clean).
class ExpertiseDetailScreen extends StatefulWidget {
  const ExpertiseDetailScreen({
    super.key,
    required this.categoryTitle,
    required this.initialChips,
  });

  final String categoryTitle; // e.g., "React"
  final List<String> initialChips;

  @override
  State<ExpertiseDetailScreen> createState() => _ExpertiseDetailScreenState();
}

class _ExpertiseDetailScreenState extends State<ExpertiseDetailScreen> {
  late List<String> chips;

  @override
  void initState() {
    super.initState();
    chips = [...widget.initialChips];
  }

  @override
  Widget build(BuildContext context) {
    const bg = LinearGradient(
      colors: [Color(0xFFF6F7FF), Color(0xFFFFF5FF)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        leadingWidth: 44,
        leading: const Padding(
          padding: EdgeInsets.only(left: 8),
          child: BackButton(),
        ),
        centerTitle: true,
        title: const Text(
          'Expertise',
          style: TextStyle(
            fontSize: 18,
            fontFamily: "segeo",
            color: Color(0xff121212),
            fontWeight: FontWeight.w700,
            letterSpacing: .1,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: bg),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),
              Text(
                'IN-${widget.categoryTitle}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF121212),
                ),
              ),
              const SizedBox(height: 12),

              // Chips area
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      // Existing chips
                      for (final label in chips)
                        _ChipPill(
                          label: label,
                          // showCancel: false  // keep default: no cancel icon/action
                        ),

                      // Add new chip
                      _AddChipPill(onTap: () => _openAddChipSheet(context)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openAddChipSheet(BuildContext context) {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE6E6E9),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Add item',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Enter chip name',
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9C5BF7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    final value = controller.text.trim();
                    if (value.isNotEmpty && !chips.contains(value)) {
                      setState(() => chips.add(value));
                    }
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      letterSpacing: .2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Visual chip pill like the screenshot. No cancel by default.
class _ChipPill extends StatelessWidget {
  const _ChipPill({
    required this.label,
    this.showCancel = false,
    this.onCancel,
  });

  final String label;
  final bool showCancel; // keep false per requirement
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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

/// “Add” pill chip (purple) to match the style in your list screen.
class _AddChipPill extends StatelessWidget {
  const _AddChipPill({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF9C5BF7),
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add_rounded, size: 16, color: Colors.white),
              SizedBox(width: 6),
              Text(
                'Add',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: "segeo",
                  fontWeight: FontWeight.w800,
                  letterSpacing: .2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Small rounded “Add new” button used in the list header.
class AddChip extends StatelessWidget {
  const AddChip({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF9C5BF7);
    return Material(
      color: primary,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add_rounded, size: 16, color: Colors.white),
              SizedBox(width: 6),
              Text(
                'Add new',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: "segeo",
                  fontWeight: FontWeight.w800,
                  letterSpacing: .2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
