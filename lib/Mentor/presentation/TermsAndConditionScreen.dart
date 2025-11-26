import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:share_plus/share_plus.dart';
import '../../Mentee/data/cubits/TermsAndConditions/TermsAndConditionCubit.dart';
import '../../Mentee/data/cubits/TermsAndConditions/TermsAndConditionStates.dart';

class TermsAndConditionScreen extends StatefulWidget {
  const TermsAndConditionScreen({Key? key})
    : super(key: key);

  @override
  State<TermsAndConditionScreen> createState() =>
      _TermsAndConditionScreenState();
}

class _TermsAndConditionScreenState extends State<TermsAndConditionScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TermsAndConditionCubit>().getTermsAndCondition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        title: const Text(
          'Terms & Conditions',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        // actions: [_AppBarActions()],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Column(
            children: [
              // _HeaderCard(),
              // const SizedBox(height: 12),
              Expanded(child: _ContentArea()),
            ],
          ),
        ),
      ),
    );
  }
}

/// AppBar action buttons (refresh is wired to cubit)
class _AppBarActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TermsAndConditionCubit, TermsAndConditionStates>(
      builder: (context, state) {
        final cubit = context.read<TermsAndConditionCubit>();
        return Row(
          children: [
            IconButton(
              tooltip: 'Refresh',
              icon: const Icon(Icons.refresh_outlined),
              onPressed: () => cubit.getTermsAndCondition(),
            ),
            IconButton(
              tooltip: 'Share',
              icon: const Icon(Icons.share_outlined),
              onPressed: () {
                final state = cubit.state;
                if (state is TermsAndConditionLoaded) {
                  final content =
                      state.termsAndConditionModel.data?.content ?? '';
                  Share.share(
                    _plainTextFromHtml(content),
                    subject: 'Terms & Conditions',
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Nothing to share yet')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}

/// Header card containing a friendly intro + timestamps
class _HeaderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.description_outlined,
                size: 32,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Terms & Conditions',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Please read these terms carefully. Last updated below.',
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // small hint icon
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('About'),
                    content: const Text(
                      'These are the terms & conditions obtained from the server.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.info_outline),
            ),
          ],
        ),
      ),
    );
  }
}

/// Main content area, handles loading, error and HTML rendering
class _ContentArea extends StatelessWidget {
  const _ContentArea();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TermsAndConditionCubit, TermsAndConditionStates>(
      listener: (context, state) {
        if (state is TermsAndConditionFailure) {
          final scaffold = ScaffoldMessenger.of(context);
          scaffold.hideCurrentSnackBar();
          scaffold.showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      builder: (context, state) {
        if (state is TermsAndConditionLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TermsAndConditionFailure) {
          return _ErrorView(
            message: state.error,
            onRetry: () =>
                context.read<TermsAndConditionCubit>().getTermsAndCondition(),
          );
        } else if (state is TermsAndConditionLoaded) {
          final model = state.termsAndConditionModel;
          final contentHtml =
              model.data?.content ?? '<p>No content available</p>';
          final updatedAt = model.data?.updatedAt;
          final createdAt = model.data?.createdAt;

          return RefreshIndicator(
            onRefresh: () =>
                context.read<TermsAndConditionCubit>().getTermsAndCondition(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Meta info
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Last updated: ${_formatDate(updatedAt) ?? "—"}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Created: ${_formatDate(createdAt) ?? "—"}',
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Copy button
                        // ElevatedButton.icon(
                        //   style: ElevatedButton.styleFrom(
                        //     elevation: 0,
                        //     backgroundColor: Colors.grey.shade100,
                        //     foregroundColor: Colors.black87,
                        //     padding: const EdgeInsets.symmetric(
                        //       horizontal: 12,
                        //       vertical: 10,
                        //     ),
                        //   ),
                        //   icon: const Icon(Icons.copy_outlined, size: 18),
                        //   label: const Text('Copy'),
                        //   onPressed: () {
                        //     final plain = _plainTextFromHtml(contentHtml);
                        //     Clipboard.setData(ClipboardData(text: plain));
                        //     ScaffoldMessenger.of(context).showSnackBar(
                        //       const SnackBar(
                        //         content: Text('Copied to clipboard'),
                        //       ),
                        //     );
                        //   },
                        // ),
                      ],
                    ),
                  ),

                  // The HTML card
                  Card(
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14.0,
                        vertical: 16,
                      ),
                      child: Html(
                        data: contentHtml,
                        // Customize styles for tags if required
                        style: {
                          "body": Style(
                            margin: Margins.zero,
                            padding: HtmlPaddings.all(0),
                            fontSize: FontSize(15.0),
                            lineHeight: LineHeight(1.5),
                            color: Colors.black87,
                            fontFamily: 'Roboto',
                          ),
                          "ol": Style(margin: Margins.only(left: 18)),
                          "ul": Style(margin: Margins.only(left: 18)),
                          "a": Style(color: Colors.blueAccent),
                          "h1": Style(
                            fontSize: FontSize(22),
                            fontWeight: FontWeight.bold,
                          ),
                          "h2": Style(
                            fontSize: FontSize(18),
                            fontWeight: FontWeight.w700,
                          ),
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),
                  // Small CTA or acknowledgement
                  Center(
                    child: Text(
                      'By using the app you agree to these terms.',
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          // initial state fallback
          return Center(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.download_outlined),
              label: const Text('Load Terms & Conditions'),
              onPressed: () =>
                  context.read<TermsAndConditionCubit>().getTermsAndCondition(),
            ),
          );
        }
      },
    );
  }
}

/// Error view widget
class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({Key? key, required this.message, required this.onRetry})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 54, color: Colors.red.shade400),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

/// Utility: Try to convert server ISO timestamp to readable date
String? _formatDate(String? iso) {
  try {
    if (iso == null || iso.isEmpty) return null;
    final dt = DateTime.parse(iso);
    return '${dt.day.toString().padLeft(2, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.year}';
  } catch (_) {
    return null;
  }
}

/// Utility: convert simple HTML -> plain text for copy/share
String _plainTextFromHtml(String html) {
  // Very basic removal of tags. For complex HTML use an HTML parser or package.
  return html
      .replaceAll(RegExp(r'<[^>]*>', multiLine: true, caseSensitive: false), '')
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&amp;', '&')
      .trim();
}
