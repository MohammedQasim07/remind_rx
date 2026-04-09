import 'dart:ui';
import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;

  const GlassCard({
    Key? key,
    required this.child,
    this.blur = 15.0,
    this.opacity = 0.65,
    this.padding = const EdgeInsets.all(20),
    this.margin,
    this.borderRadius,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultRadius = BorderRadius.circular(20);

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? defaultRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04), // Very soft shadow
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? defaultRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Material(
            color: Colors.transparent, // Material needs to be transparent for ink well inside blur
            child: InkWell(
              onTap: onTap,
              borderRadius: borderRadius ?? defaultRadius,
              child: Container(
                padding: padding,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(opacity),
                  borderRadius: borderRadius ?? defaultRadius,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5), // Subtle inner white light edge
                    width: 1.5,
                  ),
                ),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
