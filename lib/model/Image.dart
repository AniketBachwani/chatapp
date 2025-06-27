import 'package:flutter/material.dart';

List<String> AddImage = [
  "assets/Image1.jpg",
  "assets/Image4.jpg",
  "assets/Image2.jpg",
  "assets/Image5.jpg",
  "assets/Image6.jpg",
  "assets/Image3.jpg",
  "assets/Image9.jpg",
  "assets/Image7.jpg",
  "assets/Image8.jpg",
  "assets/Image10.jpg"
];

class CircularImage extends StatelessWidget {
  final int? imagePath;
  final double size;

  const CircularImage({
    super.key,
    required this.imagePath,
    this.size = 40.0, // Default size
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        width: size,
        height: size,
        color: Colors.grey[200], // Add a background color if image is missing
        child: Image.asset(
          AddImage[imagePath ?? 0],
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
