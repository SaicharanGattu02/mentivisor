import 'dart:io';
import 'package:mentivisor/utils/color_constants.dart';
import 'package:path/path.dart' as path;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mentivisor/Components/CustomSnackBar.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import 'package:mentivisor/Mentee/data/cubits/BookSession/book_session_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/BookSession/book_session_states.dart';
import 'package:mentivisor/Mentee/data/cubits/MenteeProfile/GetMenteeProfile/MenteeProfileCubit.dart';
import 'package:mentivisor/Mentee/data/cubits/WeeklySlots/weekly_slots_cubit.dart';
import 'package:mentivisor/utils/AppLogger.dart';
import '../../Components/CustomAppButton.dart';
import '../../utils/spinkittsLoader.dart';
import '../Models/MentorProfileModel.dart';
import '../data/cubits/MenteeDashBoard/mentee_dashboard_cubit.dart';
import '../data/cubits/SelectSlot/select_slot_cubit.dart';
import '../data/cubits/SelectSlot/select_slot_states.dart';
import '../data/cubits/WeeklySlots/weekly_slots_states.dart';
import 'Widgets/CommonImgeWidget.dart';
import 'Widgets/DailySlotsSheet.dart';
import 'Widgets/DayCell.dart';

class BookSessionScreen extends StatefulWidget {
  final MentorData data;
  const BookSessionScreen({Key? key, required this.data}) : super(key: key);
  @override
  _BookSessionScreenState createState() => _BookSessionScreenState();
}

class _BookSessionScreenState extends State<BookSessionScreen> {
  bool showDetails = true;
  String? selectedDate;
  String? selectedTime;
  int? selectedSlotId;
  String _weekFilter = 'This Week';
  ValueNotifier<bool> enoughBalance = ValueNotifier<bool>(false);
  TextEditingController sessionController = TextEditingController();
  String? selectedFileName;
  String? selectedFilePath;
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  final ValueNotifier<File?> _pickedFile = ValueNotifier(null);
  @override
  void initState() {
    super.initState();
    AppLogger.info("Data: ${widget.data.user}");
    context.read<WeeklySlotsCubit>().getWeeklySlots(widget.data.id ?? 0);
  }

  void _toggleDetails() {
    setState(() {
      showDetails = !showDetails;
    });
  }

  // Future<void> pickFile() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: ['pdf'],
  //   );
  //
  //   if (result != null && result.files.single.path != null) {
  //     final file = result.files.single;
  //
  //     if (file.extension?.toLowerCase() == "pdf") {
  //       setState(() {
  //         selectedFilePath = file.path;
  //         selectedFileName = file.name;
  //       });
  //     } else {
  //       CustomSnackBar1.show(context, "Only PDF files are allowed.");
  //     }
  //   }
  // }
  Future<void> pickFile() async {
    _isLoading.value = true;

    try {
      final file = await FileImagePicker.pickPdfFile();
      if (file != null) {
        _pickedFile.value = file;
        AppLogger.info("Picked & compressed file: ${file.path}");
      }
    } catch (e) {
      debugPrint('File selection error: $e');
      CustomSnackBar1.show(context, "Failed to pick file");
    } finally {
      _isLoading.value = false;
    }
  }
  void removeFile() {
    _pickedFile.value = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar1(title: "Book Session", actions: []),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFAF5FF), Color(0xFFF5F6FF), Color(0xFFEFF6FF)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        BlocBuilder<WeeklySlotsCubit, WeeklySlotsStates>(
                          builder: (context, state) {
                            String heading = 'Available Dates';
                            if (state is WeeklySlotsLoaded) {
                              final days = state.weeklySlotsModel.days ?? [];
                              if (days.isNotEmpty) {
                                heading =
                                    'Available Dates in ${days.first.month ?? ''}';
                              }
                            }
                            return Text(
                              heading,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                        const Spacer(),
                        // Week Switcher (PopupMenu with gradient look)
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xffA258F7),
                                Color(0xff726CF7),
                                Color(0xff4280F6),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xffF5F5F5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: PopupMenuButton<String>(
                              onSelected: (value) {
                                setState(() => _weekFilter = value);
                                final week = value == 'Next Week'
                                    ? 'next'
                                    : 'this';
                                context.read<WeeklySlotsCubit>().getWeeklySlots(
                                  widget.data.id ?? 0,
                                  week: week,
                                );
                              },
                              itemBuilder: (context) => const [
                                PopupMenuItem<String>(
                                  value: 'This Week',
                                  child: Text('This Week'),
                                ),
                                PopupMenuItem<String>(
                                  value: 'Next Week',
                                  child: Text('Next Week'),
                                ),
                              ],
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ShaderMask(
                                    shaderCallback: (b) =>
                                        const LinearGradient(
                                          colors: [
                                            Color(0xffA258F7),
                                            Color(0xff726CF7),
                                            Color(0xff4280F6),
                                          ],
                                        ).createShader(
                                          Rect.fromLTWH(
                                            0,
                                            0,
                                            b.width,
                                            b.height,
                                          ),
                                        ),
                                    child: Text(
                                      _weekFilter,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  ShaderMask(
                                    shaderCallback: (b) =>
                                        const LinearGradient(
                                          colors: [
                                            Color(0xffA258F7),
                                            Color(0xff726CF7),
                                            Color(0xff4280F6),
                                          ],
                                        ).createShader(
                                          Rect.fromLTWH(
                                            0,
                                            0,
                                            b.width,
                                            b.height,
                                          ),
                                        ),
                                    child: const Icon(Icons.arrow_drop_down),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // BlocBuilder<WeeklySlotsCubit, WeeklySlotsStates>(
                    //   builder: (context, state) {
                    //     if (state is WeeklySlotsLoaded) {
                    //       final r = state.weeklySlotsModel.weekRange;
                    //       if (r?.start != null && r?.end != null) {
                    //         return Text(
                    //           '${r!.start} — ${r.end}',
                    //           style: const TextStyle(
                    //             fontSize: 12,
                    //             color: Color(0xFF6A6A6A),
                    //           ),
                    //         );
                    //       }
                    //     }
                    //     return const SizedBox.shrink();
                    //   },
                    // ),
                    // const SizedBox(height: 12),
                    BlocBuilder<WeeklySlotsCubit, WeeklySlotsStates>(
                      builder: (context, state) {
                        if (state is WeeklySlotsLoading) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        if (state is WeeklySlotsFailure) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              state.error,
                              style: TextStyle(color: Colors.red),
                            ),
                          );
                        }

                        if (state is WeeklySlotsLoaded) {
                          final days = state.weeklySlotsModel.days ?? [];
                          if (days.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Text('No days available this week'),
                            );
                          }

                          return LayoutBuilder(
                            builder: (context, c) {
                              final spacing = 8.0;
                              final count = days.length; // generally 7
                              final width =
                                  (c.maxWidth - spacing * (count - 1)) / count;

                              final today = DateTime.now();
                              final todayDate = DateTime(
                                today.year,
                                today.month,
                                today.day,
                              );

                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  for (final d in days)
                                    if (d.date != null) ...[
                                      Builder(
                                        builder: (context) {
                                          final dayDate = DateTime.parse(
                                            d.date!,
                                          );
                                          final onlyDate = DateTime(
                                            dayDate.year,
                                            dayDate.month,
                                            dayDate.day,
                                          );
                                          final isPast = onlyDate.isBefore(
                                            todayDate,
                                          );

                                          return SizedBox(
                                            width: width,
                                            child: IgnorePointer(
                                              ignoring: isPast,
                                              child: Opacity(
                                                opacity: isPast ? 0.5 : 1.0,
                                                child: DayCell(
                                                  dayAbbrev: d.day ?? '',
                                                  dayNum: d.dayNum ?? '',
                                                  month: d.month ?? '',
                                                  slotCount: d.slotCount ?? 0,
                                                  selected:
                                                      selectedDate == d.date,
                                                  onTap: () async {
                                                    setState(
                                                      () =>
                                                          selectedDate = d.date,
                                                    );

                                                    final picked =
                                                        await showDailySlotsBottomSheet(
                                                          context,
                                                          mentorId:
                                                              widget
                                                                  .data
                                                                  .userId ??
                                                              0,
                                                          date: d
                                                              .date!, // ISO date
                                                        );

                                                    if (picked == null) return;

                                                    setState(() {
                                                      selectedDate = d.date;
                                                      selectedTime =
                                                          picked.timeLabel;
                                                      selectedSlotId =
                                                          picked.id;
                                                    });

                                                    context
                                                        .read<SelectSlotCubit>()
                                                        .getSelectSlot(
                                                          widget.data.userId ??
                                                              0,
                                                          picked.id ?? 0,
                                                        );
                                                  },
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                ],
                              );
                            },
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // const SizedBox(height: 8),
              // Container(
              //   padding: const EdgeInsets.all(12),
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(12),
              //   ),
              //   child: Column(
              //     spacing: 16,
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         'Session Type',
              //         style: TextStyle(
              //           fontSize: 16,
              //           fontWeight: FontWeight.w600,
              //           fontFamily: 'segeo',
              //           color: Color(0xff020817),
              //         ),
              //       ),
              //       Row(
              //         children: [
              //           Image.asset(
              //             'assets/images/zoommeetimg.png',
              //             height: 36,
              //             width: 36,
              //           ),
              //            SizedBox(width: 8),
              //            Text(
              //             'Zoom',
              //             style: TextStyle(fontSize: 16, fontFamily: 'segeo',color: Color(0xff6B7280),fontWeight: FontWeight.w400),
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
              // const SizedBox(height: 24),
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Session Topic',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'segeo',
                          fontWeight: FontWeight.w400,
                          color: Color(0xff020817),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        height: 250,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xffDDDDDD),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: sessionController,
                                  maxLines: null,
                                  expands: true,
                                  decoration: const InputDecoration(
                                    isCollapsed: true,
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    hintText:
                                        "Describe what you'd like to discuss in this session...",
                                    hintStyle: TextStyle(color: Colors.grey),
                                  ),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: const Color(0xffF5F5F5),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ValueListenableBuilder<bool>(
                                      valueListenable: _isLoading, // from your existing controller
                                      builder: (context, isLoading, _) {
                                        if (isLoading) {
                                          return  Row(spacing: 10,
                                            children: [
                                              SizedBox(
                                                height: 18,
                                                width: 18,
                                                child: CircularProgressIndicator(strokeWidth: 1,color: primarycolor,),
                                              ),Text("compressing and uploading file.....",style: TextStyle(color: Color(0xff555555),fontFamily: "segeo",fontWeight: FontWeight.w400,fontSize: 12),)
                                            ],
                                          );
                                        }

                                        return Flexible(
                                          child: ValueListenableBuilder<File?>(
                                            valueListenable: _pickedFile,
                                            builder: (context, pickedFile, __) {
                                              return Row(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  if (pickedFile == null) ...[
                                                    GestureDetector(
                                                      onTap: pickFile,
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: const [
                                                          Text(
                                                            'Add Attachment',
                                                            style: TextStyle(
                                                              color: Color(0xff555555),
                                                              fontFamily: 'segeo',
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w400,
                                                            ),
                                                          ),
                                                          SizedBox(width: 6),
                                                          Icon(
                                                            Icons.attach_file,
                                                            color: Colors.grey,
                                                            size: 18,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ] else ...[
                                                    Flexible(
                                                      child: Text(
                                                        path.basename(pickedFile.path),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: const TextStyle(
                                                          color: Color(0xff333333),
                                                          fontFamily: 'segeo',
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 6),
                                                    GestureDetector(
                                                      onTap: removeFile,
                                                      child: const Icon(
                                                        Icons.close,
                                                        color: Colors.red,
                                                        size: 18,
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Booking Summary',
                      style: TextStyle(
                        color: Color(0xff333333),
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 16),
                    GestureDetector(
                      onTap: _toggleDetails,
                      child: Row(
                        children: [
                          Center(
                            child: CachedNetworkImage(
                              imageUrl: widget.data.user?.profilePicUrl ?? "",
                              imageBuilder: (context, imageProvider) =>
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: imageProvider,
                                  ),
                              placeholder: (context, url) => CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.grey,
                                child: SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: Center(
                                    child: spinkits.getSpinningLinespinkit(),
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const CircleAvatar(
                                    radius: 20,
                                    backgroundImage: AssetImage(
                                      "assets/images/profile.png",
                                    ),
                                  ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.data.user?.name ?? "",
                                style: TextStyle(
                                  color: Color(0xff333333),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                widget.data.user?.role ?? "",
                                style: TextStyle(
                                  color: Color(0xff666666),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (showDetails) ...[
                      const SizedBox(height: 16),
                      Divider(
                        color: Colors.grey.withOpacity(0.3),
                        thickness: 0.5,
                      ),
                      const SizedBox(height: 8),
                      BlocBuilder<SelectSlotCubit, SelectSlotsStates>(
                        builder: (context, state) {
                          if (state is SelectSlotLoading) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          if (state is SelectSlotFailure) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Text(
                                state.error,
                                style: const TextStyle(color: Colors.red),
                              ),
                            );
                          }
                          if (state is SelectSlotLoaded) {
                            final slot = state.selectSlotModel.slot;
                            final wallet = state.selectSlotModel.wallet;

                            final sessionCoins = wallet?.sessionCoins ?? 0;
                            final availableCoins = wallet?.availableCoins ?? 0;
                            final balanceCoins = wallet?.balanceCoins ?? 0;
                            enoughBalance.value = balanceCoins > 0;
                            AppLogger.info(
                              "EnoughBalance Updated After Frame :: ${enoughBalance.value}.",
                            );
                            Row _row(String label, int coins) => Row(
                              children: [
                                Text(label),
                                const Spacer(),
                                Image.asset(
                                  'assets/images/GoldCoins.png',
                                  width: 16,
                                  height: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  coins.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            );
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _row('Session Cost', sessionCoins),
                                const SizedBox(height: 8),
                                _row('Your Balance', availableCoins),
                                const SizedBox(height: 8),
                                Divider(
                                  color: Colors.grey.withOpacity(0.3),
                                  thickness: 0.5,
                                ),
                                const SizedBox(height: 8),
                                _row(
                                  'Remained',
                                  balanceCoins,
                                ), // can be negative

                                const SizedBox(height: 16),
                                if (slot != null) ...[
                                  Text(
                                    'Selected: ${slot.date ?? selectedDate ?? ""} • ${slot.timeLabel ?? selectedTime ?? ""}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF666666),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                ],
                              ],
                            );
                          }
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              'Pick a day and time to see session cost and wallet details.',
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                    ],
                  ],
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: selectedSlotId != null
          ? SafeArea(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: ValueListenableBuilder<bool>(
                  valueListenable: enoughBalance,
                  builder: (context, enough_coins, child) {
                    return BlocConsumer<
                      SessionBookingCubit,
                      SessionBookingStates
                    >(
                      listener: (context, state) {
                        if (state is SessionBookingLoaded) {
                          context
                              .read<MenteeProfileCubit>()
                              .fetchMenteeProfile();
                          context.pushReplacement(
                            '/payment_success?title=${Uri.encodeComponent("Your slot was booked successfully!")}&next=/upcoming_session',
                          );
                        } else if (state is SessionBookingFailure) {
                          CustomSnackBar1.show(context, state.error ?? "");
                        }
                      },
                      builder: (context, state) {
                        final isLoading = state is SessionBookingLoading;
                        return CustomAppButton1(
                          text: 'Book Session',
                          isLoading: isLoading,
                          onPlusTap: enough_coins
                              ? () {
                                  if (selectedSlotId != null) {
                                    final Map<String, dynamic> data = {
                                      "mentor_id": widget.data.userId ?? 0,
                                      "slot_id": selectedSlotId,
                                      "topic": sessionController.text.trim(),
                                    };
                                    if (selectedFilePath != null &&
                                        selectedFilePath!.isNotEmpty) {
                                      data["attachment"] = selectedFilePath;
                                    }

                                    context
                                        .read<SessionBookingCubit>()
                                        .sessionBooking(data);
                                  }
                                }
                              : () {
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
                                        "You don’t have enough coins to book this session.\n\nPlease purchase more coins to continue.",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text(
                                            "Cancel",
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            context.push(
                                              "/buy_coins_screens?mentor_id=${widget.data.userId ?? 0}&slot_id=${selectedSlotId}",
                                            );
                                            Navigator.pop(context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.orange,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text("Purchase Coins"),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                        );
                      },
                    );
                  },
                ),
              ),
            )
          : SizedBox.shrink(),
    );
  }
}
