import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CustomAppButton.dart';
import 'package:mentivisor/Components/CustomSnackBar.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import '../data/cubits/ProductTools/TaskByDate/task_by_date_cubit.dart';
import '../data/cubits/ProductTools/TaskByDate/task_by_date_states.dart';
import '../data/cubits/ProductTools/TaskByStates/task_by_states_cubit.dart';
import '../data/cubits/ProductTools/TaskByStates/task_by_states_states.dart';
import 'package:intl/intl.dart';

import '../data/cubits/ProductTools/TaskUpdate/task_update_cubit.dart';
import '../data/cubits/ProductTools/TaskUpdate/task_update_states.dart';

class ProductivityScreen extends StatefulWidget {
  ProductivityScreen({super.key});
  @override
  _ProductivityScreenState createState() => _ProductivityScreenState();
}

class _ProductivityScreenState extends State<ProductivityScreen> {
  final ValueNotifier<DateTime> _selectedDateNotifier = ValueNotifier(
    DateTime.now(),
  );
  final ValueNotifier<List<int?>> _dayListNotifier = ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    final formattedDate = DateFormat(
      'yyyy-MM-dd',
    ).format(_selectedDateNotifier.value);

    context.read<TaskByDateCubit>().fetchTasksByDate(formattedDate);
    context.read<TaskByStatusCubit>().fetchTasksByStatus();
    _generateDayList(
      _selectedDateNotifier.value.year,
      _selectedDateNotifier.value.month,
    );
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

  final TextEditingController _taskNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar1(
        title: 'Productivity Tools',
        actions: [],
        color: Color(0xFFEFF6FF),
      ),
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
              BlocBuilder<TaskByStatusCubit, TaskByStatusStates>(
                builder: (context, state) {
                  if (state is TaskByStatusLoaded) {
                    return Row(
                      spacing: 20,
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Current Streak',
                            state.taskStatesModel.currentStreak.toString() ??
                                "0",
                            Colors.orange[100]!,
                          ),
                        ),
                        Expanded(
                          child: _buildStatCard(
                            'Completed Task',
                            state.taskStatesModel.completedTask.toString() ??
                                "0",
                            Colors.green[100]!,
                          ),
                        ),
                        Expanded(
                          child: _buildStatCard(
                            'Today Task',
                            state.taskStatesModel.todayTask.toString() ?? "0",
                            Colors.blue[100]!,
                          ),
                        ),
                      ],
                    );
                  } else if (state is TaskByStatusFailure) {
                    return Center(child: Text(state.msg ?? ""));
                  }
                  return Center(child: Text("No Data"));
                },
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
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
                              icon: const Icon(
                                Icons.chevron_left,
                                color: Color(0xFF666666),
                              ),
                              onPressed: () => _changeMonth(-1),
                            ),
                            Text(
                              DateFormat('MMMM yyyy').format(date),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF333333),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.chevron_right,
                                color: Color(0xFF666666),
                              ),
                              onPressed: () => _changeMonth(1),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa']
                          .map(
                            (d) => Expanded(
                              child: Center(
                                child: Text(
                                  d,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(color: Color(0xFFDDDDDD), height: 1),
                    ),
                    ValueListenableBuilder<DateTime>(
                      valueListenable: _selectedDateNotifier,
                      builder: (_, selectedDate, __) {
                        return ValueListenableBuilder<List<int?>>(
                          valueListenable: _dayListNotifier,
                          builder: (_, days, __) {
                            return GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 7,
                                    mainAxisSpacing: 8,
                                    crossAxisSpacing: 8,
                                  ),
                              itemCount: days.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (_, index) {
                                final day = days[index];
                                if (day == null) return const SizedBox();

                                final isSelected =
                                    selectedDate.day == day &&
                                    selectedDate.month == selectedDate.month &&
                                    selectedDate.year == selectedDate.year;

                                final isToday =
                                    day == DateTime.now().day &&
                                    selectedDate.month ==
                                        DateTime.now().month &&
                                    selectedDate.year == DateTime.now().year;

                                return GestureDetector(
                                  onTap: () {
                                    _selectedDateNotifier.value = DateTime(
                                      selectedDate.year,
                                      selectedDate.month,
                                      day,
                                    );

                                    final formattedDate = DateFormat(
                                      'yyyy-MM-dd',
                                    ).format(_selectedDateNotifier.value);
                                    context
                                        .read<TaskByDateCubit>()
                                        .fetchTasksByDate(formattedDate);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? const Color(
                                              0xFF9333EA,
                                            ).withOpacity(0.1)
                                          : isToday
                                          ? const Color(0xFFE8F0FF)
                                          : Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected
                                            ? const Color(0xFF9333EA)
                                            : isToday
                                            ? const Color(
                                                0xFF9333EA,
                                              ).withOpacity(0.3)
                                            : const Color(0xFFDDDDDD),
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
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Color(0xffCCCCCC), width: 1),
                ),
                child: ValueListenableBuilder<DateTime>(
                  valueListenable: _selectedDateNotifier,
                  builder: (_, date, __) {
                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${DateFormat('d MMM').format(date)} Tasks',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  backgroundColor: const Color(0xff9333EA),
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                ),
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.white,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(16),
                                      ),
                                    ),
                                    builder: (context) {
                                      return SafeArea(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom, // Handle keyboard
                                            left: 16,
                                            right: 16,
                                            top: 16,
                                          ),
                                          child: Column(
                                            mainAxisSize:
                                                MainAxisSize.min, // Fit content
                                            children: [
                                              // Text field for task description
                                              _buildTextField(
                                                controller: _taskNameController,
                                                hint: "Enter Task Name",
                                              ),
                                              const SizedBox(height: 16),
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: CustomOutlinedButton(
                                                      radius: 24,
                                                      text: "Cancel",
                                                      onTap: () {
                                                        context.pop();
                                                      },
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ), // Spacing between buttons
                                                  Expanded(
                                                    child:
                                                        BlocConsumer<
                                                          TaskUpdateCubit,
                                                          TaskUpdateStates
                                                        >(
                                                          listener: (context, state) async {
                                                            if (state
                                                                is TaskUpdateSuccess) {
                                                              final formattedDate =
                                                                  DateFormat(
                                                                    'yyyy-MM-dd',
                                                                  ).format(
                                                                    _selectedDateNotifier
                                                                        .value,
                                                                  );
                                                              await context
                                                                  .read<
                                                                    TaskByDateCubit
                                                                  >()
                                                                  .fetchTasksByDate(
                                                                    formattedDate,
                                                                  );
                                                              context.pop();
                                                            } else if (state
                                                                is TaskUpdateFailure) {
                                                              CustomSnackBar1.show(
                                                                context,
                                                                state.msg,
                                                              );
                                                            }
                                                          },
                                                          builder: (context, state) {
                                                            return ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                padding:
                                                                    const EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          20,
                                                                      vertical:
                                                                          12,
                                                                    ),
                                                                backgroundColor:
                                                                    const Color(
                                                                      0xff9333EA,
                                                                    ),
                                                                shadowColor: Colors
                                                                    .transparent,
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        24,
                                                                      ),
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                final formattedDate =
                                                                    DateFormat(
                                                                      'yyyy-MM-dd',
                                                                    ).format(
                                                                      _selectedDateNotifier
                                                                          .value,
                                                                    );
                                                                final Map<
                                                                  String,
                                                                  dynamic
                                                                >
                                                                data = {
                                                                  "task_date":
                                                                      formattedDate,
                                                                  "title":
                                                                      _taskNameController
                                                                          .text,
                                                                };
                                                                context
                                                                    .read<
                                                                      TaskUpdateCubit
                                                                    >()
                                                                    .addTask(
                                                                      data,
                                                                    );
                                                              },
                                                              child:
                                                                  state
                                                                      is TaskUpdateLoading
                                                                  ? const SizedBox(
                                                                      width: 20,
                                                                      height:
                                                                          20,
                                                                      child: CircularProgressIndicator(
                                                                        color: Color(
                                                                          0xffF5F5F5,
                                                                        ),
                                                                        strokeWidth:
                                                                            2,
                                                                      ),
                                                                    )
                                                                  : Text(
                                                                      "Submit",
                                                                      style: TextStyle(
                                                                        color: Color(
                                                                          0xffF5F5F5,
                                                                        ),
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        fontSize:
                                                                            14,
                                                                        fontFamily:
                                                                            "segeo",
                                                                      ),
                                                                    ),
                                                            );
                                                          },
                                                        ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 16,
                                              ), // Bottom padding
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ).whenComplete(() {
                                    _taskNameController.clear();
                                  });
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.add,
                                      color: Color(0xffF5F5F5),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      "Add Task",
                                      style: TextStyle(
                                        color: Color(0xffF5F5F5),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        fontFamily: "segeo",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          BlocBuilder<TaskByDateCubit, TaskBydateStates>(
                            builder: (context, taskState) {
                              if (taskState is TaskBydateLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (taskState is TaskBydateLoaded) {
                                final tasks =
                                    taskState
                                        .productToolTaskByDateModel
                                        .tasks ??
                                    [];

                                if (tasks.isEmpty) {
                                  return const Center(
                                    child: Text(
                                      'No tasks available',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'segeo',
                                        color: Color(0xff666666),
                                      ),
                                    ),
                                  );
                                }

                                return SizedBox(
                                  height: 300,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: tasks.length,
                                    itemBuilder: (context, index) {
                                      final task = tasks[index];
                                      return Container(
                                        margin: EdgeInsets.symmetric(
                                          vertical: 6,
                                        ),
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                task.isCompleted == 1
                                                    ? Icons.check_circle
                                                    : Icons
                                                          .radio_button_unchecked,
                                                color: task.isCompleted == 1
                                                    ? Colors.green
                                                    : const Color(0xff666666),
                                              ),
                                              onPressed: task.isCompleted == 1
                                                  ? null
                                                  : () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) => AlertDialog(
                                                          title: Text(
                                                            'Mark Task Completed',
                                                          ),
                                                          content: Text(
                                                            'Are you sure you want to mark "${task.title}" as completed?',
                                                          ),
                                                          actions: [
                                                            Row(
                                                              spacing: 10,
                                                              children: [
                                                                Expanded(
                                                                  child: CustomOutlinedButton(
                                                                    text:
                                                                        "Cancel",
                                                                    onTap: () {
                                                                      context
                                                                          .pop();
                                                                    },
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      BlocConsumer<
                                                                        TaskUpdateCubit,
                                                                        TaskUpdateStates
                                                                      >(
                                                                        listener:
                                                                            (
                                                                              context,
                                                                              state,
                                                                            ) async {
                                                                              if (state
                                                                                  is TaskUpdateSuccess) {
                                                                                final formattedDate =
                                                                                    DateFormat(
                                                                                      'yyyy-MM-dd',
                                                                                    ).format(
                                                                                      _selectedDateNotifier.value,
                                                                                    );

                                                                                await context
                                                                                    .read<
                                                                                      TaskByDateCubit
                                                                                    >()
                                                                                    .fetchTasksByDate(
                                                                                      formattedDate,
                                                                                    ); // pass date
                                                                                context.pop();
                                                                              } else if (state
                                                                                  is TaskUpdateFailure) {
                                                                                CustomSnackBar1.show(
                                                                                  context,
                                                                                  state.msg,
                                                                                );
                                                                              }
                                                                            },

                                                                        builder:
                                                                            (
                                                                              context,
                                                                              state,
                                                                            ) {
                                                                              return CustomAppButton1(
                                                                                isLoading:
                                                                                    state
                                                                                        is TaskUpdateLoading,
                                                                                text: "Done",
                                                                                onPlusTap: () {
                                                                                  context
                                                                                      .read<
                                                                                        TaskUpdateCubit
                                                                                      >()
                                                                                      .updateTaskStatus(
                                                                                        task.id ??
                                                                                            0,
                                                                                      );
                                                                                },
                                                                              );
                                                                            },
                                                                      ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                            ),

                                            SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                task.title ?? 'Untitled Task',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'segeo',
                                                  fontWeight: FontWeight.w400,
                                                  decoration:
                                                      task.isCompleted == 1
                                                      ? TextDecoration
                                                            .lineThrough
                                                      : TextDecoration.none,
                                                  color: const Color(
                                                    0xff666666,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            IconButton.outlined(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) => AlertDialog(
                                                    title: const Text(
                                                      'Delete Task',
                                                    ),
                                                    content: Text(
                                                      'Are you sure you want to delete "${task.title}"?',
                                                    ),
                                                    actions: [
                                                      Row(
                                                        spacing: 10,
                                                        children: [
                                                          Expanded(
                                                            child:
                                                                CustomOutlinedButton(
                                                                  text:
                                                                      "Cancel",
                                                                  onTap: () {
                                                                    context
                                                                        .pop();
                                                                  },
                                                                ),
                                                          ),
                                                          Expanded(
                                                            child:
                                                                BlocConsumer<
                                                                  TaskUpdateCubit,
                                                                  TaskUpdateStates
                                                                >(
                                                                  listener:
                                                                      (
                                                                        context,
                                                                        taskDelete,
                                                                      ) async {
                                                                        if (taskDelete
                                                                            is TaskUpdateSuccess) {
                                                                          final formattedDate =
                                                                              DateFormat(
                                                                                'yyyy-MM-dd',
                                                                              ).format(
                                                                                _selectedDateNotifier.value,
                                                                              );

                                                                          await context
                                                                              .read<
                                                                                TaskByDateCubit
                                                                              >()
                                                                              .fetchTasksByDate(
                                                                                formattedDate,
                                                                              ); // pass
                                                                          context
                                                                              .pop();
                                                                        } else if (taskDelete
                                                                            is TaskUpdateFailure) {
                                                                          CustomSnackBar1.show(
                                                                            context,
                                                                            "${taskDelete.msg}",
                                                                          );
                                                                        }
                                                                      },
                                                                  builder:
                                                                      (
                                                                        context,
                                                                        taskDelete,
                                                                      ) {
                                                                        return CustomAppButton1(
                                                                          isLoading:
                                                                              taskDelete
                                                                                  is TaskUpdateLoading,
                                                                          text:
                                                                              "Done",
                                                                          onPlusTap: () {
                                                                            context
                                                                                .read<
                                                                                  TaskUpdateCubit
                                                                                >()
                                                                                .deleteTask(
                                                                                  task.id ??
                                                                                      0,
                                                                                );
                                                                          },
                                                                        );
                                                                      },
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                              icon: const Icon(
                                                Icons.delete_outlined,
                                                color: Color(0xffFF4D4D),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                );
                              } else if (taskState is TaskBydateFailure) {
                                return Center(
                                  child: Text(
                                    taskState.msg,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'segeo',
                                      color: Color(0xff666666),
                                    ),
                                  ),
                                );
                              }
                              return const Center(
                                child: Text(
                                  'No Data',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'segeo',
                                    color: Color(0xff666666),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      height: 140,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.task, color: Colors.blue),
          SizedBox(height: 8),
          Text(title, style: TextStyle(fontSize: 14)),
          Text(
            value,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

Widget _buildTextField({
  required TextEditingController controller,
  required String hint,
  String? Function(String?)? validator,
  GestureTapCallback? onTap,
}) {
  return TextFormField(
    controller: controller,
    cursorColor: Colors.black,
    onTap: onTap,
    decoration: InputDecoration(hint: Text(hint), border: OutlineInputBorder()),
    validator: validator,
  );
}
