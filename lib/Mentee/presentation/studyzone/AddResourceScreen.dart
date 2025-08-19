import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mentivisor/Mentee/data/cubits/AddResource/add_resource_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/AddResource/add_resource_states.dart';
import 'package:mentivisor/Mentee/data/cubits/StudyZoneTags/StudyZoneTagsCubit.dart';
import 'package:mentivisor/Mentee/data/cubits/StudyZoneTags/StudyZoneTagsState.dart';
import '../../../Components/CustomAppButton.dart';
import '../../../Components/CustomSnackBar.dart';
import '../../../Components/CutomAppBar.dart';
import '../../../utils/ImageUtils.dart';
import '../../../utils/color_constants.dart';
import '../../data/cubits/CommunityTags/community_tags_cubit.dart';
import '../Widgets/common_widgets.dart';

class AddResourceScreen extends StatefulWidget {
  const AddResourceScreen({super.key});
  @override
  State<AddResourceScreen> createState() => _AddResourceScreenState();
}

class _AddResourceScreenState extends State<AddResourceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _resourceNameController = TextEditingController();
  final _aboutController = TextEditingController();
  final _tagController = TextEditingController();
  final ValueNotifier<File?> _imageFile = ValueNotifier<File?>(null);
  final ValueNotifier<File?> _pickedFile = ValueNotifier<File?>(null);
  final ValueNotifier<bool> _isHighlighted = ValueNotifier<bool>(false);
  ValueNotifier<bool> _anonymousNotifier = ValueNotifier<bool>(false);

  List<String> _selectedTags = [];

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
    );

    if (result != null && result.files.single.path != null) {
      _pickedFile.value = File(result.files.single.path!);
    }
  }

  void _cancelFile() {
    _pickedFile.value = null;
  }

  @override
  void dispose() {
    super.dispose();
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar1(title: "Add Resource", actions: []),
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
              Image.asset("assets/images/cloud.png", width: 130, height: 150),
              SizedBox(height: 25),
              const Text(
                'Banner',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff333333),
                ),
              ),
              const SizedBox(height: 8),
              ValueListenableBuilder<File?>(
                valueListenable: _imageFile,
                builder: (context, file, _) {
                  return GestureDetector(
                    onTap: file == null ? _pickImage : null,
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      radius: Radius.circular(8),
                      color: Color(0xff4B5462),
                      strokeWidth: 1,
                      dashPattern: [6, 3],
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        child: Container(
                          width: double.infinity,
                          color: Colors.white,
                          child: file == null
                              ? Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 14,
                                    horizontal: 16,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        "assets/icons/upload.png",
                                        width: 20,
                                        height: 20,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "Upload your Banner here ",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Color(0xff9CA3AF),
                                          fontWeight: FontWeight.w600,
                                        ),
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
              const SizedBox(height: 18),
              buildCustomLabel('Resource Name'),
              buildCustomTextField(
                controller: _resourceNameController,
                hint: "Enter Resource Name",
                validator: (value) {
                  if (value!.isEmpty) return 'Resource Name is required';
                  return null;
                },
              ),
              const SizedBox(height: 10),
              buildCustomLabel('About Resource'),
              TextFormField(
                controller: _aboutController,
                cursorColor: Colors.black,
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                decoration: InputDecoration(hintText: 'About Resource'),
                validator: (value) {
                  if (value!.isEmpty) return 'About Resource is required';
                  return null;
                },
              ),
              const SizedBox(height: 10),
              buildCustomLabel('Tags'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: buildCustomTextField(
                      controller: _tagController,
                      hint: "Enter Tag",
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 48,
                    width: 48,
                    child:ElevatedButton(
                      onPressed: () {
                        final tag = _tagController.text.trim();
                        if (tag.isNotEmpty) {
                          // Add tag through Cubit
                          context.read<CommunityTagsCubit>().addTag(tag);

                          // Clear the text field
                          _tagController.clear();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        backgroundColor: const Color(0xff315DEA),
                        padding: const EdgeInsets.all(12),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 20,
                        color: Colors.white,
                      ),
                    )

                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Suggested tags
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Suggested Tags"),
                    SizedBox(height: 5),
                    BlocBuilder<StudyZoneTagsCubit, StudyZoneTagsState>(
                      builder: (context, state) {
                        if (state is StudyZoneTagsLoading) {
                          return CircularProgressIndicator();
                        } else if (state is StudyZoneTagsLoaded) {
                          // Merge server tags with newly added tags
                          final allTags = [
                            ...state.studyZoneTagsModel.tags!,  // original tags
                            ..._selectedTags.where((tag) => !state.studyZoneTagsModel.tags!.contains(tag)) // newly added
                          ];

                          return Wrap(
                            spacing: 5,
                            runSpacing: 0,
                            children: allTags.map((tag) {
                              final isSelected = _selectedTags.contains(tag);
                              return ChoiceChip(
                                label: Text(tag),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      _selectedTags.add(tag);
                                    } else {
                                      _selectedTags.remove(tag);
                                    }
                                  });
                                },
                                selectedColor: Colors.blue.shade100,
                                backgroundColor: Colors.white,
                                side: BorderSide(
                                  color: isSelected ? Colors.blue.shade100 : Colors.grey,
                                ),
                              );
                            }).toList(),
                          );
                        } else {
                          return Text("No Tags Found");
                        }
                      },
                    )

                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Upload',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff333333),
                ),
              ),
              const SizedBox(height: 8),
              ValueListenableBuilder<File?>(
                valueListenable: _pickedFile,
                builder: (context, file, _) {
                  return GestureDetector(
                    onTap: file == null ? _pickFile : null,
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(8),
                      color: const Color(0xff4B5462),
                      strokeWidth: 1,
                      dashPattern: const [6, 3],
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                        child: Container(
                          width: double.infinity,
                          color: Colors.white,
                          child: file == null
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                    horizontal: 16,
                                  ),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        "assets/icons/upload.png",
                                        width: 20,
                                        height: 20,
                                      ),
                                      const SizedBox(width: 10),
                                      const Text(
                                        "Upload your Resources here",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Color(0xff9CA3AF),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Stack(
                                  children: [
                                    Container(
                                      height: 100,
                                      alignment: Alignment.center,
                                      color: const Color(0xffF8FAFE),
                                      child: Text(
                                        file.path.split('/').last,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: GestureDetector(
                                        onTap: _cancelFile,
                                        child: const CircleAvatar(
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
              const SizedBox(height: 24),
              BlocConsumer<AddResourceCubit, AddResourceStates>(
                listener: (context, state) {
                  if (state is AddResourceLoaded) {
                    context.pop();
                  } else if (state is AddResourceFailure) {
                    CustomSnackBar1.show(context, state.error);
                  }
                },
                builder: (context, state) {
                  final isLoading = state is AddResourceLoading;
                  return CustomAppButton1(
                    text: "Submit",
                    isLoading: isLoading,
                    onPlusTap: () {
                      if (_formKey.currentState!.validate()) {
                        final imagefile = _imageFile.value;
                        final file = _pickedFile.value;
                        final isHighlighted = _isHighlighted.value;
                        final anonymous = _anonymousNotifier.value;

                        if (imagefile == null && file == null) {
                          return;
                        }

                        Map<String, dynamic> data = {
                          "name": _resourceNameController.text,
                          "description": _aboutController.text,
                          "tag[]": _selectedTags,
                          "image": imagefile!.path,
                          "file_pdf": file!.path,
                        };
                        context.read<AddResourceCubit>().addResource(data);
                      }
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
