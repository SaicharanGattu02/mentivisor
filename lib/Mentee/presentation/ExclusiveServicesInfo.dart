import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:mentivisor/Components/CutomAppBar.dart';
import 'package:mentivisor/utils/media_query_helper.dart';

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
  State<ExclusiveServiceDetails> createState() => _ExclusiveServiceDetailsState();
}

class _ExclusiveServiceDetailsState extends State<ExclusiveServiceDetails> {
  @override
  void initState() {
    super.initState();
    _fetch();
  }

  void _fetch() {
    context.read<ExclusiveservicedetailsCubit>().exclusiveServiceDetails(widget.id);
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
    final bgTop = const Color(0xFFF2F4FF); // subtle tint like screenshot
    return Scaffold(
      appBar: CustomAppBar1(title: "Exclusive Services", actions: const []),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.center,
            colors: [bgTop, Colors.white],
          ),
        ),
        child: BlocBuilder<ExclusiveservicedetailsCubit, ExclusiveservicedetailsState>(
          builder: (context, state) {
            if (state is ExclusiveservicedetailsStateLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ExclusiveservicedetailsFailure) {
              return Center(child: Text(state.msg, style: const TextStyle(fontFamily: 'segeo')));
            }
            if (state is ExclusiveservicedetailsStateLoaded) {
              final d = state.exclusiveservicedetailsModel.data;
              final name = (d?.name ?? '').trim();
              final desc = (d?.description ?? '').trim();
              final banner = (d?.imageUrl ?? '').trim();
              // final link = (d?.link ?? '').trim(); // make sure your model has `link`

              return Stack(
                alignment: Alignment.center,
                children: [
                  ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    children: [
                      // Banner Card (rounded light container with inner image)
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
                          child: SizedBox(
                            height: 170,
                            width: double.infinity,
                            child: banner.isEmpty
                                ? Container(
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.broken_image_outlined, color: Colors.grey, size: 40),
                            )
                                : CachedNetworkImage(
                              imageUrl: banner,
                              fit: BoxFit.cover,
                              placeholder: (c, _) => const Center(
                                child: SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(strokeWidth: 1.8),
                                ),
                              ),
                              errorWidget: (c, _, __) => Container(
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.broken_image_outlined, color: Colors.grey, size: 40),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Row(
                        children: [
                          _MiniAvatar(name: name, imageUrl: banner), // or use a separate author image if you have it
                          const SizedBox(width: 8),
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

                      // Link section like screenshot (two lines, second line blue underlined)
                      const Text(
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
                          // recognizer: TapGestureRecognizer()..onTap = () => _open(link),
                        ),
                      ),

                      const SizedBox(height: 80), // space so badge doesn’t overlap last line
                    ],
                  ),

                  // Center bottom circular badge with initial (like the “S” in screenshot)
                  Positioned(
                    bottom: 28,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        backgroundColor: const Color(0xFF6B7280),
                        child: Text(
                          (name.isEmpty ? 'S' : name.characters.first.toUpperCase()),
                          style: const TextStyle(
                            fontFamily: 'segeo',
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
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

/// Small round avatar like screenshot (12px radius look)
class _MiniAvatar extends StatelessWidget {
  final String name;
  final String imageUrl;
  const _MiniAvatar({required this.name, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final initial = (name.isEmpty ? 'S' : name.trim().characters.first.toUpperCase());
    if (imageUrl.isEmpty) {
      return CircleAvatar(
        radius: 12,
        backgroundColor: Colors.grey.shade200,
        child: Text(
          initial,
          style: const TextStyle(
            fontFamily: 'segeo',
            fontSize: 12,
            color: Colors.black54,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, provider) => CircleAvatar(radius: 12, backgroundImage: provider),
      placeholder: (context, url) => CircleAvatar(
        radius: 12,
        backgroundColor: Colors.grey.shade200,
        child: Center(child: spinkits.getSpinningLinespinkit()),
      ),
      errorWidget: (context, url, error) => CircleAvatar(
        radius: 12,
        backgroundColor: Colors.grey.shade200,
        child: Text(
          initial,
          style: const TextStyle(
            fontFamily: 'segeo',
            fontSize: 12,
            color: Colors.black54,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
