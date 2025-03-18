import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ReviewSection extends StatefulWidget {
  @override
  _ReviewSectionState createState() => _ReviewSectionState();
}

class _ReviewSectionState extends State<ReviewSection> {
  int selectedRating = 0;
  List<File> images = [];

  final ImagePicker _picker = ImagePicker();

  // Function to set rating
  void setRating(int rating) {
    setState(() {
      selectedRating = rating;
    });
  }

  // Function to pick images
  Future<void> pickImages() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        images = pickedFiles.map((file) => File(file.path)).toList();
      });
    }
  }

  // Function to get dynamic layout
  Widget buildImageGrid() {
    if (images.isEmpty) {
      return Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text("No Image", style: TextStyle(color: Colors.grey[700])),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children:
          images.map((file) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                file,
                width: images.length == 1 ? double.infinity : 120,
                height: images.length == 1 ? 120 : 100,
                fit: BoxFit.cover,
              ),
            );
          }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: 400,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildImageGrid(),
                SizedBox(height: 12),
                Text(
                  "Bondok",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Public Campground / Government Permit",
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(height: 8),

                // Star Rating
                Row(
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        Icons.star,
                        color:
                            index < selectedRating
                                ? Colors.amber
                                : Colors.grey[400],
                      ),
                      onPressed: () => setRating(index + 1),
                    );
                  }),
                ),

                // Upload Button
                ElevatedButton(
                  onPressed: pickImages,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 40),
                  ),
                  child: Text("Upload Images"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
