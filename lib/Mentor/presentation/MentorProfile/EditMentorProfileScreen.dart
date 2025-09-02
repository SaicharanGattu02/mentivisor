import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import '../../../Components/CustomAppButton.dart';
import '../../../Components/CustomSnackBar.dart';
import '../../../Mentee/data/cubits/Campuses/campuses_cubit.dart';
import '../../../Mentee/data/cubits/Years/years_cubit.dart';
import '../../../Mentee/data/cubits/Years/years_states.dart';
import '../../../utils/ImageUtils.dart';
import '../../../utils/color_constants.dart';
import '../../data/Cubits/MentorProfile/MentorProfileUpdate/MentorProfileCubit.dart';
import '../../data/Cubits/MentorProfile/MentorProfileUpdate/MentorProfileState.dart';
import '../../data/Cubits/MentorProfile/mentor_profile_cubit.dart';

class EditMentorProfileScreen extends StatefulWidget {
  final int collegeId;
  const EditMentorProfileScreen({Key? key, required this.collegeId})
    : super(key: key);

  @override
  State<EditMentorProfileScreen> createState() =>
      _EditMentorProfileScreenState();
}

class _EditMentorProfileScreenState extends State<EditMentorProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _streamController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  File? _image;
  String? imagePath;
  int? _yearId;
  final ImagePicker _picker = ImagePicker();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    context.read<YearsCubit>().getYears();
    context.read<MentorProfileCubit1>().getMentorProfile().then((userData) {
      if (userData != null) {
        final data = userData.data;
        setState(() {
          _nameController.text = data?.name ?? "";
          _emailController.text = data?.email ?? "";

          _streamController.text = data?.stream ?? "";
          if (data?.yearId != null) {
            _yearId = int.tryParse(data!.yearId.toString());
            _yearController.text = data.yearName.toString();
          }

          _bioController.text = data?.bio ?? "";
          imagePath = data?.profilePic ?? "";
          _selectedLanguages = (data?.languages ?? []).cast<String>();
        });
      }
      setState(() => isLoading = false);
    });
  }

  List<String> _languages = [
    'Telugu',
    'Hindi',
    'English',
    'Kannada',
    'Tamil',
    'Marathi',
    'Gujarati',
    'Bengali',
    'Odia',
  ];
  List<String> _selectedLanguages = ['English'];
  bool _showAvailableLanguages = false;

  @override
  void dispose() {
    _nameController.dispose();
    _yearController.dispose();
    _streamController.dispose();
    _bioController.dispose();
    _emailController.dispose();
    // _phoneController.dispose();
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
    final availableLanguages = _languages
        .where((lang) => !_selectedLanguages.contains(lang))
        .toList();

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Stack(
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
                    Text(
                      "Year",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: 'segeo',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff374151),
                      ),
                    ),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: _yearController,
                      readOnly: true,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      onTap: () {
                        _openYearSelectionBottomSheet(context);
                      },
                      decoration: InputDecoration(
                        hintText: 'Select Year',
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                      ),
                      validator: (val) =>
                          val!.isEmpty ? 'Please Select Year' : null,
                    ),
                    const SizedBox(height: 16),
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
                    // _buildField(
                    //   "Phone",
                    //   _phoneController,
                    //   keyboard: TextInputType.phone,
                    //   validator: (v) {
                    //     if (v == null || v.isEmpty) return "Phone required";
                    //     if (v.length < 10) return "Enter valid phone";
                    //     return null;
                    //   },
                    // ),
                    _buildField(
                      "Bio",
                      _bioController,
                      maxLines: 4,
                      validator: (v) =>
                          v == null || v.isEmpty ? "Bio required" : null,
                    ),
                    Text(
                      "Languages",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: 'segeo',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff121212),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ..._selectedLanguages.map(
                          (lang) => Chip(
                            backgroundColor: const Color(0xffFFFFFF),
                            visualDensity: VisualDensity.compact,
                            label: Text(
                              lang,
                              style: const TextStyle(
                                color: Color(0xff555555),
                                fontFamily: 'segeo',
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                            deleteIcon: Container(
                              decoration: const BoxDecoration(
                                color: Color(0xffCDCDCD),
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(2),
                              child: const Icon(
                                Icons.close,
                                size: 16,
                                color: Color(0xff444444),
                              ),
                            ),
                            onDeleted: () {
                              setState(() {
                                _selectedLanguages.remove(lang);
                              });
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: const BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                        ActionChip(
                          visualDensity: VisualDensity.compact,
                          avatar: const Icon(
                            Icons.add,
                            size: 20,
                            color: Colors.black,
                          ),
                          label: const Text(
                            "Add new",
                            style: TextStyle(
                              color: Color(0xff555555),
                              fontFamily: 'segeo',
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _showAvailableLanguages =
                                  !_showAvailableLanguages;
                            });
                          },
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              color: Colors.white,
                              style: BorderStyle.none,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    if (_showAvailableLanguages) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Select from below",
                            style: TextStyle(
                              fontFamily: 'segeo',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff555555),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.close,
                              size: 20,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _showAvailableLanguages = false;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: availableLanguages.map((lang) {
                          return ChoiceChip(
                            label: Text(
                              lang,
                              style: const TextStyle(
                                color: Color(0xff121212),
                                fontFamily: 'segeo',
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                            selected: false,
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            onSelected: (_) {
                              setState(() {
                                _selectedLanguages.add(lang);
                                _showAvailableLanguages = false;
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 20),
          child:
              BlocConsumer<MentorProfileUpdateCubit, MentorProfileUpdateState>(
                listener: (context, state) {
                  if (state is MentorProfileUpdateSuccess) {
                    context.read<MentorProfileCubit1>().getMentorProfile();
                    CustomSnackBar1.show(
                      context,
                      state.successModel.message ?? "",
                    );
                    context.pop();
                  } else if (state is MentorProfileUpdateFailure) {
                    CustomSnackBar1.show(context, state.message ?? "");
                  }
                },
                builder: (context, state) {
                  final isLoading = state is MentorProfileUpdateLoading;
                  return SizedBox(
                    width: double.infinity,
                    child: CustomAppButton1(
                      text: isLoading ? "Updating..." : "Submit",
                      onPlusTap: () {
                        if (_formKey.currentState!.validate() && !isLoading) {
                          final data = {
                            "name": _nameController.text.trim(),
                            "year": _yearId,
                            "stream": _streamController.text.trim(),
                            "bio": _bioController.text.trim(),
                            "email": _emailController.text.trim(),
                            "college_id": widget.collegeId,
                          };
                          for (int i = 0; i < _selectedLanguages.length; i++) {
                            data["languages[$i]"] = _selectedLanguages[i];
                          }
                          if (_image != null) {
                            data["image"] = _image!.path;
                          }
                          context
                              .read<MentorProfileUpdateCubit>()
                              .updateMentorProfile(data);
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

  void _openYearSelectionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          height:
              MediaQuery.of(context).size.height *
              0.6, // Set height to 60% of screen
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocBuilder<YearsCubit, YearsStates>(
              builder: (context, state) {
                if (state is YearsLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is YearsFailure) {
                  return Center(
                    child: Text(
                      state.error,
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                } else if (state is YearsLoaded) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Select Year",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.yearsModel.data!.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                state.yearsModel.data![index].name!,
                                style: TextStyle(fontSize: 16),
                              ),
                              onTap: () {
                                _yearController.text =
                                    state.yearsModel.data![index].name!;
                                _yearId = state.yearsModel.data![index].id;
                                Navigator.pop(context);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        );
      },
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
