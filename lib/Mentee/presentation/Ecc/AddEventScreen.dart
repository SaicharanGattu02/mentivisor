import 'dart:async';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:mentivisor/Components/CustomAppButton.dart';
import 'package:mentivisor/Components/CustomSnackBar.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import 'package:mentivisor/Mentee/data/cubits/AddECC/add_ecc_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/AddECC/add_ecc_states.dart';
import 'package:mentivisor/Mentee/data/cubits/EccTags/tags_states.dart';
import 'package:mentivisor/Mentee/data/cubits/HighlightedCoins/highlighted_coins_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/HighlightedCoins/highlighted_coins_state.dart';
import 'package:mentivisor/utils/AppLogger.dart';
import 'package:path_provider/path_provider.dart';
import '../../../Components/CommonLoader.dart';
import '../../../utils/color_constants.dart';
import '../../../utils/constants.dart';
import '../../data/cubits/ECC/ecc_cubit.dart';

import '../../data/cubits/EccTags/tags_cubit.dart';
import '../Widgets/CommonImgeWidget.dart';
import '../Widgets/common_widgets.dart';

class AddEventScreen extends StatefulWidget {
  final String type;
  AddEventScreen({super.key, required this.type});
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
  final ValueNotifier<File?> _pickedFile = ValueNotifier<File?>(null);
  final ValueNotifier<bool> _isHighlighted = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _useDefaultImage = ValueNotifier<bool>(false);
  final ValueNotifier<String> selectedDateStr = ValueNotifier<String>('');
  final ValueNotifier<String> highlitedCoinValue = ValueNotifier<String>('');
  final ValueNotifier<String> selectedTimeStr = ValueNotifier<String>('');
  final ValueNotifier<String> selectedTabIndex = ValueNotifier<String>('event');
  final ValueNotifier<File?> _imageFile = ValueNotifier<File?>(null);
  ValueNotifier<bool> enoughBalance = ValueNotifier<bool>(true);
  final searchController = TextEditingController();
  Timer? _debounce;
  List<String> _selectedTags = [];
  List<String> _customTags = [];

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

  Future<void> _selectImage() async {
    final pickedImage = await ImagePickerHelper.pickImageBottomSheet(context);

    if (pickedImage != null && mounted) {
      setState(() {
        _imageFile.value = pickedImage;
      });
    }
  }

  void _cancelImage() {
    _imageFile.value = null;
  }

  @override
  void initState() {
    AppLogger.info("tag::${widget.type}");
    searchController.clear();
    context.read<EccTagsCubit>().getEccTags("");
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
              ValueListenableBuilder<String>(
                valueListenable: selectedTabIndex,
                builder: (context, selectedValue, _) {
                  final label = capitalize(selectedValue);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildCustomLabel('$label Name'),
                      buildCustomTextField(
                        controller: _eventNameController,
                        hint: "$label Name",
                        validator: (value) {
                          if (value!.isEmpty) return '$label Name is required';
                          return null;
                        },
                      ),
                    ],
                  );
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
              buildCustomLabel('Ecc Tags'),
              const SizedBox(height: 8),

              SizedBox(
                height: 48,
                child: TextField(
                  controller: searchController,
                  cursorColor: primarycolor,
                  onChanged: (query) {
                    if (_debounce?.isActive ?? false) _debounce!.cancel();
                    _debounce = Timer(const Duration(milliseconds: 300), () {
                      context.read<EccTagsCubit>().getEccTags(query);
                    });
                  },
                  style: TextStyle(fontFamily: "segeo", fontSize: 15),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    hoverColor: Colors.white,
                    hintText: "Search Ecc Tags here",
                    hintStyle: const TextStyle(color: Colors.grey),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.only(right: 33, left: 20),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              BlocBuilder<EccTagsCubit, EccTagsState>(
                builder: (context, state) {
                  if (state is EccTagsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: primarycolor,
                        strokeWidth: 1.5,
                      ),
                    );
                  } else if (state is EccTagsLoaded) {
                    final allTags = [...state.tagsModel.data!, ..._customTags];
                    if (allTags.isEmpty) {
                      return Center(child: Text("No Ecc Tags Found!"));
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
                            "Select Ecc Tags",
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
                              final isSelected = _selectedTags.contains(tag);
                              return ChoiceChip(
                                label: Text(
                                  tag,
                                  style: TextStyle(
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
                                      _selectedTags.add(tag);
                                    } else {
                                      _selectedTags.remove(tag);
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
                  } else if (state is EccTagsFailure) {
                    return Center(child: Text("No Data"));
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
                        "Selected Ecc Tags",
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
                              style: const TextStyle(
                                color: Color(0xff333333),
                                fontFamily: 'segeo',
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                            side: BorderSide(color: Colors.blue.shade50),
                            backgroundColor: Colors.blue.shade50,
                            deleteIcon: const Icon(Icons.close, size: 16),
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

              // ValueListenableBuilder<bool>(
              //   valueListenable: _isHighlighted,
              //   builder: (context, value, _) {
              //     return Row(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Checkbox(
              //           value: value,
              //           onChanged: (val) {
              //             if (val != null) _isHighlighted.value = val;
              //           },
              //         ),
              //         Expanded(
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Text(
              //                 'Highlight Post',
              //                 style: TextStyle(
              //                   fontFamily: 'segeo',
              //                   fontWeight: FontWeight.w600,
              //                   color: Color(0xff333333),
              //                   fontSize: 14,
              //                 ),
              //               ),
              //               const SizedBox(height: 8),
              //               BlocBuilder<
              //                 HighlightedCoinsCubit,
              //                 HighlightedCoinsState
              //               >(
              //                 builder: (context, state) {
              //                   if (state is GetHighlightedCoinsLoading) {
              //                     return Center(
              //                       child: DottedProgressWithLogo(),
              //                     );
              //                   } else if (state is GetHighlightedCoinsLoaded) {
              //                     final coins =
              //                         (state.highlightedCoinsModel.data !=
              //                                 null &&
              //                             state
              //                                 .highlightedCoinsModel
              //                                 .data!
              //                                 .isNotEmpty)
              //                         ? state
              //                               .highlightedCoinsModel
              //                               .data!
              //                               .first
              //                               .coins
              //                         : "0";
              //                     highlitedCoinValue.value = coins ?? "";
              //                     final requiredCoins =
              //                         int.tryParse(coins.toString()) ?? 0;
              //                     final availableCoins =
              //                         AppState.coinsNotifier.value;
              //                     AppLogger.info(
              //                       "availableCoins:${availableCoins}",
              //                     );
              //                     AppLogger.info("requiredCoins:${coins}");
              //                     if (_isHighlighted.value) {
              //                       final bool coinsValue =
              //                           availableCoins >= requiredCoins;
              //                       if (coinsValue == true) {
              //                         AppLogger.info(
              //                           "coinsValue:${coinsValue}",
              //                         );
              //                         enoughBalance.value = true;
              //                       } else {
              //                         enoughBalance.value = false;
              //                       }
              //                       AppLogger.info(
              //                         "enoughBalance:${enoughBalance.value}",
              //                       );
              //                     } else {
              //                       enoughBalance.value = true;
              //                       AppLogger.info(
              //                         "enoughBalance:${enoughBalance.value}",
              //                       );
              //                     }
              //                     return Text(
              //                       'Make your post Highlight with $coins coins for 1 day',
              //                       style: TextStyle(
              //                         fontFamily: 'segeo',
              //                         fontWeight: FontWeight.w400,
              //                         color: Color(0xff666666),
              //                         fontSize: 14,
              //                       ),
              //                     );
              //                   } else if (state
              //                       is GetHighlightedCoinsFailure) {
              //                     return Text(state.msg);
              //                   }
              //                   return const Text("No Data");
              //                 },
              //               ),
              //             ],
              //           ),
              //         ),
              //         // const SizedBox(width: 8),
              //         Image.asset(
              //           'assets/images/GoldCoins.png',
              //           width: 16,
              //           height: 16,
              //         ),
              //         const SizedBox(width: 4),
              //         ValueListenableBuilder<int>(
              //           valueListenable: AppState.coinsNotifier,
              //           builder: (context, coins, child) {
              //             return RichText(
              //               text: TextSpan(
              //                 children: [
              //                   const TextSpan(
              //                     text: "Available coins ",
              //                     style: TextStyle(
              //                       fontFamily: 'segeo',
              //                       fontWeight: FontWeight.w400,
              //                       fontSize: 12,
              //                       color: Color(0xff333333),
              //                     ),
              //                   ),
              //                   TextSpan(
              //                     text: coins.toString(),
              //                     style: const TextStyle(
              //                       fontFamily: 'segeo',
              //                       fontWeight: FontWeight.w600,
              //                       fontSize: 16,
              //                       color: Color(0xff333333),
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             );
              //           },
              //         ),
              //       ],
              //     );
              //   },
              // ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: SafeArea(
      //   child: Padding(
      //     padding: EdgeInsetsGeometry.fromLTRB(16, 20, 16, 16),
      //     child: Column(
      //       mainAxisSize: MainAxisSize.min,
      //       children: [
      //         Row(
      //           mainAxisSize: MainAxisSize.min,
      //           spacing: 10,
      //           children: [
      //             Expanded(
      //               child: CustomOutlinedButton(
      //                 text: "Cancel",
      //                 radius: 24,
      //                 onTap: () {
      //                   context.pop();
      //                 },
      //               ),
      //             ),
      //             ValueListenableBuilder<bool>(
      //               valueListenable: enoughBalance,
      //               builder: (context, value, child) {
      //                 final enough_coins = value;
      //                 AppLogger.info("enough_coins:${enough_coins}");
      //                 return Expanded(
      //                   child: BlocConsumer<AddEccCubit, AddEccStates>(
      //                     listener: (context, state) async {
      //                       if (state is AddEccSuccess) {
      //                         if (_isHighlighted.value) {
      //                           final requiredCoins =
      //                               int.tryParse(highlitedCoinValue.value) ?? 0;
      //                           await context.read<MenteeProfileCubit>().fetchMenteeProfile();
      //                           enoughBalance.value =
      //                               AppState.coinsNotifier.value >=
      //                               requiredCoins;
      //                         }
      //                         context.read<ECCCubit>().getECC(
      //                           "",
      //                           "${widget.type}",
      //                           "",
      //                         );
      //                         Future.microtask(() => context.pop());
      //                       } else if (state is AddEccFailure) {
      //                         CustomSnackBar1.show(context, state.error);
      //                       }
      //                     },
      //
      //                     builder: (context, state) {
      //                       final isLoading = state is AddEccLoading;
      //                       return CustomAppButton1(
      //                         text: "Submit",
      //                         isLoading: isLoading,
      //                         onPlusTap: () {
      //                           if (enough_coins == false) {
      //                             showDialog(
      //                               context: context,
      //                               builder: (context) => AlertDialog(
      //                                 shape: RoundedRectangleBorder(
      //                                   borderRadius: BorderRadius.circular(16),
      //                                 ),
      //                                 title: const Text(
      //                                   "Insufficient Coins",
      //                                   style: TextStyle(
      //                                     fontWeight: FontWeight.bold,
      //                                     fontSize: 18,
      //                                     color: Colors.redAccent,
      //                                   ),
      //                                 ),
      //                                 content: const Text(
      //                                   "You don’t have enough coins to book this session.\n\nPlease purchase more coins to continue.",
      //                                   style: TextStyle(
      //                                     fontSize: 14,
      //                                     color: Colors.black87,
      //                                   ),
      //                                 ),
      //                                 actions: [
      //                                   TextButton(
      //                                     onPressed: () =>
      //                                         Navigator.pop(context),
      //                                     child: const Text(
      //                                       "Cancel",
      //                                       style: TextStyle(
      //                                         color: Colors.grey,
      //                                       ),
      //                                     ),
      //                                   ),
      //                                   ElevatedButton(
      //                                     onPressed: () {
      //                                       context.push("/buy_coins_screens");
      //                                       Navigator.pop(context);
      //                                     },
      //                                     style: ElevatedButton.styleFrom(
      //                                       backgroundColor: Colors.orange,
      //                                       shape: RoundedRectangleBorder(
      //                                         borderRadius:
      //                                             BorderRadius.circular(8),
      //                                       ),
      //                                     ),
      //                                     child: const Text("Purchase Coins"),
      //                                   ),
      //                                 ],
      //                               ),
      //                             );
      //                             return;
      //                           } else {
      //                             if (_formKey.currentState!.validate()) {
      //                               final file = _imageFile.value;
      //                               final isHighlighted = _isHighlighted.value;
      //
      //                               final Map<String, dynamic> data = {
      //                                 "name": _eventNameController.text,
      //                                 "location": _locationController.text,
      //                                 "type": selectedTabIndex.value,
      //                                 "time": selectedTimeStr.value,
      //                                 "college": _collegeNameController.text,
      //                                 "description": _descriptionController.text,
      //                                 "dateofevent": selectedDateStr.value,
      //                                 // "popular": isHighlighted ? 1 : 0,
      //                                 "link": _eventLinkController.text,
      //                               };
      //
      //                               if (file != null) {
      //                                 data["image"] = file.path;
      //                               }
      //                               if (isHighlighted == true) {
      //                                 data["coins"] =
      //                                     double.tryParse(
      //                                       highlitedCoinValue.value,
      //                                     )?.toInt() ??
      //                                     0;
      //                               }
      //
      //                               context.read<AddEccCubit>().addEcc(data);
      //                             }
      //                           }
      //                         },
      //                       );
      //                     },
      //                   ),
      //                 );
      //               },
      //             ),
      //           ],
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
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
                  Expanded(
                    child: BlocConsumer<AddEccCubit, AddEccStates>(
                      listener: (context, state) async {
                        if (state is AddEccSuccess) {
                          context.read<ECCCubit>().getECC(
                            "",
                            "${widget.type}",
                            "",
                          );
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
                                          "Your event is under review. Once it’s approved, it will be visible in the ECC section",
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
                                      context.read<EccTagsCubit>().getEccTags(
                                        "${widget.type}",
                                      );
                                      Navigator.of(
                                        context,
                                      ).pop(); // Closes the dialog
                                      context.pop(); // Now safely pop the page
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else if (state is AddEccFailure) {
                          CustomSnackBar1.show(context, state.error);
                        }
                      },
                      builder: (context, state) {
                        final isLoading = state is AddEccLoading;
                        return CustomAppButton1(
                          text: "Submit",
                          isLoading: isLoading,
                          onPlusTap: () {
                            if (_formKey.currentState!.validate()) {
                              final file = _imageFile.value;
                              final Map<String, dynamic> data = {
                                "name": _eventNameController.text,
                                "location": _locationController.text,
                                "type": selectedTabIndex.value,
                                "time": selectedTimeStr.value,
                                "college": _collegeNameController.text,
                                "description": _descriptionController.text,
                                "dateofevent": selectedDateStr.value,
                                // "popular": isHighlighted ? 1 : 0,
                                "link": _eventLinkController.text,
                                "tag[]": _selectedTags,
                              };

                              if (file != null) {
                                data["image"] = file.path;
                              }
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

  // Future<void> _pickImage() async {
  //   if (!mounted) return;
  //   showModalBottomSheet(
  //     context: context,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
  //     ),
  //     backgroundColor: Colors.white,
  //     builder: (BuildContext ctx) {
  //       return SafeArea(
  //         child: Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             crossAxisAlignment: CrossAxisAlignment.stretch,
  //             children: [
  //               Center(
  //                 child: Container(
  //                   width: 40,
  //                   height: 4,
  //                   margin: const EdgeInsets.symmetric(vertical: 8),
  //                   decoration: BoxDecoration(
  //                     color: const Color(0xFF315DEA).withOpacity(0.3),
  //                     borderRadius: BorderRadius.circular(2),
  //                   ),
  //                 ),
  //               ),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.end,
  //                 children: [
  //                   IconButton(
  //                     icon: const Icon(Icons.close, color: Colors.red),
  //                     onPressed: () => Navigator.pop(ctx),
  //                   ),
  //                 ],
  //               ),
  //               ListTile(
  //                 leading: const Icon(
  //                   Icons.photo_library,
  //                   color: Color(0xff315DEA),
  //                 ),
  //                 title: const Text(
  //                   'Choose from Gallery',
  //                   style: TextStyle(fontSize: 16, color: Colors.black87),
  //                 ),
  //                 onTap: () {
  //                   Navigator.pop(ctx);
  //                   _pickImageFromGallery();
  //                 },
  //               ),
  //               ListTile(
  //                 leading: const Icon(
  //                   Icons.camera_alt,
  //                   color: Color(0xff315DEA),
  //                 ),
  //                 title: const Text(
  //                   'Take a Photo',
  //                   style: TextStyle(fontSize: 16, color: Colors.black87),
  //                 ),
  //                 onTap: () {
  //                   Navigator.pop(ctx);
  //                   _pickImageFromCamera();
  //                 },
  //               ),
  //               const SizedBox(height: 8),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

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
