import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mentivisor/Components/CustomAppButton.dart';
import 'package:mentivisor/Components/CustomSnackBar.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import 'package:mentivisor/Mentee/data/cubits/AddECC/add_ecc_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/AddECC/add_ecc_states.dart';
import '../../../utils/ImageUtils.dart';
import '../../../utils/color_constants.dart';
import '../Widgets/common_widgets.dart';

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

  final ValueNotifier<bool> _isHighlighted = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _useDefaultImage = ValueNotifier<bool>(false);
  final ValueNotifier<String> selectedDateStr = ValueNotifier<String>('');
  final ValueNotifier<String> selectedTimeStr = ValueNotifier<String>('');
  final ValueNotifier<String> selectedTabIndex = ValueNotifier<String>('event');
  final ValueNotifier<File?> _imageFile = ValueNotifier<File?>(null);

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      selectedDateStr.value = picked.toLocal().toString().split(' ')[0];
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      final now = DateTime.now();
      final dt = DateTime(
        now.year,
        now.month,
        now.day,
        picked.hour,
        picked.minute,
      );
      final formattedTime =
          "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";

      selectedTimeStr.value = formattedTime; // ⏰ 24-hour format like 14:30
    }
  }

  final ImagePicker _picker = ImagePicker();
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
        _imageFile.value = compressedFile;
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
        _imageFile.value = compressedFile;
      }
    }
  }

  void _cancelImage() {
    _imageFile.value = null;
  }

  @override
  void dispose() {
    selectedTabIndex.dispose();
    _imageFile.dispose();
    _isHighlighted.dispose();
    _useDefaultImage.dispose();
    super.dispose();
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
              SizedBox(height: 10),
              Row(
                children: [
                  _buildTab('Events', "event"),
                  _buildTab('Competitions', "competition"),
                  _buildTab('Challenges', "challenge"),
                ],
              ),
              SizedBox(height: 10),
              buildCustomLabel('Event Name'),
              buildCustomTextField(
                controller: _eventNameController,
                hint: "Event Name",
                validator: (value) {
                  if (value!.isEmpty) return 'Event Name is required';
                  return null;
                },
              ),
              buildCustomLabel('Location'),
              buildCustomTextField(
                controller: _locationController,
                hint: "Location",
                validator: (value) {
                  if (value!.isEmpty) return 'Location is required';
                  return null;
                },
              ),
              buildCustomLabel('Date'),
              ValueListenableBuilder<String>(
                valueListenable: selectedDateStr,
                builder: (context, value, _) {
                  return buildCustomTextField(
                    controller: TextEditingController(text: value),
                    hint: "Date",
                    validator: (value) {
                      if (value!.isEmpty) return 'Event Date is required';
                      return null;
                    },
                    onTap: () => _selectDate(context), // Date Picker
                  );
                },
              ),

              buildCustomLabel('Time'),
              ValueListenableBuilder<String>(
                valueListenable: selectedTimeStr,
                builder: (context, value, _) {
                  return buildCustomTextField(
                    controller: TextEditingController(text: value),
                    hint: "Time",
                    validator: (value) {
                      if (value!.isEmpty) return 'Event Time is required';
                      return null;
                    },
                    onTap: () => _selectTime(context), // Time Picker
                  );
                },
              ),
              buildCustomLabel('College/Institution Name'),
              buildCustomTextField(
                controller: _collegeNameController,
                hint: "College/Institution Name",
                validator: (value) {
                  if (value!.isEmpty) return 'College Name is required';
                  return null;
                },
              ),
              buildCustomLabel('Description (Optional)'),
              buildCustomTextField(
                controller: _descriptionController,
                hint: "Description (Optional)",
              ),
              buildCustomLabel('Event Link (optional)'),
              buildCustomTextField(
                controller: _eventLinkController,
                hint: "Event Link (optional)",
              ),
              SizedBox(height: 15),
              ValueListenableBuilder<File?>(
                valueListenable: _imageFile,
                builder: (context, file, _) {
                  return GestureDetector(
                    onTap: file == null ? _pickImage : null,
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      radius: Radius.circular(36),
                      color: primarycolor,
                      strokeWidth: 1.5,
                      dashPattern: [6, 3],
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(36)),
                        child: Container(
                          width: double.infinity,
                          color: Color(0xffF5F5F5),
                          child: file == null
                              ? Padding(
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Upload",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: labeltextColor,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Poppins",
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(
                                        Icons.upload_rounded,
                                        color: labeltextColor,
                                      ),
                                    ],
                                  ),
                                )
                              : Stack(
                                  children: [
                                    Image.file(
                                      file,
                                      width: double.infinity,
                                      height: 180,
                                      fit: BoxFit.cover,
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: GestureDetector(
                                        onTap: _cancelImage,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.black54,
                                          radius: 16,
                                          child: Icon(
                                            Icons.close,
                                            size: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 15),
              // Use Default Image Switch
              ValueListenableBuilder<bool>(
                valueListenable: _useDefaultImage,
                builder: (context, value, _) {
                  return Row(
                    children: [
                      Switch(
                        value: value,
                        onChanged: (val) {
                          _useDefaultImage.value = val;
                        },
                      ),
                      Text('Use Default Images'),
                    ],
                  );
                },
              ),
              // Highlight Post Checkbox
              ValueListenableBuilder<bool>(
                valueListenable: _isHighlighted,
                builder: (context, value, _) {
                  return Row(
                    children: [
                      Checkbox(
                        value: value,
                        onChanged: (val) {
                          if (val != null) _isHighlighted.value = val;
                        },
                      ),
                      Text('Highlight Post'),
                      SizedBox(width: 8),
                      Text('Available coins 3000'),
                    ],
                  );
                },
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
                    child: BlocConsumer<AddEccCubit, AddEccStates>(
                      listener: (context, state) {
                        if (state is AddEccLoaded) {
                          context.pop();
                          CustomSnackBar1.show(
                            context,
                            state.successModel.message ?? "",
                          );
                        } else if (state is AddEccFailure) {
                          CustomSnackBar1.show(context, state.error);
                        }
                      },
                      builder: (context, state) {
                        final isLoading = state is AddEccLoading;
                        return CustomAppButton1(
                          text: "Add Event",
                          isLoading: isLoading,
                          onPlusTap: () {
                            if (_formKey.currentState!.validate()) {
                              final file = _imageFile.value;
                              final isHighlighted = _isHighlighted.value;

                              if (file == null) {
                                // Optionally show an error/toast/snackbar
                                print('Please upload an image');
                                return;
                              }
                              Map<String, dynamic> data = {
                                "name": _eventNameController.text,
                                "location": _locationController.text,
                                "type": selectedTabIndex.value,
                                "time": selectedTimeStr.value,
                                "college": _collegeNameController.text,
                                "description": _descriptionController.text,
                                "dateofevent": selectedDateStr.value,
                                "popular": isHighlighted ? 1 : 0,
                                "link": _dateController.text,
                                "image":
                                    file.path, // ✅ Get path from ValueNotifier
                              };
                              context.read<AddEccCubit>().addEcc(data);
                            }
                          },
                        );
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

  Widget _buildTab(String title, String index) {
    return ValueListenableBuilder<String>(
      valueListenable: selectedTabIndex,
      builder: (context, selectedValue, _) {
        bool isSelected = selectedValue == index;
        return GestureDetector(
          onTap: () {
            selectedTabIndex.value = index;
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            margin: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue : Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: isSelected ? Colors.white : Color(0xff666666),
              ),
            ),
          ),
        );
      },
    );
  }
}
