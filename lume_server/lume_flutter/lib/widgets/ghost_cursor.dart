import 'package:flutter/material.dart';
import 'package:lume_server_client/lume_server_client.dart' as protocol;

/// Ghost Cursor widget with glowing orb and tail effect
/// 
/// Features:
/// - Glowing orb using CustomPainter
/// - Comet tail from last 5 positions
/// - Pulse animation on 'click' events
/// - Smooth position transitions
class GhostCursor extends StatefulWidget {
  final protocol.PointerEvent currentEvent;
  final List<protocol.PointerEvent> history;
  final double screenWidth;
  final double screenHeight;
  
  const GhostCursor({
    super.key,
    required this.currentEvent,
    required this.history,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  State<GhostCursor> createState() => _GhostCursorState();
}

class _GhostCursorState extends State<GhostCursor> 
    with SingleTickerProviderStateMixin {
  
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  
  @override
  void initState() {
    super.initState();
    
    // Pulse animation for click events
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeOut),
    );
  }
  
  @override
  void didUpdateWidget(GhostCursor oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Trigger pulse animation on click events
    if (widget.currentEvent.type == 'click' && 
        oldWidget.currentEvent.type != 'click') {
      _pulseController.forward(from: 0.0);
    }
  }
  
  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Denormalize current position
    final x = widget.currentEvent.x * widget.screenWidth;
    final y = widget.currentEvent.y * widget.screenHeight;
    
    return Stack(
      children: [
        // Tail effect (comet trail)
        ...widget.history.asMap().entries.map((entry) {
          final index = entry.key;
          final event = entry.value;
          final opacity = (index + 1) / widget.history.length * 0.5;
          final size = 8.0 + (index / widget.history.length * 12.0);
          
          final tailX = event.x * widget.screenWidth;
          final tailY = event.y * widget.screenHeight;
          
          return Positioned(
            left: tailX - size / 2,
            top: tailY - size / 2,
            child: _TailDot(
              size: size,
              opacity: opacity,
            ),
          );
        }),
        
        // Main glowing orb
        AnimatedPositioned(
          duration: const Duration(milliseconds: 16), // Smooth 60fps transition
          curve: Curves.easeOut,
          left: x - 20,
          top: y - 20,
          child: AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: child,
              );
            },
            child: const _GlowingOrb(size: 40),
          ),
        ),
      ],
    );
  }
}

/// Glowing orb using CustomPainter
class _GlowingOrb extends StatelessWidget {
  final double size;
  
  const _GlowingOrb({required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _LumeOrbPainter(),
    );
  }
}

/// Custom painter for the glowing orb effect
class _LumeOrbPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    // Outer glow (soft blue)
    final outerGlowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF6B9BD1).withOpacity(0.8), // Boosted from 0.3
          Colors.transparent,
        ],
        stops: const [0.4, 1.0], // Wider falloff
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    
    canvas.drawCircle(center, radius, outerGlowPaint);
    
    // Middle glow (gold)
    final middleGlowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFD4AF37).withOpacity(0.9), // Boosted from 0.6
          const Color(0xFFD4AF37).withOpacity(0.4),
          Colors.transparent,
        ],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 0.7));
    
    canvas.drawCircle(center, radius * 0.7, middleGlowPaint);
    
    // Core orb (bright gold)
    final corePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFFD700),
          const Color(0xFFD4AF37),
        ],
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 0.3));
    
    canvas.drawCircle(center, radius * 0.3, corePaint);
    
    // Highlight (white)
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.8);
    
    canvas.drawCircle(
      Offset(center.dx - radius * 0.1, center.dy - radius * 0.1),
      radius * 0.15,
      highlightPaint,
    );

    // Solid core (Absolute fallback visibility)
    final solidCorePaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, radius * 0.1, solidCorePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Tail dot for comet effect
class _TailDot extends StatelessWidget {
  final double size;
  final double opacity;
  
  const _TailDot({
    required this.size,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFD4AF37).withOpacity(opacity),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD4AF37).withOpacity(opacity * 0.5),
            blurRadius: size * 0.5,
            spreadRadius: size * 0.2,
          ),
        ],
      ),
    );
  }
}
