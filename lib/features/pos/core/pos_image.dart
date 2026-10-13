import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// A category or item picture. Shows, in this order:
///   * the picture itself — an https link (the admin's photo) or a small uploaded image sent as a data link
///     (the shop's own photo, shrunk by the website/app before it is saved);
///   * otherwise a neutral tile with the first letter of the name, so a tile never looks broken.
/// A bundled-asset path (a leading "/") is a desktop-only artefact and is treated as "no picture".
class PosImage extends StatelessWidget {
  const PosImage({required this.url, required this.name, this.size = 56, this.radius = 12, super.key});

  final String? url;
  final String name;
  final double size;
  final double radius;

  static final Map<String, Uint8List> _decoded = <String, Uint8List>{};

  static Uint8List? _bytesOf(String data) {
    final cached = _decoded[data];
    if (cached != null) return cached;
    final comma = data.indexOf(',');
    if (comma < 0) return null;
    try {
      final bytes = base64Decode(data.substring(comma + 1));
      if (_decoded.length > 200) _decoded.clear();
      return _decoded[data] = bytes;
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fallback = Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: scheme.primaryContainer, borderRadius: BorderRadius.circular(radius)),
      child: Text(
        name.trim().isEmpty ? '•' : name.trim().characters.first.toUpperCase(),
        style: TextStyle(fontSize: size * 0.42, fontWeight: FontWeight.w800, color: scheme.onPrimaryContainer),
      ),
    );

    final u = url?.trim();
    Widget? image;
    if (u != null && u.isNotEmpty) {
      if (u.startsWith('data:image/')) {
        final bytes = _bytesOf(u);
        if (bytes != null) image = Image.memory(bytes, width: size, height: size, fit: BoxFit.cover, gaplessPlayback: true, errorBuilder: (_, __, ___) => fallback);
      } else if (u.startsWith('http://') || u.startsWith('https://')) {
        image = CachedNetworkImage(
          imageUrl: u,
          width: size,
          height: size,
          fit: BoxFit.cover,
          memCacheWidth: (size * 3).round(),
          placeholder: (_, __) => Container(width: size, height: size, color: scheme.surfaceContainerHighest),
          errorWidget: (_, __, ___) => fallback,
        );
      }
    }
    if (image == null) return ExcludeSemantics(child: fallback);
    // The picture is decoration: the name is already read out next to it.
    return ExcludeSemantics(child: ClipRRect(borderRadius: BorderRadius.circular(radius), child: image));
  }
}
