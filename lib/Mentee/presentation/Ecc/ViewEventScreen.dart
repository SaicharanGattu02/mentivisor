import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Components/CustomAppButton.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import 'package:mentivisor/Mentee/Models/ECCModel.dart';
import 'package:mentivisor/utils/AppLauncher.dart';
import 'package:mentivisor/utils/media_query_helper.dart';
import 'package:share_plus/share_plus.dart';

import '../../../Components/CommonLoader.dart';
import '../../../Components/Shimmers.dart';
import '../../../utils/constants.dart';
import '../../data/cubits/ViewEccEventDetails/ViewEventDetailsCubit.dart';
import '../../data/cubits/ViewEccEventDetails/ViewEventDetailsState.dart';

class ViewEventScreen extends StatefulWidget {
  final int eventId;
  final String scope;

  const ViewEventScreen({
    super.key,
    required this.eventId,
    required this.scope,
  });

  @override
  State<ViewEventScreen> createState() => _ViewEventScreenState();
}

class _ViewEventScreenState extends State<ViewEventScreen> {
  ValueNotifier<String> eventLink = ValueNotifier<String>("");

  @override
  void initState() {
    super.initState();
    context.read<ViewEventDetailsCubit>().eventDetails(
      widget.eventId,
      widget.scope,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: CustomAppBar1(
        title: 'View Event',
        actions: [],
        color: Color(0xffF5F6FF),
      ),
      body: BlocBuilder<ViewEventDetailsCubit, ViewEventDetailsState>(
        builder: (context, state) {
          if (state is ViewEventDetailsLoading) {
            return EventDetailsShimmer();
          } else if (state is ViewEventDetailsLoaded) {
            final eventDetails = state.viewEccDetailsModel.data;
            eventLink.value = eventDetails?.link ?? "";
            return Column(
              children: [
                // SizedBox(
                //   height: MediaQuery.of(context).padding.top + kToolbarHeight,
                // ),
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: SizeConfig.screenWidth,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF4A90E2), Color(0xFF9013FE)],
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 12,
                            children: [
                              Text(
                                eventDetails?.name ?? "",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'segeo',
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              // Text(
                              //   eventDetails?.description ?? "",
                              //   style: const TextStyle(
                              //     color: Colors.white,
                              //     fontFamily: 'segeo',
                              //     fontSize: 14,
                              //     fontWeight: FontWeight.w500,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0, left: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _InfoRow(
                                icon: Icons.calendar_today_outlined,
                                iconBg: const Color(0xFFE8F1FF),
                                iconColor: const Color(0xFF4A90E2),
                                label: 'Date & Time',
                                value:
                                    '${formatDate(eventDetails?.dateofevent)}\n${formatTimeRange(eventDetails?.time)}',
                              ),
                              _InfoRow(
                                icon: Icons.location_on_outlined,
                                iconBg: const Color(0xFFE8FFEE),
                                iconColor: const Color(0xFF2ECC71),
                                label: 'Location',
                                value: eventDetails?.location ?? "",
                              ),
                              _InfoRow(
                                icon: Icons.apartment_rounded,
                                iconBg: const Color(0xFFF4E8FF),
                                iconColor: const Color(0xFF9013FE),
                                label: 'Organizing Institution',
                                value: eventDetails?.college ?? "",
                              ),
                            ],
                          ),
                        ),
                        // — Details box
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Color(0xffBEBEB).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Event Details',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  fontFamily: 'segeo',
                                  color: Color(0xff333333),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                eventDetails?.description ?? "",
                                style: TextStyle(
                                  color: Color(0xff666666),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'segeo',
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else if (state is ViewEventDetailsFailure) {
            return Center(child: Text(state.message));
          } else {
            return Text("No Data");
          }
        },
      ),
      // — Bottom buttons
      bottomNavigationBar: ValueListenableBuilder<String>(
        valueListenable: eventLink,
        builder: (context, link, child) {
          return (link.isNotEmpty)
              ? SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: SizedBox(
                      height: 52,
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomOutlinedButton(
                              text: "Share Event",
                              onTap: () async {
                                final eccID = widget.eventId;
                                final shareUrl =
                                    "https://mentivisor.com/ecc/$eccID";
                                Share.share(
                                  "Check out this ECC on Mentivisor:\n$shareUrl",
                                  subject:
                                      "Mentivisor Event, Competitions & Challenges",
                                );
                              },
                              radius: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomAppButton1(
                              text: "Register for Event",
                              radius: 24,
                              onPlusTap: () {
                                AppLauncher.openWebsite(link);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : SizedBox.shrink();
        },
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(12),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(color: Colors.black54, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EventDetailsShimmer extends StatelessWidget {
  const EventDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF4A90E2), Color(0xFF9013FE)],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // If your Flutter version doesn't support `spacing`, remove this line.
                // spacing: 12,
                children: [
                  shimmerText(180, 24, context),
                  const SizedBox(height: 12),
                  shimmerText(250, 14, context),
                  const SizedBox(height: 4),
                  shimmerText(220, 14, context),
                ],
              ),
            ),

            // Info rows
            Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _InfoRowShimmer(labelWidth: 120, valueLines: 2),
                  SizedBox(height: 16),
                  _InfoRowShimmer(labelWidth: 100, valueLines: 1),
                  SizedBox(height: 16),
                  _InfoRowShimmer(labelWidth: 140, valueLines: 1),
                ],
              ),
            ),

            // Details box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xffBEBEBE).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  shimmerText(100, 16, context),
                  const SizedBox(height: 12),
                  shimmerText(250, 14, context),
                  const SizedBox(height: 8),
                  shimmerText(220, 14, context),
                  const SizedBox(height: 8),
                  shimmerText(260, 14, context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRowShimmer extends StatelessWidget {
  final double labelWidth;
  final int valueLines;

  const _InfoRowShimmer({
    super.key,
    required this.labelWidth,
    this.valueLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        shimmerCircle(36, context),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            shimmerText(labelWidth, 14, context),
            const SizedBox(height: 6),
            ...List.generate(
              valueLines,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: shimmerText(200 - (index * 20), 12, context),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
