import 'package:flutter/material.dart';
// If you still want your custom buttons, you can swap the ElevatedButtons back later.

class ExpertiseDetailScreen extends StatefulWidget {
  const ExpertiseDetailScreen({
    super.key,
    required this.categoryTitle,
    required this.initialChips,
  });

  final String categoryTitle;
  final List<String> initialChips;

  @override
  State<ExpertiseDetailScreen> createState() => _ExpertiseDetailScreenState();
}

class _ExpertiseDetailScreenState extends State<ExpertiseDetailScreen> {
  late List<String> currentChips;   // existing skills
  late List<String> newlyAdded;     // newly added (unsaved)

  // Suggested topics (tap -> confirm -> add to "newlyAdded")
  final List<String> suggestedTopics = const [
    'Props',
    'Routing',
    'Performance Optimization',
    'Lifecycle Methods',
    'State Management Libraries',
    'React Hooks',
  ];

  @override
  void initState() {
    super.initState();
    currentChips = [...widget.initialChips];
    newlyAdded = [];
  }

  // Save (merge both lists and return)
  Future<void> _onSave() async {
    if (!mounted) return;
    Navigator.of(context).pop([...currentChips, ...newlyAdded]);
  }

  // Adds only to "newlyAdded" (keeps segregation)
  void _addNewChip(String value) {
    final v = value.trim();
    if (v.isEmpty) return;

    final lc = v.toLowerCase();
    final exists = currentChips.any((e) => e.toLowerCase() == lc) ||
        newlyAdded.any((e) => e.toLowerCase() == lc);

    if (exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Already added')),
      );
      return;
    }
    setState(() => newlyAdded.add(v));
  }

  /// Bulletproof confirmation dialog (works above sheets, routers, etc.)
  Future<bool> _confirmSaveConceptDialog(BuildContext ctx, {String? conceptName}) async {
    final result = await showGeneralDialog<bool>(
      context: ctx,
      barrierDismissible: false,
      barrierLabel: 'Confirm',
      barrierColor: Colors.black.withOpacity(.35),
      transitionDuration: const Duration(milliseconds: 180),
      pageBuilder: (context, anim1, anim2) {
        return SafeArea(
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: MediaQuery.of(ctx).size.width - 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.08),
                      blurRadius: 22,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF7C5CFF), Color(0xFF5EA2FF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const Icon(Icons.save_rounded, color: Colors.white),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Do you want to save this concept?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF111111),
                          height: 1.2,
                        ),
                      ),
                      if (conceptName != null && conceptName.trim().isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          conceptName.trim(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF444444),
                            height: 1.2,
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 44,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Color(0xFFE3E6EE)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const Text('Cancel'),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SizedBox(
                              height: 44,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF7C5CFF),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                onPressed: () => Navigator.of(context).pop(true),
                                child: const Text('Okay'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim, _, child) {
        final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: .98, end: 1.0).animate(curved),
            child: child,
          ),
        );
      },
    );
    return result ?? false;
  }

  List<String> get _visibleSuggestions {
    bool notPresent(String s) {
      final lc = s.toLowerCase();
      return !currentChips.any((e) => e.toLowerCase() == lc) &&
          !newlyAdded.any((e) => e.toLowerCase() == lc);
    }
    return suggestedTopics.where(notPresent).toList();
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
          'Add Expertise',
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
          child: ListView(
            children: [
              const SizedBox(height: 6),

              // Current section
              Text(
                'Current Skills in ${widget.categoryTitle}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [for (final label in currentChips) _ChipPill(label: label)],
              ),

              const SizedBox(height: 20),

              // Add new
              const Text('Add new',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),

              // Pills that were confirmed and added
              if (newlyAdded.isNotEmpty)
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [for (final label in newlyAdded) _ChipPill(label: label)],
                ),

              const SizedBox(height: 10),
              // Add button + suggestions
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _AddChipPill(onTap: () => _openAddChipSheet(context)),
                  for (final s in _visibleSuggestions)
                    _SuggestionChip(
                      label: s,
                      onTap: () async {
                        final ok = await _confirmSaveConceptDialog(context, conceptName: s);
                        if (ok) _addNewChip(s);
                      },
                    ),
                ],
              ),

              const SizedBox(height: 90),
            ],
          ),
        ),
      ),

      // Sticky Save button (plain ElevatedButton to avoid any custom wiring issues)
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: SizedBox(
            height: 52,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C5CFF),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              onPressed: () async {
                final ok = await _confirmSaveConceptDialog(context);
                if (ok) await _onSave();
              },
              child: const Text(
                'Save',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// IMPORTANT: close the sheet FIRST, then show dialog on the parent context.
  void _openAddChipSheet(BuildContext parentContext) {
    final controller = TextEditingController();

    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetCtx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16, right: 16, top: 16,
            bottom: MediaQuery.of(sheetCtx).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE6E6E9),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Add item',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                autofocus: true,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: 'Enter topic name',
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onSubmitted: (v) async {
                  final value = v.trim();
                  if (value.isEmpty) return;

                  FocusScope.of(sheetCtx).unfocus();
                  Navigator.of(sheetCtx).pop(); // close sheet first

                  // wait a beat so Navigator stack settles, then show dialog
                  await Future.delayed(const Duration(milliseconds: 60));

                  final ok = await _confirmSaveConceptDialog(parentContext, conceptName: value);
                  if (ok) _addNewChip(value);
                },
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
                  onPressed: () async {
                    final value = controller.text.trim();
                    if (value.isEmpty) return;

                    FocusScope.of(sheetCtx).unfocus();
                    Navigator.of(sheetCtx).pop(); // close sheet first

                    await Future.delayed(const Duration(milliseconds: 60));

                    final ok = await _confirmSaveConceptDialog(parentContext, conceptName: value);
                    if (ok) _addNewChip(value);
                  },
                  child: const Text(
                    'Add',
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

// ---------- UI bits ----------

class _ChipPill extends StatelessWidget {
  const _ChipPill({required this.label});
  final String label;

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
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xFF121212),
        ),
      ),
    );
  }
}

// Purple “Add” pill
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

// Suggestion chip (tap -> confirm -> add)
class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFE8ECF4)),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF121212),
            ),
          ),
        ),
      ),
    );
  }
}
