import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Components/CustomAppButton.dart';
import '../../../Components/CustomSnackBar.dart';
import '../../data/Cubits/AvailabilitySlots/AvailabilitySlotsCubit.dart';
import '../../data/Cubits/MentorAvailability/MentorAvailabilityCubit.dart';
import '../../data/Cubits/MentorAvailability/MentorAvailabilitytates.dart';


class AddSlotDialog extends StatefulWidget {
  final DateTime selectedDate;

  const AddSlotDialog({super.key, required this.selectedDate});

  @override
  State<AddSlotDialog> createState() => _AddSlotDialogState();
}

class _AddSlotDialogState extends State<AddSlotDialog> {
  late TimeOfDay from;
  late TimeOfDay to;
  bool keepForWeek = true;
  String? errorText;
  final ValueNotifier<int> totalSessionCoinsNotifier = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    _setDefaultTimes();
    _updateCoinCost();
  }

  void _setDefaultTimes() {
    final now = TimeOfDay.now();
    from = TimeOfDay(hour: now.hour, minute: 0);
    int endHour = (now.hour + 1) % 24;
    to = TimeOfDay(hour: endHour, minute: 0);
  }

  Future<void> _updateCoinCost() async {
    final fromMinutes = from.hour * 60 + from.minute;
    final toMinutes = to.hour * 60 + to.minute;
    int difference = toMinutes - fromMinutes;
    if (difference < 0) difference += 24 * 60;

    // Replace with your app coin logic
    const coinsPerMinute = 2;
    totalSessionCoinsNotifier.value = difference * coinsPerMinute;
  }

  Future<void> _pickTime(BuildContext context, bool isFrom) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isFrom ? from : to,
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          from = picked;
        } else {
          to = picked;
        }
        _updateCoinCost();
      });
    }
  }

  void _onAdd() async {
    final fromDate = DateTime(widget.selectedDate.year, widget.selectedDate.month,
        widget.selectedDate.day, from.hour, from.minute);
    final toDate = DateTime(widget.selectedDate.year, widget.selectedDate.month,
        widget.selectedDate.day, to.hour, to.minute);
    final diff = toDate.difference(fromDate).inMinutes;

    if (diff <= 0) {
      setState(() => errorText = "End time must be after start time.");
      return;
    }
    if (diff < 30) {
      setState(() => errorText = "Minimum slot is 30 minutes.");
      return;
    }
    if (diff > 180) {
      setState(() => errorText = "Maximum slot is 3 hours.");
      return;
    }

    final mapData = {
      "date": DateFormat("yyyy-MM-dd").format(widget.selectedDate),
      "start_time": "${from.hour.toString().padLeft(2, '0')}:${from.minute.toString().padLeft(2, '0')}",
      "end_time": "${to.hour.toString().padLeft(2, '0')}:${to.minute.toString().padLeft(2, '0')}",
      "repeat_weekly": keepForWeek ? "1" : "0",
      "coins": totalSessionCoinsNotifier.value.toString(),
    };

    context.read<MentorAvailabilityCubit>().addMentorAvailability(mapData);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
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
              DateFormat('d MMM yy').format(widget.selectedDate),
              style: const TextStyle(
                fontFamily: 'segeo',
                fontSize: 12,
                color: Color(0xFF7C8596),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            // Time Pickers
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _pickTime(context, true),
                    child: _timeField(Icons.schedule, _formatTime(from)),
                  ),
                ),
                const SizedBox(width: 12),
                const Text("to",
                    style: TextStyle(
                        fontFamily: 'segeo',
                        fontWeight: FontWeight.w600,
                        color: Color(0xff666666))),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _pickTime(context, false),
                    child: _timeField(Icons.access_time_filled_rounded, _formatTime(to)),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  height: 40,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xffFFEACE),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    spacing: 4,
                    children: [
                      Image.asset(
                        "assets/images/GoldCoins.png",
                        height: 24,
                        width: 24,
                        color: const Color(0xffFFCC00),
                      ),
                      ValueListenableBuilder<int>(
                        valueListenable: totalSessionCoinsNotifier,
                        builder: (_, totalCoins, __) => Text(
                          "$totalCoins",
                          style: const TextStyle(
                            fontFamily: 'segeo',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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

            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Text(
                        "Keep this timing for full week",
                        style: TextStyle(
                            fontFamily: 'segeo',
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 8),

                      SizedBox(
                        height: 20,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Switch(
                            value: keepForWeek,
                            onChanged: (v) => setState(() => keepForWeek = v),
                            activeColor: const Color(0xFF4076ED),
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

            const SizedBox(height: 10),
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
                    text: "The minimum slot is 30 minutes and maximum is 3 hours.",
                    style: TextStyle(
                      fontFamily: 'segeo',
                      fontSize: 12,
                      color: Color(0xFF5F6473),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            BlocConsumer<MentorAvailabilityCubit, MentorAvailabilityStates>(
              listener: (context, state) {
                if (state is MentorAvailabilityLoaded) {
                  Navigator.pop(context);
                  context.read<AvailableSlotsCubit>().getAvailableSlots("this_week");
                  CustomSnackBar1.show(context, "Slot added successfully!");
                } else if (state is MentorAvailabilityFailure) {
                  CustomSnackBar1.show(context, state.error);
                }
              },
              builder: (context, state) {
                final isLoading = state is MentorAvailabilityLoading;
                return CustomAppButton1(
                  text: "Add",
                  isLoading: isLoading,
                  onPlusTap: _onAdd,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(TimeOfDay t) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, t.hour, t.minute);
    return DateFormat('hh:mm a').format(dt);
  }

  Widget _timeField(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xffF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xff9333EA), size: 18),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontFamily: 'segeo',
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    totalSessionCoinsNotifier.dispose();
    super.dispose();
  }
}
