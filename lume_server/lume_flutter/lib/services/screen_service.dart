import 'dart:typed_data';
import 'package:screen_capturer/screen_capturer.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/foundation.dart';

/// Service for capturing and compressing screen frames

/// Isolated function for image processing
Future<CaptureResult?> _processImage(_ProcessImageParams params) async {
  try {
    // Decode PNG (slow operation)
    img.Image? image = img.decodeImage(params.rawBytes);
    
    if (image == null) return null;
    
    // Resize if too large (optional, for optimization)
    if (image.width > 1280) {
      image = img.copyResize(image, width: 1280);
    }
    
    // Encode to JPEG (slow operation)
    List<int> jpgBytes = img.encodeJpg(image, quality: params.quality);
    
    return CaptureResult(
      data: ByteData.sublistView(Uint8List.fromList(jpgBytes)),
      width: image.width,
      height: image.height,
    );
  } catch (e) {
    print('Isolate processing failed: $e');
    return null;
  }
}

class _ProcessImageParams {
  final Uint8List rawBytes;
  final int quality;
  
  _ProcessImageParams(this.rawBytes, this.quality);
}

/// Service for capturing and compressing screen frames
class ScreenService {
  
  /// Capture the entire screen and return raw bytes (useful for AI analysis)
  Future<Uint8List?> captureScreenshot() async {
    try {
      CapturedData? capturedData = await screenCapturer.capture(
        mode: CaptureMode.screen,
        silent: true,
      );
      return capturedData?.imageBytes;
    } catch (e) {
      print('Screenshot capture failed: $e');
      return null;
    }
  }

  /// Capture the entire screen and return compressed JPEG bytes
  Future<CaptureResult?> captureCompressedFrame({int quality = 50}) async {
    try {
      // Capture screen
      CapturedData? capturedData = await screenCapturer.capture(
        mode: CaptureMode.screen,
        silent: true,
      );
      
      if (capturedData == null || capturedData.imageBytes == null) {
        return null;
      }
      
      // usage of compute() to offload CPU intensive work
      if (capturedData.imageBytes == null) return null;

      return await compute(_processImage, _ProcessImageParams(capturedData.imageBytes!, quality));
    } catch (e) {
      print('Capture failed: $e');
      return null;
    }
  }
}

class CaptureResult {
  final ByteData data;
  final int width;
  final int height;
  
  CaptureResult({
    required this.data, 
    required this.width, 
    required this.height
  });
}
