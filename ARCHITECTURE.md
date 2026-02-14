# Arquitectura de la Aplicación

## Flujo General

```
┌─────────────────┐
│  Flutter App    │
│   (Celular)     │
└────────┬────────┘
         │
         │ Socket.IO + WebRTC
         │
┌────────▼────────────────┐
│  Backend (.NET C#)      │
│  - Signal Server        │
│  - Virtual Camera       │
│  - Streaming            │
└────────────────────────┘
         │
         │
┌────────▼────────────────┐
│   Windows/OBS           │
│   - Display Camera      │
│   - Record/Stream       │
└─────────────────────────┘
```

## Componentes Flutter

### 1. **Models** (`lib/models/`)
- `AppConfig`: Configuración persistente
- `CameraResolution`: Resoluciones disponibles
- `CameraFps`: Frames por segundo disponibles

### 2. **Services** (`lib/services/`)

#### `CameraService`
- Inicializa y gestiona la cámara
- Maneja WebRTC PeerConnection
- Captura y procesa video
- Controla resolución y FPS

#### `SocketService`
- Conecta con Socket.IO
- Maneja eventos WebRTC
- Intercambia candidatos ICE
- Gestiona el estado de conexión

#### `ConfigService`
- Almacena/recupera configuración con SharedPreferences
- Persiste las preferencias del usuario

### 3. **Providers** (`lib/providers/`)

#### `CameraProvider` (ChangeNotifier)
- State management centralizado
- Orquesta CameraService y SocketService
- Notifica cambios a la UI
- Maneja ciclo de vida de streaming

### 4. **Screens** (`lib/screens/`)

#### `CameraStreamPage`
- Pantalla principal
- Muestra video en vivo
- Controles de play/pause/cambio de cámara
- Indicador de estado

#### `SettingsPage`
- Configuración de IP/puerto
- Selección de resolución y FPS
- Nombre del dispositivo
- Opciones de seguridad

## Flujo de Datos

```
┌─────────────────────────────────┐
│      CameraProvider             │
│  (ChangeNotifier/State)         │
├─────────────────────────────────┤
│  - isStreaming                  │
│  - statusMessage                │
│  - config: AppConfig            │
├─────────────────────────────────┤
│  - startStreaming()             │
│  - stopStreaming()              │
│  - switchCamera()               │
│  - updateConfig()               │
└──────────────┬──────────────────┘
               │
      ┌────────┴────────┐
      │                 │
┌─────▼──────────┐  ┌──▼────────────┐
│ CameraService  │  │ SocketService │
├────────────────┤  ├───────────────┤
│ - RTCRenderer  │  │ - Socket.IO   │
│ - MediaStream  │  │ - WebRTC      │
│ - RTC Peer     │  │ - ICE Cand.   │
└────────────────┘  └───────────────┘
         │                 │
         └─────────┬───────┘
                   │
        ┌──────────▼──────────┐
        │   Network/Backend   │
        └─────────────────────┘
```

## Ciclo de Vida

### 1. **Inicialización**
```
App Start
    ↓
AppInitializer (FutureBuilder)
    ↓
Inicializar ConfigService
    ↓
Crear Providers
    ↓
CameraProvider.initialize()
    ├─ CameraService.initRenderer()
    ├─ Cargar configuración
    └─ Mostrar CameraStreamPage
```

### 2. **Comenzar Streaming**
```
Usuario toca Play
    ↓
CameraProvider.startStreaming()
    ├─ CameraService.startCameraStream()
    │  ├─ getUserMedia()
    │  ├─ Crear RTCPeerConnection
    │  └─ Añadir tracks
    │
    ├─ SocketService.connect()
    │  ├─ Conectar Socket.IO
    │  ├─ Emitir device_info
    │  └─ Escuchar webrtc_offer
    │
    └─ Cambiar estado a streaming
```

### 3. **Detener Streaming**
```
Usuario toca Stop
    ↓
CameraProvider.stopStreaming()
    ├─ SocketService.disconnect()
    ├─ CameraService.stopCameraStream()
    │  ├─ Detener tracks
    │  └─ Cerrar PeerConnection
    │
    └─ Actualizar estado
```

## Comunicación Socket.IO

### Eventos Cliente → Servidor

**1. device_info** (Al conectar)
```json
{
  "name": "My Phone Camera",
  "type": "camera",
  "timestamp": 1704009600000
}
```

**2. ice_candidate** (Durante negociación WebRTC)
```json
{
  "candidate": "candidate:842163...",
  "sdpMLineIndex": 0,
  "sdpMid": "0"
}
```

**3. webrtc_answer** (Respuesta a oferta)
```json
{
  "sdp": "v=0\r\no=...",
  "type": "answer"
}
```

### Eventos Servidor → Cliente

**1. webrtc_offer** (Inicia negociación)
```json
{
  "sdp": "v=0\r\no=...",
  "type": "offer"
}
```

**2. ice_candidate** (Candidatos ICE)
```json
{
  "candidate": "candidate:842163...",
  "sdpMLineIndex": 0,
  "sdpMid": "0"
}
```

## Seguridad

### Implementado
- ✅ Socket.IO con HTTPS (configurable)
- ✅ Contraseña opcional
- ✅ Almacenamiento seguro de credenciales
- ✅ Validación de entrada

### Recomendaciones
- 🔐 Usar HTTPS en producción
- 🔐 Implementar autenticación fuerte
- 🔐 Usar WSS (WebSocket Secure)
- 🔐 Validar certificados SSL
- 🔐 Firewalling en la red

## Consideraciones de Rendimiento

### Optimizaciones
- **Resolución adaptativa**: Ajusta según disponibilidad de ancho de banda
- **FPS configurable**: 15-60 FPS según capacidad del dispositivo
- **Codec eficiente**: WebRTC usa codec VP8/VP9/H264
- **Hardware acceleration**: Usa aceleración de hardware cuando está disponible

### Limites
- La resolución Full HD puede requerir buena conexión
- 60 FPS requiere dispositivo potente
- WiFi de 5GHz recomendado

## Expansión Futura

### Características Planificadas
- [ ] Grabación de video local
- [ ] Múltiples streams simultáneamente
- [ ] Estadísticas de rendimiento
- [ ] Reconocimiento automático de servidor
- [ ] Control remoto desde PC
- [ ] Efectos de filtros
- [ ] Compresión adaptativa
