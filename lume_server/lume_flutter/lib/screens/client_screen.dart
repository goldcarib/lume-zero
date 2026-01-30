import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:provider/provider.dart';
import '../state/lume_session_state.dart';
import '../services/webrtc_service.dart';
import '../theme/lume_theme.dart';

class ClientScreen extends StatefulWidget {
  const ClientScreen({super.key});

  @override
  State<ClientScreen> createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  final WebRTCService _webRTCService = WebRTCService();
  // Action Menu State
  Offset? _menuPosition;
  bool _showFallbackOption = false;
  Timer? _connectionTimer;
  Uint8List? _lastValidFrameData; // Cache last valid frame

  @override
  void initState() {
    super.initState();
    _initWebRTC();
  }

  Future<void> _initWebRTC() async {
    setState(() {
      _showFallbackOption = false;
    });
    
    _connectionTimer?.cancel();
    _connectionTimer = Timer(const Duration(seconds: 5), () {
      if (mounted && _webRTCService.remoteRenderer?.srcObject == null) {
        // Auto-switch to FFmpeg mode instead of showing prompt
        _switchToFfmpegMode();
      }
    });

    await _webRTCService.init();
    
    // Setup signaling
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final sessionState = context.read<LumeSessionState>();
      _webRTCService.onSignal = (type, sdp, candidate, sdpMid, sdpMlineIndex) {
        sessionState.sendSignaling(
          type: type,
          sdp: sdp,
          candidate: candidate,
          sdpMid: sdpMid,
          sdpMlineIndex: sdpMlineIndex,
        );
      };
      
      sessionState.onSignalingMessage = (type, sdp, candidate, sdpMid, sdpMlineIndex) {
        _webRTCService.handleSignal(type, sdp, candidate, sdpMid, sdpMlineIndex);
      };
      
      _webRTCService.onRemoteStream = (_) {
        _connectionTimer?.cancel();
        if (mounted) setState(() { _showFallbackOption = false; });
      };
      
      // Notify host we are ready to join
      _webRTCService.joinAsViewer();
      // Small delay to ensure host is ready for signaling
      Future.delayed(const Duration(milliseconds: 500), () {
        sessionState.sendSignaling(type: 'request_offer');
      });
    });
    
    if (mounted) setState(() {}); // Refresh to show renderer
  }

  void _switchToCompatibilityMode() {
    _connectionTimer?.cancel();
    final sessionState = context.read<LumeSessionState>();
    sessionState.sendSignaling(type: 'use_compatibility_mode');
    setState(() {
       _showFallbackOption = false;
    });
  }

  void _switchToFfmpegMode() {
    _connectionTimer?.cancel();
    final sessionState = context.read<LumeSessionState>();
    sessionState.sendSignaling(type: 'use_ffmpeg_mode');
    setState(() {
       _showFallbackOption = false;
    });
  }

  @override
  void dispose() {
    _webRTCService.dispose();
    super.dispose();
  }

  void _onPointerHover(PointerEvent event, BoxConstraints constraints, double? imgWidth, double? imgHeight) {
    if (imgWidth == null || imgHeight == null) return;
    _sendPointerEvent(event.localPosition, constraints, imgWidth, imgHeight, 'move');
  }

  void _onPointerDown(PointerEvent event, BoxConstraints constraints, double? imgWidth, double? imgHeight) {
    if (imgWidth == null || imgHeight == null) return;
    _sendPointerEvent(event.localPosition, constraints, imgWidth, imgHeight, 'click');
  }

  void _onPointerExit() {
    // Optional: Hide cursor on exit
  }

  void _onPointerSignal(PointerSignalEvent event, BoxConstraints constraints) {
    if (event is PointerScrollEvent) {
      // Handle scroll if needed
    }
  }
  
  void _sendPointerEvent(Offset local, BoxConstraints constraints, double imgW, double imgH, String type) {
    // Calculate Rendered Image Rect
    final imageRatio = imgW / imgH;
    final screenRatio = constraints.maxWidth / constraints.maxHeight;
    
    double renderWidth, renderHeight;
    double offsetX, offsetY;
    
    if (screenRatio > imageRatio) {
      // Screen is wider (Pillarbox)
      renderHeight = constraints.maxHeight;
      renderWidth = renderHeight * imageRatio;
      offsetX = (constraints.maxWidth - renderWidth) / 2;
      offsetY = 0;
    } else {
      // Screen is taller (Letterbox)
      renderWidth = constraints.maxWidth;
      renderHeight = renderWidth / imageRatio;
      offsetX = 0;
      offsetY = (constraints.maxHeight - renderHeight) / 2;
    }
    
    // Check bounds
    if (local.dx < offsetX || local.dx > offsetX + renderWidth ||
        local.dy < offsetY || local.dy > offsetY + renderHeight) {
      return;
    }
    
    // Normalize
    final normX = (local.dx - offsetX) / renderWidth;
    final normY = (local.dy - offsetY) / renderHeight;
    
    context.read<LumeSessionState>().sendPointerEvent(
      normalizedX: normX,
      normalizedY: normY,
      type: type,
    );
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         title: const Text('Remote View'),
         leading: IconButton(
           icon: const Icon(Icons.arrow_back),
           onPressed: () {
              context.read<LumeSessionState>().leaveSession();
              Navigator.pop(context);
           },
         ),
       ),
       floatingActionButton: FloatingActionButton.extended(
         onPressed: () => _showButlerChat(context),
         icon: const Icon(Icons.psychology, color: Colors.black),
         label: const Text('ASK BUTLER', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
         backgroundColor: LumeTheme.primaryGold,
       ),
       body: Consumer<LumeSessionState>(
         builder: (context, state, _) {
           final frame = state.currentFrame;
           
           return LayoutBuilder(
             builder: (context, constraints) {
               if (_webRTCService.remoteRenderer?.srcObject == null) {
                 // If we have a frame (from fallback or old protocol), show it
                 if (frame != null) {
                    return _buildFrameView(frame, constraints);
                 }

                 return Center(
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       const CircularProgressIndicator(),
                       const SizedBox(height: 16),
                       const Text("Connecting to Host..."),
                       const SizedBox(height: 24),
                       ElevatedButton(
                         onPressed: () => _initWebRTC(),
                         child: const Text("Retry Connection"),
                       ),
                       if (_showFallbackOption) ...[
                         const SizedBox(height: 16),
                         TextButton(
                       onPressed: _switchToCompatibilityMode,
                       child: const Text("Switch to Compatibility Mode (Loud)"),
                     ),
                     TextButton(
                       onPressed: _switchToFfmpegMode,
                       child: const Text("Switch to FFmpeg Mode (Silent)"),
                     ),
                   ],
                       const SizedBox(height: 32),
                       _buildDiagnosticPanel(state),
                     ],
                   ),
                 );
               }

               return GestureDetector(
                 onDoubleTapDown: (details) {
                   final x = details.localPosition.dx / constraints.maxWidth;
                   final y = details.localPosition.dy / constraints.maxHeight;
                   state.sendPointerEvent(
                     normalizedX: x,
                     normalizedY: y,
                     type: 'action',
                     action: 'drop_poi',
                   );
                 },
                 child: MouseRegion(
                   onHover: (e) => _onPointerHover(e, constraints, 1280, 720), // Assume default or get from stream
                   onExit: (_) => _onPointerExit(),
                   child: Listener(
                     onPointerDown: (e) => _onPointerDown(e, constraints, 1280, 720),
                     onPointerMove: (e) => _onPointerHover(e, constraints, 1280, 720),
                     onPointerSignal: (e) => _onPointerSignal(e, constraints),
                     child: Container(
                       width: double.infinity,
                       height: double.infinity,
                       color: Colors.black,
                       child: RTCVideoView(
                         _webRTCService.remoteRenderer!,
                         objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitContain,
                       ),
                     ),
                   ),
                 ),
               );
             },
           );
         },
       ),
     );
  }
  Widget _buildDiagnosticPanel(LumeSessionState state) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Diagnostic Logs:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.blueAccent)),
          const SizedBox(height: 8),
          ...state.diagnosticLogs.map((log) => Text(
                log,
                style: const TextStyle(fontSize: 10, fontFamily: 'monospace', color: Colors.white70),
              )),
          if (state.diagnosticLogs.isEmpty)
            const Text("No messages received yet...", style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildFrameView(dynamic frame, BoxConstraints constraints) {
    return GestureDetector(
      onDoubleTapDown: (details) {
        final x = details.localPosition.dx / constraints.maxWidth;
        final y = details.localPosition.dy / constraints.maxHeight;
        final state = context.read<LumeSessionState>();
        state.sendPointerEvent(
          normalizedX: x,
          normalizedY: y,
          type: 'action',
          action: 'drop_poi',
        );
      },
      child: MouseRegion(
        onHover: (e) => _onPointerHover(e, constraints, frame.width?.toDouble(), frame.height?.toDouble()),
        onExit: (_) => _onPointerExit(),
        child: Listener(
          onPointerDown: (e) => _onPointerDown(e, constraints, frame.width?.toDouble(), frame.height?.toDouble()),
          onPointerMove: (e) => _onPointerHover(e, constraints, frame.width?.toDouble(), frame.height?.toDouble()),
          onPointerSignal: (e) => _onPointerSignal(e, constraints),
          child: Image.memory(
            frame.data.buffer.asUint8List(),
            gaplessPlayback: true,
            fit: BoxFit.contain,
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            errorBuilder: (context, error, stackTrace) {
              // Keep showing last valid frame instead of black screen
              if (_lastValidFrameData != null) {
                return Image.memory(
                  _lastValidFrameData!,
                  gaplessPlayback: true,
                  fit: BoxFit.contain,
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                );
              }
              return Container(
                color: Colors.black,
                child: const Center(
                  child: Icon(Icons.image_not_supported, color: Colors.white24, size: 48),
                ),
              );
            },
            frameBuilder: (context, child, frameNum, wasSynchronouslyLoaded) {
              // Cache this frame if it loaded successfully
              if (frameNum != null) {
                _lastValidFrameData = frame.data.buffer.asUint8List();
              }
              return child;
            },
          ),
        ),
      ),
    );
  }

  void _showButlerChat(BuildContext context) {
    final controller = TextEditingController();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false, // Prevent dismissal on outside tap
      enableDrag: false, // Prevent swipe-to-dismiss
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black12, // Minimal darkness (very light background)
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.4,
          decoration: const BoxDecoration(
            color: LumeTheme.surfaceDark,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.psychology, color: LumeTheme.primaryGold),
                  const SizedBox(width: 12),
                  const Text('AI Butler Assistance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                ],
              ),
              const Divider(color: Colors.white10),
              Expanded(
                child: Consumer<LumeSessionState>(
                  builder: (context, state, _) {
                    return ListView.builder(
                      itemCount: state.diagnosticLogs.where((l) => l.contains('[AI Butler]')).length,
                      itemBuilder: (context, index) {
                        final butlerLogs = state.diagnosticLogs.where((l) => l.contains('[AI Butler]')).toList();
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            butlerLogs[index],
                            style: TextStyle(
                              color: butlerLogs[index].contains('Thinking') ? Colors.white38 : Colors.white70,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Ask about the current screen...',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send, color: LumeTheme.primaryGold),
                    onPressed: () async {
                      final q = controller.text.trim();
                      if (q.isNotEmpty) {
                        controller.clear();
                        await context.read<LumeSessionState>().askButler(q);
                      }
                    },
                  ),
                ),
                onSubmitted: (q) async {
                  if (q.trim().isNotEmpty) {
                    controller.clear();
                    await context.read<LumeSessionState>().askButler(q.trim());
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
