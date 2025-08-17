// slots_booking_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SlotsBookingScreen extends StatefulWidget {
  const SlotsBookingScreen({Key? key}) : super(key: key);

  @override
  State<SlotsBookingScreen> createState() => _SlotsBookingScreenState();
}

class _SlotsBookingScreenState extends State<SlotsBookingScreen> {
  DateTime visibleMonth = DateTime.now();
  DateTime selectedDate = DateTime.now();

  // sample recent added groups (replace with your real data)
  final List<Map<String, dynamic>> recentAdded = [
    {
      'title': '15 Jun - 21 Jun 25',
      'subtitle': '1 week',
      'slots': ['9:00 - 10:00', '9:00 - 10:00', '9:00 - 10:00', '9:00 - 10:00', '9:00 - 10:00', '9:00 - 10:00'],
    },
    {
      'title': '16 Jun 25',
      'subtitle': '6 slots',
      'slots': ['9:00 - 10:00', '9:00 - 10:00', '9:00 - 10:00', '9:00 - 10:00'],
    },
    {
      'title': '15 Jun 25',
      'subtitle': '6 slots',
      'slots': ['9:00 - 10:00', '9:00 - 10:00', '9:00 - 10:00'],
    },
  ];

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
    final startOffset = (firstDay.weekday) % 7; // 0..6 with Sunday = 0
    final List<int?> list = [];
    for (int i = 0; i < startOffset; i++) list.add(null);
    for (int d = 1; d <= lastDay.day; d++) list.add(d);
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final gridDays = makeMonthGrid(visibleMonth);
    final monthTitle = DateFormat('MMM yyyy').format(visibleMonth);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F6FD),
      appBar: AppBar(
        title: const Text('Availability', style: TextStyle(fontFamily: 'segeo')),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        foregroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // --- top calendar card ---
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 12)],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // month header
                    Row(
                      children: [
                        Text('Jun 2025', style: TextStyle(fontWeight: FontWeight.w700)),
                        const Spacer(),
                        IconButton(onPressed: prevMonth, icon: const Icon(Icons.chevron_left)),
                        IconButton(onPressed: nextMonth, icon: const Icon(Icons.chevron_right)),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // small pill with weekday names
                    Container(
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1E9FF),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: ['Su','Mo','Tu','We','Th','Fr','Sa']
                            .map((d) => Expanded(
                          child: Center(child: Text(d, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
                        )).toList(),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // calendar grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: gridDays.length,
                      itemBuilder: (context, index) {
                        final day = gridDays[index];
                        if (day == null) return const SizedBox();
                        final isSelected = selectedDate.day == day && selectedDate.month == visibleMonth.month && selectedDate.year == visibleMonth.year;
                        final isToday = DateTime.now().day == day && DateTime.now().month == visibleMonth.month && DateTime.now().year == visibleMonth.year;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedDate = DateTime(visibleMonth.year, visibleMonth.month, day);
                              // TODO: trigger your cubit fetch for selectedDate here
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFF9333EA).withOpacity(0.08) : (isToday ? const Color(0xFFE8F0FF) : Colors.white),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected ? const Color(0xFF9333EA) : (isToday ? const Color(0xFF9333EA).withOpacity(0.25) : const Color(0xFFDDDDDD)),
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(day.toString(), style: const TextStyle(fontSize: 12)),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            // --- selected date + add slot row ---
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // date row + Add Slot button
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          DateFormat('d MMM yy').format(selectedDate),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          // TODO: show Add Slot flow (bottom sheet)
                        },
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('+ Add Slot'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF9333EA),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // time range + coin pill + delete icon (sample)
                  Row(
                    children: [
                      // time chips
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('09:00', style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(width: 8),
                      const Text('to'),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('10:00', style: TextStyle(fontWeight: FontWeight.w600)),
                      ),

                      const SizedBox(width: 12),

                      // coin pill
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF6CF),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE6D7A6)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.monetization_on, size: 16, color: Color(0xFFFFA800)),
                            SizedBox(width: 6),
                            Text('50', style: TextStyle(fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),

                      const Spacer(),

                      // trash icon placeholder
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.delete_outline, color: Color(0xFFFF4D4D)),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // weekly toggle sample
                  Row(
                    children: [
                      const Text('Mark timing for the full week'),
                      const SizedBox(width: 8),
                      Switch(value: true, onChanged: (v) {}),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // --- Recent Added header ---
            Row(
              children: const [
                Text('Recent Added', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                Spacer(),
              ],
            ),

            const SizedBox(height: 8),

            // --- recent added list: blue bordered container with several cards ---
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF2F8BFF), width: 2), // blue border
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                children: recentAdded.map((group) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7FBFF),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6)],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.calendar_today_outlined, size: 16, color: const Color(0xFF333333)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(group['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.w700)),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEEF5FF),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(group['subtitle'] ?? '', style: const TextStyle(fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // tag pills
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: (group['slots'] as List<String>).map((s) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: const Color(0xFFDDDDDD)),
                              ),
                              child: Text(s, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
