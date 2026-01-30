import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/lume_session_state.dart';
import '../widgets/ghost_cursor.dart';
import '../theme/lume_theme.dart';
import '../widgets/browser_view.dart';
import '../widgets/action_menu.dart';
import '../widgets/action_overlays.dart';

/// Main Session Screen
class SessionScreen extends StatefulWidget {
  final String url;

  const SessionScreen({
    super.key, 
    required this.url,
  });

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  // Mode: Interact (web) vs Present (pointer)
  bool _isPresentMode = true;
  
  // Action Menu State
  Offset? _menuPosition;
  
  // Transient Overlay State
  Timer? _overlayTimer;
  
  @override
  void dispose() {
    _overlayTimer?.cancel();
    super.dispose();
  }
  
  void _onPointerMove(PointerHoverEvent event, Size screenSize) {
    if (!_isPresentMode) return;
    
    final sessionState = context.read<LumeSessionState>();
    final normalized = CoordinateNormalization.normalize(
      x: event.position.dx,
      y: event.position.dy,
      screenWidth: screenSize.width,
      screenHeight: screenSize.height,
    );
    
    sessionState.sendPointerEvent(
      normalizedX: normalized['x']!,
      normalizedY: normalized['y']!,
      type: 'move',
    );
  }
  
  void _onPointerDown(PointerDownEvent event, Size screenSize) {
    if (!_isPresentMode) return;
    
    final sessionState = context.read<LumeSessionState>();
    final normalized = CoordinateNormalization.normalize(
      x: event.position.dx,
      y: event.position.dy,
      screenWidth: screenSize.width,
      screenHeight: screenSize.height,
    );
    
    sessionState.sendPointerEvent(
      normalizedX: normalized['x']!,
      normalizedY: normalized['y']!,
      type: 'click',
    );
  }

  void _showActionMenu(Offset position) {
    if (!_isPresentMode) return;
    setState(() => _menuPosition = position);
  }

  void _handleAction(String actionType, Size screenSize) {
    if (_menuPosition == null) return;
    
    final sessionState = context.read<LumeSessionState>();
    final normalized = CoordinateNormalization.normalize(
      x: _menuPosition!.dx,
      y: _menuPosition!.dy,
      screenWidth: screenSize.width,
      screenHeight: screenSize.height,
    );
    
    sessionState.sendPointerEvent(
      normalizedX: normalized['x']!,
      normalizedY: normalized['y']!,
      type: 'action',
      action: actionType,
    );
    
    // Close menu
    setState(() => _menuPosition = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<LumeSessionState>(
          builder: (context, state, _) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Session: ${state.sessionId ?? "Unknown"}'),
                if (state.isConnected)
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            );
          },
        ),
        actions: [
          // Mode Toggle
          Padding(
             padding: const EdgeInsets.symmetric(horizontal: 8),
             child: SegmentedButton<bool>(
              segments: const [
                ButtonSegment(
                  value: true,
                  icon: Icon(Icons.present_to_all),
                  label: Text('Present'),
                ),
                ButtonSegment(
                  value: false,
                  icon: Icon(Icons.touch_app),
                  label: Text('Interact'),
                ),
              ],
              selected: {_isPresentMode},
              onSelectionChanged: (selection) {
                setState(() {
                  _isPresentMode = selection.first;
                  _menuPosition = null;
                });
              },
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                     return LumeTheme.primaryGold;
                  }
                  return null;
                }),
              ),
            ),
          ),
          
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await context.read<LumeSessionState>().leaveSession();
              if (mounted) Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenSize = Size(constraints.maxWidth, constraints.maxHeight);
          
          return Stack(
            children: [
              // 1. Browser Layer (Iframe)
              Positioned.fill(
                child: BrowserView(url: widget.url),
              ),
              
              // 2. Interaction Layer (Only visible in Present mode)
              if (_isPresentMode)
                Positioned.fill(
                  child: MouseRegion(
                    onHover: (event) => _onPointerMove(event, screenSize),
                    child: Listener(
                      onPointerDown: (event) => _onPointerDown(event, screenSize),
                      child: GestureDetector(
                        onLongPressStart: (details) => _showActionMenu(details.localPosition),
                        behavior: HitTestBehavior.translucent,
                        child: Container(
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                ),
                
              // 3. Ghost Cursor & Action Overlays (Always on top)
              Consumer<LumeSessionState>(
                builder: (context, state, _) {
                  final currentEvent = state.currentPointerEvent;
                  final history = state.pointerHistory;
                  final lastAction = state.lastActionEvent;
                  
                  return Stack(
                    children: [
                      // Ghost Cursor
                      if (currentEvent != null && history.isNotEmpty)
                        GhostCursor(
                          currentEvent: currentEvent,
                          history: history,
                          screenWidth: screenSize.width,
                          screenHeight: screenSize.height,
                        ),
                        
                      // Action Overlay
                      if (lastAction != null && lastAction.action != null)
                        _buildActionOverlay(lastAction, screenSize, state),
                    ],
                  );
                },
              ),
              
              // 4. Action Menu (Local UI)
              if (_menuPosition != null)
                ActionMenu(
                  position: _menuPosition!,
                  onActionSelected: (action) => _handleAction(action, screenSize),
                  onDismiss: () => setState(() => _menuPosition = null),
                ),
            ],
          );
        },
      ),
    );
  }
  
  Widget _buildActionOverlay(
    dynamic actionEvent, // Using dynamic to avoid import conflict issues temporarily
    Size screenSize,
    LumeSessionState state,
  ) {
    if (actionEvent == null) return const SizedBox.shrink();
    
    // Auto-clear action after 3 seconds
    if (_overlayTimer?.isActive != true) {
      _overlayTimer = Timer(const Duration(seconds: 3), () {
        state.consumeLastAction();
      });
    }

    final x = actionEvent.x * screenSize.width;
    final y = actionEvent.y * screenSize.height;
    
    Widget overlay;
    switch (actionEvent.action) {
      case 'look_here':
        overlay = const LookHereRing();
        break;
      case 'check_box':
        overlay = const ArrowPointer();
        break;
      case 'scroll':
        overlay = const ArrowPointer(color: LumeTheme.softBlue);
        break;
      default:
        return const SizedBox.shrink();
    }
    
    return Positioned(
      left: x - 50, // Center based on size (roughly)
      top: y - 50,
      child: overlay,
    );
  }
}
