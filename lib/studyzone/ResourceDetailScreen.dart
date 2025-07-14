import 'package:flutter/material.dart';

class ResourceDetailScreen extends StatelessWidget {
  final String imageUrl;
  final String courseDescription;
  final List<String> courseTags;
  final String authorName;
  final String authorRole;
  final int downloads;
  final String memberSince;

  const ResourceDetailScreen({
    Key? key,
    this.imageUrl =
    'https://via.placeholder.com/400x200.png?text=Course+Banner',
    this.courseDescription =
    'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s...',
    this.courseTags = const ['DSA', 'Road Map', 'Road map 2024'],
    this.authorName = 'Dr. Sarah Chen',
    this.authorRole = 'Verified Mentor',
    this.downloads = 15000,
    this.memberSince = '2022',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5FA),
      body: DefaultTextStyle.merge(
        style: const TextStyle(
          fontFamily: 'segeo',
          fontWeight: FontWeight.w600,
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // AppBar
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black87),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Text(
                      'Resource Detail',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'segeo',
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),

              // Banner image
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/download.jpg',
                    height: 167,
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
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
                        courseDescription,
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
                        children: courseTags.map((tag) {
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

                      // About Author
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
                                const CircleAvatar(
                                  radius: 24,
                                  backgroundImage: AssetImage(
                                      'assets/images/profileimg.png'),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        authorName,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'segeo',
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Text(
                                        authorRole,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontFamily: 'segeo',
                                          color: Color(0xff666666),
                                        ),
                                      ),
                                    ],
                                  ),
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
                                  '$downloads+ downloads',
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
                                  'Member since $memberSince',
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

                      const SizedBox(height: 15),

                      // Report Resource
                      GestureDetector(
                        onTap: () => _showReportSheet(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.cancel, size: 16, color: Colors.black54),
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
                              Icon(Icons.arrow_forward_ios,
                                  size: 16, color: Colors.black54),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),

              // Download button
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12,
                ),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFA258F7),
                        Color(0xFF726CF7),
                        Color(0xFF4280F6),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Trigger download functionality
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Download',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'segeo',
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showReportSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const _ReportSheetContent(),
    );
  }
}

class _ReportSheetContent extends StatefulWidget {
  const _ReportSheetContent();
  @override
  State<_ReportSheetContent> createState() => _ReportSheetContentState();
}

class _ReportSheetContentState extends State<_ReportSheetContent> {
  final List<String> _options = [
    'False Information',
    'Copied',
    'Abusing Resource',
    'Other',
  ];
  String? _selected;
  final _otherController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selected = _options.first;
  }

  @override
  void dispose() {
    _otherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Report Resource',
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'segeo',
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          ..._options.map((opt) {
            return RadioListTile<String>(
              contentPadding: EdgeInsets.zero,
              title: Text(opt, style: const TextStyle(fontFamily: 'segeo')),
              value: opt,
              groupValue: _selected,
              onChanged: (v) => setState(() => _selected = v),
            );
          }).toList(),
          if (_selected == 'Other') ...[
            const SizedBox(height: 8),
            TextField(
              controller: _otherController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Custom / Explain your reason here',
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
          SizedBox(
            width: double.infinity,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  final reason = (_selected == 'Other')
                      ? _otherController.text.trim()
                      : _selected;
                  // TODO: submit report with `reason`
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Download',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'segeo',
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
