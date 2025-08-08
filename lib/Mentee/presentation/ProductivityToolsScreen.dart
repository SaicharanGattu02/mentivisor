import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import '../data/cubits/ProductTools/TaskByDate/task_by_date_cubit.dart';
import '../data/cubits/ProductTools/TaskByStates/task_by_states_cubit.dart';
import '../data/cubits/ProductTools/TaskByStates/task_by_states_states.dart';
import 'package:intl/intl.dart';

class ProductivityScreen extends StatefulWidget {
  ProductivityScreen({super.key});
  @override
  _ProductivityScreenState createState() => _ProductivityScreenState();
}
class _ProductivityScreenState extends State<ProductivityScreen> {
  final ValueNotifier<DateTime> _selectedDateNotifier =
  ValueNotifier(DateTime.now());
  final ValueNotifier<List<int?>> _dayListNotifier = ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    context.read<TaskByDateCubit>().fetchTasksByDate("");
    context.read<TaskByStatusCubit>().fetchTasksByStatus();
    _generateDayList(_selectedDateNotifier.value.year,
        _selectedDateNotifier.value.month);
  }

  void _generateDayList(int year, int month) {
    final List<int?> days = [];
    final firstDayOfMonth = DateTime(year, month, 1);
    final lastDayOfMonth = DateTime(year, month + 1, 0);
    final firstDayWeekday = firstDayOfMonth.weekday % 7;

    for (int i = 0; i < firstDayWeekday; i++) {
      days.add(null);
    }
    for (int i = 1; i <= lastDayOfMonth.day; i++) {
      days.add(i);
    }
    _dayListNotifier.value = days;
  }

  void _changeMonth(int delta) {
    final current = _selectedDateNotifier.value;
    final newDate = DateTime(current.year, current.month + delta, 1);
    _selectedDateNotifier.value = newDate;
    _generateDayList(newDate.year, newDate.month);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar1(title: 'Productivity Tools', actions: []),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFAF5FF), Color(0xFFF5F6FF), Color(0xFFEFF6FF)],
            stops: [0.0, 0.5, 1.0],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              _buildStatsSection(),
              SizedBox(height: 20),
              _buildCalendar(),
              SizedBox(height: 24),
              _buildTaskSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    return BlocBuilder<TaskByStatusCubit, TaskByStatusStates>(
      builder: (context, state) {
        if (state is TaskByStatusLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TaskByStatusLoaded) {
          return Row(
            spacing: 20,
            children: [
              Expanded(
                child: _buildStatCard('Current Streak',
                    state.taskStatesModel.currentStreak.toString(), Colors.orange[100]!),
              ),
              Expanded(
                child: _buildStatCard('Completed Task',
                    state.taskStatesModel.completedTask.toString(), Colors.green[100]!),
              ),
              Expanded(
                child: _buildStatCard('Today Task',
                    state.taskStatesModel.todayTask.toString(), Colors.blue[100]!),
              ),
            ],
          );
        } else if (state is TaskByStatusFailure) {
          return Center(child: Text(state.msg ?? ""));
        }
        return Center(child: Text("No Data"));
      },
    );
  }

  Widget _buildCalendar() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          ValueListenableBuilder<DateTime>(
            valueListenable: _selectedDateNotifier,
            builder: (_, date, __) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, color: Color(0xFF666666)),
                    onPressed: () => _changeMonth(-1),
                  ),
                  Text(
                    DateFormat('MMMM yyyy').format(date),
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF333333)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right, color: Color(0xFF666666)),
                    onPressed: () => _changeMonth(1),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 12),
          Row(
            children: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa']
                .map((d) => Expanded(
              child: Center(
                child: Text(
                  d,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
            ))
                .toList(),
          ),
          const Divider(color: Color(0xFFDDDDDD), height: 1),
          ValueListenableBuilder<List<int?>>(
            valueListenable: _dayListNotifier,
            builder: (_, days, __) {
              final currentDate = _selectedDateNotifier.value;
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7, mainAxisSpacing: 8, crossAxisSpacing: 8),
                itemCount: days.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (_, index) {
                  final day = days[index];
                  if (day == null) return const SizedBox();

                  final isSelected = currentDate.day == day &&
                      currentDate.month == currentDate.month &&
                      currentDate.year == currentDate.year;
                  final isToday = day == DateTime.now().day &&
                      currentDate.month == DateTime.now().month &&
                      currentDate.year == DateTime.now().year;

                  return GestureDetector(
                    onTap: () {
                      _selectedDateNotifier.value =
                          DateTime(currentDate.year, currentDate.month, day);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Color(0xFF9333EA).withOpacity(0.1)
                            : isToday
                            ? Color(0xFFE8F0FF)
                            : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? Color(0xFF9333EA)
                              : isToday
                              ? Color(0xFF9333EA).withOpacity(0.3)
                              : Color(0xFFDDDDDD),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text('$day'),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTaskSection() {
    return ValueListenableBuilder<DateTime>(
      valueListenable: _selectedDateNotifier,
      builder: (_, date, __) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${DateFormat('d MMM').format(date)} Tasks',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Color(0xff9333EA)),
                    onPressed: () {},
                    child: Row(
                      children: [Icon(Icons.add, color: Colors.white), Text("Add Task")],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              ...['Complete 30 minutes Study', 'Read 10 pages of a book'].map(
                    (task) => _buildTaskItem(task, false),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Icon(Icons.task, color: Colors.blue),
          SizedBox(height: 8),
          Text(title, style: TextStyle(fontSize: 14)),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildTaskItem(String title, bool isCompleted) {
    return Row(
      children: [
        Icon(isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isCompleted ? Colors.green : Colors.red),
        SizedBox(width: 8),
        Expanded(child: Text(title)),
        Icon(Icons.delete, color: Colors.red),
      ],
    );
  }
}
