// customutils/shimmer_widget.dart

import 'package:bitdevs_project/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerBox extends StatelessWidget {
  final double height;
  final double width;
  final double borderRadius;

  const ShimmerBox({
    super.key,
    required this.height,
    required this.width,
    this.borderRadius = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: kgraycolor.withOpacity(0.4),
      highlightColor: kgraycolor.withOpacity(0.1),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: kgraycolor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class QuickActionBar extends StatelessWidget {
  final List<Map<String, dynamic>> actions;

  const QuickActionBar({super.key, required this.actions});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: actions.map((action) {
        return GestureDetector(
          onTap: action['onTap'],
          child: Column(
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.tertiary,
                ),
                child: Center(
                  child: Image.asset(
                    action['icon'],
                    height: 30,
                    width: 30,
                    color: korangeColor,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                action['label'],
                style: TextStyle(
                  color: korangeColor,
                  fontSize: 13,
                  fontFamily: "Aeonik",
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
