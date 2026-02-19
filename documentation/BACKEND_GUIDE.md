# Guía del Backend (.NET C#)

Este documento describe cómo implementar el servidor backend en .NET C# que se conecta con la app Flutter.

## Arquitectura del Backend

```
┌──────────────────────────────┐
│   Signal Server              │
│  (Socket.IO / WebSocket)     │
├──────────────────────────────┤
│ - Conectar clientes          │
│ - Intercambiar WebRTC SDP    │
│ - Procesar ICE candidates    │
└──────────────────────────────┘
         │
         ├─────────────────────┬──────────────┐
         │                     │              │
┌────────▼─────────┐  ┌────────▼──────┐  ┌───▼─────────┐
│ WebRTC Handler   │  │ Virtual Camera│  │  OBS Link   │
│ - PeerConnection │  │ - DirectShow  │  │  - Video    │
│ - Media Stream   │  │ - Filter      │  │  - Streaming│
└──────────────────┘  └───────────────┘  └─────────────┘
```

## Stack Recomendado

```csharp
// Dependencias NuGet necesarias:
- SocketIOSharp or Socket.IO .NET
- WebRTC Sharp o Pion WebRTC (P2P)
- DirectShowLib (para cámara virtual Windows)
```

## Implementación Básica

### 1. Project Setup

```bash
dotnet new console -n CameraStreamerServer
cd CameraStreamerServer
dotnet add package SocketIOSharp
dotnet add package WebSocketSharp
```

### 2. Signal Server (Ejemplo básico)

```csharp
using SocketIOSharp.Core;
using System;
using System.Collections.Generic;
using System.Linq;

public class SignalServer
{
    private SocketIOServer _socketIOServer;
    private Dictionary<string, ClientConnection> _clients;

    public class ClientConnection
    {
        public string Id { get; set; }
        public string DeviceName { get; set; }
        public DateTime ConnectedAt { get; set; }
        public SocketIOSocket Socket { get; set; }
    }

    public SignalServer(int port = 8080, bool useHttps = true)
    {
        var serverConfig = new SocketIOServerOption()
        {
            ConnectTimeout = 60 * 1000,
            HttpListenerPort = port,
            // Configurar HTTPS si es necesario
            IsSecured = useHttps,
            CertificatePath = useHttps ? "cert.pfx" : null,
            CertificatePassword = useHttps ? "password" : null,
        };

        _socketIOServer = new SocketIOServer(serverConfig);
        _clients = new Dictionary<string, ClientConnection>();
        SetupEventHandlers();
    }

    private void SetupEventHandlers()
    {
        // Cliente conecta
        _socketIOServer.On("connect", (SocketIOSocket socket) =>
        {
            Console.WriteLine($"Cliente conectado: {socket.Id}");
            
            // Escuchar información del dispositivo
            socket.On("device_info", (data) =>
            {
                var clientInfo = new ClientConnection
                {
                    Id = socket.Id,
                    DeviceName = data["name"]?.ToString() ?? "Unknown",
                    ConnectedAt = DateTime.Now,
                    Socket = socket
                };
                _clients[socket.Id] = clientInfo;
                Console.WriteLine($"Dispositivo: {clientInfo.DeviceName}");
            });

            // Manejar oferta WebRTC
            socket.On("webrtc_offer", (data) =>
            {
                Console.WriteLine($"Oferta WebRTC recibida de {socket.Id}");
                // Procesar oferta y crear respuesta
                HandleWebRTCOffer(socket, data);
            });

            // Manejar respuesta WebRTC
            socket.On("webrtc_answer", (data) =>
            {
                Console.WriteLine($"Respuesta WebRTC recibida de {socket.Id}");
                HandleWebRTCAnswer(socket, data);
            });

            // Manejar candidatos ICE
            socket.On("ice_candidate", (data) =>
            {
                Console.WriteLine($"ICE candidate recibido");
                HandleICECandidate(socket, data);
            });

            // Cliente desconecta
            socket.On("disconnect", () =>
            {
                _clients.Remove(socket.Id);
                Console.WriteLine($"Cliente desconectado: {socket.Id}");
            });
        });
    }

    private void HandleWebRTCOffer(SocketIOSocket socket, dynamic data)
    {
        try
        {
            var sdp = data["sdp"]?.ToString();
            var type = data["type"]?.ToString();

            // Aquí procesarías la oferta WebRTC
            // 1. Crear RTCPeerConnection
            // 2. setRemoteDescription con la oferta
            // 3. Crear answer
            // 4. Enviar answer al cliente

            Console.WriteLine($"Procesando oferta WebRTC. SDP: {sdp?.Substring(0, 50)}...");

            // Enviar respuesta (simplificado)
            socket.Emit("webrtc_answer", new
            {
                sdp = "v=0\r\no=...", // Answer SDP
                type = "answer"
            });
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error en WebRTC Offer: {ex.Message}");
        }
    }

    private void HandleWebRTCAnswer(SocketIOSocket socket, dynamic data)
    {
        try
        {
            var sdp = data["sdp"]?.ToString();
            Console.WriteLine("Procesando respuesta WebRTC");
            
            // Procesar answer SDP
            // setRemoteDescription con la answer
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error en WebRTC Answer: {ex.Message}");
        }
    }

    private void HandleICECandidate(SocketIOSocket socket, dynamic data)
    {
        try
        {
            var candidate = data["candidate"]?.ToString();
            var sdpMLineIndex = data["sdpMLineIndex"];
            var sdpMid = data["sdpMid"]?.ToString();

            Console.WriteLine($"Procesando ICE candidate: {candidate?.Substring(0, 50)}...");
            
            // Procesar candidato ICE
            // addIceCandidate(candidate)
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error en ICE Candidate: {ex.Message}");
        }
    }

    public void Start()
    {
        _socketIOServer.Start();
        Console.WriteLine("Signal Server iniciado en puerto 8080");
        Console.WriteLine("Esperando conexiones...");
    }

    public void Stop()
    {
        _socketIOServer.Close();
    }

    public List<ClientConnection> GetConnectedClients()
    {
        return _clients.Values.ToList();
    }
}

// Program.cs
class Program
{
    static void Main(string[] args)
    {
        var server = new SignalServer(port: 8080, useHttps: true);
        server.Start();

        // Mostrar clientes conectados cada 10 segundos
        while (true)
        {
            System.Threading.Thread.Sleep(10000);
            var clients = server.GetConnectedClients();
            Console.WriteLine($"\nClientes conectados: {clients.Count}");
            foreach (var client in clients)
            {
                Console.WriteLine($"  - {client.DeviceName} ({client.Id}) - {client.ConnectedAt}");
            }
        }
    }
}
```

### 3. Virtual Camera Filter (DirectShow - Windows)

```csharp
using DirectShowLib;
using System;
using System.Runtime.InteropServices;

public class VirtualCameraFilter
{
    private IBaseFilter _source;
    private IBaseFilter _virtualCameraFilter;
    private IGraphBuilder _graphBuilder;

    public void SetupVirtualCamera()
    {
        try
        {
            // Crear Graph
            _graphBuilder = (IGraphBuilder)new FilterGraph();

            // Añadir source filter (cámara física o stream)
            _graphBuilder.AddSourceFilter("...", "Source", out _source);

            // Añadir virtual camera filter (DirectShow)
            // Aquí usarías un filter personalizado o existente
            // como "VirtualCamera" o "Dummy Video Renderer"

            // Conectar filters
            // _graphBuilder.Connect(...);

            Console.WriteLine("Virtual Camera setup completado");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error setup virtual camera: {ex.Message}");
        }
    }

    public void RenderStream()
    {
        try
        {
            IMediaControl mediaControl = (IMediaControl)_graphBuilder;
            mediaControl.Run();
            Console.WriteLine("Stream renderizado");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error renderizando: {ex.Message}");
        }
    }

    public void Stop()
    {
        try
        {
            IMediaControl mediaControl = (IMediaControl)_graphBuilder;
            mediaControl.Stop();
        }
        catch { }
    }
}
```

### 4. Modelo de Configuración

```csharp
public class ServerConfig
{
    public int Port { get; set; } = 8080;
    public bool UseHttps { get; set; } = true;
    public string CertificatePath { get; set; }
    public string CertificatePassword { get; set; }
    public string VirtualCameraName { get; set; } = "Camera Streamer";
    public bool EnableLogging { get; set; } = true;
    public int MaxClients { get; set; } = 10;
}
```

## Flujo de Conexión Completo

```
1. Celular (Flutter)
   ├─ Se conecta a Signal Server
   ├─ Emite "device_info"
   └─ Espera oferta WebRTC

2. PC (.NET Server)
   ├─ Recibe "device_info"
   ├─ Crea RTCPeerConnection
   ├─ Crea offer WebRTC
   └─ Emite "webrtc_offer"

3. Celular (Flutter)
   ├─ Recibe offer
   ├─ setRemoteDescription(offer)
   ├─ Crea answer
   └─ Emite "webrtc_answer"

4. PC (.NET Server)
   ├─ Recibe answer
   ├─ setRemoteDescription(answer)
   ├─ Espera ICE candidates

5. Ambos
   ├─ Intercambian ICE candidates
   ├─ Establecen conexión P2P
   └─ Comienza streaming de video

6. PC (.NET Server)
   ├─ Recibe MediaStream
   ├─ La envía a Virtual Camera
   ├─ Aplicación (OBS) consume Virtual Camera
   └─ Video visible en OBS/Windows
```

## Conectar con OBS

```csharp
// Usar plugin VirtualCamera de OBS
// O implementar captura DirectShow y renderizar con GDI+

public class OBSIntegration
{
    public void CaptureAndDisplayVideo(IMediaStream stream)
    {
        // 1. Capturar frames del stream
        // 2. Convertir a formato compatible (YUV420, RGB, etc)
        // 3. Renderizar en screen buffer o texture
        // 4. OBS consume la textura directamente
    }
}
```

## Seguridad en Backend

```csharp
public class SecurityHandler
{
    public bool ValidateClient(string deviceId, string password)
    {
        // Implementar autenticación
        // Validar token/contraseña
        // Limitar conexiones por IP
        return true;
    }

    public void SetupSSL(string certPath, string password)
    {
        // Configurar certificado SSL
        // Usar HTTPS/WSS en producción
    }
}
```

## Recursos Adicionales

- [Socket.IO Documentation](https://socket.io/docs/)
- [WebRTC Specification](https://www.w3.org/TR/webrtc/)
- [DirectShow .NET](https://github.com/novotnyllc/VideoLAN.DotNet)
- [Pion WebRTC (Go alternative)](https://github.com/pion/webrtc)

## Próximos Pasos

1. ✅ Implementar Signal Server
2. ⬜ Integrar WebRTC peer connection
3. ⬜ Crear Virtual Camera Filter
4. ⬜ Conectar con OBS
5. ⬜ Pruebas de rendimiento
6. ⬜ Implementar autenticación segura
7. ⬜ Documentación de API completa
