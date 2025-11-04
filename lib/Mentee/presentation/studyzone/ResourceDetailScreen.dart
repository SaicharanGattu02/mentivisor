import 'dart:developer' as AppLogger;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CustomSnackBar.dart';
import 'package:mentivisor/Mentee/data/cubits/StudyZoneReport/StudyZoneReportCubit.dart';
import 'package:mentivisor/Mentee/data/cubits/StudyZoneReport/StudyZoneReportState.dart';
import 'package:mentivisor/utils/constants.dart';
import 'package:share_plus/share_plus.dart';
import '../../../Components/CommonLoader.dart';
import '../../../Components/CustomAppButton.dart';
import '../../../Components/CutomAppBar.dart';
import '../../../Components/Shimmers.dart';
import '../../../services/AuthService.dart';
import '../../../utils/media_query_helper.dart';
import '../../../utils/spinkittsLoader.dart';
import '../../data/cubits/AddResource/add_resource_cubit.dart';
import '../../data/cubits/AddResource/add_resource_states.dart';
import '../../data/cubits/ResourceDetails/ResourceDetailsCubit.dart';
import '../../data/cubits/ResourceDetails/ResourceDetailsState.dart';

class ResourceDetailScreen extends StatefulWidget {
  final int resourceId;
  final String scope;
  const ResourceDetailScreen({
    super.key,
    required this.resourceId,
    required this.scope,
  });

  @override
  State<ResourceDetailScreen> createState() => _ResourceDetailScreenState();
}

class _ResourceDetailScreenState extends State<ResourceDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<Resourcedetailscubit>().resourceDetails(
      widget.resourceId,
      widget.scope,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar1(
        title: "Resource Detail",
        actions: [
          IconButton(
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            icon: Image.asset(
              'assets/icons/ShareNetwork.png',
              width: 18,
              height: 18,
            ),
            onPressed: () async {
              final study_zone_Id = widget.resourceId;
              final shareUrl =
                  "https://mentivisor.com/study_zone/$study_zone_Id";
              Share.share(
                "Check out this Study Zone on Mentivisor:\n$shareUrl",
                subject: "Mentivisor Study Zone",
              );
            },
          ),
        ],
      ),
      body: Container(
        height: SizeConfig.screenHeight,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF7F8FC), Color(0xFFEFF4FF)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: BlocBuilder<Resourcedetailscubit, ResourceDetailsState>(
          builder: (context, state) {
            if (state is ResourceDetailsLoading) {
              return ResourceDetailsShimmer();
            } else if (state is ResourceDetailsLoaded) {
              final resourceData = state.resourceDetailsModel.data;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(4),
                      child: CachedNetworkImage(
                        width: SizeConfig.screenWidth,
                        imageUrl: resourceData?.image ?? "",
                        fit: BoxFit.fill,
                        placeholder: (context, url) => SizedBox(
                          width: 120,
                          height: 120,
                          child: Center(
                            child: spinkits.getSpinningLinespinkit(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 120,
                          height: 120,
                          color: const Color(0xffF8FAFE),
                          child: const Icon(
                            Icons.broken_image,
                            size: 40,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      capitalize('${resourceData?.name ?? ''}'),
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'segeo',
                        fontWeight: FontWeight.w700,
                        color: Color(0xff121212),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      resourceData?.description ?? "",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xff666666),
                        fontFamily: 'segeo',
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: (resourceData?.tag ?? []).map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Text(
                            tag,
                            style: const TextStyle(
                              fontSize: 12,
                              fontFamily: 'segeo',
                              color: Colors.black87,
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 24),
                    const Text(
                      'About Author',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'segeo',
                        fontWeight: FontWeight.w700,
                        color: Color(0xff121212),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors
                                      .black, // background behind image or text
                                ),
                                alignment: Alignment.center,
                                child:
                                    (resourceData
                                            ?.uploader
                                            ?.profilePicUrl
                                            ?.isEmpty ??
                                        true)
                                    ? Text(
                                        (resourceData
                                                    ?.uploader
                                                    ?.name
                                                    ?.isNotEmpty ??
                                                false)
                                            ? resourceData!.uploader!.name![0]
                                                  .toUpperCase()
                                            : '',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : GestureDetector(
                                        onTap: () async {
                                          final userIdStr =
                                              await AuthService.getUSerId(); // String? like "107"
                                          final userId = int.tryParse(
                                            userIdStr ?? '',
                                          ); // Parse to int, default 0 if null/invalid
                                          final uploaderId =
                                              resourceData?.uploader?.id;
                                          if (userId == uploaderId) {
                                            context.push("/profile");
                                          } else {
                                            context.push(
                                              "/common_profile/${resourceData?.uploader?.id}",
                                            );
                                          }
                                        },
                                        child: CircleAvatar(
                                          radius:
                                              30, // Adjust the size as needed
                                          backgroundColor: Colors
                                              .black, // Background behind image or initials
                                          child:
                                              (resourceData
                                                      ?.uploader
                                                      ?.profilePicUrl
                                                      ?.isEmpty ??
                                                  true)
                                              ? Text(
                                                  (resourceData
                                                              ?.uploader
                                                              ?.name
                                                              ?.isNotEmpty ??
                                                          false)
                                                      ? resourceData!
                                                            .uploader!
                                                            .name![0]
                                                            .toUpperCase()
                                                      : '',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                              : ClipOval(
                                                  child: CachedNetworkImage(
                                                    imageUrl: resourceData!
                                                        .uploader!
                                                        .profilePicUrl!,
                                                    fit: BoxFit.cover,
                                                    width:
                                                        60, // Match CircleAvatar diameter
                                                    height: 60,
                                                    placeholder:
                                                        (
                                                          context,
                                                          url,
                                                        ) => Center(
                                                          child: spinkits
                                                              .getSpinningLinespinkit(),
                                                        ),
                                                    errorWidget:
                                                        (
                                                          context,
                                                          url,
                                                          error,
                                                        ) => const ColoredBox(
                                                          color: Color(
                                                            0xffF8FAFE,
                                                          ),
                                                          child: Center(
                                                            child: Icon(
                                                              Icons
                                                                  .broken_image,
                                                              size: 40,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                        ),
                                                  ),
                                                ),
                                        ),
                                      ),
                              ),

                              SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    capitalize(
                                      resourceData?.uploader?.name ?? "",
                                    ),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'segeo',
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    // overflow: TextOverflow.ellipsis,
                                    // maxLines: 1,
                                    '${resourceData?.uploader?.college?.name ?? ""}',

                                    // ' ${resourceData?.uploader?.yearRelation?.name ?? ""} year\n${resourceData?.uploader?.stream ?? ""}'
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'segeo',
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xff666666),
                                    ),
                                  ),
                                  SizedBox(
                                    width: SizeConfig.screenWidth * 0.65,
                                    child: Text(
                                      maxLines: 2,
                                      resourceData?.uploader?.bio ?? "",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontFamily: 'segeo',
                                        color: Color(0xff666666),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Image.asset(
                                "assets/icons/download.png",
                                width: 14,
                                height: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${resourceData?.downloadsCount ?? 0} + downloads',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'segeo',
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              // const Icon(
                              //   Icons.calendar_today,
                              //   size: 16,
                              //   color: Colors.black54,
                              // ),
                              // const SizedBox(width: 4),
                              // Text(
                              //   'Member since ${studyZoneCampusData.uploader?.year ?? 0}+ Year',
                              //   style: const TextStyle(
                              //     fontSize: 12,
                              //     fontFamily: 'segeo',
                              //     color: Colors.black54,
                              //   ),
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    GestureDetector(
                      onTap: () => _showReportSheet(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xffF5F5F5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/icons/FileX.png",
                              width: 24,
                              height: 24,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Report Resource',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                                fontFamily: 'segeo',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Spacer(),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              );
            } else if (state is ResourceDetailsFailure) {
              return Center(child: Text(state.message));
            } else {
              return Center(child: Text("No Data"));
            }
          },
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.fromLTRB(16, 0, 16, 24),
          child: BlocConsumer<AddResourceCubit, AddResourceStates>(
            listener: (context, state) {
              if (state is AddResourceLoaded) {
                CustomSnackBar1.show(context, "Downloaded Successfully");
              } else if (state is AddResourceFailure) {
                CustomSnackBar1.show(
                  context,
                  state.error.isNotEmpty ? state.error : "Download Failed",
                );
              }
            },
            builder: (context, state) {
              final currentId = widget.resourceId;
              final isLoading = state is AddResourceLoading;
              return CustomAppButton1(
                radius: 24,
                isLoading: isLoading,
                text: "Download",
                textSize: 14,
                onPlusTap: () {
                  context.read<AddResourceCubit>().resourceDownload(
                    currentId.toString(),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showReportSheet(BuildContext context) {
    String _selected = 'False Information';
    final TextEditingController _otherController = TextEditingController();
    final List<String> _reportReasons = [
      'False Information',
      'Copied',
      'Harassment',
      'Abusing Resource',
      'Other',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext builderContext) {
        return SafeArea(
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 16,
                  right: 16,
                  top: 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Close Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Report Content',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'segeo',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Report Reasons List
                    const Text(
                      'Reason for reporting',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'segeo',
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Radio Buttons for Report Reasons
                    Column(
                      children: _reportReasons.map((String reason) {
                        return RadioListTile<String>(
                          title: Text(
                            reason,
                            style: const TextStyle(
                              fontFamily: 'segeo',
                              fontSize: 16,
                            ),
                          ),
                          value: reason,
                          visualDensity: VisualDensity.compact,
                          groupValue: _selected,
                          onChanged: (String? value) {
                            setState(() {
                              _selected = value!;
                            });
                          },
                          activeColor: const Color(0xFF4A00E0),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                          ),
                        );
                      }).toList(),
                    ),
                    // Custom Reason TextField
                    if (_selected == 'Other') ...[
                      const SizedBox(height: 16),
                      TextField(
                        controller: _otherController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Please explain your reason',
                          hintStyle: const TextStyle(fontFamily: 'segeo'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    // Submit Button
                    BlocConsumer<StudyZoneReportCubit, StudyZoneReportState>(
                      listener: (context, state) {
                        if (state is StudyZoneReportSuccess) {
                          CustomSnackBar1.show(
                            context,
                            "Report submitted successfully.",
                          );
                          context.pop();
                        } else if (state is StudyZoneReportFailure) {
                          return CustomSnackBar1.show(
                            context,
                            state.message ?? "",
                          );
                        }
                      },
                      builder: (context, state) {
                        return SafeArea(
                          child: CustomAppButton1(
                            isLoading: state is StudyZoneReportLoading,
                            text: "Submit Report",
                            onPlusTap: () {
                              String finalReason = _selected;
                              if (_selected == 'Other') {
                                final otherText = _otherController.text.trim();

                                if (otherText.isEmpty) {
                                  CustomSnackBar1.show(
                                    context,
                                    "Please provide a reason in the text box.",
                                  );
                                  return; // Stop submission if empty
                                }

                                finalReason = otherText;
                              }

                              // Build data payload
                              final Map<String, dynamic> data = {
                                "content_id": widget.resourceId, // Use the relevant ID
                                "reason": finalReason,           // Either selected or typed reason
                              };

                              // Call your Cubit/Bloc
                              context.read<StudyZoneReportCubit>().postStudyZoneReport(data);
                            },

                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class ResourceDetailsShimmer extends StatelessWidget {
  const ResourceDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 🔹 Header Image
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: shimmerContainer(double.infinity, 200, context),
        ),
        const SizedBox(height: 16),

        // 🔹 Scrollable content
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔹 Title
                  shimmerText(200, 16, context),
                  const SizedBox(height: 8),

                  // 🔹 Description (3 lines)
                  shimmerText(double.infinity, 12, context),
                  const SizedBox(height: 6),
                  shimmerText(250, 12, context),
                  const SizedBox(height: 6),
                  shimmerText(180, 12, context),

                  const SizedBox(height: 16),

                  // 🔹 Tags
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(
                      4,
                      (i) => shimmerContainer(
                        80 + (i * 10).toDouble(),
                        26,
                        context,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 🔹 "About Author" Title
                  shimmerText(120, 14, context),
                  const SizedBox(height: 8),

                  // 🔹 Author Card
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Avatar + Name
                        Row(
                          children: [
                            shimmerCircle(60, context),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                shimmerText(120, 14, context), // name
                                const SizedBox(height: 4),
                                shimmerText(100, 12, context), // college
                                const SizedBox(height: 4),
                                shimmerText(180, 10, context), // bio line
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Downloads
                        Row(
                          children: [
                            shimmerContainer(20, 20, context),
                            const SizedBox(width: 6),
                            shimmerText(100, 12, context),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Optional date info
                        shimmerText(120, 12, context),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🔹 Report Resource button
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xffF5F5F5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        shimmerContainer(24, 24, context),
                        const SizedBox(width: 10),
                        shimmerText(140, 14, context),
                        const Spacer(),
                        shimmerContainer(14, 14, context),
                      ],
                    ),
                  ),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
