import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CustomSnackBar.dart';
import 'package:mentivisor/Mentee/data/cubits/StudyZoneReport/StudyZoneReportCubit.dart';
import 'package:mentivisor/Mentee/data/cubits/StudyZoneReport/StudyZoneReportState.dart';
import '../../../Components/CustomAppButton.dart';
import '../../../Components/CutomAppBar.dart';
import '../../../utils/color_constants.dart';
import '../../../utils/media_query_helper.dart';
import '../../../utils/spinkittsLoader.dart';
import '../../Models/StudyZoneCampusModel.dart';

class ResourceDetailScreen extends StatelessWidget {
  final StudyZoneCampusData studyZoneCampusData;

  const ResourceDetailScreen({super.key, required this.studyZoneCampusData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar1(title: "Resource Detail", actions: []),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF7F8FC), Color(0xFFEFF4FF)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(4),
              child: CachedNetworkImage(
                width: SizeConfig.screenWidth,
                height: 200,
                imageUrl: studyZoneCampusData.image ?? "",
                fit: BoxFit.cover,
                placeholder: (context, url) => SizedBox(
                  width: 120,
                  height: 120,
                  child: Center(child: spinkits.getSpinningLinespinkit()),
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

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // About Course
                    const Text(
                      'About Course',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'segeo',
                        fontWeight: FontWeight.w700,
                        color: Color(0xff121212),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      studyZoneCampusData.description ?? "",
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
                      children: (studyZoneCampusData.tag ?? []).map((tag) {
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
                                  color: Colors.black, // inner bg behind image
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: CachedNetworkImage(
                                  imageUrl:
                                      studyZoneCampusData
                                          .uploader
                                          ?.profilePic ??
                                      "",
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Center(
                                    child: spinkits.getSpinningLinespinkit(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const ColoredBox(
                                        color: Color(0xffF8FAFE),
                                        child: Center(
                                          child: Icon(
                                            Icons.broken_image,
                                            size: 40,
                                            color: Colors.grey,
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
                                    studyZoneCampusData.uploader?.name ?? "",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'segeo',
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    studyZoneCampusData.uploader?.email ?? "",
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontFamily: 'segeo',
                                      color: Color(0xff666666),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              const Icon(
                                Icons.download_rounded,
                                size: 16,
                                color: Colors.black54,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${studyZoneCampusData.downloadsCount ?? 0} + downloads',
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
                              const Icon(
                                Icons.calendar_today,
                                size: 16,
                                color: Colors.black54,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Member since ${studyZoneCampusData.uploader?.year ?? 0}+ Year',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'segeo',
                                  color: Colors.black54,
                                ),
                              ),
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
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.fromLTRB(16, 0, 16, 24),
          child: CustomAppButton1(text: "Download", onPlusTap: () {}),
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
        return StatefulBuilder(
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
                            final Map<String, dynamic> data = {
                              "content_id": studyZoneCampusData.id,
                              "reason": _selected,
                            };
                            context
                                .read<StudyZoneReportCubit>()
                                .postStudyZoneReport(data);
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
        );
      },
    );
  }
}
