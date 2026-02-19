# Camera Streamer App - Flutter

Una aplicación multiplataforma basada en Flutter que convierte tu celular en una webcam virtual para usar con OBS, Windows o cualquier software que soporte WebRTC.

## Características

- 📱 **Streaming de cámara en tiempo real** usando WebRTC
- 🎥 **Múltiples resoluciones**: QVGA, VGA, HD, Full HD
- ⚙️ **Configuración flexible de FPS**: 15, 24, 30, 60 FPS
- 🔒 **Conexión segura HTTPS** configurable
- 🌍 **Multiplataforma**: Android, iOS, Windows, macOS, Linux, Web
- 🎛️ **Interfaz intuitiva** con controles en tiempo real
- 🔄 **Cambio de cámara** (frontal/trasera)
- 📊 **Indicador de estado** de conexión

## Requisitos

- Flutter 3.9.2 o superior
- Dart 3.9.2 o superior
- Android 21+ / iOS 13+ / Windows 10+

## Instalación

### 1. Clonar el proyecto
```bash
git clone <repository-url>
cd flutter_caminout_app
```

### 2. Instalar dependencias
```bash
flutter pub get
```

### 3. Configurar permisos

#### Android (android/app/src/main/AndroidManifest.xml)
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.CHANGE_NETWORK_STATE" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

#### iOS (ios/Runner/Info.plist)
```xml
<key>NSCameraUsageDescription</key>
<string>Esta app necesita acceso a tu cámara para funcionar</string>
<key>NSLocalNetworkUsageDescription</key>
<string>Esta app necesita acceso a tu red local</string>
```

### 4. Compilar y ejecutar
```bash
flutter run
```

## Uso

### Configuración Inicial
1. Abre la app
2. Toca el icono de engranaje (⚙️) para abrir Settings
3. Configura:
   - **IP del servidor**: La IP de tu PC
   - **Puerto**: El puerto del servidor (default: 8080)
   - **Resolución**: Selecciona la calidad deseada
   - **FPS**: Selecciona los frames por segundo
   - **Nombre del dispositivo**: Identificar el dispositivo
   - **Conexión segura**: Activa/desactiva HTTPS

### Iniciar Streaming
1. Vuelve a la pantalla principal
2. Toca el botón verde de play
3. Verás el feed de la cámara en vivo
4. Usa los controles para cambiar de cámara o detener

## Estructura del Proyecto

```
lib/
├── main.dart                 # Punto de entrada
├── models/
│   └── app_config.dart      # Modelos de configuración
├── services/
│   ├── camera_service.dart  # Gestión de cámara WebRTC
│   ├── config_service.dart  # Almacenamiento de configuración
│   └── socket_service.dart  # Conexión Socket.IO
├── providers/
│   └── camera_provider.dart # State management con Provider
└── screens/
    ├── camera_stream_page.dart  # Pantalla principal
    └── settings_page.dart       # Pantalla de configuración
```

## API de Conexión

### Socket.IO Events

**Cliente → Servidor:**
- `device_info`: Información del dispositivo al conectar
- `ice_candidate`: Candidatos ICE para WebRTC
- `webrtc_answer`: Respuesta WebRTC

**Servidor → Cliente:**
- `webrtc_offer`: Oferta WebRTC
- `ice_candidate`: Candidatos ICE

### Formato de Mensajes

```json
// device_info
{
  "name": "My Phone Camera",
  "type": "camera",
  "timestamp": 1234567890
}

// ice_candidate
{
  "candidate": "...",
  "sdpMLineIndex": 0,
  "sdpMid": "0"
}

// webrtc_offer/answer
{
  "sdp": "...",
  "type": "offer|answer"
}
```

## Configuración de Resoluciones

Las resoluciones disponibles son:
- **QVGA**: 320x240 (bajo ancho de banda)
- **VGA**: 640x480 (estándar)
- **HD**: 1280x720 (recomendado)
- **Full HD**: 1920x1080 (máxima calidad)

## Solución de Problemas

### La cámara no inicia
- Verifica los permisos en la app
- Intenta cerrar y reabrir la app
- Reinicia tu dispositivo

### No se conecta al servidor
- Verifica que el servidor esté corriendo
- Comprueba la IP y el puerto
- Desactiva firewall temporalmente para probar
- Asegúrate que ambos dispositivos estén en la misma red

### El video es lento o pixelado
- Reduce la resolución
- Reduce los FPS
- Verifica la conexión WiFi
- Acércate al router

## Próximas Funcionalidades

- [ ] Grabación de video
- [ ] Soporte para múltiples dispositivos
- [ ] Estadísticas en tiempo real
- [ ] Modo oscuro mejorado
- [ ] Autenticación con contraseña
- [ ] Historial de conexiones

## Backend (.NET C#)

Para más información sobre el servidor backend, consulta la documentación del proyecto .NET en el repositorio.

## Licencia

MIT License

## Contribuciones

Las contribuciones son bienvenidas. Por favor crea un pull request con tus cambios.

## Soporte

Si encuentras problemas o tienes sugerencias, abre un issue en el repositorio.
