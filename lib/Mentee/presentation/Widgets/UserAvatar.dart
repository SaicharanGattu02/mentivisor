import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String? imageUrl;     // remote/local url (can be null)
  final String? name;         // used to show initial
  final double size;

  const UserAvatar({super.key, this.imageUrl, this.name, this.size = 36});

  @override
  Widget build(BuildContext context) {
    final hasUrl = (imageUrl ?? '').trim().isNotEmpty;
    final initial = (name ?? '').trim().isNotEmpty
        ? name!.trim().characters.first.toUpperCase()
        : '?';

    return SizedBox(
      width: size,
      height: size,
      child: ClipOval(
        child: hasUrl
            ? Image.network(
          imageUrl!,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _initial(initial),
        )
            : _initial(initial),
      ),
    );
  }

  Widget _initial(String initial) {
    return Container(
      color: const Color(0xFFE7ECF2),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Color(0xFF2A3A4B),
        ),
      ),
    );
  }
}

