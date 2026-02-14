import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:provider/provider.dart';
import '../models/app_config.dart';
import '../providers/camera_provider.dart';

class CameraStreamPage extends StatelessWidget {
  const CameraStreamPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera Streamer'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).pushNamed('/settings');
            },
          ),
        ],
      ),
      body: Consumer<CameraProvider>(
        builder: (context, provider, child) {
          return Stack(
            children: [
              // Video preview
              if (provider.isStreaming)
                RTCVideoView(
                  provider.cameraService.localRenderer,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                )
              else
                Container(
                  color: Colors.black87,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.videocam_off,
                          size: 80,
                          color: Colors.white54,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          provider.statusMessage,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              // Control buttons
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    if (provider.isStreaming)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FloatingActionButton(
                            heroTag: 'switch_camera',
                            mini: true,
                            onPressed: () => provider.switchCamera(),
                            backgroundColor: Colors.blue,
                            child: const Icon(Icons.flip_camera_android),
                          ),
                          const SizedBox(width: 12),
                          FloatingActionButton(
                            heroTag: 'stop',
                            onPressed: () => provider.stopStreaming(),
                            backgroundColor: Colors.red,
                            child: const Icon(Icons.stop),
                          ),
                        ],
                      )
                    else
                      FloatingActionButton(
                        heroTag: 'start',
                        onPressed: provider.isLoading
                            ? null
                            : () => provider.startStreaming(),
                        backgroundColor:
                            provider.isLoading ? Colors.grey : Colors.green,
                        child: provider.isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.videocam),
                      ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: provider.isStreaming
                                  ? Colors.green
                                  : Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            provider.isStreaming ? 'STREAMING' : 'OFFLINE',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Status message overlay
              if (!provider.isStreaming && provider.statusMessage.isNotEmpty)
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      provider.statusMessage,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
