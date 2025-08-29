import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';

import '../../../Components/CommonLoader.dart';
import '../../../Components/CustomAppButton.dart';
import '../../../Components/CustomSnackBar.dart';
import '../../../Components/CutomAppBar.dart';
import '../../../services/AuthService.dart';
import '../../../utils/AppLogger.dart';
import '../../../utils/ImageUtils.dart';
import '../../../utils/constants.dart';
import '../../data/cubits/AddCommunityPost/add_communitypost_cubit.dart';
import '../../data/cubits/AddCommunityPost/add_communitypost_states.dart';
import '../../data/cubits/CommunityPosts/CommunityPostsCubit.dart';
import '../../data/cubits/CommunityTags/community_tags_cubit.dart';
import '../../data/cubits/CommunityTags/community_tags_states.dart';
import '../../data/cubits/HighlightedCoins/highlighted_coins_cubit.dart';
import '../../data/cubits/HighlightedCoins/highlighted_coins_state.dart';
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
  ValueNotifier<bool> enoughBalance = ValueNotifier<bool>(true);

  final ImagePicker _picker = ImagePicker();
  List<String> _selectedTags = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([
        context.read<HighlightedCoinsCubit>().highlitedCoins("community"),
        context.read<CommunityTagsCubit>().getCommunityTags(),
      ]);
    });
  }

  @override
  void dispose() {
    _headingController.dispose();
    _describeController.dispose();
    _tagController.dispose();
    _imageFile.dispose();
    _isHighlighted.dispose();
    _anonymousNotifier.dispose();
    super.dispose();
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

  Future<void> _pickImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      final File raw = File(pickedFile.path);
      final File? compressed = await ImageUtils.compressImage(raw);
      if (!mounted) return;
      if (compressed != null) _imageFile.value = compressed;
    }
  }

  Future<void> _pickImageFromCamera() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      final File raw = File(pickedFile.path);
      final File? compressed = await ImageUtils.compressImage(raw);
      if (!mounted) return;
      if (compressed != null) _imageFile.value = compressed;
    }
  }

  void _cancelImage() {
    _imageFile.value = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar1(title: "Add Post", actions: const []),
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

              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Suggested",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: 'segeo',
                        fontSize: 14,
                        color: Color(0xff374151E5).withOpacity(0.9),
                      ),
                    ),
                    SizedBox(height: 12),
                    BlocBuilder<CommunityTagsCubit, CommunityTagsStates>(
                      builder: (context, state) {
                        if (state is CommunityTagsLoading) {
                          return const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          );
                        } else if (state is CommunityTagsLoaded) {
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
                          return const Text("No Tags Found");
                        }
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

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
                      radius: const Radius.circular(36),
                      color: Colors.grey,
                      strokeWidth: 1.5,
                      dashPattern: const [6, 3],
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(36),
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
                                        "Upload image in 16:9 or 4:3",
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
                                      height: 180,
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
                                  highlitedCoinValue.value = coins ?? "";
                                  final requiredCoins =
                                      int.tryParse(coins.toString()) ?? 0;
                                  final availableCoins = AppState.coinsNotifier.value;
                                  AppLogger.info(
                                    "availableCoins:${availableCoins}",
                                  );
                                  AppLogger.info("requiredCoins:${coins}");
                                  if (_isHighlighted.value) {
                                    final bool coinsValue =
                                        availableCoins >= requiredCoins;
                                    if (coinsValue == true) {
                                      AppLogger.info(
                                        "coinsValue:${coinsValue}",
                                      );
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
                            return const Text(
                              "Loading...",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                          final coins = int.tryParse(snapshot.data ?? "0") ?? 0;
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
                      ),
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
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 36),
          child: ValueListenableBuilder<bool>(
            valueListenable: enoughBalance,
            builder: (context, enough_coins, _) {
              AppLogger.info("enough_coins:$enough_coins");
              return Expanded(
                child: BlocConsumer<AddCommunityPostCubit, AddCommunityPostStates>(
                  listener: (context, state) {
                    if (state is AddCommunityPostLoaded) {
                      context.read<CommunityPostsCubit>().getCommunityPosts(
                        "",
                        "${widget.type}",
                      );
                      if (!mounted) return;
                      context.pop();
                    } else if (state is AddCommunityPostFailure) {
                      if (!mounted) return;
                      CustomSnackBar1.show(context, state.error);
                    }
                  },
                  builder: (context, state) {
                    final isLoading = state is AddCommunityPostLoading;

                    return CustomAppButton1(
                      text: "Post It",
                      isLoading: isLoading,
                      onPlusTap: () {
                        if (!enough_coins) {
                          // show insufficient coins dialog
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
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text("Purchase Coins"),
                                ),
                              ],
                            ),
                          );
                          return;
                        }
                        FocusScope.of(context).unfocus();
                        if (!(_formKey.currentState?.validate() ?? false))
                          return;

                        final isHighlighted = _isHighlighted.value;
                        final anonymous = _anonymousNotifier.value;
                        final file = _imageFile.value;

                        final Map<String, dynamic> data = {
                          "heading": _headingController.text.trim(),
                          "description": _describeController.text.trim(),
                          "anonymous": anonymous ? 1 : 0,
                          "popular": isHighlighted ? 1 : 0,
                          "tags[]": _selectedTags,
                        };

                        if (file != null) {
                          data["image"] = file.path;
                        }
                        if (isHighlighted) {
                          data["coins"] =
                              double.tryParse(
                                highlitedCoinValue.value,
                              )?.toInt() ??
                              0;
                        }

                        context.read<AddCommunityPostCubit>().addCommunityPost(
                          data,
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
