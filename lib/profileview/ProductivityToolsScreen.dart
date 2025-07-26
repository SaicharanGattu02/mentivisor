import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:table_calendar/table_calendar.dart';

class ProductivityToolsScreen extends StatefulWidget {
  @override
  _ProductivityToolsScreenState createState() =>
      _ProductivityToolsScreenState();
}

class _ProductivityToolsScreenState extends State<ProductivityToolsScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<String>> _tasks = {};
  final TextEditingController _taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    // seed with three example tasks
    _tasks[_selectedDay!] = [
      'Complete 30 minutes Study',
      'Complete 30 minutes Study',
      'Complete 30 minutes Study',
    ];
  }

  List<String> get _todayTasks => _tasks[_selectedDay!] ?? [];

  int get _currentStreak {
    // naive streak: count backward days that have tasks
    int streak = 0;
    DateTime day = _selectedDay!;
    while ((_tasks[day]?.isNotEmpty ?? false)) {
      streak++;
      day = day.subtract(const Duration(days: 1));
    }
    return streak;
  }

  int get _completedTaskCount {
    return _tasks.values.fold(0, (sum, list) => sum + list.length);
  }

  void _addTask() {
    final text = _taskController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _tasks.putIfAbsent(_selectedDay!, () => []);
      _tasks[_selectedDay!]!.add(text);
      _taskController.clear();
    });
  }

  void _deleteTask(int idx) {
    setState(() {
      _tasks[_selectedDay!]!.removeAt(idx);
    });
  }

  void _toggleComplete(int idx) {
    setState(() {
      final list = _tasks[_selectedDay!]!;
      final item = list.removeAt(idx);
      // move completed to top
      list.insert(0, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: const BackButton(color: Colors.black87),
        centerTitle: true,
        title: const Text(
          'Productivity Tools',
          style: TextStyle(color: Color(0xff222222), fontWeight: FontWeight.w600,fontFamily: 'segeo'),
        ),
      ),
      body: Column(
        children: [
          // ── TOP METRIC CARDS ─────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _MetricCard(
                  color: const Color(0xFFFFF0E6),
                  icon: Icons.local_fire_department,
                  iconColor: Colors.orange,
                  label: 'Current Streak',
                  value: _currentStreak.toString().padLeft(2, '0'),
                ),
                _MetricCard(
                  color: const Color(0xFFE6FFF2),
                  icon: Icons.check_circle,
                  iconColor: Colors.green,
                  label: 'Completed Task',
                  value: _completedTaskCount.toString(),
                ),
                _MetricCard(
                  color: const Color(0xFFDCEBF7),
                  icon: Icons.today,
                  iconColor: const Color(0xFF2563EC),
                  label: 'Today Task',
                  value: _todayTasks.length.toString(),
                ),
              ],
            ),
          ),

          // ── CALENDAR ───────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(8),

              ),
            ),
          ),

          // ── TASK LIST ───────────────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      // header + add button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${_selectedDay!.day} ${_monthName(_selectedDay!)} Task',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          ElevatedButton.icon(
                            onPressed: _addTask,
                            icon: const Icon(Icons.add, size: 16),
                            label: const Text('Add Task'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff9333EA),
                              shape: const StadiumBorder(),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // inline input
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _taskController,
                              decoration: InputDecoration(
                                hintText: 'Task Name',
                                filled: true,
                                fillColor: Colors.grey.shade200,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding:
                                const EdgeInsets.symmetric(horizontal: 12),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: _addTask,
                            child: const Text('Add'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // tasks
                      Expanded(
                        child: ListView.separated(
                          itemCount: _todayTasks.length,
                          separatorBuilder: (_, __) =>
                          const SizedBox(height: 8),
                          itemBuilder: (_, idx) {
                            final task = _todayTasks[idx];
                            final done = idx != 0;
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: Colors.grey.shade200),
                              ),
                              child: ListTile(
                                leading: IconButton(
                                  icon: Icon(
                                    done
                                        ? Icons.check_circle
                                        : Icons.circle_outlined,
                                    color: done ? Colors.green : Colors.grey,
                                  ),
                                  onPressed: () => _toggleComplete(idx),
                                ),
                                title: Text(
                                  task,
                                  style: TextStyle(
                                    decoration: done
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  ),
                                ),
                                trailing: IconButton(
                                  icon:
                                  const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteTask(idx),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _monthName(DateTime d) {
    const m = [
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
      'Dec'
    ];
    return m[d.month - 1];
  }
}

class _MetricCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _MetricCard({
    required this.color,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: iconColor, size: 28),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style:
                const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}