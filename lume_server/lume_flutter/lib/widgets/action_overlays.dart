import 'package:flutter/material.dart';
import '../theme/lume_theme.dart';

/// Pulsing ring animation for "Look Here" action
class LookHereRing extends StatefulWidget {
  final double size;
  final Color color;

  const LookHereRing({
    super.key,
    this.size = 100.0,
    this.color = LumeTheme.accentGold,
  });

  @override
  State<LookHereRing> createState() => _LookHereRingState();
}

class _LookHereRingState extends State<LookHereRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: widget.color,
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Arrow pointing to "Check this Box"
class ArrowPointer extends StatefulWidget {
  final Color color;

  const ArrowPointer({
    super.key,
    this.color = LumeTheme.accentGold,
  });

  @override
  State<ArrowPointer> createState() => _ArrowPointerState();
}

class _ArrowPointerState extends State<ArrowPointer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -20),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: _slideAnimation.value,
          child: Icon(
            Icons.arrow_downward_rounded,
            size: 64,
            color: widget.color,
            shadows: [
              Shadow(
                color: widget.color.withOpacity(0.5),
                blurRadius: 10,
              ),
            ],
          ),
        );
      },
    );
  }
}
