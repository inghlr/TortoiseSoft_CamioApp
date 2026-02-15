/// Enum for camera resolution types
enum ResolutionType {
  qvga('QVGA (320x240)', 320, 240),
  vga('VGA (640x480)', 640, 480),
  hd('HD (1280x720)', 1280, 720),
  fullHd('Full HD (1920x1080)', 1920, 1080),
  twoK('2K (2560x1440)', 2560, 1440);

  final String name;
  final int width;
  final int height;

  const ResolutionType(this.name, this.width, this.height);

  factory ResolutionType.fromIndex(int index) {
    return ResolutionType.values[index.clamp(0, ResolutionType.values.length - 1)];
  }
}
