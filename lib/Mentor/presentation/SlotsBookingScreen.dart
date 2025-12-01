import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mentivisor/Components/CommonLoader.dart';
import 'package:mentivisor/Components/CustomAppButton.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import 'package:mentivisor/Mentee/data/cubits/DeleteSlot/DeleteSlotCubit.dart';
import 'package:mentivisor/Mentee/data/cubits/DeleteSlot/DeleteSlotStates.dart';
import 'package:mentivisor/Mentor/data/Cubits/MentorAvailability/MentorAvailabilitytates.dart';
import 'package:mentivisor/Mentor/presentation/widgets/add_slot_dialog.dart';
import 'package:mentivisor/utils/color_constants.dart';
import '../../Components/CustomSnackBar.dart';
import '../../Components/Shimmers.dart';
import '../../Mentee/data/cubits/ProductTools/TaskByDate/task_by_date_cubit.dart';
import '../../Mentee/data/cubits/ProductTools/TaskByStates/task_by_states_cubit.dart';
import '../../utils/constants.dart';
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

class Slotsbookingscreen extends StatefulWidget {
  const Slotsbookingscreen({super.key});

  @override
  _SlotsbookingscreenState createState() => _SlotsbookingscreenState();
}

class _SlotsbookingscreenState extends State<Slotsbookingscreen> {
  DateTime visibleMonth = DateTime.now();
  DateTime selectedDate = DateTime.now();
  final TextEditingController _taskNameController = TextEditingController();
  TimeOfDay? from;
  TimeOfDay? to;

  bool keepForWeek = true;

  String _weekFilter = 'this_week';

  @override
  void initState() {
    super.initState();
    context.read<AvailableSlotsCubit>().getAvailableSlots(_weekFilter);
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
                                : Colors.grey.withOpacity(
                                    0.5,
                                  ), // make it visually disabled
                          ),
                        ),

                        IconButton(
                          onPressed: nextMonth,
                          icon: const Icon(Icons.chevron_right),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 42,
                      decoration: BoxDecoration(
                        color: kLightLav,
                        borderRadius: BorderRadius.circular(22),
                      ),
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
                        final currentDateOnly = DateTime(
                          now.year,
                          now.month,
                          now.day,
                        );

                        final date = DateTime(
                          visibleMonth.year,
                          visibleMonth.month,
                          day,
                        );
                        final isPast = date.isBefore(currentDateOnly);

                        final isToday =
                            now.day == day &&
                            now.month == visibleMonth.month &&
                            now.year == visibleMonth.year;

                        return GestureDetector(
                          onTap: isPast
                              ? null
                              : () => _onDateSelected(day), // disable tap
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
                      },
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
                  "Slots",
                  style: TextStyle(
                    fontFamily: 'segeo',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                Row(
                  spacing: 5,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(1.5),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xffA258F7),
                            Color(0xff726CF7),
                            Color(0xff4280F6),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xffF5F5F5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: PopupMenuButton<String>(
                          onSelected: (value) {
                            setState(
                              () => _weekFilter = value == 'This Week'
                                  ? 'this_week'
                                  : 'next_week',
                            );
                            context
                                .read<AvailableSlotsCubit>()
                                .getAvailableSlots(
                                  _weekFilter,
                                ); // Send correct server value
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem<String>(
                              value: 'This Week',
                              child: Text('This Week'),
                            ),
                            PopupMenuItem<String>(
                              value: 'Next Week',
                              child: Text('Next Week'),
                            ),
                          ],
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ShaderMask(
                                shaderCallback: (b) =>
                                    const LinearGradient(
                                      colors: [
                                        Color(0xffA258F7),
                                        Color(0xff726CF7),
                                        Color(0xff4280F6),
                                      ],
                                    ).createShader(
                                      Rect.fromLTWH(0, 0, b.width, b.height),
                                    ),
                                child: Text(
                                  _weekFilter == 'this_week'
                                      ? 'This Week'
                                      : 'Next Week', // Display human-readable text
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              ShaderMask(
                                shaderCallback: (b) =>
                                    const LinearGradient(
                                      colors: [
                                        Color(0xffA258F7),
                                        Color(0xff726CF7),
                                        Color(0xff4280F6),
                                      ],
                                    ).createShader(
                                      Rect.fromLTWH(0, 0, b.width, b.height),
                                    ),
                                child: const Icon(Icons.arrow_drop_down),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => _showAddSlotDialog(context),
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 18,
                      ),
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
                          vertical: 5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            BlocBuilder<AvailableSlotsCubit, AvailableSlotsStates>(
              builder: (context, state) {
                if (state is AvailableSlotsLoading) {
                  return const AvailableSlotsShimmer();
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
                  final recentSlots = state.availableSlotsModel.recentSlots;

                  if (recentSlots == null ||
                      recentSlots.days?.isEmpty == true) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        "No recent slots found",
                        style: TextStyle(fontFamily: 'segeo'),
                      ),
                    );
                  }

                  return Column(
                    children: [
                      // Show week range and unique slots
                      _weekSlotsWidget(
                        recentSlots.range,
                        recentSlots.uniqueTimeSlots,
                      ),
                      const SizedBox(height: 20),
                      // Loop through the days and show slots
                      for (final day in recentSlots.days!) ...[
                        _recentGroupCard(
                          title: day.date ?? '',
                          slots: day.slots ?? [],
                          count: day.slots?.length??0,// ← Send the slot objects directly
                          statusCounts: day.statusCounts,
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

  // Widget to show week-wide slots
  Widget _weekSlotsWidget(
    String? range,
    List<UniqueTimeSlot>? uniqueTimeSlots,
  ) {
    return Container(
      padding: EdgeInsets.all(12),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (range != null) ...[
            Text(
              "$range",
              style: const TextStyle(
                fontFamily: 'segeo',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
          ],
          Text(
            "Available Weekly Slots: ${uniqueTimeSlots?.length}",
            style: const TextStyle(
              fontFamily: 'segeo',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF7C8596),
            ),
          ),
          const SizedBox(height: 10),
          // Show unique time slots for the week
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children:
                uniqueTimeSlots?.map((slot) {
                  bool isBooked = slot.status?.toLowerCase() == 'booked';
                  return _slotChip(slot.time!, isBooked);
                }).toList() ??
                [],
          ),
        ],
      ),
    );
  }

  Widget _recentGroupCard({
    required String title,
    required List<TimeSlot> slots,
    required int count,
    required StatusCounts? statusCounts,
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
            // Title Row
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
              ],
            ),

            const SizedBox(height: 8),

            // ⭐ Slot Count (RESTORED)
            Text(
              countLabel,
              style: const TextStyle(
                fontFamily: 'segeo',
                fontSize: 13,
                color: Color(0xFF7C8596),
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 10),

            // Slot Pills
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: slots.map((slot) {
                bool isBooked = (slot.status?.toLowerCase() == "booked");
                return _slotItem(
                  timeSlot: slot,
                  isBooked: isBooked,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }


  Widget _slotItem({required TimeSlot timeSlot, required bool isBooked}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isBooked ? Colors.grey.shade200 : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isBooked ? Colors.grey.shade300 : Colors.blue.shade200,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            timeSlot.time ?? "",
            style: TextStyle(
              color: isBooked ? Colors.grey : Colors.black,
              fontSize: 14,
              fontFamily: 'segeo',
            ),
          ),

          const SizedBox(width: 6),

          // ❌ Hide delete icon if booked
          if (!isBooked)
            GestureDetector(
              onTap: () {
                showDeleteConfirmationDialog(
                  context,
                      () {
                    context.read<DeleteSlotCubit>().deleteSlot(timeSlot.id.toString());
                  },
                );
              },
              child: Icon(
                Icons.cancel,
                size: 18,
                color: primarycolor,
              ),
            ),
        ],
      ),
    );
  }


  Future<void> showDeleteConfirmationDialog(
      BuildContext context,
      VoidCallback onConfirm,
      ) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return BlocConsumer<DeleteSlotCubit, DeleteSlotStates>(
          listener: (context, state) {
            if (state is DeleteSlotLoaded) {
              Navigator.pop(context); // close dialog
              context.read<AvailableSlotsCubit>().getAvailableSlots(_weekFilter);
            }
            if (state is DeleteSlotFailure) {
              Navigator.pop(context);
              CustomSnackBar1.show(context, state.error);
            }
          },
          builder: (context, state) {
            final isLoading = state is DeleteSlotLoading;
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.red, size: 30),
                  const SizedBox(width: 8),
                  const Text("Delete Slot"),
                ],
              ),
              content: const Text(
                "Are you sure you want to delete this Slot? This action cannot be undone.",
              ),
              actions: [
                TextButton(
                  onPressed: isLoading ? null : () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: isLoading ? null : onConfirm,
                  child: isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Text("Delete"),
                ),
              ],
            );
          },
        );
      },
    );
  }


  Widget _slotChip(String slotTime, bool isBooked) {
    return Opacity(
      opacity: isBooked ? 0.5 : 1.0, // Reduce opacity if booked
      child: Chip(
        label: Text(slotTime),
        side: BorderSide(
          color: isBooked ? Colors.grey.shade300 : Colors.blue.shade100,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(36),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        backgroundColor: isBooked ? Colors.grey.shade300 : Colors.blue.shade100,
      ),
    );
  }

  String _rangeTime(String startTime) {
    return "$startTime";
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


  Future<void> _showAddSlotDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => AddSlotDialog(selectedDate: selectedDate),
    );
  }

}


class AvailableSlotsShimmer extends StatelessWidget {
  const AvailableSlotsShimmer({super.key});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Week Range Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                shimmerText(160, 16, context), // Week range title
                const SizedBox(height: 8),
                Row(
                  children: [
                    shimmerText(100, 12, context),
                    const SizedBox(width: 8),
                    shimmerText(80, 12, context),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    shimmerContainer(80, 24, context),
                    const SizedBox(width: 6),
                    shimmerContainer(80, 24, context),
                    const SizedBox(width: 6),
                    shimmerContainer(80, 24, context),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 🔹 Simulated "Recent Days" slot groups
          for (int i = 0; i < 3; i++) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  shimmerText(140, 16, context), // Day title
                  const SizedBox(height: 10),

                  // Slot chips shimmer
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(
                      4,
                      (index) => shimmerContainer(80, 28, context),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Count/status shimmer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      shimmerText(100, 12, context),
                      shimmerText(80, 12, context),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}
