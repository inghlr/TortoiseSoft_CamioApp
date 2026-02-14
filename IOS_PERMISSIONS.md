// Archivo: ios/Runner/Info.plist
// Agregar estas claves al diccionario root:

<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <!-- Descripción para permiso de cámara -->
    <key>NSCameraUsageDescription</key>
    <string>Esta app necesita acceso a tu cámara para transmitir video en tiempo real. El acceso a la cámara es esencial para que la app funcione correctamente.</string>
    
    <!-- Descripción para acceso a red local -->
    <key>NSLocalNetworkUsageDescription</key>
    <string>Esta app necesita acceso a tu red local para conectarse al servidor y transmitir el video de tu cámara.</string>
    
    <!-- Descripción para mDNS (Bonjour) -->
    <key>NSBonjourServices</key>
    <array>
        <string>_http._tcp</string>
        <string>_https._tcp</string>
    </array>
    
    <!-- Requiere conexión segura -->
    <key>NSRequiresSecureConnection</key>
    <false/>
    
    <!-- Configuración de transporte de aplicaciones -->
    <key>NSAppTransportSecurity</key>
    <dict>
        <!-- Permite conexiones HTTP para desarrollo (en producción usa HTTPS) -->
        <key>NSAllowsArbitraryLoads</key>
        <true/>
        
        <!-- O más seguro: especifica dominios confiables -->
        <!--
        <key>NSExceptionDomains</key>
        <dict>
            <key>yourdomain.com</key>
            <dict>
                <key>NSIncludesSubdomains</key>
                <true/>
                <key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
                <true/>
                <key>NSTemporaryExceptionMinimumTLSVersion</key>
                <string>TLSv1.1</string>
            </dict>
        </dict>
        -->
    </dict>

    <!-- Resto de configuración de la app -->
    ...
</dict>
</plist>
