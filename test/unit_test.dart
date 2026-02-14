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
      test('should have correct resolution models', () {
        expect(cameraResolutions.length, 4);
        expect(cameraResolutions[0].name, 'QVGA (320x240)');
        expect(cameraResolutions[1].name, 'VGA (640x480)');
        expect(cameraResolutions[2].name, 'HD (1280x720)');
        expect(cameraResolutions[3].name, 'Full HD (1920x1080)');
      });

      test('HD resolution should have correct dimensions', () {
        final hdResolution = cameraResolutions[2];
        expect(hdResolution.width, 1280);
        expect(hdResolution.height, 720);
      });
    });

    // Tests para CameraFps
    group('Camera FPS', () {
      test('should have correct FPS models', () {
        expect(cameraFps.length, 4);
        expect(cameraFps[0].fps, 15);
        expect(cameraFps[1].fps, 24);
        expect(cameraFps[2].fps, 30);
        expect(cameraFps[3].fps, 60);
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
        cameraProvider.updateResolution(2); // HD
        expect(cameraProvider.config.selectedResolutionIndex, 2);
      });

      test('CameraProvider should update FPS', () {
        cameraProvider.updateFps(3); // 60 FPS
        expect(cameraProvider.config.selectedFpsIndex, 3);
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
