import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:mentivisor/Components/CutomAppBar.dart';
import 'package:mentivisor/utils/media_query_helper.dart';

import '../../Components/CommonLoader.dart';
import '../../Components/Shimmers.dart';
import '../../utils/spinkittsLoader.dart';
import '../data/cubits/ExclusiveServiceDetails/ExclusiveServiceDetails_Cubit.dart';
import '../data/cubits/ExclusiveServiceDetails/ExclusiveServiceDetails_State.dart';

class ExclusiveServiceDetails extends StatefulWidget {
  final int id;
  final String title;
  const ExclusiveServiceDetails({
    super.key,
    required this.id,
    required this.title,
  });

  @override
  State<ExclusiveServiceDetails> createState() =>
      _ExclusiveServiceDetailsState();
}

class _ExclusiveServiceDetailsState extends State<ExclusiveServiceDetails> {
  @override
  void initState() {
    super.initState();
    _fetch();
  }

  void _fetch() {
    context.read<ExclusiveservicedetailsCubit>().exclusiveServiceDetails(
      widget.id,
    );
  }

  Future<void> _open(String url) async {
    if (url.isEmpty) return;
    final uri = Uri.tryParse(url);
    if (uri != null) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgTop = const Color(0xFFF2F4FF);
    return Scaffold(
      appBar: CustomAppBar1(title: "Exclusive Services", actions: const []),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFAF5FF), Color(0xFFF5F6FF), Color(0xFFEFF6FF)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child:
            BlocBuilder<
              ExclusiveservicedetailsCubit,
              ExclusiveservicedetailsState
            >(
              builder: (context, state) {
                if (state is ExclusiveservicedetailsStateLoading) {
                  return const ExclusiveServiceDetailsShimmer();
                }

                if (state is ExclusiveservicedetailsFailure) {
                  return Center(
                    child: Text(
                      state.msg,
                      style: const TextStyle(fontFamily: 'segeo'),
                    ),
                  );
                }
                if (state is ExclusiveservicedetailsStateLoaded) {
                  final d = state.exclusiveservicedetailsModel.data;
                  final name = (d?.name ?? '').trim();
                  final desc = (d?.description ?? '').trim();
                  final exclusiveServiceImge = (d?.exclusiveService ?? '')
                      .trim();
                  final image = (d?.imageUrl ?? '').trim();
                  final link = (d?.link ?? '').trim();

                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      ListView(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFD9DEE7),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: SizedBox(
                                height: 140,
                                width: double.infinity,
                                child: exclusiveServiceImge.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl: exclusiveServiceImge,
                                        fit: BoxFit.cover,
                                        placeholder: (c, _) => const Center(
                                          child: SizedBox(
                                            width: 22,
                                            height: 22,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 1.8,
                                            ),
                                          ),
                                        ),
                                        errorWidget: (c, _, __) => const Icon(
                                          Icons.broken_image_outlined,
                                          color: Colors.grey,
                                        ),
                                      )
                                    : Icon(
                                        Icons.broken_image_outlined,
                                        color: Colors.grey,
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          Row(
                            children: [
                              // CachedNetworkImage(
                              //   imageUrl: image,
                              //   imageBuilder: (context, imageProvider) =>
                              //       CircleAvatar(
                              //         radius: 12,
                              //         backgroundImage: imageProvider,
                              //       ),
                              //   placeholder: (context, url) => CircleAvatar(
                              //     radius: 12,
                              //     backgroundColor: Colors.grey,
                              //     child: SizedBox(
                              //       width: 12,
                              //       height: 12,
                              //       child: Center(
                              //         child: spinkits.getSpinningLinespinkit(),
                              //       ),
                              //     ),
                              //   ),
                              //   errorWidget: (context, url, error) =>
                              //       const CircleAvatar(
                              //         radius: 12,
                              //         backgroundImage: AssetImage(
                              //           "assets/images/profile.png",
                              //         ),
                              //       ),
                              // ),
                              // const SizedBox(width: 8),
                              Text(
                                name.isEmpty ? '—' : name,
                                style: const TextStyle(
                                  fontFamily: 'segeo',
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF222222),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // Title (bold)
                          Text(
                            name.isEmpty ? '—' : name,
                            style: const TextStyle(
                              fontFamily: 'segeo',
                              fontSize: 18,
                              height: 1.25,
                              color: Color(0xFF111111),
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Paragraph (muted grey)
                          Text(
                            desc.isEmpty ? '—' : desc,
                            style: const TextStyle(
                              fontFamily: 'segeo',
                              fontSize: 13,
                              height: 1.45,
                              color: Color(0xFF6B7280), // grey-600ish
                              fontWeight: FontWeight.w400,
                            ),
                          ),

                          const SizedBox(height: 16),
                          if (link.isNotEmpty) ...[
                            Text(
                              'Visit this link to access the exclusive service.',
                              style: TextStyle(
                                fontFamily: 'segeo',
                                fontSize: 14,
                                height: 1.35,
                                color: Color(0xFF757575),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            RichText(
                              text: TextSpan(
                                text: 'Click here',
                                style: const TextStyle(
                                  fontFamily: 'segeo',
                                  fontSize: 14,
                                  decoration: TextDecoration.underline,
                                  color: Color(0xFF9D5AF7), // blue
                                  fontWeight: FontWeight.w700,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => _open(link),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  );
                }

                // Fallback
                return const SizedBox.shrink();
              },
            ),
      ),
    );
  }
}

class ExclusiveServiceDetailsShimmer extends StatelessWidget {
  const ExclusiveServiceDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          children: [
            // 🔹 Top Image Container with shadow and border radius
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6FA),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: shimmerContainer(double.infinity, 170, context),
              ),
            ),

            const SizedBox(height: 16),

            // 🔹 Profile Row shimmer
            Row(
              children: [
                shimmerCircle(24, context),
                const SizedBox(width: 8),
                shimmerText(100, 12, context),
              ],
            ),

            const SizedBox(height: 12),

            // 🔹 Title shimmer
            shimmerText(180, 20, context),

            const SizedBox(height: 10),

            // 🔹 Description shimmer (3–4 lines)
            shimmerText(double.infinity, 12, context),
            const SizedBox(height: 6),
            shimmerText(double.infinity, 12, context),
            const SizedBox(height: 6),
            shimmerText(240, 12, context),

            const SizedBox(height: 16),

            // 🔹 Link info section shimmer
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  shimmerText(200, 14, context),
                  const SizedBox(height: 8),
                  shimmerText(100, 14, context),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
