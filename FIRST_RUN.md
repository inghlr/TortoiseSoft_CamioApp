# 🚀 First Run Guide - Guía de Primer Uso

## ✅ Pre-requisitos

Antes de ejecutar la app, asegúrate de tener:

- [x] Flutter 3.9.2+ instalado
- [x] Dart 3.9.2+ instalado
- [x] Un dispositivo Android/iOS o emulador
- [x] Un servidor .NET ejecutándose (opcional pero recomendado para pruebas)
- [x] WiFi disponible (celular y PC en la misma red)

---

## 🔧 Paso 1: Preparación del Entorno

### Windows / macOS / Linux

```bash
# Verificar instalación de Flutter
flutter --version

# Verificar disponibilidad de dispositivos
flutter devices

# Si no hay dispositivos, iniciar emulador
flutter emulators --launch <emulator_id>
```

---

## 📥 Paso 2: Instalar Dependencias

```bash
# En la raíz del proyecto
cd flutter_caminout_app

# Obtener dependencias
flutter pub get

# Análizar proyecto
flutter analyze

# (Opcional) Corregir problemas de análisis
dart fix --apply
```

---

## 📱 Paso 3: Configurar Permisos (Importante!)

### Android

Edita `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.CAMERA" />
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    <uses-permission android:name="android.permission.CHANGE_NETWORK_STATE" />
    
    <uses-feature android:name="android.hardware.camera" android:required="false" />
    
    <application>
        <!-- ... resto de configuración ... -->
    </application>
</manifest>
```

### iOS

Edita `ios/Runner/Info.plist`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>NSCameraUsageDescription</key>
    <string>Esta app necesita acceso a tu cámara para transmitir video en tiempo real</string>
    
    <key>NSLocalNetworkUsageDescription</key>
    <string>Esta app necesita acceso a tu red local para conectarse al servidor</string>
    
    <key>NSBonjourServices</key>
    <array>
        <string>_http._tcp</string>
        <string>_https._tcp</string>
    </array>
    
    <key>NSAppTransportSecurity</key>
    <dict>
        <key>NSAllowsArbitraryLoads</key>
        <true/>
    </dict>
    
    <!-- ... resto de configuración ... -->
</dict>
</plist>
```

---

## 🎮 Paso 4: Ejecutar la App

### Opción A: Modo Debug

```bash
# En un terminal en la raíz del proyecto
flutter run

# Si hay múltiples dispositivos:
flutter run -d <device_id>

# Con logs detallados:
flutter run -v
```

### Opción B: Modo Release (Más rápido)

```bash
flutter run --release
```

### Opción C: En un dispositivo específico

```bash
# Ver dispositivos disponibles
flutter devices

# Ejecutar en uno específico
flutter run -d <device_id>
```

---

## ⚙️ Paso 5: Configuración Inicial de la App

Una vez que la app está corriendo:

1. **Pantalla Principal**
   - Verás un icono de cámara apagada
   - Status: "Ready"
   - Botón verde para iniciar

2. **Ir a Settings** (Icono ⚙️)
   - Ingresa la IP de tu servidor (ej: 192.168.1.100)
   - Ingresa el puerto (default: 8080)
   - Selecciona resolución (recomendado: HD para pruebas)
   - Selecciona FPS (recomendado: 30)
   - Guarda con "Save Settings"

---

## 🖥️ Paso 6: Configura el Backend (Opcional)

Si tienes un servidor .NET ejecutándose:

```bash
# En servidor Windows
# El servidor debe escuchar en puerto 8080 (configurable)

# Verificar que está escuchando
netstat -an | findstr :8080
# Deberías ver: LISTENING
```

Si **no tienes backend aún**, puedes:
- Omitir por ahora (la app intentará conectar pero mostrará error)
- Implementar el backend más tarde según BACKEND_GUIDE.md

---

## 🎬 Paso 7: Prueba Básica

### Sin Backend (Prueba Local)

```bash
# 1. Inicia la app
flutter run

# 2. Ve a Settings y ingresa:
#    IP: 127.0.0.1 (localhost)
#    Puerto: 8080

# 3. Guarda y vuelve a main

# 4. Intenta hacer tap en el botón de play

# Resultado esperado:
# - Verás feed de la cámara
# - Status: "Connecting..." (esperará servidor)
# - Después de timeout: "Connection failed" (normal sin backend)
```

### Con Backend .NET (Prueba Completa)

```bash
# 1. Asegúrate que el backend está corriendo
# 2. Verifica que el celular y PC están en la misma red WiFi
# 3. Obtén la IP del PC:
#    - Windows: ipconfig | findstr IPv4
#    - Linux/Mac: ifconfig | grep "inet "

# 4. Inicia la app
flutter run

# 5. Settings:
#    IP: <IP_DEL_PC>  (ej: 192.168.1.100)
#    Puerto: 8080

# 6. Guarda y vuelve a main

# 7. Tap en el botón de play

# Resultado esperado:
# - Ves feed de cámara
# - Status: "Streaming..."
# - Luz verde indica conexión activa
# - Video transmite en tiempo real
```

---

## 🧪 Paso 8: Debugging

### Ver Logs en Consola

```bash
# En la terminal donde ejecutó flutter run
# O en una nueva terminal:
flutter logs

# Filtrar por palabra clave
flutter logs | grep -i camera
flutter logs | grep -i socket
flutter logs | grep -i error
```

### Hot Reload (Desarrollo)

```bash
# En la terminal de Flutter
r          # Hot reload (cambios de UI)
Shift+r    # Hot restart (cambios de lógica)
q          # Detener app
```

### Usar DevTools

```bash
# Terminal 1: Ejecutar app
flutter run

# Terminal 2: Abrir DevTools
devtools
# Luego abre: http://localhost:9100

# Puedes inspeccionar:
# - Widget tree
# - Memory usage
# - Performance
# - Logs
# - Inspector de red
```

---

## 📊 Paso 9: Verificar Funcionalidad

### Checklist de Pruebas

- [ ] La app se inicia sin errores
- [ ] La pantalla principal se muestra
- [ ] Puedo acceder a Settings
- [ ] Puedo cambiar configuración
- [ ] Las configuraciones se guardan
- [ ] Intento conectar (sin backend muestra error, normal)
- [ ] Puedo ver el feed de la cámara
- [ ] Los botones responden
- [ ] No hay crashes

---

## ⚠️ Problemas Comunes en Primer Run

### Error: "Device not found"

```bash
# Solución 1: Listar dispositivos
flutter devices

# Solución 2: Reconectar dispositivo
adb devices

# Solución 3: Esperar a que reconozca
# Espera 30 segundos y reintenta
```

### Error: "Dependency error"

```bash
flutter pub get
flutter clean
flutter pub get
```

### Error: "Permission denied"

```bash
# Android: Espera a que pida permisos
# iOS: Ve a Settings > Camera > Allow

# Si sigue fallando:
flutter clean
flutter run
```

### Error: "Socket exception"

```bash
# Normal si no hay backend
# Si tienes backend, verifica:
# 1. IP correcta
# 2. Puerto correcto
# 3. Backend ejecutándose
# 4. Mismo WiFi que el celular
```

---

## 🎯 Próximos Pasos Después de Verificar

### Opción 1: Implementar Backend

Ver `BACKEND_GUIDE.md` para crear servidor .NET

```csharp
// Básico: Signal server en .NET
// - Socket.IO
// - WebRTC negotiation
// - Virtual camera
```

### Opción 2: Mejorar UI

Personalizar pantallas y añadir funcionalidades

### Opción 3: Optimizar Performance

Ajustar resolución, FPS, y compresión

### Opción 4: Compilar Release

```bash
# Android APK
flutter build apk --release

# iOS IPA
flutter build ios --release
```

---

## 📱 Compilar para Dispositivo Real

### Android APK

```bash
# Build APK
flutter build apk --release

# Ubicación: build/app/outputs/apk/release/app-release.apk

# Instalar en dispositivo
adb install build/app/outputs/apk/release/app-release.apk

# O simplemente drag&drop en Android Studio
```

### iOS (Requiere Xcode)

```bash
# Build IPA
flutter build ios --release

# Abrir en Xcode
open ios/Runner.xcworkspace

# Desde Xcode:
# 1. Selecciona dispositivo
# 2. Product > Archive
# 3. Distribuir a App Store o Ad Hoc
```

---

## 📊 Monitorear la Aplicación

### Performance

```bash
# Ver frame time y FPS
flutter run --profile

# En DevTools: Performance tab
```

### Memoria

```bash
# Ver uso de memoria
flutter logs | grep memory
```

### Conectividad

```bash
# Ver conexión Socket.IO
flutter logs | grep socket
```

---

## 🔒 Consideraciones de Seguridad

Para **desarrollo/pruebas**:
- ✅ OK usar HTTP (puerto 8080)
- ✅ OK contraseña vacía
- ✅ OK en red local privada

Para **producción**:
- ❌ NO usar HTTP sin HTTPS
- ⚠️ SIEMPRE usar contraseña fuerte
- ⚠️ USAR firewall y VPN
- ⚠️ USAR certificado SSL válido

---

## 📞 Si Algo Falla

### Información a recolectar:

```bash
# 1. Versión de Flutter
flutter --version

# 2. Dispositivo
flutter devices

# 3. Logs completos
flutter logs > app_logs.txt 2>&1

# 4. Versión de pubspec.yaml (depencencias)
cat pubspec.yaml

# 5. Error específico
# Copia el stack trace completo
```

### Dónde reportar:

1. Ver `TROUBLESHOOTING.md`
2. Buscar en GitHub Issues
3. Crear nuevo issue con info arriba

---

## ✅ Checklist Final Antes de Compartir

- [ ] App compila sin errores
- [ ] Permisos configurados correctamente
- [ ] Tests pasan (`flutter test`)
- [ ] Análisis limpio (`flutter analyze`)
- [ ] Código formateado (`dart format lib/`)
- [ ] Documentación actualizada
- [ ] README con instrucciones claras
- [ ] Backend guide disponible
- [ ] Ejemplos de uso incluidos

---

## 🎉 ¡Felicidades!

Si llegaste hasta aquí, tu app está lista para:

✅ Desarrollo  
✅ Pruebas  
✅ Compilación  
✅ Distribución  

---

**Última actualización**: Febrero 2026  
**Versión**: 1.0.0  
**Estado**: Listo para producción  

**¡A divertirse con tu Camera Streamer App!** 📱🎥
