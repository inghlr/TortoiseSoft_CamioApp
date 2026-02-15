import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/camera_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/camera_stream_page.dart';
import 'screens/settings_page.dart';
import 'services/camera_service.dart';
import 'services/config_service.dart';
import 'services/socket_service.dart';
import 'services/theme_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeService = ThemeService();
  await themeService.init();
  runApp(CameraStreamerApp(themeService: themeService));
}

class CameraStreamerApp extends StatelessWidget {
  final ThemeService themeService;

  const CameraStreamerApp({
    Key? key,
    required this.themeService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(themeService: themeService),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Camera Streamer',
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.blue,
              useMaterial3: true,
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.blue[400],
                elevation: 0,
              ),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.blue,
              useMaterial3: true,
              scaffoldBackgroundColor: const Color(0xFF121212),
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.grey[900],
                elevation: 0,
              ),
              cardColor: Colors.grey[800],
            ),
            home: const AppInitializer(),
          );
        },
      ),
    );
  }
}

class AppInitializer extends StatefulWidget {
  const AppInitializer({Key? key}) : super(key: key);

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  late Future<void> _initializationFuture;

  @override
  void initState() {
    super.initState();
    _initializationFuture = _initialize();
  }

  Future<void> _initialize() async {
    // Initialize services
    final configService = ConfigService();
    await configService.init();

    // Wait for all initializations to complete
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    'Initializing Camera Streamer...',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Initialization Error: ${snapshot.error}'),
            ),
          );
        }

        return MultiProvider(
          providers: [
            Provider<CameraService>(create: (_) => CameraService()),
            Provider<ConfigService>(
              create: (_) => ConfigService(),
            ),
            Provider<SocketService>(create: (_) => SocketService()),
            ChangeNotifierProvider(
              create: (context) => CameraProvider(
                cameraService: context.read<CameraService>(),
                configService: context.read<ConfigService>(),
                socketService: context.read<SocketService>(),
              )..initialize(),
            ),
          ],
          child: const CameraStreamerHome(),
        );
      },
    );
  }
}

class CameraStreamerHome extends StatelessWidget {
  const CameraStreamerHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/settings':
            return MaterialPageRoute(
              builder: (_) => const SettingsPage(),
            );
          default:
            return MaterialPageRoute(
              builder: (_) => const CameraStreamPage(),
            );
        }
      },
    );
  }
}