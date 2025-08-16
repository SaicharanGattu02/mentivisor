import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mentivisor/Components/CustomSnackBar.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import 'package:mentivisor/Mentee/data/cubits/BookSession/book_session_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/BookSession/book_session_states.dart';
import 'package:mentivisor/Mentee/data/cubits/WeeklySlots/weekly_slots_cubit.dart';
import 'package:mentivisor/utils/AppLogger.dart';
import '../../Components/CustomAppButton.dart';
import '../Models/MentorProfileModel.dart';
import '../data/cubits/SelectSlot/select_slot_cubit.dart';
import '../data/cubits/SelectSlot/select_slot_states.dart';
import '../data/cubits/WeeklySlots/weekly_slots_states.dart';
import 'Widgets/DailySlotsSheet.dart';
import 'Widgets/DayCell.dart';

class BookSessionScreen extends StatefulWidget {
  final MentorData data;
  const BookSessionScreen({Key? key, required this.data}) : super(key: key);
  @override
  _BookSessionScreenState createState() => _BookSessionScreenState();
}

class _BookSessionScreenState extends State<BookSessionScreen> {
  bool showDetails = true;
  String? selectedDate;
  String? selectedTime;
  int? selectedSlotId;      // after picking
  String _weekFilter = 'This Week'; // or 'Next Week'

  @override
  void initState() {
    super.initState();
    AppLogger.info("Data: ${widget.data.user}");
    context.read<WeeklySlotsCubit>().getWeeklySlots(widget.data.id ?? 0);
  }

  void _toggleDetails() {
    setState(() {
      showDetails = !showDetails;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar1(title: "Book Session", actions: []),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFAF5FF), Color(0xFFF5F6FF), Color(0xFFEFF6FF)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    // ── Header: Title + Week Picker ──────────────────────────────────────────
                    Row(
                      children: [
                        // Title dynamically from response month (fallback text shown while loading)
                        BlocBuilder<WeeklySlotsCubit, WeeklySlotsStates>(
                          builder: (context, state) {
                            String heading = 'Available Dates';
                            if (state is WeeklySlotsLoaded) {
                              final days = state.weeklySlotsModel.days ?? [];
                              if (days.isNotEmpty) {
                                heading =
                                    'Available Dates in ${days.first.month ?? ''}';
                              }
                            }
                            return Text(
                              heading,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                        const Spacer(),
                        // Week Switcher (PopupMenu with gradient look)
                        Container(
                          padding: const EdgeInsets.all(2),
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
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xffF5F5F5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: PopupMenuButton<String>(
                              onSelected: (value) {
                                setState(() => _weekFilter = value);
                                final week = value == 'Next Week'
                                    ? 'next'
                                    : 'this';
                                context.read<WeeklySlotsCubit>().getWeeklySlots(
                                  widget.data.id ?? 0,
                                  week: week,
                                );
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
                                          Rect.fromLTWH(
                                            0,
                                            0,
                                            b.width,
                                            b.height,
                                          ),
                                        ),
                                    child: Text(
                                      _weekFilter,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
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
                                          Rect.fromLTWH(
                                            0,
                                            0,
                                            b.width,
                                            b.height,
                                          ),
                                        ),
                                    child: const Icon(Icons.arrow_drop_down),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // ── Week Range (Mon 11 – Sun 17) ─────────────────────────────────────────
                    BlocBuilder<WeeklySlotsCubit, WeeklySlotsStates>(
                      builder: (context, state) {
                        if (state is WeeklySlotsLoaded) {
                          final r = state.weeklySlotsModel.weekRange;
                          if (r?.start != null && r?.end != null) {
                            return Text(
                              '${r!.start} — ${r.end}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6A6A6A),
                              ),
                            );
                          }
                        }
                        return const SizedBox.shrink();
                      },
                    ),

                    const SizedBox(height: 12),

                    // ── Days row (7 cells) ───────────────────────────────────────────────────
                    BlocBuilder<WeeklySlotsCubit, WeeklySlotsStates>(
                      builder: (context, state) {
                        if (state is WeeklySlotsLoading) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        if (state is WeeklySlotsFailure) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              state.error,
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        }

                        if (state is WeeklySlotsLoaded) {
                          final days = state.weeklySlotsModel.days ?? [];
                          if (days.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Text('No days available this week'),
                            );
                          }

                          return LayoutBuilder(
                            builder: (context, c) {
                              final spacing = 8.0;
                              final count = days.length; // generally 7
                              final width =
                                  (c.maxWidth - spacing * (count - 1)) / count;

                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  for (final d in days)
                                    SizedBox(
                                      width: width,
                                      child: DayCell(
                                        dayAbbrev: d.day ?? '',
                                        dayNum: d.dayNum ?? '',
                                        month: d.month ?? '',
                                        slotCount: d.slotCount ?? 0,
                                        selected: selectedDate == d.date,
                                        onTap: () async {
                                          // if ((d.slotCount ?? 0) == 0) return;

                                          setState(() => selectedDate = d.date);

                                          final picked = await showDailySlotsBottomSheet(
                                            context,
                                            mentorId: widget.data.userId ?? 0,
                                            date: d.date!, // ISO date
                                          );

                                          if (picked == null) return;

                                          setState(() {
                                            selectedDate = d.date;
                                            selectedTime = picked.timeLabel;
                                            selectedSlotId = picked.id;
                                          });

                                          // 🔹 Fetch preview (slot + wallet)
                                          context.read<SelectSlotCubit>().getSelectSlot(
                                            widget.data.userId ?? 0,
                                            picked.id ?? 0,
                                          );
                                        },
                                      ),
                                    ),
                                ],
                              );
                            },
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Session Type',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/zoommeetimg.png', // Standardized path
                      height: 36,
                      width: 36,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'G-Meet',
                      style: TextStyle(fontSize: 16, fontFamily: 'Segoe'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Session Topic',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Segoe',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        height: 250,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Describe what you\'d like to discuss in this session...',
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.attach_file,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Add Attachment',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Booking Summary',
                      style: TextStyle(
                        color: Color(0xff333333),
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 16),
                    GestureDetector(
                      onTap: _toggleDetails,
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white.withOpacity(0.4),
                            child: CachedNetworkImage(
                              imageUrl: widget.data.user?.profilePicUrl ?? "",
                              width: 60,
                              height: 60,
                            ), // Standardized path
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.data.user?.name ?? "",
                                style: TextStyle(
                                  color: Color(0xff333333),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                widget.data.user?.designation ?? "",
                                style: TextStyle(
                                  color: Color(0xff666666),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (showDetails) ...[
                      const SizedBox(height: 16),
                      Divider(color: Colors.grey.withOpacity(0.3), thickness: 0.5),
                      const SizedBox(height: 8),

                      BlocBuilder<SelectSlotCubit, SelectSlotsStates>(
                        builder: (context, state) {
                          if (state is SelectSlotLoading) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          if (state is SelectSlotFailure) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Text(state.error, style: const TextStyle(color: Colors.red)),
                            );
                          }

                          if (state is SelectSlotLoaded) {
                            final slot = state.selectSlotModel.slot;
                            final wallet = state.selectSlotModel.wallet;

                            final sessionCoins   = wallet?.sessionCoins ?? 0;   // cost: 480
                            final availableCoins = wallet?.availableCoins ?? 0; // balance before: 0
                            final balanceCoins   = wallet?.balanceCoins ?? 0;   // after: -480
                            final enough         = wallet?.enoughBalance ?? false;

                            Row _row(String label, int coins) => Row(
                              children: [
                                Text(label),
                                const Spacer(),
                                Image.asset('assets/images/GoldCoins.png', width: 16, height: 16),
                                const SizedBox(width: 8),
                                Text(
                                  coins.toString(),
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            );

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _row('Session Cost', sessionCoins),
                                const SizedBox(height: 8),
                                _row('Your Balance', availableCoins),
                                const SizedBox(height: 8),
                                Divider(color: Colors.grey.withOpacity(0.3), thickness: 0.5),
                                const SizedBox(height: 8),
                                _row('Remained', balanceCoins), // can be negative

                                const SizedBox(height: 16),
                                // Slot summary line (nice UX)
                                if (slot != null) ...[
                                  Text(
                                    'Selected: ${slot.date ?? selectedDate ?? ""} • ${slot.timeLabel ?? selectedTime ?? ""}',
                                    style: const TextStyle(fontSize: 12, color: Color(0xFF666666)),
                                  ),
                                  const SizedBox(height: 8),
                                ],
                                const SizedBox(height: 4),
                                if (!enough)
                                  const Text(
                                    'You do not have enough coins to book this session.',
                                    style: TextStyle(fontSize: 12, color: Color(0xFF9A0000)),
                                  ),
                              ],
                            );
                          }

                          // Nothing yet selected
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text('Pick a day and time to see session cost and wallet details.'),
                          );
                        },
                      ),

                      const SizedBox(height: 12),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          child: BlocConsumer<SessionBookingCubit, SessionBookingStates>(
            listener: (context, state) {
              if (state is SessionBookingLoaded) {
                CustomSnackBar1.show(context, state.sessionBookingModel.message ?? "");
              } else if (state is SessionBookingFailure) {
                CustomSnackBar1.show(context, state.error ?? "");
              }
            },
            builder: (context, state) {
              final isLoading = state is SessionBookingLoading;
              return CustomAppButton1(
                text: 'Book Session',
                isLoading: isLoading,
                onPlusTap: () {
                  if (selectedSlotId != null) {
                    context.read<SessionBookingCubit>().sessionBooking(
                      widget.data.userId ?? 0,
                      selectedSlotId!, // slot id
                    );
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }

}
