import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomerServiceScreen extends StatelessWidget {
  const CustomerServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'Customer Service';
    const bodyText =
        'Lorem Ipsum is simply dummy text of the printing and typesetting industry. '
        'Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, '
        'when an unknown printer took a galley of type and scrambled it to make a type '
        'specimen book';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,

        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Illustration area
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: AspectRatio(
                aspectRatio: 1, // nice square block like the screenshot
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      // put your exact art here to match the screenshot
                      'images/customer_service_img.png',
                      fit: BoxFit.cover,
                      // fallback so the screen still runs without the asset
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.support_agent_rounded,
                        size: 160,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Description sheet (fills the rest)
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  // subtle top radius only, like your design
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                  ),
                  // light lilac -> white gradient like the mock
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFF3F2FF), // very light purple
                      Colors.white,
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          bodyText,
                          style: TextStyle(
                            fontSize: 13.5,
                            height: 1.45,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Phone row
                        _ContactRow(
                          leading: Image.asset(
                            "images/telephoneimg.png",
                            width: 20,
                            height: 20,
                          ),
                          text: '+91 8448484848',
                        ),
                        const SizedBox(height: 14),

                        // Email row (uses asset if you add it)
                        _ContactRow(
                          leading: Image.asset(
                            "images/gmailimg.png",
                            width: 20,
                            height: 20,
                          ),
                          text: 'Mentivisor123@gmail.com',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final Widget leading;
  final String text;

  const _ContactRow({required this.leading, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        leading,
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 13.5, color: Colors.black),
          ),
        ),
      ],
    );
  }
}

class _RoundIcon extends StatelessWidget {
  final IconData icon;
  const _RoundIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Icon(icon, size: 20, color: const Color(0xFF2196F3)),
    );
  }
}

class _RoundImageOrIcon extends StatelessWidget {
  final String asset;
  final IconData fallbackIcon;

  const _RoundImageOrIcon({required this.asset, required this.fallbackIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          asset,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) =>
              Icon(fallbackIcon, size: 20, color: Colors.redAccent),
        ),
      ),
    );
  }
}
