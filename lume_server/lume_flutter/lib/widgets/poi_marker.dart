import 'package:flutter/material.dart';

class PoiMarker extends StatefulWidget {
  final double x;
  final double y;
  final Duration duration;

  const PoiMarker({
    super.key,
    required this.x,
    required this.y,
    required this.duration,
  });

  @override
  State<PoiMarker> createState() => _PoiMarkerState();
}

class _PoiMarkerState extends State<PoiMarker> with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    // Fade out over the last 2 seconds
    _fadeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 80),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0), weight: 20),
    ]).animate(_fadeController);

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = 30.0;
    
    return Positioned(
      left: widget.x - size / 2,
      top: widget.y - size / 2,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                Colors.amber.withOpacity(0.8),
                Colors.amber.withOpacity(0.2),
                Colors.transparent,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.amber.withOpacity(0.5),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.not_listed_location,
              color: Colors.white,
              size: size * 0.6,
            ),
          ),
        ),
      ),
    );
  }
}
