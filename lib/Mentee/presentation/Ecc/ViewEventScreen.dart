import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mentivisor/Components/CustomAppButton.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import 'package:mentivisor/Mentee/Models/ECCModel.dart';
import 'package:mentivisor/utils/AppLauncher.dart';
import 'package:share_plus/share_plus.dart';

import '../../../utils/constants.dart';

class ViewEventScreen extends StatefulWidget {
  final ECCList eccList;

  const ViewEventScreen({super.key, required this.eccList});

  @override
  State<ViewEventScreen> createState() => _ViewEventScreenState();
}

class _ViewEventScreenState extends State<ViewEventScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: CustomAppBar1(title: 'View Event', actions: []),
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top + kToolbarHeight),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
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
                            widget.eccList.name ?? "",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            widget.eccList.description ?? "",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _InfoRow(
                            icon: Icons.calendar_today,
                            iconBg: const Color(0xFFE8F1FF),
                            iconColor: const Color(0xFF4A90E2),
                            label: 'Date & Time',
                            value:
                                '${formatDate(widget.eccList.dateofevent)}\n${formatTimeRange(widget.eccList.time)}',
                          ),
                          _InfoRow(
                            icon: Icons.location_on,
                            iconBg: const Color(0xFFE8FFEE),
                            iconColor: const Color(0xFF2ECC71),
                            label: 'Location',
                            value: widget.eccList.location ?? "",
                          ),
                          _InfoRow(
                            icon: Icons.apartment,
                            iconBg: const Color(0xFFF4E8FF),
                            iconColor: const Color(0xFF9013FE),
                            label: 'Organizing Institution',
                            value: widget.eccList.college ?? "",
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
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.eccList.description ?? "",
                            style: const TextStyle(
                              color: Colors.black54,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      // — Bottom buttons
      bottomNavigationBar: ((widget.eccList.link ?? "").isNotEmpty)
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
                            final eccID = widget.eccList.id;
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
                            AppLauncher.openWebsite(widget.eccList.link ?? "");
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : SizedBox.shrink(),
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
      padding: const EdgeInsets.symmetric(vertical: 8),
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
