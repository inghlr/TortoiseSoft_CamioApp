/// Enumerador para tipos de cámara
enum CameraType {
  front('front'),
  back('back');

  final String value;
  const CameraType(this.value);

  factory CameraType.fromString(String value) {
    return CameraType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => CameraType.front,
    );
  }
}
