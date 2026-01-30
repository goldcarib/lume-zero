import 'dart:convert';
import 'package:flutter_webrtc/flutter_webrtc.dart';

typedef SignalingCallback = void Function(String type, String? sdp, String? candidate, String? sdpMid, int? sdpMlineIndex);

class WebRTCService {
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  RTCVideoRenderer? localRenderer;
  RTCVideoRenderer? remoteRenderer;
  
  SignalingCallback? onSignal;
  Function(MediaStream)? onRemoteStream;
  Function(RTCPeerConnectionState)? onConnectionState;
  
  final List<RTCIceCandidate> _iceBuffer = [];
  bool _remoteDescriptionSet = false;
  
  final Map<String, dynamic> _configuration = {
    'iceServers': [
      {'urls': 'stun:stun1.l.google.com:19302'},
      {'urls': 'stun:stun2.l.google.com:19302'},
    ]
  };
  
  Future<void> init() async {
    localRenderer = RTCVideoRenderer();
    remoteRenderer = RTCVideoRenderer();
    await localRenderer!.initialize();
    await remoteRenderer!.initialize();
  }
  
  Future<void> startScreenShare() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': false,
      'video': {
        'mandatory': {
          'minWidth': '1280',
          'minHeight': '720',
          'minFrameRate': '30',
        },
        'optional': [],
      }
    };

    try {
      final sources = await desktopCapturer.getSources(types: [SourceType.Screen]);
      if (sources.isEmpty) {
        throw Exception('No screen sources found');
      }
      
      final source = sources.first;
      
      _localStream = await navigator.mediaDevices.getDisplayMedia({
        'audio': false,
        'video': {
          'deviceId': {'exact': source.id},
          'mandatory': {
            'frameRate': 30.0,
            // 'chromeMediaSource': 'desktop', // specific for some platforms
          }
        }
      });
      
      if (localRenderer != null) {
        localRenderer!.srcObject = _localStream;
      }
      
      await _createPeerConnection();
      
      // Add tracks to peer connection
      _localStream!.getTracks().forEach((track) {
        _peerConnection!.addTrack(track, _localStream!);
      });
      
      // Create Offer
      RTCSessionDescription offer = await _peerConnection!.createOffer();
      await _peerConnection!.setLocalDescription(offer);
      
      onSignal?.call('offer', offer.sdp, null, null, null);
      
    } catch (e) {
      print('Error starting screen share: $e');
    }
  }
  
  Future<void> joinAsViewer() async {
    await _createPeerConnection();
  }
  
  Future<void> _createPeerConnection() async {
    _peerConnection = await createPeerConnection(_configuration);
    
    _peerConnection!.onIceCandidate = (candidate) {
      onSignal?.call('candidate', null, candidate.candidate, candidate.sdpMid, candidate.sdpMLineIndex);
    };
    
    _peerConnection!.onTrack = (event) {
      if (event.streams.isNotEmpty) {
        remoteRenderer!.srcObject = event.streams[0];
        onRemoteStream?.call(event.streams[0]);
      }
    };

    _peerConnection!.onConnectionState = (state) {
      print('WebRTC Connection State: $state');
      onConnectionState?.call(state);
    };
  }
  
  Future<void> handleSignal(String type, String? sdp, String? candidate, String? sdpMid, int? sdpMlineIndex) async {
    if (_peerConnection == null) return;
    
    switch (type) {
      case 'offer':
        await _peerConnection!.setRemoteDescription(RTCSessionDescription(sdp, 'offer'));
        _remoteDescriptionSet = true;
        _drainIceBuffer();
        final answer = await _peerConnection!.createAnswer();
        await _peerConnection!.setLocalDescription(answer);
        onSignal?.call('answer', answer.sdp, null, null, null);
        break;
        
      case 'answer':
        await _peerConnection!.setRemoteDescription(RTCSessionDescription(sdp, 'answer'));
        _remoteDescriptionSet = true;
        _drainIceBuffer();
        break;
        
      case 'candidate':
        if (candidate == null) break;
        final iceCandidate = RTCIceCandidate(candidate, sdpMid, sdpMlineIndex);
        if (_remoteDescriptionSet) {
          await _peerConnection!.addCandidate(iceCandidate);
        } else {
          _iceBuffer.add(iceCandidate);
        }
        break;
        
      case 'request_offer':
        // Host should re-initiate offer
        if (_localStream != null) {
          await _peerConnection?.close();
          await _createPeerConnection();
          _localStream!.getTracks().forEach((track) {
            _peerConnection!.addTrack(track, _localStream!);
          });
          RTCSessionDescription offer = await _peerConnection!.createOffer();
          await _peerConnection!.setLocalDescription(offer);
          onSignal?.call('offer', offer.sdp, null, null, null);
        }
        break;
        
      case 'bye':
        _dispose();
        break;
    }
  }
  
  Future<void> _drainIceBuffer() async {
    while (_iceBuffer.isNotEmpty) {
      final cand = _iceBuffer.removeAt(0);
      await _peerConnection!.addCandidate(cand);
    }
  }

  void _dispose() {
    _localStream?.dispose();
    _peerConnection?.close();
    localRenderer?.dispose();
    remoteRenderer?.dispose();
    _iceBuffer.clear();
    _remoteDescriptionSet = false;
  }
  
  void dispose() {
    onSignal?.call('bye', null, null, null, null);
    _dispose();
  }
}
