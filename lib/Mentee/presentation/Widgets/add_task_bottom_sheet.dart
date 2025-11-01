import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../Components/CustomAppButton.dart';
import '../../../Components/CustomSnackBar.dart';
import '../../data/cubits/ProductTools/TaskByDate/task_by_date_cubit.dart';
import '../../data/cubits/ProductTools/TaskByStates/task_by_states_cubit.dart';
import '../../data/cubits/ProductTools/TaskUpdate/task_update_cubit.dart';
import '../../data/cubits/ProductTools/TaskUpdate/task_update_states.dart';

class AddTaskBottomSheet extends StatefulWidget {
  final ValueNotifier<DateTime> selectedDateNotifier;
  const AddTaskBottomSheet({
    super.key,
    required this.selectedDateNotifier,
  });

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  TimeOfDay? selectedTime;
  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        // Force 24-hour format in the picker UI
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (time != null) {
      setState(() {
        selectedTime = time;
        // Format manually in 24-hour style
        final now = DateTime.now();
        final formatted = DateFormat('HH:mm').format(
          DateTime(now.year, now.month, now.day, time.hour, time.minute),
        );
        _timeController.text = formatted;
      });
    }
  }


  @override
  void dispose() {
    _taskNameController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Add Task",style:TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),),
            SizedBox(height: 15,),
            _buildTextField(
              controller: _taskNameController,
              hint: "Enter Task Name",
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _pickTime,
              child: AbsorbPointer(
                child: _buildTextField(
                  controller: _timeController,
                  hint: "Select Time",
                  suffixIcon: const Icon(Icons.access_time, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomOutlinedButton(
                    radius: 24,
                    text: "Cancel",
                    onTap: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: BlocConsumer<TaskUpdateCubit, TaskUpdateStates>(
                    listener: (context, state) async {
                      if (state is TaskUpdateSuccess) {
                        final formattedDate =
                        DateFormat('yyyy-MM-dd').format(widget.selectedDateNotifier.value);
                        await context.read<TaskByDateCubit>().fetchTasksByDate(formattedDate);
                        context.read<TaskByStatusCubit>().fetchTasksByStatus();
                        Navigator.pop(context);
                      } else if (state is TaskUpdateFailure) {
                        CustomSnackBar1.show(context, state.msg);
                      }
                    },
                    builder: (context, state) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          backgroundColor: const Color(0xff9333EA),
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        onPressed: () {
                          final formattedDate =
                          DateFormat('yyyy-MM-dd').format(widget.selectedDateNotifier.value);
                          final Map<String, dynamic> data = {
                            "task_date": formattedDate,
                            "title": _taskNameController.text,
                            "task_time": _timeController.text,
                          };
                          context.read<TaskUpdateCubit>().addTask(data);
                        },
                        child: state is TaskUpdateLoading
                            ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Color(0xffF5F5F5),
                            strokeWidth: 2,
                          ),
                        )
                            : const Text(
                          "Submit",
                          style: TextStyle(
                            color: Color(0xffF5F5F5),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            fontFamily: "segeo",
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    );
  }
}
