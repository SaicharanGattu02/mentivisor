import 'dart:ffi';
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
import 'package:mentivisor/Mentee/data/cubits/HighlightedCoins/highlighted_coins_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/HighlightedCoins/highlighted_coins_state.dart';
import 'package:mentivisor/utils/AppLogger.dart';
import '../../../Components/CommonLoader.dart';
import '../../../utils/ImageUtils.dart';
import '../../../utils/color_constants.dart';
import '../../../utils/constants.dart';
import '../../data/cubits/CommunityPosts/CommunityPostsCubit.dart';
import '../../data/cubits/ECC/ecc_cubit.dart';
import '../Widgets/common_widgets.dart';

class AddEventScreen extends StatefulWidget {
  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _collegeNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _eventLinkController = TextEditingController();

  final ValueNotifier<bool> _isHighlighted = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _useDefaultImage = ValueNotifier<bool>(false);
  final ValueNotifier<String> selectedDateStr = ValueNotifier<String>('');
  final ValueNotifier<String> highlitedCoinValue = ValueNotifier<String>('');
  final ValueNotifier<String> selectedTimeStr = ValueNotifier<String>('');
  final ValueNotifier<String> selectedTabIndex = ValueNotifier<String>('event');
  final ValueNotifier<File?> _imageFile = ValueNotifier<File?>(null);
  ValueNotifier<bool> enoughBalance = ValueNotifier<bool>(true);


  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
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

      selectedTimeStr.value = formattedTime;
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
  void initState() {
    context.read<HighlightedCoinsCubit>().highlitedCoins("ecc");
    super.initState();
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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                child: Row(
                  children: [
                    _buildTab('Events', "event"),
                    _buildTab('Competitions', "competition"),
                    _buildTab('Challenges', "challenges"),
                  ],
                ),
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
                    onTap: () => _selectTime(context),
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
              buildCustomLabel('Description'),
              buildCustomTextField(
                controller: _descriptionController,
                hint: "Description",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Description is required';
                  }
                  return null;
                },
              ),

              buildCustomLabel('Event Link (optional)'),
              buildCustomTextField(
                controller: _eventLinkController,
                hint: "Event Link (optional)",
              ),
              SizedBox(height: 15),
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
                            ? _pickImage
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
                        ),
                      );
                    },
                  );
                },
              ),

              SizedBox(height: 15),
              ValueListenableBuilder<bool>(
                valueListenable: _useDefaultImage,
                builder: (context, value, _) {
                  return Row(
                    spacing: 8,
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
                        scale: 0.8, // ✅ makes the switch smaller
                        child: Switch(
                          value: value,
                          activeColor: Theme.of(
                            context,
                          ).primaryColor, // ✅ primary color
                          onChanged: (val) {
                            _useDefaultImage.value = val;
                          },
                        ),
                      ),


                    ],
                  );
                },
              ),
              ValueListenableBuilder<bool>(
                valueListenable: _isHighlighted,
                builder: (context, value, _) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: value,
                        onChanged: (val) {
                          if (val != null) _isHighlighted.value = val;
                        },
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Highlight Post',
                              style: TextStyle(
                                fontFamily: 'segeo',
                                fontWeight: FontWeight.w600,
                                color: Color(0xff333333),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            BlocBuilder<
                              HighlightedCoinsCubit,
                              HighlightedCoinsState
                            >(
                              builder: (context, state) {
                                if (state is GetHighlightedCoinsLoading) {
                                  return Center(
                                    child: DottedProgressWithLogo(),
                                  );
                                } else if (state is GetHighlightedCoinsLoaded) {

                                  final coins =
                                      (state.highlightedCoinsModel.data !=
                                              null &&
                                          state
                                              .highlightedCoinsModel
                                              .data!
                                              .isNotEmpty)
                                      ? state
                                            .highlightedCoinsModel
                                            .data!
                                            .first
                                            .coins
                                      : "0";
                                  highlitedCoinValue.value=coins??"";
                                  final requiredCoins = int.tryParse(coins.toString()) ?? 0;
                                  final availableCoins = AppState.coins;
                                  AppLogger.info("availableCoins:${availableCoins}");
                                  AppLogger.info("requiredCoins:${coins}");
                                  if (_isHighlighted.value) {
                                    final bool coinsValue =
                                        availableCoins >= requiredCoins;
                                    if (coinsValue == true) {
                                      AppLogger.info("coinsValue:${coinsValue}");
                                      enoughBalance.value = true;
                                    } else {
                                      enoughBalance.value = false;
                                    }
                                    AppLogger.info(
                                      "enoughBalance:${enoughBalance.value}",
                                    );
                                  } else {
                                    enoughBalance.value = true;
                                    AppLogger.info(
                                      "enoughBalance:${enoughBalance.value}",
                                    );
                                  }

                                   Text(
                                    'Make your post Highlight with $coins coins for 1 day',
                                    style: TextStyle(
                                      fontFamily: 'segeo',
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff666666),
                                      fontSize: 14,
                                    ),
                                  );
                                } else if (state
                                    is GetHighlightedCoinsFailure) {
                                  return Text(state.msg);
                                }
                                return const Text("No Data");
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Image.asset(
                        'assets/images/GoldCoins.png',
                        width: 16,
                        height: 16,
                      ),
                      const SizedBox(width: 4),
                      StreamBuilder<int>(
                        stream: AppState.coinsStream,
                        initialData: AppState.coins,
                        builder: (context, snapshot) {
                          final coins = snapshot.data ?? 0;

                          return RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: "Available coins ",
                                  style: TextStyle(
                                    fontFamily: 'segeo',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: Color(0xff333333),
                                  ),
                                ),
                                TextSpan(
                                  text: coins.toString(),
                                  style: const TextStyle(
                                    fontFamily: 'segeo',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Color(0xff333333),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      )

                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.fromLTRB(16, 20, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 10,
                children: [
                  Expanded(
                    child: CustomOutlinedButton(
                      text: "Cancel",
                      radius: 24,
                      onTap: () {
                        context.pop();
                      },
                    ),
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: enoughBalance,
                    builder: (context, value, child) {
                      final enough_coins = value;
                      AppLogger.info("enough_coins:${enough_coins}");
                      return Expanded(
                        child: BlocConsumer<AddEccCubit, AddEccStates>(
                          listener: (context, state) {
                            if (state is AddEccLoaded) {
                              context
                                  .read<CommunityPostsCubit>()
                                  .getCommunityPosts("beyond", "all");
                              context
                                  .read<CommunityPostsCubit>()
                                  .getCommunityPosts("beyond", "upcoming");
                              context
                                  .read<CommunityPostsCubit>()
                                  .getCommunityPosts("beyond", "highlighted");
                              context.read<ECCCubit>().getECC("", "", "");
                              context.pop();
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
                                if (enough_coins==false) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      title: const Text(
                                        "Insufficient Coins",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                      content: const Text(
                                        "You don’t have enough coins to book this session.\n\nPlease purchase more coins to continue.",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: const Text(
                                            "Cancel",
                                            style: TextStyle(color: Colors.grey),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            context.push("/buy_coins_screens");
                                            Navigator.pop(context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.orange,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text("Purchase Coins"),
                                        ),
                                      ],
                                    ),
                                  );
                                  return;
                                }else{
                                  if (_formKey.currentState!.validate()) {
                                    final file = _imageFile.value;
                                    final isHighlighted = _isHighlighted.value;

                                    final Map<String, dynamic> data = {
                                      "name": _eventNameController.text,
                                      "location": _locationController.text,
                                      "type": selectedTabIndex.value,
                                      "time": selectedTimeStr.value,
                                      "college": _collegeNameController.text,
                                      "description": _descriptionController.text,
                                      "dateofevent": selectedDateStr.value,
                                      "popular": isHighlighted ? 1 : 0,
                                      "link": _eventLinkController.text,
                                    };

                                    if (file != null) {
                                      data["image"] = file.path;
                                    }
                                    if (isHighlighted) {
                                      data["coins"] = double.tryParse(highlitedCoinValue.value)?.toInt() ?? 0;
                                    }

                                    context.read<AddEccCubit>().addEcc(data);
                                  }
                                }


                              },

                              // onPlusTap: enough_coins
                              //     ? () {
                              //         if (_formKey.currentState!.validate()) {
                              //           final file = _imageFile.value;
                              //           final isHighlighted =
                              //               _isHighlighted.value;
                              //           Map<String, dynamic> data = {
                              //             "name": _eventNameController.text,
                              //             "location": _locationController.text,
                              //             "type": selectedTabIndex.value,
                              //             "time": selectedTimeStr.value,
                              //             "college":
                              //                 _collegeNameController.text,
                              //             "description":
                              //                 _descriptionController.text,
                              //             "dateofevent": selectedDateStr.value,
                              //             "popular": isHighlighted ? 1 : 0,
                              //             "link": _eventLinkController.text,
                              //           };
                              //           if (file != null) {
                              //             data["image"] = file.path;
                              //           }
                              //           if (isHighlighted) {
                              //             data["coins"] = highlitedCoinValue.value;
                              //           }
                              //
                              //           context.read<AddEccCubit>().addEcc(
                              //             data,
                              //           );
                              //         }
                              //       }
                              //     : () {
                              //         showDialog(
                              //           context: context,
                              //           builder: (context) => AlertDialog(
                              //             shape: RoundedRectangleBorder(
                              //               borderRadius: BorderRadius.circular(
                              //                 16,
                              //               ),
                              //             ),
                              //             title: const Text(
                              //               "Insufficient Coins",
                              //               style: TextStyle(
                              //                 fontWeight: FontWeight.bold,
                              //                 fontSize: 18,
                              //                 color: Colors.redAccent,
                              //               ),
                              //             ),
                              //             content: const Text(
                              //               "You don’t have enough coins to book this session.\n\nPlease purchase more coins to continue.",
                              //               style: TextStyle(
                              //                 fontSize: 14,
                              //                 color: Colors.black87,
                              //               ),
                              //             ),
                              //             actions: [
                              //               TextButton(
                              //                 onPressed: () =>
                              //                     Navigator.pop(context),
                              //                 child: const Text(
                              //                   "Cancel",
                              //                   style: TextStyle(
                              //                     color: Colors.grey,
                              //                   ),
                              //                 ),
                              //               ),
                              //               ElevatedButton(
                              //                 onPressed: () {
                              //                   context.push(
                              //                     "/buy_coins_screens",
                              //                   );
                              //                   Navigator.pop(context);
                              //                 },
                              //                 style: ElevatedButton.styleFrom(
                              //                   backgroundColor: Colors.orange,
                              //                   shape: RoundedRectangleBorder(
                              //                     borderRadius:
                              //                         BorderRadius.circular(8),
                              //                   ),
                              //                 ),
                              //                 child: const Text(
                              //                   "Purchase Coins",
                              //                 ),
                              //               ),
                              //             ],
                              //           ),
                              //         );
                              //       },
                            );
                          },
                        ),
                      );
                    },
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
