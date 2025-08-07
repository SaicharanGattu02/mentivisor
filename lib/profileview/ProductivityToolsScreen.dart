import 'package:flutter/material.dart';

class ProductivityScreen extends StatefulWidget {
  @override
  _ProductivityScreenState createState() => _ProductivityScreenState();
}

class _ProductivityScreenState extends State<ProductivityScreen> {
  int selectedDay = DateTime.now().day;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {},
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Productivity Tools',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatCard('Current Streak', '03', Colors.orange[100]!),
                    _buildStatCard('Completed Task', '10', Colors.green[100]!),
                    _buildStatCard('Today Task', '15', Colors.blue[100]!),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        'Aug 2025',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa']
                            .map(
                              (e) => Expanded(
                            child: Center(
                              child: Text(
                                e,
                                style:
                                const TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        )
                            .toList(),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Divider(color: Colors.grey, height: 1),
                      ),
                      GridView.count(
                        crossAxisCount: 7,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: List.generate(31, (index) {
                          int day = index + 1;
                          bool isSelected = selectedDay == day;

                          Color textColor = isSelected ? Colors.pink : Colors.grey;
                          Color borderColor = isSelected ? Colors.pink : Colors.grey.shade300;
                          double borderWidth = isSelected ? 2.0 : 1.0;

                          return GestureDetector(
                            onTap: () {
                              setState(() => selectedDay = day);
                            },
                            child: Container(
                              margin: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: borderColor,
                                  width: borderWidth,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '$day',
                                  style: TextStyle(
                                    fontWeight:
                                    isSelected ? FontWeight.bold : FontWeight.normal,
                                    color: textColor,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$selectedDay Aug Task',
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(10),
                      ),
                      child: Icon(Icons.add, color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Task Name',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text('Add', style: TextStyle(color: Colors.purple)),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      ...[
                        'Complete 30 minutes Study',
                        'Complete 30 minutes Study',
                        'Complete 30 minutes Study'
                      ].map((task) => Container(
                        padding: EdgeInsets.all(12),
                        margin: EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: _buildTaskItem(task, task.hashCode % 2 == 0),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            title == 'Current Streak'
                ? Icons.local_fire_department
                : title == 'Completed Task'
                ? Icons.check_circle
                : Icons.task,
            color: title == 'Current Streak'
                ? Colors.orange
                : title == 'Completed Task'
                ? Colors.green
                : Colors.blue,
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(fontSize: 14),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(String title, bool isCompleted) {
    return Row(
      children: [
        Icon(
          isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isCompleted ? Colors.green : Colors.red,
          size: 20,
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              decoration: isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
        ),
        Icon(Icons.delete, color: Colors.red, size: 20),
      ],
    );
  }
}
