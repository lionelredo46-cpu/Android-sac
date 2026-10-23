import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../theme/strato.dart';

/// Bloc de chargement : verre qui scintille.
class LoadingSkeleton extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const LoadingSkeleton({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  const LoadingSkeleton.rectangular({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  const LoadingSkeleton.circular({
    super.key,
    required double size,
  })  : width = size,
        height = size,
        borderRadius = size / 2;

  @override
  Widget build(BuildContext context) {
    final s = context.strato;
    return Shimmer.fromColors(
      baseColor: s.isDark ? const Color(0x14FFFFFF) : const Color(0x140A1F44),
      highlightColor: s.isDark ? const Color(0x33FFFFFF) : const Color(0x060A1F44),
      period: const Duration(milliseconds: 1700),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
