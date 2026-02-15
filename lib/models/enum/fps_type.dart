/// Enumerador para tipos de FPS
enum FpsType {
  fps15(15, '15 FPS'),
  fps24(24, '24 FPS'),
  fps30(30, '30 FPS'),
  fps60(60, '60 FPS');

  final int fps;
  final String label;

  const FpsType(this.fps, this.label);

  factory FpsType.fromIndex(int index) {
    return FpsType.values[index.clamp(0, FpsType.values.length - 1)];
  }
}
