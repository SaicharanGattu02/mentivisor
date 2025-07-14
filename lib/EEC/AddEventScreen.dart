
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddEventScreen extends StatefulWidget {
  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  String _eventName = '';
  String _location = '';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _collegeName = '';
  String _organizationName = '';
  String _description = '';
  String _eventLink = '';
  bool _useDefaultImage = true;
  bool _highlightPost = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Add Event'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'images/addeventscreen.png', // Placeholder for the event illustration
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16.0),
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'What is the Update',
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: Text('Events'),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text('Competitions'),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text('Challenges'),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Event Name'),
                      onChanged: (value) => _eventName = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter event name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Location'),
                      onChanged: (value) => _location = value,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Date',
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                            controller: TextEditingController(text: _selectedDate.toString().split(' ')[0]),
                            onTap: () => _selectDate(context),
                            readOnly: true,
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Time',
                        suffixIcon: Icon(Icons.access_time),
                      ),
                      controller: TextEditingController(text: _selectedTime.format(context)),
                      onTap: () => _selectTime(context),
                      readOnly: true,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'College/Institution Name'),
                      onChanged: (value) => _collegeName = value,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Organization name'),
                      onChanged: (value) => _organizationName = value,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Event Description'),
                      maxLines: 3,
                      onChanged: (value) => _description = value,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Event Link (optional)'),
                      onChanged: (value) => _eventLink = value,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Event image', suffixIcon: Icon(Icons.upload)),
                            readOnly: true,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Use Default images'),
                        Switch(
                          value: _useDefaultImage,
                          onChanged: (value) {
                            setState(() {
                              _useDefaultImage = value;
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Highlight post Highlight with 40 coins for 1 day'),
                        Switch(
                          value: _highlightPost,
                          onChanged: (value) {
                            setState(() {
                              _highlightPost = value;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF9C27B0)),
                          child: Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Add event logic here
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Event Added')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF9C27B0)),
                          child: Text('Add Event'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}