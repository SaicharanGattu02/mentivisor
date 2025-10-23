import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:mentivisor/Mentee/data/cubits/AddResource/add_resource_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/AddResource/add_resource_states.dart';
import 'package:mentivisor/Mentee/data/cubits/Tags/tags_states.dart';
import 'package:path_provider/path_provider.dart';
import '../../../Components/CommonLoader.dart';
import '../../../Components/CustomAppButton.dart';
import '../../../Components/CustomSnackBar.dart';
import '../../../Components/CutomAppBar.dart';
import '../../../utils/AppLogger.dart';
import '../../../utils/color_constants.dart';
import '../../Models/StudyZoneTagsModel.dart';
import '../../data/cubits/StudyZoneCampus/StudyZoneCampusCubit.dart';
import '../../data/cubits/Tags/tags_cubit.dart';
import '../Widgets/CommonImgeWidget.dart';
import '../Widgets/common_widgets.dart';
import 'package:image/image.dart' as img;

class AddResourceScreen extends StatefulWidget {
  const AddResourceScreen({super.key});
  @override
  State<AddResourceScreen> createState() => _AddResourceScreenState();
}

class _AddResourceScreenState extends State<AddResourceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _resourceNameController = TextEditingController();
  final _aboutController = TextEditingController();

  final ValueNotifier<File?> _imageFile = ValueNotifier<File?>(null);
  final ValueNotifier<File?> _pickedFile = ValueNotifier<File?>(null);
  final ValueNotifier<bool> _isHighlighted = ValueNotifier<bool>(false);
  ValueNotifier<bool> _anonymousNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _useDefaultImage = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  final searchController = TextEditingController();
  Timer? _debounce;
  List<String> _selectedTags = [];
  List<String> _customTags = [];

  Future<void> _selectFile() async {
    _isLoading.value = true; // start loading

    try {
      final file = await FileImagePicker.pickPdfFile();

      if (file != null) {
        _pickedFile.value = file;
      }
    } catch (e) {
      debugPrint('File selection error: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> _selectImage() async {
    final image = await FileImagePicker.pickImageBottomSheet(context);
    if (image != null) {
      final resizedImage = await _resizeImage(image);
      final prev = _imageFile.value;
      if (prev != null) {
        FileImage(prev).evict();
      }

      // Update value (no need for setState when using ValueNotifier)
      _imageFile.value = resizedImage;
    }
  }

  Future<File> _resizeImage(File imageFile) async {
    final decoded = img.decodeImage(await imageFile.readAsBytes());
    if (decoded == null) return imageFile;

    final resized = img.copyResize(decoded, width: 800);

    final tempDir = await getTemporaryDirectory();
    final stamp = DateTime.now().microsecondsSinceEpoch; // unique
    final tempFile = File('${tempDir.path}/resized_$stamp.jpg');

    await tempFile.writeAsBytes(img.encodeJpg(resized), flush: true);
    return tempFile;
  }

  void _cancelImage() {
    final prev = _imageFile.value;
    if (prev != null) {
      FileImage(prev).evict();
    }
    _imageFile.value = null;
  }

  void _cancelFile() {
    _pickedFile.value = null;
  }

  @override
  void initState() {
    searchController.clear();
    context.read<TagsCubit>().getStudyZoneTags("");
    super.initState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _imageFile.dispose();
    _pickedFile.dispose();
    _isHighlighted.dispose();
    _anonymousNotifier.dispose();
    _useDefaultImage.dispose();
    _resourceNameController.dispose();
    _aboutController.dispose();
    searchController.dispose();
    super.dispose();
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
              ValueListenableBuilder<bool>(
                valueListenable: _useDefaultImage,
                builder: (context, value, child) {
                  return ValueListenableBuilder<File?>(
                    valueListenable: _imageFile,
                    builder: (context, file, _) {
                      final isDisabled = _useDefaultImage.value;
                      AppLogger.info("isDisabled:${isDisabled}");

                      return GestureDetector(
                        onTap: (!isDisabled && file == null)
                            ? _selectImage
                            : null,
                        child: Opacity(
                          opacity: isDisabled ? 0.5 : 1.0,
                          child: DottedBorder(
                            borderType: BorderType.RRect,
                            radius: Radius.circular(36),
                            color: isDisabled ? Colors.grey : primarycolor,
                            strokeWidth: 1.5,
                            dashPattern: [6, 3],
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(36),
                              ),
                              child: Container(
                                width: double.infinity,
                                color: Color(0xffF5F5F5),
                                child: file == null
                                    ? Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 14,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Upload your Banner here",
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Color(0xff9CA3AF),
                                                fontWeight: FontWeight.w400,
                                                fontFamily: "segeo",
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
                                            key: ValueKey(file.path),
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
                        ),
                      );
                    },
                  );
                },
              ),

              SizedBox(height: 8),
              ValueListenableBuilder<bool>(
                valueListenable: _useDefaultImage,
                builder: (context, value, _) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      Text(
                        'Use Default Images',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'segeo',
                          color: Color(0xff666666),
                        ),
                      ),
                      Transform.scale(
                        scale: 0.5,
                        child: Switch(
                          padding: EdgeInsets.zero,
                          value: value,
                          onChanged: (val) {
                            _useDefaultImage.value = val;
                          },
                          activeTrackColor: const Color(0xff2563EB),
                          inactiveTrackColor: Colors.grey.shade300,
                          inactiveThumbColor: const Color(
                            0xff2563EB,
                          ), // inactive thumb
                          thumbColor: MaterialStateProperty.resolveWith<Color>((
                            states,
                          ) {
                            if (states.contains(MaterialState.selected)) {
                              return Colors.white;
                            }
                            return const Color(0xff2563EB);
                          }),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  );
                },
              ),

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
              SizedBox(
                height: 48,
                child: TextField(
                  controller: searchController,
                  cursorColor: primarycolor,
                  onChanged: (query) {
                    if (_debounce?.isActive ?? false) _debounce!.cancel();
                    _debounce = Timer(const Duration(milliseconds: 300), () {
                      context.read<TagsCubit>().getStudyZoneTags(query);
                    });
                  },
                  style: TextStyle(fontFamily: "segeo", fontSize: 15),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    hoverColor: Colors.white,
                    hintText: "Search Tags here",
                    hintStyle: const TextStyle(color: Colors.grey),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.only(right: 33, left: 20),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              BlocBuilder<TagsCubit, TagsState>(
                builder: (context, state) {
                  if (state is TagsLoading) {
                    return const Center(child: DottedProgressWithLogo());
                  } else if (state is TagsLoaded) {
                    final allTags = [...state.tagsModel.data!, ..._customTags];
                    if (allTags.isEmpty) {
                      return Center(child: Text("No Tags Found!"));
                    }
                    return Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Select Tags",
                            style: TextStyle(
                              color: Color(0xff374151),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'segeo',
                            ),
                          ),
                          const SizedBox(height: 5),
                          Wrap(
                            spacing: 5,
                            runSpacing: 0,
                            children: allTags.map((tag) {
                              final zone =
                                  tag as StudyZone; // 👈 explicitly cast
                              final tagText = zone.tags ?? "";
                              final isSelected = _selectedTags.contains(
                                tagText,
                              );

                              return ChoiceChip(
                                label: Text(
                                  tagText,
                                  style: const TextStyle(
                                    color: Color(0xff333333),
                                    fontFamily: 'segeo',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                  ),
                                ),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      _selectedTags.add(tagText);
                                    } else {
                                      _selectedTags.remove(tagText);
                                    }
                                  });
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
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
              const SizedBox(height: 8),
              if (_selectedTags.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Selected Tags",
                        style: TextStyle(
                          color: Color(0xff374151),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'segeo',
                        ),
                      ),
                      const SizedBox(height: 5),
                      Wrap(
                        spacing: 5,
                        runSpacing: 0,
                        children: _selectedTags.map((tag) {
                          return Chip(
                            label: Text(
                              tag,
                              style: TextStyle(
                                color: Color(0xff333333),
                                fontFamily: 'segeo',
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                            side: BorderSide(color: Colors.blue.shade50),
                            backgroundColor: Colors.blue.shade50,
                            deleteIcon: Icon(Icons.close, size: 16),
                            onDeleted: () {
                              setState(() {
                                _selectedTags.remove(tag);
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                SizedBox.shrink(),
              ],
              const SizedBox(height: 8),
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
                  return ValueListenableBuilder<bool>(
                    valueListenable: _isLoading,
                    builder: (context, isLoading, __) {
                      return GestureDetector(
                        onTap: (!isLoading && file == null)
                            ? _selectFile
                            : null,
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
                              child: isLoading
                                  ? const SizedBox(
                                      height: 100,
                                      child: Center(
                                        child: Column(
                                          spacing: 10,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.blue,
                                            ),
                                            Text("Uploading...."),
                                          ],
                                        ),
                                      ),
                                    )
                                  : file == null
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
                  );
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BlocConsumer<AddResourceCubit, AddResourceStates>(
        listener: (context, state) {
          if (state is AddResourceSuccess) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  title: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Lottie.asset(
                        'assets/lottie/successfully.json',
                        width: 160,
                        height: 120,
                        repeat: true,
                      ),
                      Text(
                        state.successModel.message ??
                            "Your resource is under review. Once it’s approved, it will be available in the Study Zone.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontFamily: 'segeo',
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    CustomAppButton1(
                      text: "Okay",
                      onPlusTap: () {
                        context.read<TagsCubit>().getStudyZoneTags("");
                        Navigator.of(context).pop();
                        context.pop(); // Now pop the page AFTER user taps Okay
                      },
                    ),
                  ],
                );
              },
            );

            context.read<StudyZoneCampusCubit>().fetchStudyZoneCampus(
              "",
              "",
              "",
            );
          } else if (state is AddResourceFailure) {
            CustomSnackBar1.show(context, state.error);
          }
        },

        builder: (context, state) {
          final isLoading = state is AddResourceLoading;
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: CustomAppButton1(
                text: "Submit",
                isLoading: isLoading,
                onPlusTap: () {
                  if (_formKey.currentState!.validate()) {
                    final imagefile = _imageFile.value;
                    final file = _pickedFile.value;

                    if (file == null) {
                      CustomSnackBar1.show(
                        context,
                        "Please upload a resource file.",
                      );
                      return;
                    }

                    final isHighlighted = _isHighlighted.value;
                    final anonymous = _anonymousNotifier.value;

                    Map<String, dynamic> data = {
                      "name": _resourceNameController.text,
                      "description": _aboutController.text,
                      "tag[]": _selectedTags,
                    };

                    if (imagefile != null) {
                      data["image"] = imagefile.path;
                    }
                    if (file != null) {
                      data["file_pdf"] = file.path;
                    }

                    context.read<AddResourceCubit>().addResource(data, "");
                  }
                },

                // onPlusTap: () {
                //   if (_formKey.currentState!.validate()) {
                //     final imagefile = _imageFile.value;
                //     final file = _pickedFile.value;
                //     final isHighlighted = _isHighlighted.value;
                //     final anonymous = _anonymousNotifier.value;
                //
                //     if (imagefile == null && file == null) {
                //       return;
                //     }
                //
                //     Map<String, dynamic> data = {
                //       "name": _resourceNameController.text,
                //       "description": _aboutController.text,
                //       "tag[]": _selectedTags,
                //     };
                //     if (imagefile != null) {
                //       data["image"] = imagefile.path;
                //     }
                //     if (file != null) {
                //       data["file_pdf"] = file.path;
                //     }
                //     context.read<AddResourceCubit>().addResource(data, "");
                //   }
                // },
              ),
            ),
          );
        },
      ),
    );
  }
}
