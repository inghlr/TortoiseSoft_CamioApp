// Archivo: android/app/src/main/AndroidManifest.xml
// Asegúrate de incluir estos permisos:

<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Permisos de cámara -->
    <uses-permission android:name="android.permission.CAMERA" />
    
    <!-- Permisos de red -->
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    <uses-permission android:name="android.permission.CHANGE_NETWORK_STATE" />
    
    <!-- Permisos de almacenamiento (opcional) -->
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
    
    <!-- Configuración de características de cámara -->
    <uses-feature android:name="android.hardware.camera" android:required="false" />
    <uses-feature android:name="android.hardware.camera.autofocus" android:required="false" />

    <!-- Resto de configuración de la aplicación -->
    <application>
        ...
    </application>
</manifest>
