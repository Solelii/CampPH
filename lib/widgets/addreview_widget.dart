import 'package:flutter/material.dart';
import 'package:campph/themes/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:campph/services/review_service.dart';
import 'package:campph/services/user_service.dart';

class AddReviewForm extends StatefulWidget {
  final String campId;

  const AddReviewForm({super.key, required this.campId});

  @override
  State<AddReviewForm> createState() => _AddReviewFormState();
}

class _AddReviewFormState extends State<AddReviewForm> {
  int _selectedRating = 0;
  final TextEditingController _commentController = TextEditingController();
  final ReviewFirestoreService _reviewService = ReviewFirestoreService();
  final UserFirestoreService _userService = UserFirestoreService();

  bool get _hasInput =>
      _selectedRating > 0 || _commentController.text.trim().isNotEmpty;

  void _showErrorFlushbar(String message) {
    Flushbar(
      message: message,
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 2),
      flushbarPosition: FlushbarPosition.TOP,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
    ).show(context);
  }

  void _showSuccessFlushbar(String message) {
    Flushbar(
      message: message,
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 2),
      flushbarPosition: FlushbarPosition.TOP,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
    ).show(context);
  }

  void _handleClose() {
    if (_hasInput) {
      showDialog(
        context: context,
        builder:
            (ctx) => AlertDialog(
              title: const Text("Discard Review?"),
              content: const Text(
                "You have unsaved changes. Are you sure you want to leave this page?",
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(), // Stay on page
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(); // Close dialog
                    Navigator.of(context).pop(); // Close bottom sheet
                  },
                  child: const Text("Discard"),
                ),
              ],
            ),
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  Future<void> _submitReview() async {
    if (_selectedRating == 0 || _commentController.text.trim().isEmpty) {
      _showErrorFlushbar('Please select a rating and enter a comment');
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _showErrorFlushbar('You must be logged in to submit a review');
        return;
      }

      // Use your UserFirestoreService to get the username by user ID
      final username = await _userService.getUsername(user.uid) ?? 'Anonymous';

      await _reviewService.addOrUpdateReview(
        campId: widget.campId,
        userId: user.uid,
        username: username,
        rating: _selectedRating,
        comment: _commentController.text.trim(),
      );

      if (mounted) {
        Navigator.of(context).pop(); // Close bottom sheet
        _showSuccessFlushbar('Review submitted!');
      }
    } catch (e) {
      _showErrorFlushbar('Error submitting review. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with close icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 48), // Spacer
                const Text(
                  'Leave a Review',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _handleClose,
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Star rating
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final starIndex = index + 1;
                return IconButton(
                  icon: Icon(
                    Icons.star,
                    color:
                        _selectedRating >= starIndex
                            ? Colors.amber
                            : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedRating = starIndex;
                    });
                  },
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: _commentController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Write your comment...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _submitReview,
              icon: const Icon(Icons.send),
              label: const Text('Submit Review'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkGreen,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
