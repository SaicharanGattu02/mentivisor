import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mentivisor/Components/CustomAppButton.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import 'package:mentivisor/Mentee/data/cubits/MenteeProfile/MenteeProfileUpdate/MenteeProfileState.dart';
import '../../../Components/CommonLoader.dart';
import '../../../Components/CustomSnackBar.dart';
import '../../../utils/ImageUtils.dart';
import '../../../utils/color_constants.dart';
import '../../data/cubits/Campuses/campuses_cubit.dart';
import '../../data/cubits/Campuses/campuses_states.dart';
import '../../data/cubits/MenteeDashBoard/mentee_dashboard_cubit.dart';
import '../../data/cubits/MenteeProfile/GetMenteeProfile/MenteeProfileCubit.dart';
import '../../data/cubits/MenteeProfile/MenteeProfileUpdate/MenteeProfileCubit.dart';
import '../../data/cubits/Years/years_cubit.dart';
import '../../data/cubits/Years/years_states.dart';

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
  final TextEditingController _collegeController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _streamController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _phoneController = TextEditingController();
  File? _image;
  String? imagePath;
  int? _yearId;
  int? _collegeId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    context.read<CampusesCubit>().getCampuses();
    context.read<YearsCubit>().getYears();
    context.read<MenteeProfileCubit>().fetchMenteeProfile().then((userData) {
      if (userData != null) {
        final data = userData.data;
        setState(() {
          _nameController.text = data?.user?.name ?? "";
          _emailController.text = data?.user?.email ?? "";
          // _phoneController.text = data?.user?.contact?.toString() ?? "";
          _streamController.text = data?.user?.stream ?? "";
          _bioController.text = data?.user?.bio ?? "";
          imagePath = data?.user?.profilePicUrl ?? "";
          if (data?.user?.collegeId != null) {
            _collegeId = int.tryParse(data?.user?.collegeId.toString() ?? "");
            _collegeController.text = data?.user?.college_name ?? "";
          }

          if (data?.user?.yearId != null) {
            _yearId = int.tryParse(data?.user?.yearId.toString() ?? "");
            _yearController.text = data?.user?.yearName.toString() ?? "";
          }
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
    // _phoneController.dispose();
    super.dispose();
  }

  Future<void> _selectImage() async {
    final pickedImage = await ImagePickerHelper.pickImage(
      context,
      iconColor: primarycolor,
    );
    if (pickedImage != null) {
      setState(() => _image = pickedImage);
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
          ? Center(child: DottedProgressWithLogo())
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
                            backgroundColor: Colors.grey[200],
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
                              onTap: () {
                                _selectImage();
                              },
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
                    Text(
                      "College Name",
                      style: const TextStyle(
                        fontFamily: 'segeo',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff374151),
                      ),
                    ),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: _collegeController,
                      readOnly: true,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      onTap: () {
                        _openCollegeSelectionBottomSheet(context);
                      },
                      decoration: InputDecoration(       suffixIcon: Icon(Icons.arrow_drop_down_sharp),
                        hintText: 'Enter your college name',
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                      ),
                      validator: (val) =>
                          val!.isEmpty ? 'Please enter your college' : null,
                    ),
                    SizedBox(height: 16),
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
                        suffixIcon: Icon(Icons.arrow_drop_down_sharp),
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
                            "year": _yearId,
                            "college_id": _collegeId,
                            "stream": _streamController.text.trim(),
                            "bio": _bioController.text.trim(),
                            "email": _emailController.text.trim(),
                            // "phone": _phoneController.text.trim(),
                            // "college_id": widget.collegeId,
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

  void _openCollegeSelectionBottomSheet(BuildContext context) {
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
          height: MediaQuery.of(context).size.height * 0.6,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocBuilder<CampusesCubit, CampusesStates>(
              builder: (context, state) {
                if (state is CampusesLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is CampusesLoaded) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Select College",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.campusesModel.data!.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                state.campusesModel.data![index].name!,
                                style: TextStyle(fontSize: 16),
                              ),
                              onTap: () {
                                _collegeController.text =
                                    state.campusesModel.data![index].name!;
                                _collegeId =
                                    state.campusesModel.data![index].id;
                                Navigator.pop(context);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                } else if (state is CampusesFailure) {
                  return Center(
                    child: Text(
                      state.error,
                      style: TextStyle(color: Colors.red),
                    ),
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
