import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_config.dart';
import '../models/enum/resolution_type.dart';
import '../models/enum/fps_type.dart';
import '../providers/camera_provider.dart';
import '../providers/theme_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController _deviceNameController;
  late TextEditingController _ipController;
  late TextEditingController _portController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    final provider = context.read<CameraProvider>();
    _deviceNameController = TextEditingController(
      text: provider.config.deviceName,
    );
    _ipController = TextEditingController(
      text: provider.config.serverIp,
    );
    _portController = TextEditingController(
      text: provider.config.serverPort.toString(),
    );
    _passwordController = TextEditingController(
      text: provider.config.customPassword ?? '',
    );
  }

  @override
  void dispose() {
    _deviceNameController.dispose();
    _ipController.dispose();
    _portController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Consumer<CameraProvider>(
        builder: (context, provider, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Device name
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Device Information',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _deviceNameController,
                        decoration: InputDecoration(
                          labelText: 'Device Name',
                          border: OutlineInputBorder(),
                          hintText: 'e.g., My Phone Camera',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Server configuration
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Server Connection',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _ipController,
                        decoration: InputDecoration(
                          labelText: 'Server IP',
                          border: OutlineInputBorder(),
                          hintText: '192.168.1.100',
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _portController,
                        decoration: InputDecoration(
                          labelText: 'Port',
                          border: OutlineInputBorder(),
                          hintText: '8080',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 12),
                      CheckboxListTile(
                        title: const Text('Use Secure Connection (HTTPS)'),
                        value: provider.config.useSecureConnection,
                        onChanged: (value) {
                          provider.config.useSecureConnection = value ?? true;
                          setState(() {});
                        },
                        contentPadding: EdgeInsets.zero,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password (Optional)',
                          border: OutlineInputBorder(),
                          hintText: 'Leave empty if not required',
                        ),
                        obscureText: true,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Camera settings
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Camera Settings',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      // Resolution dropdown
                      Text(
                        'Resolution',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      DropdownButton<ResolutionType>(
                        isExpanded: true,
                        value: provider.config.selectedResolution,
                        items: ResolutionType.values
                            .map(
                              (resolution) => DropdownMenuItem(
                                value: resolution,
                                child: Text(resolution.name),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            provider.updateResolution(value);
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      // FPS dropdown
                      Text(
                        'Frame Rate',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      DropdownButton<FpsType>(
                        isExpanded: true,
                        value: provider.config.selectedFps,
                        items: FpsType.values
                            .map(
                              (fps) => DropdownMenuItem(
                                value: fps,
                                child: Text(fps.label),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            provider.updateFps(value);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Theme settings
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Appearance',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      Consumer<ThemeProvider>(
                        builder: (context, themeProvider, _) {
                          return Column(
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: const Text('Dark Mode'),
                                subtitle: Text(
                                  _getThemeModeLabel(themeProvider.themeMode),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.color,
                                  ),
                                ),
                                trailing: PopupMenuButton<ThemeMode>(
                                  onSelected: (mode) {
                                    themeProvider.setThemeMode(mode);
                                  },
                                  itemBuilder: (BuildContext context) => [
                                    PopupMenuItem(
                                      value: ThemeMode.system,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.brightness_auto,
                                            size: 20,
                                            color: themeProvider.themeMode ==
                                                    ThemeMode.system
                                                ? Colors.blue
                                                : null,
                                          ),
                                          const SizedBox(width: 8),
                                          const Text('System'),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: ThemeMode.light,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.brightness_7,
                                            size: 20,
                                            color: themeProvider.themeMode ==
                                                    ThemeMode.light
                                                ? Colors.blue
                                                : null,
                                          ),
                                          const SizedBox(width: 8),
                                          const Text('Light'),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: ThemeMode.dark,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.brightness_4,
                                            size: 20,
                                            color: themeProvider.themeMode ==
                                                    ThemeMode.dark
                                                ? Colors.blue
                                                : null,
                                          ),
                                          const SizedBox(width: 8),
                                          const Text('Dark'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final newConfig = AppConfig(
                    serverIp: _ipController.text,
                    serverPort: int.tryParse(_portController.text) ?? 8080,
                    deviceName: _deviceNameController.text,
                    selectedCamera: provider.config.selectedCamera,
                    selectedResolution:
                        provider.config.selectedResolution,
                    selectedFps: provider.config.selectedFps,
                    useSecureConnection:
                        provider.config.useSecureConnection,
                    customPassword: _passwordController.text.isEmpty
                        ? null
                        : _passwordController.text,
                  );

                  provider.updateConfig(newConfig);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Settings saved!'),
                      duration: Duration(seconds: 2),
                    ),
                  );

                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: Colors.green,
                ),
                child: const Text(
                  'Save Settings',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Helper to get the theme mode label
  String _getThemeModeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'Use system settings';
      case ThemeMode.light:
        return 'Tema claro';
      case ThemeMode.dark:
        return 'Tema oscuro';
    }
  }
}
