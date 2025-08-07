import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddEventScreen extends StatefulWidget {
  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();

  // form fields
  String _eventName = '';
  String _location = '';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _collegeName = '';
  String _description = '';
  String _eventLink = '';
  bool _useDefaultImage = true;
  bool _highlightPost = false;

  // segmented control
  int _selectedSegment = 0;
  final List<String> _segments = ['Events', 'Competitions', 'Challenges'];

  // colors
  final Color primaryColor = const Color(0xFF1677FF);
  final Color bgColor = const Color(0xFFF7F8FC);

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  @override
  Widget build(BuildContext context) {
    final dateLabel = DateFormat.yMd().format(_selectedDate);
    final timeLabel = _selectedTime.format(context);

    return Scaffold(
      backgroundColor: Color(0xffFAF5FF),
      appBar: AppBar(
        backgroundColor: Color(0xffFAF5FF),
        elevation: 0.5,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add Event',
          style: TextStyle(
            color: Color(0xff222222),
            fontWeight: FontWeight.w600,
            fontFamily: 'segeo',
            fontSize: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Illustration with blue border
            Container(
              decoration: BoxDecoration(
                // border: Border.all(color: primaryColor, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.hardEdge,
              child: Image.asset(
                'images/addeventscreen.png', // your illustration
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 24),

            // Segmented control
            Text(
              'What is the Update',
              style: TextStyle(
                color: Color(0xff222222),
                fontWeight: FontWeight.w600,
                fontFamily: 'segeo',
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: List.generate(_segments.length, (i) {
                final selected = i == _selectedSegment;
                return Padding(
                  padding: EdgeInsets.only(
                    right: i == _segments.length - 1 ? 0 : 8,
                  ),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedSegment = i),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selected ? primaryColor : Colors.grey.shade300,
                        ),
                      ),
                      child: Text(
                        _segments[i],
                        style: TextStyle(
                          color: selected ? primaryColor : Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 24),

            // Form fields
            Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'Event Name',
                    hint: 'Enter your name',
                    onChanged: (v) => _eventName = v,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'Location',
                    hint: 'Event location',
                    onChanged: (v) => _location = v,
                  ),
                  const SizedBox(height: 16),
                  _buildDateTimeField(
                    label: 'Date',
                    value: dateLabel,
                    icon: Icons.calendar_today,
                    onTap: _pickDate,
                  ),
                  const SizedBox(height: 16),
                  _buildDateTimeField(
                    label: 'Time',
                    value: timeLabel,
                    icon: Icons.access_time,
                    onTap: _pickTime,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'College/Institution Name',
                    hint: 'Organization name',
                    onChanged: (v) => _collegeName = v,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'Event Description',
                    hint: 'Event Description',
                    maxLines: 3,
                    onChanged: (v) => _description = v,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'Event Link (optional)',
                    hint: 'Paste the link here',
                    onChanged: (v) => _eventLink = v,
                  ),
                  const SizedBox(height: 16),

                  // Upload button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.upload_file, size: 20, color: Colors.grey),
                          SizedBox(width: 8),
                          Text('Upload', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  SwitchListTile(
                    title: const Text('Highlight Post'),
                    subtitle: const Text(
                      'Make your post Highlight with 40 coins for 1 day',
                    ),
                    value: _highlightPost,
                    onChanged: (v) => setState(() => _highlightPost = v),
                    activeColor: primaryColor,
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFA258F7), // gradient start color
                                  Color(0xFF726CF7), // gradient middle color
                                  Color(0xFF4280F6), // gradient end color
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Center(
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              // your submission logic
                            }
                          },
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFA258F7), // gradient start color
                                  Color(0xFF726CF7), // gradient middle color
                                  Color(0xFF4280F6), // gradient end color
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Center(
                              child: Text(
                                'Add Event',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    int maxLines = 1,

    required Function(String) onChanged,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1) Label above the field, not inside
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),

        // 2) Capsule‑shaped TextFormField
        TextFormField(
          onChanged: onChanged,
          validator: validator,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[500]),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 18,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30), // pill shape
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateTimeField({
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return TextFormField(
      readOnly: true,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        hintText: value,
        suffixIcon: Icon(icon, color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      controller: TextEditingController(text: value),
    );
  }
}
