import 'package:flutter_caminout_app/models/enum/fps_type.dart';
import 'package:flutter_caminout_app/models/enum/resolution_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_caminout_app/main.dart';
import 'package:flutter_caminout_app/models/app_config.dart';
import 'package:flutter_caminout_app/services/camera_service.dart';
import 'package:flutter_caminout_app/services/config_service.dart';
import 'package:flutter_caminout_app/services/socket_service.dart';
import 'package:flutter_caminout_app/providers/camera_provider.dart';

void main() {
  group('Camera Streamer App Tests', () {
    // Tests para AppConfig
    group('AppConfig Model', () {
      test('AppConfig should initialize with default values', () {
        final config = AppConfig();
        expect(config.serverIp, '192.168.1.100');
        expect(config.serverPort, 8080);
        expect(config.deviceName, 'My Phone Camera');
        expect(config.useSecureConnection, true);
      });

      test('AppConfig should convert to JSON and back', () {
        final original = AppConfig(
          serverIp: '10.0.0.1',
          serverPort: 9000,
          deviceName: 'Test Camera',
          useSecureConnection: false,
        );

        final json = original.toJson();
        final restored = AppConfig.fromJson(json);

        expect(restored.serverIp, '10.0.0.1');
        expect(restored.serverPort, 9000);
        expect(restored.deviceName, 'Test Camera');
        expect(restored.useSecureConnection, false);
      });
    });

    // Tests para CameraResolution
    group('Camera Resolution', () {
      test('should have correct resolution enums', () {
        expect(ResolutionType.values.length, 4);
        expect(ResolutionType.qvga.name, 'QVGA (320x240)');
        expect(ResolutionType.vga.name, 'VGA (640x480)');
        expect(ResolutionType.hd.name, 'HD (1280x720)');
        expect(ResolutionType.fullHd.name, 'Full HD (1920x1080)');
      });

      test('HD resolution should have correct dimensions', () {
        expect(ResolutionType.hd.width, 1280);
        expect(ResolutionType.hd.height, 720);
      });
    });

    // Tests para Camera FPS
    group('Camera FPS', () {
      test('should have correct FPS enums', () {
        expect(FpsType.values.length, 4);
        expect(FpsType.fps15.fps, 15);
        expect(FpsType.fps24.fps, 24);
        expect(FpsType.fps30.fps, 30);
        expect(FpsType.fps60.fps, 60);
      });
    });

    // Tests para CameraService
    group('CameraService', () {
      late CameraService cameraService;

      setUp(() {
        cameraService = CameraService();
      });

      test('CameraService should initialize with null streams', () {
        expect(cameraService.isStreaming, false);
        expect(cameraService.localStream, isNull);
      });

      test('CameraService should have localRenderer', () {
        expect(cameraService.localRenderer, isNotNull);
      });
    });

    // Tests para SocketService
    group('SocketService', () {
      late SocketService socketService;

      setUp(() {
        socketService = SocketService();
      });

      test('SocketService should initialize not connected', () {
        expect(socketService.isConnected, false);
      });

      test('SocketService should have connection status stream', () {
        expect(socketService.connectionStatus, isNotNull);
      });

      tearDown(() async {
        await socketService.disconnect();
      });
    });

    // Tests para CameraProvider
    group('CameraProvider', () {
      late CameraProvider cameraProvider;
      late CameraService cameraService;
      late ConfigService configService;
      late SocketService socketService;

      setUp(() async {
        cameraService = CameraService();
        configService = ConfigService();
        socketService = SocketService();

        cameraProvider = CameraProvider(
          cameraService: cameraService,
          configService: configService,
          socketService: socketService,
        );
      });

      test('CameraProvider should initialize with ready status', () async {
        await cameraProvider.initialize();
        expect(cameraProvider.isStreaming, false);
      });

      test('CameraProvider should not be loading by default', () {
        expect(cameraProvider.isLoading, false);
      });

      test('CameraProvider should update resolution', () {
        cameraProvider.updateResolution(ResolutionType.hd);
        expect(cameraProvider.config.selectedResolution, ResolutionType.hd);
      });

      test('CameraProvider should update FPS', () {
        cameraProvider.updateFps(FpsType.fps60);
        expect(cameraProvider.config.selectedFps, FpsType.fps60);
      });

      tearDown(() async {
        cameraProvider.dispose();
      });
    });
  });

  group('Integration Tests', () {
    testWidgets(
      'CameraStreamerApp should render without errors',
      (WidgetTester tester) async {
        await tester.pumpWidget(const CameraStreamerApp());
        expect(find.byType(CameraStreamerApp), findsOneWidget);
      },
    );
  });
}
