import 'package:flutter/material.dart';
import '../theme/lume_theme.dart';

class ActionMenu extends StatelessWidget {
  final Offset position;
  final Function(String) onActionSelected;
  final VoidCallback onDismiss;

  const ActionMenu({
    super.key,
    required this.position,
    required this.onActionSelected,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Modal barrier to dismiss
        Positioned.fill(
          child: GestureDetector(
            onTap: onDismiss,
            behavior: HitTestBehavior.translucent,
            child: Container(color: Colors.transparent),
          ),
        ),
        
        // Menu content
        Positioned(
          left: position.dx,
          top: position.dy,
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: LumeTheme.surfaceDark,
                borderRadius: BorderRadius.circular(16),
                boxShadow: LumeTheme.cardShadow,
                border: Border.all(color: LumeTheme.accentGold.withOpacity(0.3)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _MenuItem(
                    icon: Icons.ads_click,
                    label: "Look Here",
                    onTap: () => onActionSelected('look_here'),
                  ),
                  const Divider(height: 1, color: Colors.white10),
                  _MenuItem(
                    icon: Icons.check_box_outlined,
                    label: "Check Box",
                    onTap: () => onActionSelected('check_box'),
                  ),
                  const Divider(height: 1, color: Colors.white10),
                  _MenuItem(
                    icon: Icons.swap_vert,
                    label: "Scroll Here",
                    onTap: () => onActionSelected('scroll'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: LumeTheme.accentGold, size: 20),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
