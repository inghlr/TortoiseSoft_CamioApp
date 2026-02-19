# flutter_caminout_app

# Camera Streamer - Convierte tu celular en WebCam

Una aplicación completa que transforma tu dispositivo móvil en una cámara virtual WebRTC. Compatible con OBS, Windows, y cualquier aplicación que soporte webcam virtual.

## 📱 Características Principales

- ✅ **Streaming de video WebRTC** en tiempo real
- ✅ **Múltiples resoluciones** (QVGA, VGA, HD, Full HD)
- ✅ **FPS configurables** (15, 24, 30, 60)
- ✅ **Conexión segura HTTPS/WSS**
- ✅ **Multiplataforma** (Android, iOS, Windows, macOS, Linux)
- ✅ **Interfaz intuitiva** con controles en vivo
- ✅ **Cambio de cámara** frontal/trasera
- ✅ **Indicador de conexión** en tiempo real
- ✅ **Configuración persistente** guardada localmente

## 🎯 Casos de Uso

- 📹 Grabar con mejor calidad en OBS/Twitch
- 🎥 Llamadas por videollamada con celular
- 📚 Crear contenido educativo
- 🎮 Streaming de juegos
- 🖥️ Presentaciones

## 🚀 Quick Start

### Requisitos Previos
```bash
Flutter 3.9.2+
Dart 3.9.2+
Android 21+ / iOS 13+ / Windows 10+
```

### 1️⃣ Instalación
```bash
git clone <repo-url>
cd flutter_caminout_app
flutter pub get
```

### 2️⃣ Configuración de Permisos

#### Android
Edita `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

#### iOS
Edita `ios/Runner/Info.plist`:
```xml
<key>NSCameraUsageDescription</key>
<string>Necesitamos acceso a tu cámara para transmitir video</string>
<key>NSLocalNetworkUsageDescription</key>
<string>Necesitamos acceso a tu red local para conectar al servidor</string>
```

### 3️⃣ Compilar y Ejecutar
```bash
# Development
flutter run

# Release
flutter build apk --release  # Android
flutter build ios --release   # iOS
```

## 📖 Documentación

- 📋 **[SETUP.md](documents/SETUP.md)** - Instalación detallada y troubleshooting
- 🏗️ **[ARCHITECTURE.md](documents/ARCHITECTURE.md)** - Arquitectura de la aplicación
- 🖥️ **[BACKEND_GUIDE.md](documents/BACKEND_GUIDE.md)** - Guía de implementación del servidor .NET
- 🔐 **[ANDROID_PERMISSIONS.md](documents/ANDROID_PERMISSIONS.md)** - Configuración de permisos Android
- 🍎 **[IOS_PERMISSIONS.md](documents/IOS_PERMISSIONS.md)** - Configuración de permisos iOS

## 🏗️ Estructura del Proyecto

```
flutter_caminout_app/
├── lib/
│   ├── main.dart                           # Punto de entrada
│   ├── models/
│   │   └── app_config.dart                # Configuración y modelos
│   ├── services/
│   │   ├── camera_service.dart            # Gestión de cámara WebRTC
│   │   ├── config_service.dart            # Almacenamiento local
│   │   └── socket_service.dart            # Comunicación Socket.IO
│   ├── providers/
│   │   └── camera_provider.dart           # State management (Provider)
│   └── screens/
│       ├── camera_stream_page.dart        # Pantalla principal
│       └── settings_page.dart             # Configuración
├── test/
│   └── unit_test.dart                     # Tests unitarios
├── pubspec.yaml                           # Dependencias
└── README.md                              # Este archivo
```

## 🔌 Dependencias

```yaml
flutter_webrtc: ^1.3.0          # WebRTC
permission_handler: ^11.4.4     # Permisos
shared_preferences: ^2.2.2      # Almacenamiento local
provider: ^6.0.0                # State management
socket_io_client: ^2.0.1        # Socket.IO client
crypto: ^3.0.3                  # Encriptación
```

## 🎮 Uso

### Pantalla Principal
1. Abre la app
2. Toca el botón verde ▶️ para iniciar streaming
3. Verás el feed de tu cámara en vivo
4. Usa los botones de control:
   - 🔄 Cambiar cámara
   - ⏹️ Detener streaming

### Configuración
1. Toca el icono ⚙️ (Settings)
2. Configura:
   - **IP del Servidor**: IP de tu PC (ej: 192.168.1.100)
   - **Puerto**: Puerto del servidor (default: 8080)
   - **Resolución**: Calidad de video
   - **FPS**: Frames por segundo
   - **Conexión Segura**: HTTPS on/off
   - **Contraseña**: Optional

## 🖥️ Backend (.NET C#)

El backend actúa como intermediario entre la app y el sistema operativo:

1. **Signal Server**: Gestiona conexiones WebRTC
2. **Virtual Camera**: Crea cámara virtual en Windows/macOS
3. **Stream Handler**: Procesa y transmite video a OBS

### Implementación Rápida

```csharp
dotnet new console -n CameraStreamerServer
cd CameraStreamerServer
dotnet add package SocketIOSharp
dotnet add package WebSocketSharp
// ... Implementar según documents/BACKEND_GUIDE.md
```

Ver [BACKEND_GUIDE.md](documents/BACKEND_GUIDE.md) para instrucciones completas.

## 🔐 Seguridad

### ✅ Implementado
- Socket.IO con HTTPS configurable
- Validación de entrada
- Almacenamiento local seguro

### 🔒 Recomendaciones
- Usa HTTPS en producción
- Implementa autenticación fuerte
- WSS (WebSocket Secure)
- Valida certificados SSL
- Firewall en la red

## 📊 Resoluciones Soportadas

| Nombre | Resolución | Ancho de Banda | Uso |
|--------|-----------|----------------|-----|
| QVGA | 320x240 | 🟢 Bajo | WiFi lento |
| VGA | 640x480 | 🟡 Medio | WiFi normal |
| HD | 1280x720 | 🟠 Alto | WiFi rápido |
| Full HD | 1920x1080 | 🔴 Muy alto | Gigabit |

## ⚡ Optimización

### Para mejor rendimiento:
- Usa WiFi 5GHz si es posible
- Reduce resolución si hay lag
- Limita FPS según capacidad del dispositivo
- Cierra otras apps consumiendo datos

## 🐛 Troubleshooting

### La cámara no inicia
```bash
flutter clean
flutter pub get
flutter run
```

### Error de conexión
- Verifica IP y puerto
- Asegúrate que el servidor esté running
- Comprueba firewall

### Video lento/pixelado
- Reduce resolución
- Reduce FPS
- Mejora la conexión WiFi

## 📝 Logs y Debugging

Para ver logs:
```bash
flutter run -v
```

Para debuguear en un dispositivo:
```bash
flutter attach
```

## 🔄 Updates

Actualizar dependencias:
```bash
flutter pub upgrade
```

## 📱 Dispositivos Soportados

### Android
- Versión 5.0+ (API 21)
- Se necesita permiso de cámara

### iOS
- Versión 13.0+
- Se necesita permiso de cámara y red local

### Windows/macOS/Linux
- Solo disponible como cliente
- Se requiere app .NET para virtual camera

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Por favor:

1. Fork el repositorio
2. Crea una rama (`git checkout -b feature/mejora`)
3. Commit cambios (`git commit -am 'Agrega mejora'`)
4. Push a la rama (`git push origin feature/mejora`)
5. Abre un Pull Request

## 📄 Licencia

MIT License - Ver LICENSE para detalles

## 🆘 Soporte

- 📧 Email: support@example.com
- 🐛 Issues: [GitHub Issues](https://github.com/...)
- 💬 Discussions: [GitHub Discussions](https://github.com/...)

## 🙏 Agradecimientos

- Flutter team por el excelente framework
- WebRTC community
- Socket.IO by @socketio

---

**Última actualización**: Febrero 2026
**Versión**: 1.0.0
**Estado**: ✅ Producción

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

