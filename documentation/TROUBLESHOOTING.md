# Troubleshooting - Camera Streamer App

## 🎥 Problemas de Cámara

### La cámara no inicia

**Síntomas:**
- Error al presionar play
- Pantalla negra
- "getUserMedia failed"

**Soluciones:**

1. **Verificar permisos:**
   ```bash
   # Android
   adb shell pm list permissions | grep -i camera
   
   # iOS
   # Ir a Settings > Camera > Permitir acceso
   ```

2. **Limpiar y recompilar:**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

3. **Reiniciar dispositivo:**
   - Apaga y enciende el dispositivo
   - Cierra completamente la app

4. **Verificar disponibilidad de cámara:**
   - ¿Otra app está usando la cámara?
   - ¿La cámara está deshabilitada en el device?

### Video pixelado o entrecortado

**Síntomas:**
- Video de baja calidad
- FPS bajo
- Lag perceptible

**Causas y soluciones:**

1. **WiFi débil:**
   - Acércate al router
   - Usa WiFi 5GHz si es posible
   - Verifica velocidad: `speedtest.net`

2. **Resolución muy alta:**
   - Reduce a VGA o HD
   - Evita Full HD con WiFi lento

3. **FPS muy alto:**
   - Reduce a 24 o 30 FPS
   - 60 FPS requiere conexión excelente

4. **Dispositivo sobrecargado:**
   - Cierra otras aplicaciones
   - Reinicia el dispositivo
   - Verifica temperatura del CPU

### Cámara congela o se detiene

**Síntomas:**
- Video se pause inesperadamente
- La app se congela
- Necesita reiniciar

**Soluciones:**

1. **Liberar memoria:**
   ```bash
   # Cerrar apps de fondo
   # En Android: Ajustes > Memoria > Limpiar memoria
   ```

2. **Revisar logs:**
   ```bash
   flutter logs | grep -i camera
   ```

3. **Actualizar drivers (Windows/Mac):**
   - Actualiza drivers de cámara
   - Actualiza chipset

## 🌐 Problemas de Conexión

### No conecta al servidor

**Síntomas:**
- "Connection failed" o timeout
- No recibe oferta WebRTC
- Status: "Connecting..."

**Verificaciones:**

1. **Verificar servidor está corriendo:**
   ```bash
   # En Windows
   netstat -an | findstr :8080
   
   # En Linux/Mac
   lsof -i :8080
   ```

2. **Verificar IP correcta:**
   ```bash
   # Windows
   ipconfig | findstr IPv4
   
   # Linux/Mac
   ifconfig | grep "inet "
   ```

3. **Verificar firewall:**
   ```bash
   # Windows
   # Control Panel > Windows Defender Firewall > Allow app
   
   # Linux
   sudo ufw allow 8080/tcp
   
   # Mac
   # System Preferences > Security & Privacy > Firewall
   ```

4. **Test de conectividad:**
   ```bash
   # Desde el celular
   ping <SERVER_IP>
   telnet <SERVER_IP> 8080
   ```

5. **Revisar logs del servidor:**
   ```bash
   # Backend .NET
   dotnet run -v
   ```

### Conexión inestable (desconexiones frecuentes)

**Síntomas:**
- Desconecta y reconecta frecuentemente
- Latencia variable
- Pérdida de paquetes

**Soluciones:**

1. **Mejorar WiFi:**
   - Cambia canal WiFi (2.4GHz: 1, 6, 11)
   - Acércate al router
   - Elimina interferencias

2. **Aumentar timeouts:**
   ```dart
   // En socket_service.dart
   static const Duration socketConnectionTimeout = Duration(seconds: 15);
   static const Duration reconnectDelay = Duration(seconds: 5);
   ```

3. **Verificar ancho de banda:**
   - Verifica si otro dispositivo consume mucho
   - Limita resolución/FPS

4. **Router config:**
   - Reinicia router
   - Actualiza firmware
   - Verifica canal 5GHz disponible

### CORS o errores de socket

**Síntomas:**
- Error 403 o 401
- "CORS error"
- Socket no emite eventos

**Soluciones:**

1. **Backend CORS config:**
   ```csharp
   // En Socket.IO servidor
   app.UseSocketIO((context) => {
       context.Credentials.AllowAnonymous = true;
   });
   ```

2. **Verificar headers:**
   - Revisa headers de respuesta
   - Valida origen permitido

3. **Certificado SSL:**
   ```bash
   # Si usa HTTPS
   # Verificar que certificado es válido
   # openssl s_client -connect <IP>:8080
   ```

## 🔐 Problemas de Seguridad

### Contraseña no funciona

**Síntomas:**
- No puede conectar con contraseña
- Error de autenticación

**Soluciones:**

1. **Verificar contraseña:**
   - Revisa que esté escrita correctamente
   - Diferencia entre mayúsculas/minúsculas

2. **Limpiar storage:**
   ```bash
   # Android
   adb shell pm clear com.flutter.app
   
   # iOS
   # Settings > App > Storage > Clear
   ```

3. **Regenerar contraseña:**
   - Elimina contraseña guardada
   - Vuelve a ingresar

### HTTPS no funciona

**Síntomas:**
- "Certificate error"
- "SSL_ERROR_BAD_CERT_DOMAIN"

**Soluciones:**

1. **Verificar certificado:**
   ```bash
   openssl s_client -connect <IP>:<PORT>
   # Revisa fecha de expiración y dominio
   ```

2. **Añadir excepciones (desarrollo):**
   ```csharp
   // En .NET backend - SOLO para desarrollo
   ServicePointManager.ServerCertificateValidationCallback =
       (sender, cert, chain, sslPolicyErrors) => true;
   ```

3. **Usar cert autofirmado:**
   ```bash
   # Generar certificado
   openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem
   
   # Convertir a PFX
   openssl pkcs12 -export -out cert.pfx -inkey key.pem -in cert.pem
   ```

## 💾 Problemas de Almacenamiento

### Configuración no se guarda

**Síntomas:**
- Settings se pierden al cerrar
- Siempre vuelve a valores default

**Soluciones:**

1. **Verificar SharedPreferences:**
   ```dart
   // Debug
   final prefs = await SharedPreferences.getInstance();
   print(prefs.getKeys());
   ```

2. **Limpiar storage:**
   ```bash
   # Android
   adb shell pm clear com.example.app
   
   # Emulador
   flutter clean
   ```

3. **Verificar permisos de escritura:**
   - Android: WRITE_EXTERNAL_STORAGE
   - iOS: Documents directory

## 🚀 Problemas de Rendimiento

### La app es lenta

**Síntomas:**
- Lag en interfaz
- Botones lentos
- UI no responde

**Causas y soluciones:**

1. **Inspeccionar performance:**
   ```bash
   flutter run -v
   # Busca "frame time"
   ```

2. **Reducir resolución:**
   - Cambiar a HD en lugar de Full HD
   - Reduce FPS a 24

3. **Profile la app:**
   ```bash
   # Con DevTools
   flutter pub global activate devtools
   devtools
   # Luego: flutter run --profile
   ```

4. **Revisar logs:**
   ```bash
   flutter logs | grep "frame"
   ```

## 📱 Problemas Específicos de Android

### Cámara no tiene permisos

**Error:**
```
java.lang.SecurityException: Permission Denial
```

**Solución:**
```xml
<!-- AndroidManifest.xml -->
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.INTERNET" />
```

### Build error con flutter_webrtc

**Error:**
```
error: cannot find symbol class RTCVideoRenderer
```

**Solución:**
```bash
# Asegúrate de que Gradle está actualizado
flutter pub get
flutter clean
flutter pub get
flutter build apk
```

### Problema con NDK

**Error:**
```
NDK not found
```

**Solución:**
```bash
# Instala NDK via Android Studio
# o establece:
# android.ndk.version=23.1.7779620
```

## 🍎 Problemas Específicos de iOS

### Permission denied para cámara

**Error:**
```
NSCameraUsageDescription missing
```

**Solución:**
```xml
<!-- ios/Runner/Info.plist -->
<key>NSCameraUsageDescription</key>
<string>Necesitamos acceso a la cámara</string>

<key>NSLocalNetworkUsageDescription</key>
<string>Necesitamos acceso a la red local</string>

<key>NSBonjourServices</key>
<array>
  <string>_http._tcp</string>
  <string>_https._tcp</string>
</array>
```

### CocoaPods error

**Error:**
```
pod install failed
```

**Solución:**
```bash
cd ios
rm -rf Pods
rm Podfile.lock
pod install
cd ..
flutter run
```

### Swift version conflict

**Error:**
```
Swift version incompatible
```

**Solución:**
```bash
# iOS/Podfile
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '5.8'
    end
  end
end
```

## 🪟 Problemas Específicos de Windows

### DirectShow not found

**Error:**
```
DirectShowLib not found
```

**Solución:**
```bash
dotnet add package DirectShowLib
```

### Virtual camera no aparece

**Problema:**
Camera no aparece en Windows

**Soluciones:**
1. Usa OBS virtual camera
2. Usa SplitCam para simular
3. Implementa DirectShow filter personalizado

## 🔧 Debug General

### Ver logs detallados

```bash
# Todos los logs
flutter logs

# Filtrar por nivel
flutter logs --info
flutter logs --warning
flutter logs --error

# Buscar palabra específica
flutter logs | grep -i "camera"
flutter logs | grep -i "socket"
```

### Usar DevTools

```bash
# Instalar
flutter pub global activate devtools

# Ejecutar
devtools

# Iniciar app con modo debug
flutter run --debug
```

### Revisar memoria

```bash
# Ver uso de memoria en tiempo real
flutter logs | grep "memory"
```

## 📞 Contacto para Soporte

Si después de intentar estos pasos aún tienes problemas:

1. Recolecta logs completos
2. Documenta pasos para reproducir
3. Indica dispositivo y versión SO
4. Abre un issue en GitHub
5. Incluye:
   - Stack trace completo
   - Logs de Flutter (`flutter logs`)
   - Versión de app y dependencias
   - Pasos exactos para reproducir

---

**Última actualización**: Febrero 2026
