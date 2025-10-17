import 'dart:async';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../Components/CommonLoader.dart';
import '../../../Components/CustomAppButton.dart';
import '../../../Components/CustomSnackBar.dart';
import '../../../Components/CutomAppBar.dart';
import '../../../services/AuthService.dart';
import '../../../utils/AppLogger.dart';
import '../../../utils/ImageUtils.dart';
import '../../../utils/color_constants.dart';
import '../../../utils/constants.dart';
import '../../data/cubits/AddCommunityPost/add_communitypost_cubit.dart';
import '../../data/cubits/AddCommunityPost/add_communitypost_states.dart';
import '../../data/cubits/CommunityPosts/CommunityPostsCubit.dart';
import '../../data/cubits/CommunityTags/community_tags_cubit.dart';
import '../../data/cubits/CommunityTags/community_tags_states.dart';
import '../../data/cubits/HighlightedCoins/highlighted_coins_cubit.dart';
import '../../data/cubits/HighlightedCoins/highlighted_coins_state.dart';
import '../../data/cubits/MenteeProfile/GetMenteeProfile/MenteeProfileCubit.dart';
import '../../data/cubits/Tags/TagsSearch/tags_search_cubit.dart';
import '../../data/cubits/Tags/TagsSearch/tags_search_states.dart';
import '../Widgets/common_widgets.dart';

class AddPostScreen extends StatefulWidget {
  final String type;
  const AddPostScreen({Key? key, required this.type}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _headingController = TextEditingController();
  final _describeController = TextEditingController();
  final _tagController = TextEditingController();

  final ValueNotifier<File?> _imageFile = ValueNotifier<File?>(null);
  final ValueNotifier<bool> _isHighlighted = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _anonymousNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<String> highlitedCoinValue = ValueNotifier<String>('');
  final ValueNotifier<int> AvailableCoins = ValueNotifier<int>(0);
  ValueNotifier<bool> enoughBalance = ValueNotifier<bool>(true);

  final ImagePicker _picker = ImagePicker();
  final searchController = TextEditingController();
  Timer? _debounce;
  List<String> _selectedTags = [];
  // List<String> _customTags = [];

  @override
  void initState() {
    super.initState();
    searchController.clear();
    context.read<HighlightedCoinsCubit>().highlitedCoins("community");
  }

  @override
  void dispose() {
    super.dispose();
    _headingController.dispose();
    _describeController.dispose();
    _tagController.dispose();
    _imageFile.dispose();
    _isHighlighted.dispose();
    _anonymousNotifier.dispose();
  }

  Future<void> _pickImage() async {
    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF315DEA).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                ListTile(
                  leading: const Icon(
                    Icons.photo_library,
                    color: Color(0xff315DEA),
                  ),
                  title: const Text(
                    'Choose from Gallery',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickImageFromGallery();
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.camera_alt,
                    color: Color(0xff315DEA),
                  ),
                  title: const Text(
                    'Take a Photo',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
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

  Future<File?> _pickValidateAndResize(
    BuildContext context, {
    required ImageSource source,
    int targetWidth = 384,
    double tolerancePct = 0.10, // 10% around 16:9
    int? minSourceWidth, // e.g. 800 to avoid tiny images
  }) async {
    final XFile? picked = await _picker.pickImage(source: source);
    if (picked == null) return null;

    final raw = File(picked.path);

    final ok = await ImageUtils1.isAcceptable16by9(
      raw,
      tolerancePct: tolerancePct,
      minWidth: minSourceWidth,
    );

    if (!ok) {
      // Clear message explaining the constraint
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please pick a landscape photo close to 16:9. '
            'Portrait (9:16) images are not allowed.',
          ),
        ),
      );
      return null;
    }

    // Safe to resize to true 16:9
    final resized = await ImageUtils1.resizeTo16by9(
      raw,
      targetWidth: targetWidth,
    );
    return resized;
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (!mounted) return;

    if (pickedFile != null) {
      _imageFile.value = File(pickedFile.path);
    }
  }

  Future<void> _pickImageFromCamera() async {
    final exact = await _pickValidateAndResize(
      context,
      source: ImageSource.camera,
      targetWidth: 384,
      tolerancePct: 0.10,
      minSourceWidth: 800,
    );
    if (!mounted) return;
    if (exact != null) _imageFile.value = exact;
  }

  void _cancelImage() {
    _imageFile.value = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar1(title: "Add Community Post", actions: const []),
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
                hint: "Write a heading",
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Heading is required';
                  }
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
                decoration: const InputDecoration(
                  hintText: 'Describe your Post',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Describe is required';
                  }
                  return null;
                },
              ),
              // const SizedBox(height: 10),
              //
              // buildCustomLabel('Tags'),
              // const SizedBox(height: 8),
              //
              // SizedBox(
              //   height: 48,
              //   child: TextField(
              //     controller: searchController,
              //     cursorColor: primarycolor,
              //     onChanged: (query) {
              //       if (_debounce?.isActive ?? false) _debounce!.cancel();
              //       _debounce = Timer(const Duration(milliseconds: 300), () {
              //         context.read<TagsSearchCubit>().getTagsSearch(query);
              //       });
              //     },
              //     style: TextStyle(fontFamily: "segeo", fontSize: 15),
              //     decoration: InputDecoration(
              //       prefixIcon: Icon(Icons.search, color: Colors.grey),
              //       hoverColor: Colors.white,
              //       hintText: "Search Tags here",
              //       hintStyle: const TextStyle(color: Colors.grey),
              //       fillColor: Colors.white,
              //       filled: true,
              //       contentPadding: EdgeInsets.only(right: 33, left: 20),
              //     ),
              //   ),
              // ),

              // const SizedBox(height: 8),

              // BlocBuilder<TagsSearchCubit, TagsSearchState>(
              //   builder: (context, state) {
              //     if (state is TagsSearchLoading) {
              //       return const Center(child: DottedProgressWithLogo());
              //     } else if (state is TagsSearchLoaded) {
              //       // Safe null check
              //       final apiTags = state.tagsModel.data ?? [];
              //       final allTags = [...apiTags, ..._customTags];
              //
              //       return Container(
              //         padding: const EdgeInsets.all(10),
              //         decoration: BoxDecoration(
              //           color: Colors.white,
              //           borderRadius: BorderRadius.circular(8),
              //         ),
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             const Text(
              //               "Select Tags",
              //               style: TextStyle(
              //                 color: Color(0xff374151),
              //                 fontSize: 14,
              //                 fontWeight: FontWeight.w600,
              //                 fontFamily: 'segeo',
              //               ),
              //             ),
              //             const SizedBox(height: 5),
              //             allTags.isEmpty
              //                 ? const Center(
              //                     child: Padding(
              //                       padding: EdgeInsets.symmetric(vertical: 10),
              //                       child: Text(
              //                         "No Tags Found!",
              //                         style: TextStyle(
              //                           fontSize: 14,
              //                           fontWeight: FontWeight.w500,
              //                         ),
              //                       ),
              //                     ),
              //                   )
              //                 : Wrap(
              //                     spacing: 5,
              //                     runSpacing: 0,
              //                     children: allTags.map((tag) {
              //                       final isSelected = _selectedTags.contains(
              //                         tag,
              //                       );
              //                       return ChoiceChip(
              //                         label: Text(
              //                           tag,
              //                           style: const TextStyle(
              //                             color: Color(0xff333333),
              //                             fontFamily: 'segeo',
              //                             fontWeight: FontWeight.w400,
              //                             fontSize: 12,
              //                           ),
              //                         ),
              //                         selected: isSelected,
              //                         onSelected: (selected) {
              //                           setState(() {
              //                             if (selected) {
              //                               _selectedTags.add(tag);
              //                             } else {
              //                               _selectedTags.remove(tag);
              //                             }
              //                           });
              //                         },
              //                         selectedColor: Colors.blue.shade100,
              //                         backgroundColor: Colors.white,
              //                         side: BorderSide(
              //                           color: isSelected
              //                               ? Colors.blue.shade100
              //                               : Colors.grey,
              //                         ),
              //                       );
              //                     }).toList(),
              //                   ),
              //           ],
              //         ),
              //       );
              //     } else if (state is TagsSearchFailure) {
              //       return Center(child: Text("Error: ${state.error}"));
              //     } else {
              //       return const SizedBox.shrink();
              //     }
              //   },
              // ),
              //
              // const SizedBox(height: 8),
              // if (_selectedTags.isNotEmpty) ...[
              //   Container(
              //     padding: const EdgeInsets.all(10),
              //     decoration: BoxDecoration(
              //       color: Colors.white,
              //       borderRadius: BorderRadius.circular(8),
              //     ),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         const Text(
              //           "Selected Tags",
              //           style: TextStyle(
              //             color: Color(0xff374151),
              //             fontSize: 14,
              //             fontWeight: FontWeight.w600,
              //             fontFamily: 'segeo',
              //           ),
              //         ),
              //         const SizedBox(height: 5),
              //         Wrap(
              //           spacing: 5,
              //           runSpacing: 0,
              //           children: _selectedTags.map((tag) {
              //             return Chip(
              //               label: Text(
              //                 tag,
              //                 style: const TextStyle(
              //                   color: Color(0xff333333),
              //                   fontFamily: 'segeo',
              //                   fontWeight: FontWeight.w500,
              //                   fontSize: 12,
              //                 ),
              //               ),
              //               side: BorderSide(color: Colors.blue.shade50),
              //               backgroundColor: Colors.blue.shade50,
              //               deleteIcon: const Icon(Icons.close, size: 16),
              //               onDeleted: () {
              //                 setState(() {
              //                   _selectedTags.remove(tag);
              //                 });
              //               },
              //             );
              //           }).toList(),
              //         ),
              //       ],
              //     ),
              //   ),
              // ] else ...[
              //   SizedBox.shrink(),
              // ],
              const SizedBox(height: 8),
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
                      radius: const Radius.circular(12),
                      color: Colors.grey,
                      strokeWidth: 1.5,
                      dashPattern: const [6, 3],
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(12),
                        ),
                        child: Container(
                          width: double.infinity,
                          color: const Color(0xffF5F5F5),
                          child: file == null
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text(
                                        "Upload image",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Color(0xff6D6D6D),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(
                                        Icons.upload_rounded,
                                        color: Color(0xff6D6D6D),
                                      ),
                                    ],
                                  ),
                                )
                              : Stack(
                                  children: [
                                    Image.file(
                                      file,
                                      width: double.infinity,
                                      height: 214,
                                      fit: BoxFit.cover,
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: GestureDetector(
                                        onTap: _cancelImage,
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

              SizedBox(height: 15),
              ValueListenableBuilder<bool>(
                valueListenable: _anonymousNotifier,
                builder: (context, value, _) {
                  return Row(
                    spacing: 8,
                    children: [
                      Text(
                        'Post this anonymous',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'segeo',
                          color: Color(0xff333333),
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
                            _anonymousNotifier.value = val;
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 5),
              Text(
                'Viewer can’t see who is posted it',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'segeo',
                  color: Color(0xff666666),
                ),
              ),
              SizedBox(height: 24),
              ValueListenableBuilder<bool>(
                valueListenable: enoughBalance,
                builder: (context, enough_coins, _) {
                  return ValueListenableBuilder<bool>(
                    valueListenable: _isHighlighted,
                    builder: (context, value, _) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: value,
                            onChanged: (val) {
                              AppLogger.info(
                                "Info  Enoug:${val},${enoughBalance.value}",
                              );

                              if (val == null) return;
                              _isHighlighted.value = val;
                              if (val && !enough_coins) {
                                AppLogger.info(
                                  "Info  Enoug :${val},${enough_coins}",
                                );
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    title: Text(
                                      "Insufficient Coins",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                    content: const Text(
                                      "You don’t have enough coins to post this.\n\nPlease purchase more coins to continue.",
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
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                        child: const Text("Purchase Coins"),
                                      ),
                                    ],
                                  ),
                                );
                                _isHighlighted.value = false;
                                enoughBalance.value = false;
                              }
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
                                SizedBox(height: 8),
                                BlocBuilder<
                                  HighlightedCoinsCubit,
                                  HighlightedCoinsState
                                >(
                                  builder: (context, state) {
                                    if (state is GetHighlightedCoinsLoading) {
                                      return Center(
                                        child: DottedProgressWithLogo(),
                                      );
                                    } else if (state
                                        is GetHighlightedCoinsLoaded) {
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
                                      highlitedCoinValue.value = coins ?? "";
                                      return Text(
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
                          FutureBuilder<String?>(
                            future: AuthService.getCoins(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                // if (AvailableCoins.value >= highlitedCoinValue.value) {
                                //   enoughBalance.value = true;
                                // } else {
                                //   enoughBalance.value = false;
                                // }
                                return const Text(
                                  "Loading...",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }
                              AvailableCoins.value =
                                  int.tryParse(snapshot.data ?? "0") ?? 0;
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
                                      text:
                                          AvailableCoins.value.toString() ??
                                          "0",
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
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 36),
          child: BlocConsumer<AddCommunityPostCubit, AddCommunityPostStates>(
            listener: (context, state) async {
              if (state is AddCommunityPostSuccess) {
                if (_isHighlighted.value) {
                  final requiredCoins =
                      int.tryParse(highlitedCoinValue.value) ?? 0;
                  await context.read<MenteeProfileCubit>().fetchMenteeProfile();
                  enoughBalance.value =
                      AppState.coinsNotifier.value >= requiredCoins;
                }

                context.read<CommunityPostsCubit>().getCommunityPosts(
                  "",
                  "${widget.type}",
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
                          const Text(
                            "Your post is under review. Once it’s approved, it will be visible to the community",
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
                            Navigator.of(context).pop(); // close the dialog
                            context.pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              } else if (state is AddCommunityPostFailure) {
                CustomSnackBar1.show(context, state.error);
              }
            },

            builder: (context, state) {
              final isLoading = state is AddCommunityPostLoading;

              return CustomAppButton1(
                text: "Post It",
                isLoading: isLoading,
                onPlusTap: () {
                  FocusScope.of(context).unfocus();
                  if (!(_formKey.currentState?.validate() ?? false)) return;
                  final isHighlighted = _isHighlighted.value;
                  final anonymous = _anonymousNotifier.value;
                  final file = _imageFile.value;

                  final Map<String, dynamic> data = {
                    "heading": _headingController.text.trim(),
                    "description": _describeController.text.trim(),
                    "anonymous": anonymous ? 1 : 0,
                    "popular": isHighlighted ? 1 : 0,
                    // "tags[]": _selectedTags,
                  };

                  if (file != null) {
                    data["image"] = file.path;
                  }
                  if (isHighlighted) {
                    data["coins"] =
                        double.tryParse(highlitedCoinValue.value)?.toInt() ?? 0;
                  }

                  context.read<AddCommunityPostCubit>().addCommunityPost(data);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
