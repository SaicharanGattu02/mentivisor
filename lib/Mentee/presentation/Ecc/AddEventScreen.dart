import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mentivisor/Components/CustomAppButton.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';

import '../../../utils/ImageUtils.dart';
import '../../../utils/color_constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Add Event',
      theme: ThemeData(
        fontFamily: 'segeo',
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AddEventScreen(),
    );
  }
}

class AddEventScreen extends StatefulWidget {
  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _collegeNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _eventLinkController = TextEditingController();

  bool _isHighlighted = false;
  bool _useDefaultImage = false;

  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (selectedDate != null && selectedDate != DateTime.now()) {
      setState(() {
        _dateController.text = "${selectedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selectedTime != null) {
      setState(() {
        _timeController.text = selectedTime.format(context);
      });
    }
  }

  final ImagePicker _picker = ImagePicker();
  File? _image;
  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: primarycolor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                ListTile(
                  leading: Icon(Icons.photo_library, color: primarycolor),
                  title: const Text(
                    'Choose from Gallery',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImageFromGallery();
                  },
                ),

                // Camera Option
                ListTile(
                  leading: Icon(Icons.camera_alt, color: primarycolor),
                  title: const Text(
                    'Take a Photo',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImageFromCamera();
                  },
                ),

                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      File? compressedFile = await ImageUtils.compressImage(
        File(pickedFile.path),
      );
      if (compressedFile != null) {
        setState(() {
          _image = compressedFile;
        });
      }
    }
  }

  Future<void> _pickImageFromCamera() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      File? compressedFile = await ImageUtils.compressImage(
        File(pickedFile.path),
      );
      if (compressedFile != null) {
        setState(() {
          _image = compressedFile;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar1(title: "Add Event", actions: []),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF7F8FC), Color(0xFFEFF4FF)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Image.asset("assets/images/addevent.png"),
              Text('What is the Update', style: TextStyle(fontSize: 18)),
              Row(
                children: [
                  _buildTab('Events'),
                  _buildTab('Competitions'),
                  _buildTab('Challenges'),
                ],
              ),
              SizedBox(height: 20),
              _buildCustomLabel('Event Name'),
              _buildTextField(
                controller: _eventNameController,
                hint: "Event Name",
                validator: (value) {
                  if (value!.isEmpty) return 'Event Name is required';
                  return null;
                },
              ),
              _buildCustomLabel('Location'),
              _buildTextField(
                controller: _locationController,
                hint: "Location",
                validator: (value) {
                  if (value!.isEmpty) return 'Location is required';
                  return null;
                },
              ),
              _buildCustomLabel('Date'),
              _buildTextField(
                controller: _dateController,
                hint: "Date",
                validator: (value) {
                  if (value!.isEmpty) return 'Event Date is required';
                  return null;
                },
                onTap: () => _selectDate(context), // Date Picker
              ),
              _buildCustomLabel('Time'),
              _buildTextField(
                controller: _timeController,
                hint: "Time",
                validator: (value) {
                  if (value!.isEmpty) return 'Event Time is required';
                  return null;
                },
                onTap: () => _selectTime(context), // Time Picker
              ),
              _buildCustomLabel('College/Institution Name'),
              _buildTextField(
                controller: _collegeNameController,
                hint: "College/Institution Name",
                validator: (value) {
                  if (value!.isEmpty) return 'College Name is required';
                  return null;
                },
              ),
              _buildCustomLabel('Description (Optional)'),
              _buildTextField(
                controller: _descriptionController,
                hint: "Description (Optional)",
              ),
              _buildCustomLabel('Event Link (optional)'),
              _buildTextField(
                controller: _eventLinkController,
                hint: "Event Link (optional)",
              ),
              SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  _pickImage();
                },
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: Radius.circular(36),
                  color: primarycolor,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(36)),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      color: Color(0xffF5F5F5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Uploads",
                            style: TextStyle(
                              fontSize: 15,
                              color: labeltextColor,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Poppins",
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.apartment_outlined, color: labeltextColor),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Switch(
                    value: _useDefaultImage,
                    onChanged: (val) {
                      setState(() {
                        _useDefaultImage = val;
                      });
                    },
                  ),
                  Text('Use Default Images'),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: _isHighlighted,
                    onChanged: (val) {
                      setState(() {
                        _isHighlighted = val!;
                      });
                    },
                  ),
                  Text('Highlight Post'),
                  SizedBox(width: 8),
                  Text('Available coins 3000'),
                ],
              ),
              SizedBox(height: 20),
              Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: CustomOutlinedButton(
                      text: "Cancel",
                      radius: 24,
                      onTap: () {},
                    ),
                  ),
                  Expanded(
                    child: CustomAppButton1(
                      text: "Add Event",
                      onPlusTap: () {
                        if (_formKey.currentState!.validate()) {
                          // Handle Add Event
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Event Added')),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String title) {
    return GestureDetector(
      onTap: () {
        // Handle tab switching
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
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
      decoration: InputDecoration(
        hint: Text(hint),
        border: OutlineInputBorder(),
      ),
      validator: validator,
    );
  }

  Widget _buildCustomLabel(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
