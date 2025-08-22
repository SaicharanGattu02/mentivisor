import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mentivisor/Components/CustomAppButton.dart';

import '../../Models/DailySlotsModel.dart';
import '../../data/cubits/DailySlots/daily_slots_cubit.dart';
import '../../data/cubits/DailySlots/daily_slots_states.dart';

// ───────────────────────────────────────────────────────────────────────────────
// CALL THIS: final picked = await showDailySlotsBottomSheet(context, mentorId: 12, date: "2025-08-02");
// It returns a Slots? (your model). If user closes without picking, returns null.
// ───────────────────────────────────────────────────────────────────────────────
Future<Slots?> showDailySlotsBottomSheet(
  BuildContext context, {
  required int mentorId,
  required String date, // "YYYY-MM-DD"
}) {
  return showModalBottomSheet<Slots?>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return SafeArea(
        child: DailySlotsSheet(mentorId: mentorId, date: date),
      );
    },
  );
}

// ───────────────────────────────────────────────────────────────────────────────
// SHEET (kept in same file as a single widget for easy paste)
// ───────────────────────────────────────────────────────────────────────────────

class DailySlotsSheet extends StatefulWidget {
  final int mentorId;
  final String date;

  const DailySlotsSheet({
    super.key,
    required this.mentorId,
    required this.date,
  });

  @override
  State<DailySlotsSheet> createState() => DailySlotsSheetState();
}

class DailySlotsSheetState extends State<DailySlotsSheet> {
  Slots? _selected;

  // Palette tuned to the screenshot
  static const _bg = Color(0xFFF6FAFF);
  static const _chipBg = Color(0xFFE9F1FF);
  static const _chipText = Color(0xFF2F65F5);
  static const _selectedBg = Color(0xFFE7F9EE);
  static const _selectedText = Color(0xFF12834C);
  static const _titleText = Color(0xFF121212);
  static const _subtitleText = Color(0xFF4A4A4A);

  String _formatHeading(String yMd) {
    // expects "YYYY-MM-DD"
    try {
      final dt = DateTime.parse(yMd);
      // "15 July 25"
      final day = DateFormat('d').format(dt);
      final mon = DateFormat('MMMM').format(dt);
      final yy = DateFormat('yy').format(dt);
      return '$day $mon $yy';
    } catch (_) {
      return yMd;
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<DailySlotsCubit>().getDailySlots(widget.mentorId, widget.date);
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final sheetHeight = media.size.height * 0.6;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: Material(
        color: Colors.white,
        child: SizedBox(
          height: sheetHeight,
          child: Container(
            decoration: const BoxDecoration(color: _bg),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag handle
                  Center(
                    child: Container(
                      width: 48,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Date heading
                  Text(
                    _formatHeading(widget.date),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: _titleText,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 18),

                  const Text(
                    'Select time from the available time Slots',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _subtitleText,
                    ),
                  ),
                  const SizedBox(height: 18),

                  // CONTENT
                  Expanded(
                    child: BlocBuilder<DailySlotsCubit, DailySlotsStates>(
                      builder: (context, state) {
                        if (state is DailySlotsLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state is DailySlotsFailure) {
                          return Center(
                            child: Text(
                              state.error,
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        }
                        if (state is DailySlotsLoaded) {
                          final model = state.dailySlotsModel;
                          final slots = model.slots ?? [];

                          if (slots.isEmpty) {
                            return const Center(
                              child: Text(
                                'No slots available',
                                style: TextStyle(fontSize: 16),
                              ),
                            );
                          }

                          // Wrap like the screenshot (2 columns feeling)
                          return SingleChildScrollView(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Wrap(
                              spacing: 18,
                              runSpacing: 18,
                              children: [
                                for (final s in slots)
                                  _SlotChip(
                                    label: s.timeLabel ?? '',
                                    isBooked: s.isBooked ?? false,
                                    isSelected: _selected?.id == s.id,
                                    onTap: (s.isBooked ?? false)
                                        ? null
                                        : () {
                                            setState(() => _selected = s);
                                          },
                                  ),
                              ],
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  CustomAppButton1(
                    text: "Pick the Time",
                    onPlusTap: () {
                      if (_selected != null) {
                        Navigator.of(context).pop<Slots?>(_selected);
                      }
                    },
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────────────────────
// SLOT CHIP
// ───────────────────────────────────────────────────────────────────────────────
class _SlotChip extends StatelessWidget {
  final String label;
  final bool isBooked;
  final bool isSelected;
  final VoidCallback? onTap;

  const _SlotChip({
    required this.label,
    required this.isBooked,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const chipBg = Color(0xFFE9F1FF);
    const chipText = Color(0xFF2F65F5);
    const selBg = Color(0xFFE7F9EE);
    const selText = Color(0xFF12834C);

    final bg = isSelected ? selBg : chipBg;
    final txt = isSelected ? selText : chipText;

    return Opacity(
      opacity: isBooked ? 0.45 : 1.0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          constraints: const BoxConstraints(minWidth: 210),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    color: txt,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (isSelected) ...[
                const SizedBox(width: 8),
                const Icon(Icons.check, size: 22, color: selText),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
