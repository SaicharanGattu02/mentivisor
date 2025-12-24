import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CommonLoader.dart';
import 'package:mentivisor/Components/CustomAppButton.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import 'package:mentivisor/Mentee/presentation/Widgets/CommonBackground.dart';
import 'package:mentivisor/services/AuthService.dart';
import 'package:mentivisor/utils/AppLogger.dart';
import 'package:mentivisor/utils/constants.dart';
import 'package:mentivisor/utils/media_query_helper.dart';
import '../../../Components/Shimmers.dart';
import '../../../utils/spinkittsLoader.dart';
import '../../Models/MentorProfileModel.dart';
import '../../data/cubits/ExpertiseExpansionCubit.dart';
import '../../data/cubits/MentorProfile/MentorProfileCubit.dart';
import '../../data/cubits/MentorProfile/MentorProfileState.dart';
import '../Widgets/ReviewCard.dart';

class MentorProfileScreen extends StatefulWidget {
  final int id;
  MentorProfileScreen({super.key, required this.id});
  @override
  State<MentorProfileScreen> createState() => _MentorProfileScreenState();
}

class _MentorProfileScreenState extends State<MentorProfileScreen> {
  bool hasTodaySlots = false;
  bool hasTomorrowSlots = false;
  bool hasRemainingSlots = false;
  String? user_id;
  int? profile_id;
  List<bool> _expandedExpertise = [];

  @override
  void initState() {
    super.initState();
    context.read<MentorProfileCubit>().fetchMentorProfile(widget.id);
    getUserID();
  }

  Future<void> getUserID() async {
    user_id = await AuthService.getUSerId();
  }

  final ValueNotifier<bool> _isExpertiseExpanded = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar1(title: 'Mentor profile', actions: []),
      body: Background(
        child: BlocConsumer<MentorProfileCubit, MentorProfileState>(
          listener: (context, state) {
            if (state is MentorProfileLoaded) {
              final d = state.mentorProfileModel.data;
              // initialize the expansion list
              _expandedExpertise = List.filled(
                d?.expertises?.length ?? 0,
                false,
              );
              final t1 = (d?.todaySlots ?? []).isNotEmpty;
              final t2 = (d?.tomorrowSlots ?? []).isNotEmpty;
              final t3 = (d?.remainingSlots ?? 0) > 0;
              if (t1 != hasTodaySlots ||
                  t2 != hasTomorrowSlots ||
                  t3 != hasRemainingSlots) {
                setState(() {
                  hasTodaySlots = t1;
                  hasTomorrowSlots = t2;
                  hasRemainingSlots = t3;
                  profile_id = state.mentorProfileModel.data?.userId ?? 0;
                });
              }
            }
          },
          builder: (context, state) {
            if (state is MentorProfileLoading) {
              return MentorProfileShimmer();
            } else if (state is MentorProfileFailure) {
              return Center(child: Text(state.message));
            } else if (state is MentorProfileLoaded) {
              final mentorData = state.mentorProfileModel.data;
              final name = mentorData?.user?.name ?? "";
              AppLogger.info(
                "hasTodaySlots:$hasTodaySlots, hasTomorrowSlots:$hasTomorrowSlots, hasRemainingSlots:$hasRemainingSlots",
              );
              return Container(
                padding: EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xfff6faff), Color(0xffe0f2fe)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              if ((mentorData?.user?.profilePicUrl ?? "")
                                  .isNotEmpty) {
                                _showImagePreview(
                                  context,
                                  mentorData!.user!.profilePicUrl!,
                                  name,
                                );
                              }
                            },
                            child: SizedBox(
                              width: 120,
                              height: 120,
                              child: CachedNetworkImage(
                                imageUrl: mentorData?.user?.profilePicUrl ?? "",
                                fadeInDuration: const Duration(
                                  milliseconds: 200,
                                ),
                                fadeOutDuration: const Duration(
                                  milliseconds: 100,
                                ),
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                placeholder: (context, url) => Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFE0E0E0),
                                  ),
                                  child: Center(
                                    child: SizedBox(
                                      width: 28,
                                      height: 28,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey.shade300,
                                  ),
                                  child: Center(
                                    child: Text(
                                      (name != null && name.trim().isNotEmpty)
                                          ? name.trim()[0].toUpperCase()
                                          : 'U',
                                      style: const TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xff333333),
                                        fontFamily: 'segeo',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 12),
                        Container(
                          padding: EdgeInsets.all(16),
                          margin: EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            spacing: 8,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                capitalize(mentorData?.user?.name ?? 'Unknown'),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${mentorData?.yearName ?? ''} year student in ${mentorData?.user?.stream ?? ''} from ${mentorData?.user?.college?.name ?? ''}",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff444444),
                                  fontFamily: "segeo",
                                ),
                              ),

                              // Text(
                              //   "${mentorData?.user?.email ?? ''}",
                              //   style: TextStyle(
                              //     fontSize: 14,
                              //     fontWeight: FontWeight.w400,
                              //     color: Color(0xff444444),
                              //     fontFamily: "segeo",
                              //   ),
                              // ),
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/icons/language.png",
                                    width: 18,
                                    height: 18,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    (mentorData?.langages ?? []).join(
                                      ', ',
                                    ), // Languages from data
                                    style: TextStyle(fontFamily: "Inter"),
                                  ),
                                ],
                              ),
                              if ((mentorData?.totalReviews ?? 0) > 0)
                                Row(
                                  children: [
                                    Image.asset(
                                      "assets/images/starvector.png",
                                      color: Colors.amber,
                                      height: 14,
                                      width: 14,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      '${mentorData?.averageRating ?? 0} (${mentorData?.totalReviews ?? 0} reviews)',
                                      style: TextStyle(fontFamily: "Inter"),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        _buildSection(
                          title: 'About',
                          child: Text(
                            mentorData?.user?.bio ?? 'No information available',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: "Inter",
                              height: 1.8,
                            ),
                          ),
                        ),
                        BlocProvider(
                          create: (_) => ExpertiseExpansionCubit(),
                          child: _buildExpertiseSection(
                            mentorData ?? MentorData(),
                          ),
                        ),
                        // Container(
                        //   width: double.infinity,
                        //   padding: EdgeInsets.all(16),
                        //   margin: EdgeInsets.only(bottom: 16),
                        //   decoration: BoxDecoration(
                        //     color: Colors.white,
                        //     borderRadius: BorderRadius.circular(12),
                        //     boxShadow: [
                        //       BoxShadow(
                        //         color: Colors.black.withOpacity(0.05),
                        //         blurRadius: 10,
                        //         offset: Offset(0, 2),
                        //       ),
                        //     ],
                        //   ),
                        //   child: ValueListenableBuilder<bool>(
                        //     valueListenable: _isExpertiseExpanded,
                        //     builder: (context, isExpanded, _) {
                        //       return Column(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           Row(
                        //             mainAxisAlignment:
                        //                 MainAxisAlignment.spaceBetween,
                        //             children: [
                        //               const Text(
                        //                 'Expertise',
                        //                 style: TextStyle(
                        //                   fontSize: 18,
                        //                   fontWeight: FontWeight.w500,
                        //                   fontFamily: 'Inter',
                        //                   color: Color(0xff333333),
                        //                 ),
                        //               ),
                        //               IconButton(
                        //                 padding: EdgeInsets.zero,
                        //                 visualDensity: VisualDensity.compact,
                        //                 onPressed: () {
                        //                   _isExpertiseExpanded.value =
                        //                       !isExpanded;
                        //                 },
                        //                 icon: Icon(
                        //                   isExpanded
                        //                       ? Icons.arrow_drop_up_outlined
                        //                       : Icons.arrow_drop_down_outlined,
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //           if (isExpanded) ...[
                        //             SizedBox(height: 10),
                        //             Wrap(
                        //               spacing: 4,
                        //               children: (mentorData?.expertises ?? [])
                        //                   .expand<Widget>(
                        //                     (e) => [
                        //                       _buildChip(e.name ?? ""),
                        //                       ...(e.subExpertises ?? []).map(
                        //                         (sub) =>
                        //                             _buildChip(sub.name ?? ""),
                        //                       ),
                        //                     ],
                        //                   )
                        //                   .toList(),
                        //             ),
                        //           ],
                        //         ],
                        //       );
                        //     },
                        //   ),
                        // ),
                        if (hasTodaySlots ||
                            hasTomorrowSlots ||
                            hasRemainingSlots) ...[
                          _buildSection(
                            title: 'Available Slots',
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (hasTodaySlots) ...[
                                  Text(
                                    'Today',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Wrap(
                                    runSpacing: 10,
                                    spacing: 8,
                                    children: (mentorData?.todaySlots ?? [])
                                        .map(
                                          (slot) => _buildTimeSlot(
                                            "${slot.startTime} - ${slot.endTime}",
                                            const Color(0xFFdcfce7),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                  SizedBox(height: 16),
                                ],
                                if (hasTomorrowSlots) ...[
                                  Text(
                                    'Tomorrow',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Wrap(
                                    runSpacing: 10,
                                    spacing: 8,
                                    children: (mentorData?.tomorrowSlots ?? [])
                                        .map(
                                          (slot) => _buildTimeSlot(
                                            "${slot.startTime} - ${slot.endTime}",
                                            const Color(0xFFdbeafe),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                  SizedBox(height: 20),
                                ],
                                if (hasRemainingSlots)
                                  Text(
                                    'More ${mentorData?.remainingSlots} slots available within the week',
                                    style: const TextStyle(
                                      color: Color(0xff666666),
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'segeo',
                                      fontSize: 16,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ] else ...[
                          _buildSection(
                            title: 'Available Slots',
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Center(
                                child: Text(
                                  'No slots available',
                                  style: const TextStyle(
                                    color: Color(0xff999999),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],

                        if ((mentorData?.ratings ?? []).isNotEmpty)
                          _buildSection(
                            title: 'Recent Reviews',
                            child: Column(
                              children: (mentorData!.ratings!).map<Widget>((
                                review,
                              ) {
                                return ReviewCard(
                                  name: review.user?.name ?? "",
                                  id: review.userId ?? 0,
                                  rating: review.rating ?? 0,
                                  createdAt: review.createdAt ?? "",
                                  review: review.feedback ?? "",
                                  imgeUrl: review.user?.profilePicUrl ?? "",
                                );
                              }).toList(),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return SizedBox.shrink();
          },
        ),
      ),
      bottomNavigationBar:
          (hasTodaySlots || hasTomorrowSlots || hasRemainingSlots)
          ? int.parse(user_id ?? "") == profile_id
                ? SizedBox.shrink()
                : SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                      child: BlocBuilder<MentorProfileCubit, MentorProfileState>(
                        builder: (context, state) {
                          final mentorData = (state is MentorProfileLoaded)
                              ? state.mentorProfileModel.data
                              : null;
                          return SizedBox(
                            width: double.infinity,
                            child: CustomAppButton1(
                              text: 'Book Session',
                              onPlusTap: mentorData == null
                                  ? null // disable until loaded
                                  : () {
                                      context.push(
                                        '/book_sessions_screen',
                                        extra:
                                            mentorData, // << pass the exact object you have
                                      );
                                    },
                            ),
                          );
                        },
                      ),
                    ),
                  )
          : SizedBox.shrink(),
    );
  }

  void _showImagePreview(BuildContext context, String imageUrl, String? name) {
    showDialog(
      context: context,
      builder: (_) {
        return GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(20),
            child: InteractiveViewer(
              minScale: 0.8,
              maxScale: 4,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Container(
                  alignment: Alignment.center,
                  color: Colors.grey.shade800,
                  child: Text(
                    (name != null && name.trim().isNotEmpty)
                        ? name.trim()[0].toUpperCase()
                        : 'U',
                    style: const TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildExpertiseSection(MentorData mentorData) {
    return BlocBuilder<ExpertiseExpansionCubit, int?>(
      builder: (context, expandedIndex) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Expertise',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Inter',
                  color: Color(0xff333333),
                ),
              ),
              SizedBox(height: 12),

              // LOOP EXPERTISE
              ...List.generate(mentorData.expertises?.length ?? 0, (index) {
                final exp = mentorData.expertises![index];
                final isOpen = expandedIndex == index;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.read<ExpertiseExpansionCubit>().toggle(index);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              exp.name ?? "",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Icon(
                              isOpen
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              size: 22,
                            ),
                          ],
                        ),
                      ),
                    ),

                    if (isOpen)
                      Padding(
                        padding: const EdgeInsets.only(left: 6, bottom: 10),
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 8,
                          children: (exp.subExpertises ?? [])
                              .map((sub) => _buildChip(sub.name ?? ""))
                              .toList(),
                        ),
                      ),

                    SizedBox(height: 8),
                  ],
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              fontFamily: 'Inter',
              color: Color(0xff333333),
            ),
          ),
          SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _buildTimeSlot(String time, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(36),
      ),
      child: Text(time, style: TextStyle(color: Color(0xFF15803d))),
    );
  }

  Widget _buildChip(String label) {
    return Chip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          fontFamily: "Inter",
        ),
      ),

      side: BorderSide(color: Color(0xFFf3e8ff)),
      backgroundColor: Color(0xFFf3e8ff),
      labelStyle: TextStyle(
        color: Color(0xFFA351EE),
        fontFamily: "Inter",
        fontWeight: FontWeight.bold,
      ),
      padding: EdgeInsets.symmetric(horizontal: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(36), // change 12 to your need
      ),
    );
  }
}

class MentorProfileShimmer extends StatelessWidget {
  const MentorProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xfff6faff), Color(0xffe0f2fe)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: shimmerCircle(120, context)),
              SizedBox(height: 16),

              Container(
                padding: EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    shimmerText(140, 20, context), // name
                    const SizedBox(height: 8),
                    shimmerText(260, 14, context), // college line
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        shimmerCircle(18, context),
                        const SizedBox(width: 8),
                        shimmerText(120, 14, context), // languages
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        shimmerCircle(14, context),
                        const SizedBox(width: 8),
                        shimmerText(80, 12, context), // rating
                      ],
                    ),
                  ],
                ),
              ),
              _buildSectionShimmer(context, 'About', 3),

              _buildSectionShimmer(context, 'Expertise', 2, isChips: true),

              _buildSectionShimmer(
                context,
                'Available Slots',
                2,
                isChips: true,
              ),

              _buildSectionShimmer(context, 'Recent Reviews', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionShimmer(
    BuildContext context,
    String title,
    int lines, {
    bool isChips = false,
  }) {
    return Container(
      width: SizeConfig.screenWidth,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          shimmerText(120, 18, context), // section title
          const SizedBox(height: 12),
          if (isChips)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(
                lines * 3,
                (index) => shimmerText(60 + (index % 2) * 20, 28, context),
              ),
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(
                lines,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: shimmerText(280 - (index * 40), 14, context),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
