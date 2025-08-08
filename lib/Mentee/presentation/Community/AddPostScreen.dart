import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mentivisor/Components/CustomAppButton.dart';
import 'package:mentivisor/Components/CustomSnackBar.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import 'package:mentivisor/Mentee/data/cubits/AddCommunityPost/add_communitypost_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/AddCommunityPost/add_communitypost_states.dart';
import 'package:mentivisor/Mentee/data/cubits/CommunityTags/community_tags_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/CommunityTags/community_tags_states.dart';

import '../../../utils/ImageUtils.dart';
import '../../../utils/color_constants.dart';
import '../Widgets/common_widgets.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _headingController = TextEditingController();
  final _describeController = TextEditingController();
  final _tagController = TextEditingController();

  final ValueNotifier<File?> _imageFile = ValueNotifier<File?>(null);
  final ValueNotifier<bool> _isHighlighted = ValueNotifier<bool>(false);
  ValueNotifier<bool> _anonymousNotifier = ValueNotifier<bool>(false);

  List<String> _selectedTags = [];

  @override
  void initState() {
    super.initState();
    context.read<CommunityTagsCubit>().getCommunityTags();
  }

  @override
  void dispose() {
    _headingController.dispose();
    _describeController.dispose();
    _tagController.dispose();
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
      appBar: CustomAppBar1(title: "Add Post", actions: []),
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
              buildCustomLabel('Heading'),
              buildCustomTextField(
                controller: _headingController,
                hint: "Write an heading",
                validator: (value) {
                  if (value!.isEmpty) return 'Heading is required';
                  return null;
                },
              ),
              const SizedBox(height: 10),
              buildCustomLabel('Describe'),
              TextFormField(
                controller: _describeController,
                cursorColor: Colors.black,
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                decoration: InputDecoration(hintText: 'Describe your Post'),
                validator: (value) {
                  if (value!.isEmpty) return 'Describe is required';
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
                    child: ElevatedButton(
                      onPressed: () {
                        final tag = _tagController.text.trim();
                        if (tag.isNotEmpty) {
                          context.read<CommunityTagsCubit>().addTag(tag);
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
                    ),
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
                    Text("Suggested :"),
                    SizedBox(height: 5),
                    BlocBuilder<CommunityTagsCubit, CommunityTagsStates>(
                      builder: (context, state) {
                        if (state is CommunityTagsLoading) {
                          return CircularProgressIndicator();
                        } else if (state is CommunityTagsLoaded) {
                          // Debug the state
                          debugPrint(
                            "Selected Tags in UI: ${state.selectedTags}",
                          );
                          _selectedTags = state.selectedTags;
                          return Wrap(
                            spacing: 5,
                            runSpacing: 0,
                            children: state.allTags.map((tag) {
                              final isSelected = state.selectedTags.contains(
                                tag,
                              );
                              return ChoiceChip(
                                label: Text(tag),
                                selected: isSelected,
                                onSelected: (_) {
                                  context.read<CommunityTagsCubit>().toggleTag(
                                    tag,
                                  );
                                },
                                selectedColor: Colors.blue.shade100,
                                backgroundColor: Colors.white,
                                side: BorderSide(
                                  color: isSelected
                                      ? Colors.blue.shade100
                                      : Colors.grey,
                                ),
                              );
                            }).toList(),
                          );
                        } else {
                          return Text("No Tags Found");
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Image upload
              const Text(
                'Image',
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
                      radius: Radius.circular(36),
                      color: Colors.grey,
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
                                        "Upload image in 16:9 or 4:3",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: labeltextColor,
                                          fontWeight: FontWeight.w600,
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
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Post this anonymous',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff333333),
                          ),
                        ),
                        ValueListenableBuilder<bool>(
                          valueListenable: _anonymousNotifier,
                          builder: (context, value, child) {
                            return Transform.scale(
                              scale: 0.5,
                              child: Switch(
                                value: value,
                                onChanged: (v) => _anonymousNotifier.value = v,
                                activeColor: const Color(0xff315DEA),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const Text(
                      'Viewer can’t see who posted it',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Color(0xff666666),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Highlight post
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

              const SizedBox(height: 32),
              BlocConsumer<AddCommunityPostCubit, AddCommunityPostStates>(
                listener: (context, state) {
                  if (state is AddCommunityPostLoaded) {
                    context.pop();
                  }else if(state is AddCommunityPostFailure){
                    CustomSnackBar1.show(context, state.error);
                  }
                },
                builder: (context, state) {
                  final isLoading = state is AddCommunityPostLoading;
                  return CustomAppButton1(
                    text: "Post It",
                    isLoading: isLoading,
                    onPlusTap: () {
                      if (_formKey.currentState!.validate()) {
                        final file = _imageFile.value;
                        final isHighlighted = _isHighlighted.value;
                        final anonymous = _anonymousNotifier.value;

                        if (file == null) {
                          print('Please upload an image');
                          return;
                        }

                        Map<String, dynamic> data = {
                          "heading": _headingController.text,
                          "description": _describeController.text,
                          "anonymous": anonymous ? 1 : 0,
                          "popular": isHighlighted ? 1 : 0,
                          "tags[]": _selectedTags,
                          "image": file.path,
                        };
                        context.read<AddCommunityPostCubit>().addCommunityPost(
                          data,
                        );
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
