import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:crypto/crypto.dart';

class FfmpegCaptureService {
  String? _ffmpegPath;
  Timer? _captureTimer;
  Digest? _lastFrameHash;
  bool _enableDeltaDetection = true;
  
  /// Enable or disable delta detection (only send if frame changed)
  void setDeltaDetection(bool enabled) {
    _enableDeltaDetection = enabled;
  }
  
  // Set this to the path where ffmpeg.exe is located
  void setFfmpegPath(String path) {
    _ffmpegPath = path;
  }

  /// Automatically attempt to find ffmpeg.exe
  Future<bool> initialize() async {
    // 1. Check if it's already in the PATH
    if (await _checkFfmpeg('ffmpeg')) {
      _ffmpegPath = 'ffmpeg';
      return true;
    }

    // 2. Check relative to executable (for portable builds)
    final exePath = Platform.resolvedExecutable;
    final exeDir = p.dirname(exePath);
    
    final localPaths = [
      p.join(exeDir, 'ffmpeg.exe'),
      p.join(exeDir, 'bin', 'ffmpeg.exe'),
      p.join(Directory.current.path, 'bin', 'ffmpeg.exe'),
      p.join(Directory.current.path, 'ffmpeg.exe'),
      // Check sibling server directory (Common in this workspace)
      p.join(Directory.current.path, '../lume_server/lume_server_server/ffmpeg.exe'),
    ];

    for (final path in localPaths) {
      if (await _checkFfmpeg(path)) {
        _ffmpegPath = path;
        debugPrint('Auto-discovered FFmpeg at: $path');
        return true;
      }
    }

    debugPrint('FFmpeg not found. Eco mode will be unavailable.');
    return false;
  }

  Future<bool> _checkFfmpeg(String command) async {
    try {
      final result = await Process.run(command, ['-version']);
      return result.exitCode == 0;
    } catch (_) {
      return false;
    }
  }

  Future<Uint8List?> captureFrame({int quality = 6}) async {
    if (_ffmpegPath == null) {
      debugPrint('FFmpeg path not set');
      return null;
    }

    final tempDir = Directory.systemTemp;
    final outputPath = p.join(tempDir.path, 'lume_capture.jpg');
    
    try {
      // ffmpeg -f gdigrab -framerate 1 -i desktop -frames:v 1 -q:v 5 -y output.jpg
      final result = await Process.run(_ffmpegPath!, [
        '-f', 'gdigrab',
        '-framerate', '1',
        '-i', 'desktop',
        '-frames:v', '1',
        '-q:v', quality.toString(), // Quality 1-31 (lower is better, 6 is good balance, 20 is eco)
        '-y',
        outputPath,
      ]);

      if (result.exitCode == 0) {
        final file = File(outputPath);
        if (await file.exists()) {
          final bytes = await file.readAsBytes();
          
          if (_enableDeltaDetection) {
            final currentHash = md5.convert(bytes);
            if (currentHash == _lastFrameHash) {
              // Frame hasn't changed
              return null;
            }
            _lastFrameHash = currentHash;
          }
          
          return bytes;
        }
      } else {
        debugPrint('FFmpeg error: ${result.stderr}');
      }
    } catch (e) {
      debugPrint('Capture exception: $e');
    }
    return null;
  }

  void startPeriodicCapture(Duration interval, Function(Uint8List data) onFrame, {int quality = 6}) {
    _captureTimer?.cancel();
    _captureTimer = Timer.periodic(interval, (timer) async {
      final data = await captureFrame(quality: quality);
      if (data != null) {
        onFrame(data);
      }
    });
  }

  void stop() {
    _captureTimer?.cancel();
    _captureTimer = null;
    _lastFrameHash = null;
    
    // Attempt rapid cleanup
    if (Platform.isWindows) {
      Process.run('taskkill', ['/F', '/IM', 'ffmpeg.exe']);
    }
  }
}
