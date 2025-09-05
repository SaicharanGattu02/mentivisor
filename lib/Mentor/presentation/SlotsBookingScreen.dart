import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mentivisor/Components/CustomAppButton.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import 'package:mentivisor/Mentor/data/Cubits/MentorAvailability/MentorAvailabilitytates.dart';
import '../../Components/CustomSnackBar.dart';
import '../../Mentee/data/cubits/ProductTools/TaskByDate/task_by_date_cubit.dart';
import '../../Mentee/data/cubits/ProductTools/TaskByStates/task_by_states_cubit.dart';
import '../Models/AvailableSlotsModel.dart';
import '../data/Cubits/AvailabilitySlots/AvailabilitySlotsCubit.dart';
import '../data/Cubits/AvailabilitySlots/AvailabilitySlotsStates.dart';
import '../data/Cubits/MentorAvailability/MentorAvailabilityCubit.dart';

const Color kPurple = Color(0xFF9333EA);
const Color kLightLav = Color(0xFFF1E9FF);
const Color kCardBlueBorder = Color(0xFF2F8BFF);
const Color kPillBorder = Color(0xFFDDDDE8);
const Color kCoinBg = Color(0xFFFFF6CF);

const TextStyle kTitle16Bold = TextStyle(
  fontFamily: 'segeo',
  fontSize: 16,
  fontWeight: FontWeight.w700,
);

// small helper pill (used in the group cards)
Widget _slotChip(String label) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: Color(0xFFF5F5F5), // light lavender background
      borderRadius: BorderRadius.circular(16),
    ),
    child: Text(
      label,
      style: const TextStyle(
        fontFamily: 'segeo',
        fontWeight: FontWeight.w600,
        fontSize: 13,
        color: Colors.black,
      ),
    ),
  );
}

class Slotsbookingscreen extends StatefulWidget {
  const Slotsbookingscreen({super.key});

  @override
  _SlotsbookingscreenState createState() => _SlotsbookingscreenState();
}

class _SlotsbookingscreenState extends State<Slotsbookingscreen> {
  DateTime visibleMonth = DateTime.now();
  DateTime selectedDate = DateTime.now();
  final TextEditingController _taskNameController = TextEditingController();

  bool keepForWeek = true;

  @override
  void initState() {
    super.initState();
    context.read<AvailableSlotsCubit>().getAvailableSlots();
  }

  void prevMonth() {
    setState(() {
      visibleMonth = DateTime(visibleMonth.year, visibleMonth.month - 1, 1);
    });
  }

  void nextMonth() {
    setState(() {
      visibleMonth = DateTime(visibleMonth.year, visibleMonth.month + 1, 1);
    });
  }

  List<int?> makeMonthGrid(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    final startOffset = (firstDay.weekday) % 7; // Sunday = 0
    final List<int?> list = [];
    for (int i = 0; i < startOffset; i++) list.add(null);
    for (int d = 1; d <= lastDay.day; d++) list.add(d);
    return list;
  }

  void _onDateSelected(int day) {
    final selected = DateTime(visibleMonth.year, visibleMonth.month, day);
    final today = DateTime.now();
    final currentDateOnly = DateTime(today.year, today.month, today.day);

    if (selected.isBefore(currentDateOnly)) {
      return;
    }

    setState(() {
      selectedDate = selected;
    });
  }


  @override
  Widget build(BuildContext context) {
    final gridDays = makeMonthGrid(visibleMonth);
    final monthTitle = DateFormat('MMMM yyyy').format(visibleMonth);
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6FD),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 14,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          monthTitle,
                          style: const TextStyle(
                            fontFamily: 'segeo',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: visibleMonth.isAfter(DateTime(2025, 9))
                              ? prevMonth
                              : null,
                          icon: Icon(
                            Icons.chevron_left,
                            color: visibleMonth.isAfter(DateTime(2025, 9))
                                ? Colors.black
                                : Colors.grey.withOpacity(0.5), // make it visually disabled
                          ),
                        ),

                        IconButton(
                          onPressed: nextMonth,
                          icon: const Icon(Icons.chevron_right),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 42,
                      decoration: BoxDecoration(
                        color: kLightLav,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa']
                            .map(
                              (d) => Expanded(
                                child: Center(
                                  child: Text(
                                    d,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'segeo',
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 7,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            childAspectRatio: 1.0,
                          ),
                      itemCount: gridDays.length,
                        itemBuilder: (context, index) {
                          final day = gridDays[index];
                          if (day == null) return const SizedBox();

                          final isSelected =
                              selectedDate.day == day &&
                                  selectedDate.month == visibleMonth.month &&
                                  selectedDate.year == visibleMonth.year;

                          DateTime now = DateTime.now();
                          final currentDateOnly = DateTime(now.year, now.month, now.day);

                          final date = DateTime(visibleMonth.year, visibleMonth.month, day);
                          final isPast = date.isBefore(currentDateOnly);

                          final isToday =
                              now.day == day &&
                                  now.month == visibleMonth.month &&
                                  now.year == visibleMonth.year;

                          return GestureDetector(
                            onTap: isPast ? null : () => _onDateSelected(day), // disable tap
                            child: Opacity(
                              opacity: isPast ? 0.4 : 1.0, // fade past dates
                              child: Center(
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? kPurple.withOpacity(0.08)
                                        : (isToday
                                        ? const Color(0xFFE8F0FF)
                                        : Colors.white),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected
                                          ? kPurple
                                          : (isToday
                                          ? kPurple.withOpacity(0.25)
                                          : const Color(0xFFDDDDDD)),
                                      width: isSelected ? 2 : 1,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    day.toString(),
                                    style: const TextStyle(
                                      fontFamily: 'segeo',
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            // // ---------------- Selected Day Detail Card (exactly like image) ----------------
            // Container(
            //   width: double.infinity,
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(16),
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.black.withOpacity(0.03),
            //         blurRadius: 12,
            //       ),
            //     ],
            //   ),
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(
            //       vertical: 14,
            //       horizontal: 12,
            //     ),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         // Top row: date + Add Slot button
            //         Row(
            //           children: [
            //             Text(
            //               selectedTitle, // e.g., 17 Jun 25
            //               style: const TextStyle(
            //                 fontFamily: 'segeo',
            //                 fontSize: 16,
            //                 fontWeight: FontWeight.w700,
            //               ),
            //             ),
            //             const Spacer(),
            //
            //           ],
            //         ),
            //         const SizedBox(height: 10),
            //
            //         // Time row + coin + delete
            //         Row(
            //           children: [
            //             _iconTextPill(
            //               Icons.schedule,
            //               "09:00",
            //               Color(0xff666666),
            //             ),
            //             const SizedBox(width: 16),
            //             const Text(
            //               "to",
            //               style: TextStyle(fontFamily: 'segeo', fontSize: 13),
            //             ),
            //             const SizedBox(width: 16),
            //             _iconTextPill(
            //               Icons.access_time_filled_rounded,
            //               "10:00",
            //               Color(0xff666666),
            //             ),
            //             const Spacer(),
            //             // _coinPill("50"),
            //             const SizedBox(width: 10),
            //             IconButton(
            //               onPressed: () {},
            //               icon: const Icon(
            //                 Icons.delete_outline,
            //                 color: Colors.redAccent,
            //               ),
            //             ),
            //           ],
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            //
            // const SizedBox(height: 18),

            // ---------------- Recent Added header ----------------
            // ---------------- Recent Added header ----------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Recent Added",
                  style: TextStyle(
                    fontFamily: 'segeo',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                TextButton.icon(
                  onPressed: _showAddSlotDialog,
                  icon: const Icon(Icons.add, color: Colors.white, size: 18),
                  label: const Text(
                    "Add Slot",
                    style: TextStyle(
                      fontFamily: 'segeo',
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xff9333EA),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            BlocBuilder<AvailableSlotsCubit, AvailableSlotsStates>(
              builder: (context, state) {
                if (state is AvailableSlotsLoading) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                }
                if (state is AvailableSlotsFailure) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      state.error,
                      style: const TextStyle(
                        color: Colors.red,
                        fontFamily: 'segeo',
                      ),
                    ),
                  );
                }
                if (state is AvailableSlotsLoaded) {
                  final data = state.availableSlotsModel.recentSlots ?? [];
                  if (data.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        "No recent slots found",
                        style: TextStyle(fontFamily: 'segeo'),
                      ),
                    );
                  }

                  final groups = _groupRecent(data);

                  return Column(
                    children: [
                      for (final g in groups) ...[
                        _recentGroupCard(
                          title: g.title,
                          badge: g.badge,
                          slots: g.chips,
                          count: g.count, // NEW
                        ),
                        const SizedBox(height: 12),
                      ],
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    super.dispose();
  }

  // ---------- helpers (exact visual style) ----------

  Widget _iconTextPill(IconData icon, String text, color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5), // light lavender background
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF6C6F7B)),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontFamily: 'segeo',
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _coinPill(String coins) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: kCoinBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Image.asset("assets/images/GoldCoins.png", height: 19, width: 19),
          const SizedBox(width: 6),
          Text(
            coins,
            style: const TextStyle(
              fontFamily: 'segeo',
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _recentGroupCard({
    required String title,
    String? badge,
    required List<String> slots,
    required int count, // NEW
  }) {
    String countLabel = "$count slot${count == 1 ? '' : 's'}";
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 12),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.calendar_month_outlined,
                  size: 18,
                  color: Color(0xFF333333),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'segeo',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (badge != null) ...[
                  const SizedBox(width: 6),
                  Text(
                    badge!,
                    style: const TextStyle(
                      fontFamily: 'segeo',
                      fontSize: 12,
                      color: Color(0xFF7C8596),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            Text(
              countLabel, // DYNAMIC
              style: const TextStyle(
                fontFamily: 'segeo',
                fontSize: 13,
                color: Color(0xFF7C8596),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: slots.map(_slotChip).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Future<TimeOfDay?> _pickTime(BuildContext context, TimeOfDay initial) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (context, child) {
        // Optional: match your theme
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: const TimePickerThemeData(
              hourMinuteTextStyle: TextStyle(
                fontFamily: 'segeo',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    return picked;
  }

  String _fmt(TimeOfDay t) {
    final hh = t.hour.toString().padLeft(2, '0');
    final mm = t.minute.toString().padLeft(2, '0');
    return "$hh:$mm";
  }

  Duration _diffOnDay(TimeOfDay from, TimeOfDay to, DateTime day) {
    final a = DateTime(day.year, day.month, day.day, from.hour, from.minute);
    final b = DateTime(day.year, day.month, day.day, to.hour, to.minute);
    return b.difference(a);
  }

  DateTime _parseYmd(String ymd) => DateTime.parse(ymd); // "2025-09-04"
  DateTime _combine(DateTime d, String hhmmss) {
    final t = DateFormat('HH:mm:ss').parse(hhmmss);
    return DateTime(d.year, d.month, d.day, t.hour, t.minute, t.second);
  }

  String _fmtDay(DateTime d) => DateFormat('d MMM yy').format(d);
  String _fmtTime(String hhmmss) {
    final t = DateFormat('HH:mm:ss').parse(hhmmss);
    return DateFormat('h:mm').format(t); // 9:00
  }

  String _rangeTime(String start, String end) =>
      "${_fmtTime(start)} - ${_fmtTime(end)}";

  // week starts on Sunday (to match your calendar header Su–Sa)
  DateTime _weekStartSunday(DateTime d) {
    final dow = d.weekday % 7; // Sun=0, Mon=1,... Sat=6
    return d.subtract(Duration(days: dow));
  }

// Helper: keep first occurrence per key (stable order)
  List<T> uniqueBy<T, K>(Iterable<T> list, K Function(T) key) {
    final seen = <K>{};
    final out = <T>[];
    for (final item in list) {
      final k = key(item);
      if (seen.add(k)) out.add(item);
    }
    return out;
  }

  List<_Grouped> _groupRecent(List<RecentSlots> raw) {
    final weekly = <RecentSlots>[];
    final singles = <RecentSlots>[];
    for (final r in raw) (r.repeatWeekly == 1 ? weekly : singles).add(r);

    final out = <_Grouped>[];

    // Weekly groups (Sun–Sat)
    final Map<DateTime, List<RecentSlots>> byWeek = {};
    for (final r in weekly) {
      final d = _parseYmd(r.date!);
      final ws = _weekStartSunday(d);
      final key = DateTime(ws.year, ws.month, ws.day);
      byWeek.putIfAbsent(key, () => []).add(r);
    }

    byWeek.forEach((start, items) {
      // ✅ Dedupe by time range within the same week
      final uniq = uniqueBy<RecentSlots, String>(
        items,
            (e) => "${e.startTime}-${e.endTime}",
      );

      final end = start.add(const Duration(days: 6));
      final title =
          "${DateFormat('d MMM').format(start)} - ${DateFormat('d MMM yy').format(end)}";

      final chips = uniq
          .map((e) => _rangeTime(e.startTime!, e.endTime!))
          .toList();

      out.add(_Grouped(start, title, "1 week", chips, uniq.length)); // count = unique
    });

    // Single-day groups (leave as-is)
    final Map<DateTime, List<RecentSlots>> byDate = {};
    for (final r in singles) {
      final d = _parseYmd(r.date!);
      final key = DateTime(d.year, d.month, d.day);
      byDate.putIfAbsent(key, () => []).add(r);
    }
    byDate.forEach((day, items) {
      final title = _fmtDay(day);
      final chips = items
          .map((e) => _rangeTime(e.startTime!, e.endTime!))
          .toList();
      out.add(_Grouped(day, title, null, chips, items.length));
    });

    out.sort((a, b) => b.sortKey.compareTo(a.sortKey));
    return out;
  }


  Future<void> _showAddSlotDialog() async {
    TimeOfDay from = const TimeOfDay(hour: 9, minute: 0);
    TimeOfDay to = const TimeOfDay(hour: 10, minute: 0);
    final coinsCtl = TextEditingController(text: "00");
    String? errorText;

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setLocal) {
            Future<void> pickFrom() async {
              final p = await _pickTime(ctx, from);
              if (p != null) setLocal(() => from = p);
            }

            Future<void> pickTo() async {
              final p = await _pickTime(ctx, to);
              if (p != null) setLocal(() => to = p);
            }

            void onAdd() async {
              // basic validation
              final d = _diffOnDay(from, to, selectedDate);
              if (d.inMinutes < 0) {
                setLocal(
                  () => errorText = "End time must be after start time.",
                );
                return;
              }
              if (d.inMinutes < 30) {
                setLocal(() => errorText = "Minimum slot is 30 minutes.");
                return;
              }
              if (d.inMinutes > 180) {
                setLocal(() => errorText = "Maximum slot is 3 hours.");
                return;
              }

              // build API data map (24-hour format)
              String fmtTime(TimeOfDay t) =>
                  "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}";

              final mapData = {
                "date": DateFormat("yyyy-MM-dd").format(selectedDate),
                "start_time": fmtTime(from), // e.g. 11:35
                "end_time": fmtTime(to), // e.g. 12:35
                "repeat_weekly": keepForWeek ? "1" : "0",
              };

              // call cubit
              final response = await context
                  .read<MentorAvailabilityCubit>()
                  .addMentorAvailability(mapData);

              Navigator.of(ctx).pop(); // close dialog
            }

            return Dialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    const Text(
                      "Add Slot",
                      style: TextStyle(
                        fontFamily: 'segeo',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      DateFormat('d MMM yy').format(selectedDate),
                      style: const TextStyle(
                        fontFamily: 'segeo',
                        fontSize: 12,
                        color: Color(0xFF7C8596),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Time row (From - To - Coins)
                    Row(
                      children: [
                        // From
                        Expanded(
                          child: GestureDetector(
                            onTap: pickFrom,
                            child: _timeFieldPill(Icons.schedule, _fmt(from)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          "to",
                          style: TextStyle(fontFamily: 'segeo', fontSize: 13),
                        ),
                        const SizedBox(width: 12),
                        // To
                        Expanded(
                          child: GestureDetector(
                            onTap: pickTo,
                            child: _timeFieldPill(
                              Icons.access_time_filled_rounded,
                              _fmt(to),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Coins
                        // Container(
                        //   padding: const EdgeInsets.symmetric(
                        //     horizontal: 10,
                        //     vertical: 8,
                        //   ),
                        //   decoration: BoxDecoration(
                        //     color: kCoinBg,
                        //     borderRadius: BorderRadius.circular(12),
                        //   ),
                        //   child: Row(
                        //     mainAxisSize: MainAxisSize.min,
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     children: [
                        //       Image.asset(
                        //         "assets/images/GoldCoins.png", // make sure path matches your pubspec
                        //         height: 19,
                        //         width: 19,
                        //       ),
                        //       const SizedBox(width: 6),
                        //       // keep a stable width so 9/99/100 don't shift layout
                        //       SizedBox(
                        //         width: 36,
                        //         child: Text(
                        //           "0", // e.g. "00"
                        //           textAlign:
                        //               TextAlign.left, // or TextAlign.center
                        //           style: const TextStyle(
                        //             fontFamily: 'segeo',
                        //             fontWeight: FontWeight.w700,
                        //             fontSize: 14,
                        //             height:
                        //                 1.2, // nicer vertical alignment with the icon
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),

                    if (errorText != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        errorText!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontFamily: 'segeo',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],

                    const SizedBox(height: 14),
                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              const Text(
                                "Want to keep this timing for the full week",
                                style: TextStyle(
                                  fontFamily: 'segeo',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: 22,
                                height: 13,
                                child: FittedBox(
                                  fit: BoxFit.fill,
                                  child: Switch(
                                    value: keepForWeek, // <- same variable
                                    onChanged: (v) => setLocal(() {
                                      // <- use setLocal, not setState
                                      keepForWeek = v;
                                    }),
                                    activeColor: Color(0xFF4076ED),
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),
                    const Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Note: ",
                            style: TextStyle(
                              fontFamily: 'segeo',
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.red,
                            ),
                          ),
                          TextSpan(
                            text:
                                "The minimum time is half an hour and the maximum is three hours.",
                            style: TextStyle(
                              fontFamily: 'segeo',
                              fontSize: 12,
                              color: Color(0xFF5F6473),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child:
                          BlocConsumer<
                            MentorAvailabilityCubit,
                            MentorAvailabilityStates
                          >(
                            listener: (context, state) {
                              if (state is MentorAvailabilityLoaded) {
                                _showSuccessDialog();
                                context
                                    .read<AvailableSlotsCubit>()
                                    .getAvailableSlots();
                              } else if (state is MentorAvailabilityFailure) {
                                CustomSnackBar1.show(context, state.error);
                              }
                            },
                            builder: (context, state) {
                              final isLoading =
                                  state is MentorAvailabilityLoading;
                              return CustomAppButton1(
                                text: "Add",
                                isLoading: isLoading,
                                onPlusTap: onAdd,
                              );
                            },
                          ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showSuccessDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Green check
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8F7EF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Color(0xFF22C55E),
                    size: 36,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "New Slot added",
                  style: TextStyle(
                    fontFamily: 'segeo',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF8A4DFF), Color(0xFF2F8BFF)],
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: const Text(
                          "Okay",
                          style: TextStyle(
                            fontFamily: 'segeo',
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // small pill used inside dialog (matches your style)
  Widget _timeFieldPill(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF6C6F7B)),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontFamily: 'segeo',
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _Grouped {
  final DateTime sortKey;
  final String title;
  final String? badge;
  final List<String> chips;
  final int count; // NEW
  _Grouped(this.sortKey, this.title, this.badge, this.chips, this.count);
}
