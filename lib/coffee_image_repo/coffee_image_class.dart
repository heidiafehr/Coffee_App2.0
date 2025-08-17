class CoffeeImage {
  CoffeeImage({
    required this.file,
  });

  factory CoffeeImage.fromRestJson(Map<String, dynamic> json) {
    return CoffeeImage(file: json['file'].toString(),);
  }

  final String file;
}