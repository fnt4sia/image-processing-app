class ModelImage {
  final String path;
  final double brightness;
  final double red;
  final double green;
  final double blue;
  final List<String> activeFilters;
  final bool grayScale;
  final double rotation;
  final double sepia;
  final double saturation;
  final String size;
  final String crop;

  ModelImage({
    required this.path,
    required this.brightness,
    required this.red,
    required this.green,
    required this.blue,
    required this.activeFilters,
    required this.grayScale,
    required this.rotation,
    required this.sepia,
    required this.saturation,
    required this.size,
    required this.crop,
  });

  Map<String, dynamic> jsonConverter() {
    return {
      'path': path,
      'brightness': brightness,
      'red': red,
      'green': green,
      'blue': blue,
      'activeFilters': activeFilters,
      'grayScale': grayScale,
      'rotation': rotation,
      'sepia': sepia,
      'saturation': saturation,
      'size': size,
      'crop': crop,
    };
  }

  factory ModelImage.fromJson(Map<String, dynamic> json) {
    return ModelImage(
      path: json['path'],
      brightness: json['brightness'],
      red: json['red'],
      green: json['green'],
      blue: json['blue'],
      activeFilters: List<String>.from(json['activeFilters']),
      grayScale: json['grayScale'],
      rotation: json['rotation'],
      sepia: json['sepia'],
      saturation: json['saturation'],
      size: json['size'],
      crop: json['crop'],
    );
  }
}
