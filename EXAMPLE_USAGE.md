// Archivo: EXAMPLE_USAGE.md
# Ejemplos de Uso - Camera Streamer API

## 1️⃣ Uso Básico

### Inicializar la Aplicación

```dart
import 'package:flutter_caminout_app/models/app_config.dart';
import 'package:flutter_caminout_app/providers/camera_provider.dart';
import 'package:provider/provider.dart';

// En main.dart, el Provider ya está configurado
// Solo necesitas acceder a él en tus widgets

class MyCameraPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CameraProvider>(
      builder: (context, cameraProvider, child) {
        // Tu interfaz aquí
        return Container();
      },
    );
  }
}
```

## 2️⃣ Iniciar Streaming

```dart
// Acceder a CameraProvider
final cameraProvider = context.read<CameraProvider>();

// Iniciar streaming
await cameraProvider.startStreaming();

// Verificar estado
if (cameraProvider.isStreaming) {
  print('¡Streaming activo!');
}
```

## 3️⃣ Mostrar Video en Vivo

```dart
import 'package:flutter_webrtc/flutter_webrtc.dart';

Consumer<CameraProvider>(
  builder: (context, cameraProvider, _) {
    return RTCVideoView(
      cameraProvider.cameraService.localRenderer,
      objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
    );
  },
)
```

## 4️⃣ Configurar Resolución y FPS

```dart
final cameraProvider = context.read<CameraProvider>();

// Cambiar a Full HD
cameraProvider.updateResolution(3);

// Cambiar a 60 FPS
cameraProvider.updateFps(3);

// Guardar configuración
await cameraProvider.configService.saveConfig(cameraProvider.config);

// Reiniciar streaming con nueva configuración
await cameraProvider.stopStreaming();
await Future.delayed(Duration(seconds: 1));
await cameraProvider.startStreaming();
```

## 5️⃣ Cambiar Cámara (Frontal ↔ Trasera)

```dart
final cameraProvider = context.read<CameraProvider>();

// Cambiar cámara
await cameraProvider.switchCamera();

// El mensaje de estado se actualizará automáticamente
print(cameraProvider.statusMessage); // "Camera switched"
```

## 6️⃣ Monitorear Estado de Conexión

```dart
Consumer<CameraProvider>(
  builder: (context, cameraProvider, _) {
    return Column(
      children: [
        Text(
          'Estado: ${cameraProvider.statusMessage}',
          style: TextStyle(
            color: cameraProvider.isStreaming ? Colors.green : Colors.red,
          ),
        ),
        if (cameraProvider.isLoading)
          CircularProgressIndicator()
      ],
    );
  },
)
```

## 7️⃣ Actualizar Configuración del Servidor

```dart
final cameraProvider = context.read<CameraProvider>();
final newConfig = AppConfig(
  serverIp: '192.168.0.50',
  serverPort: 9000,
  deviceName: 'My Android Phone',
  selectedResolutionIndex: 2, // HD
  selectedFpsIndex: 2,        // 30 FPS
  useSecureConnection: true,
);

cameraProvider.updateConfig(newConfig);
```

## 8️⃣ Escuchar Cambios de Conexión

```dart
Consumer<CameraProvider>(
  builder: (context, cameraProvider, _) {
    return StreamBuilder<ConnectionStatus>(
      stream: cameraProvider.socketService.connectionStatus,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final status = snapshot.data;
          return Text(
            'Conexión: ${status.toString()}',
          );
        }
        return Text('Desconectado');
      },
    );
  },
)
```

## 9️⃣ Detener Streaming

```dart
final cameraProvider = context.read<CameraProvider>();

// Detener
await cameraProvider.stopStreaming();

// Verificar
if (!cameraProvider.isStreaming) {
  print('Streaming detenido');
}
```

## 🔟 Acceder a Información del Dispositivo

```dart
final cameraProvider = context.read<CameraProvider>();
final config = cameraProvider.config;

print('Nombre: ${config.deviceName}');
print('IP: ${config.serverIp}');
print('Puerto: ${config.serverPort}');
print('Resolución: ${cameraResolutions[config.selectedResolutionIndex].name}');
print('FPS: ${cameraFps[config.selectedFpsIndex].label}');
print('Seguro: ${config.useSecureConnection}');
```

## 🔒 Gestionar Permisos

```dart
import 'package:permission_handler/permission_handler.dart';

Future<bool> requestCameraPermission() async {
  final status = await Permission.camera.request();
  return status.isGranted;
}

Future<bool> requestNetworkPermission() async {
  final status = await Permission.location.request(); // Para acceso a red
  return status.isGranted;
}

// En initState o before startStreaming
if (await requestCameraPermission()) {
  await cameraProvider.startStreaming();
}
```

## 📊 Ejemplo Completo - Pantalla Personalizada

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class CustomCameraPage extends StatefulWidget {
  @override
  _CustomCameraPageState createState() => _CustomCameraPageState();
}

class _CustomCameraPageState extends State<CustomCameraPage> {
  late TextEditingController _ipController;
  late TextEditingController _portController;

  @override
  void initState() {
    super.initState();
    _ipController = TextEditingController();
    _portController = TextEditingController();
  }

  @override
  void dispose() {
    _ipController.dispose();
    _portController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CameraProvider>(
      builder: (context, cameraProvider, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Custom Camera Streamer'),
          ),
          body: Column(
            children: [
              // Video Preview
              Expanded(
                child: RTCVideoView(
                  cameraProvider.cameraService.localRenderer,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                ),
              ),

              // Configuration
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _ipController,
                      decoration: InputDecoration(
                        labelText: 'Server IP',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: _portController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Port',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              final newConfig = AppConfig(
                                serverIp: _ipController.text,
                                serverPort: int.parse(
                                  _portController.text,
                                ),
                                deviceName: cameraProvider.config.deviceName,
                              );
                              cameraProvider.updateConfig(newConfig);
                            },
                            child: Text('Update Config'),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: cameraProvider.isStreaming
                                ? () => cameraProvider.stopStreaming()
                                : () => cameraProvider.startStreaming(),
                            child: Text(
                              cameraProvider.isStreaming
                                  ? 'Stop'
                                  : 'Start',
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Status
                    SizedBox(height: 16),
                    Text(
                      'Status: ${cameraProvider.statusMessage}',
                      style: TextStyle(
                        color: cameraProvider.isStreaming
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
```

## 🔗 Integración con Socket.IO

Si necesitas acceso directo a Socket.IO:

```dart
final socketService = context.read<SocketService>();

// Escuchar eventos personalizados
socketService.socket.on('custom_event', (data) {
  print('Evento personalizado: $data');
});

// Emitir eventos personalizados
socketService.socket.emit('custom_message', {
  'message': 'Hola',
  'timestamp': DateTime.now().toIso8601String(),
});
```

## ⚠️ Error Handling

```dart
try {
  await cameraProvider.startStreaming();
} catch (e) {
  print('Error: $e');
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Error: $e')),
  );
}
```

## 📱 Tips de Implementación

1. **Siempre dispose correctamente**: Los servicios deben liberarse en dispose()
2. **Maneja permisos**: Solicita permisos antes de usar cámara
3. **Valida entrada**: Valida IP y puerto antes de conectar
4. **Muestra estado**: Mantén al usuario informado del estado actual
5. **Maneja errores**: Captura y muestra errores apropiadamente
6. **Optimiza UI**: Usa Consumer/Builder para re-renders eficientes
7. **Prueba en dispositivos**: Las emuladores pueden ser lentos
