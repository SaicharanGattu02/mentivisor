import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mentivisor/Components/CustomAppButton.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import 'package:mentivisor/Mentee/data/cubits/MenteeProfile/MenteeProfileUpdate/MenteeProfileState.dart';
import '../../../Components/CustomSnackBar.dart';
import '../../../utils/ImageUtils.dart';
import '../../../utils/color_constants.dart';
import '../../data/cubits/MenteeDashBoard/mentee_dashboard_cubit.dart';
import '../../data/cubits/MenteeProfile/GetMenteeProfile/MenteeProfileCubit.dart';
import '../../data/cubits/MenteeProfile/MenteeProfileUpdate/MenteeProfileCubit.dart';

class EditProfileScreen extends StatefulWidget {
  final int collegeId;
  const EditProfileScreen({Key? key, required this.collegeId})
    : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _streamController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  File? _image;
  String? imagePath;
  final ImagePicker _picker = ImagePicker();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    context.read<MenteeProfileCubit>().fetchMenteeProfile().then((userData) {
      if (userData != null) {
        final data = userData.data;
        setState(() {
          _nameController.text = data?.user?.name ?? "";
          _emailController.text = data?.user?.email ?? "";
          _phoneController.text = data?.user?.contact?.toString() ?? "";
          _streamController.text = data?.user?.stream ?? "";
          _yearController.text = data?.user?.year ?? "";
          _bioController.text = data?.user?.bio ?? "";
          imagePath = data?.user?.profilePicUrl ?? "";
        });
      }
      setState(() => isLoading = false);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _yearController.dispose();
    _streamController.dispose();
    _bioController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library, color: primarycolor),
                title: const Text("Choose from Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromGallery();
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt, color: primarycolor),
                title: const Text("Take a Photo"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromCamera();
                },
              ),
            ],
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
        setState(() => _image = compressedFile);
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
        setState(() => _image = compressedFile);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F4FD),
      appBar: CustomAppBar1(
        title: "Edit Profile",
        actions: [],
        color: Color(0xFFF2F4FD),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Profile Pic
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: _image != null
                              ? FileImage(_image!)
                              : (imagePath?.startsWith('http') ?? false)
                              ? CachedNetworkImageProvider(imagePath!)
                              : const AssetImage('assets/images/profile.png')
                                    as ImageProvider,
                        ),
                        Positioned(
                          bottom: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: primarycolor,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              padding: const EdgeInsets.all(6),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    _buildField(
                      "Name",
                      _nameController,
                      validator: (v) =>
                          v == null || v.isEmpty ? "Name required" : null,
                    ),
                    _buildField(
                      "Stream",
                      _streamController,
                      validator: (v) =>
                          v == null || v.isEmpty ? "Stream required" : null,
                    ),
                    _buildField(
                      "Year",
                      _yearController,
                      keyboard: TextInputType.number,
                      validator: (v) =>
                          v == null || v.isEmpty ? "Year required" : null,
                    ),
                    _buildField(
                      "Email",
                      _emailController,
                      keyboard: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.isEmpty) return "Email required";
                        final emailRegex = RegExp(
                          r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                        );
                        return emailRegex.hasMatch(v)
                            ? null
                            : "Enter valid email";
                      },
                    ),
                    _buildField(
                      "Phone",
                      _phoneController,
                      keyboard: TextInputType.phone,
                      validator: (v) {
                        if (v == null || v.isEmpty) return "Phone required";
                        if (v.length < 10) return "Enter valid phone";
                        return null;
                      },
                    ),
                    _buildField(
                      "Bio",
                      _bioController,
                      maxLines: 4,
                      validator: (v) =>
                          v == null || v.isEmpty ? "Bio required" : null,
                    ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          child:
              BlocConsumer<MenteeProfileUpdateCubit, MenteeProfileUpdateState>(
                listener: (context, state) {
                  if (state is MenteeProfileUpdateSuccess) {
                    context.read<MenteeProfileCubit>().fetchMenteeProfile();
                    CustomSnackBar1.show(
                      context,
                      state.successModel.message ?? "",
                    );
                    context.pop();
                  } else if (state is MenteeProfileUpdateFailure) {
                    CustomSnackBar1.show(context, state.message ?? "");
                  }
                },
                builder: (context, state) {
                  final isLoading = state is MenteeProfileUpdateLoading;
                  return SizedBox(
                    width: double.infinity,
                    child: CustomAppButton1(
                      text: isLoading ? "Updating..." : "Submit",
                      onPlusTap: () {
                        if (_formKey.currentState!.validate() && !isLoading) {
                          final data = {
                            "name": _nameController.text.trim(),
                            "year": _yearController.text.trim(),
                            "stream": _streamController.text.trim(),
                            "bio": _bioController.text.trim(),
                            "email": _emailController.text.trim(),
                            "phone": _phoneController.text.trim(),
                            "college_id": widget.collegeId,
                          };
                          if (_image != null) {
                            data["profile_pic"] = _image!.path;
                          }

                          context
                              .read<MenteeProfileUpdateCubit>()
                              .updateMenteeProfile(data);
                        }
                      },
                    ),
                  );
                },
              ),
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    String? Function(String?)? validator,
    TextInputType keyboard = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'segeo',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xff374151),
            ),
          ),
          const SizedBox(height: 4),
          TextFormField(
            controller: controller,
            validator: validator,
            keyboardType: keyboard,
            maxLines: maxLines,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
