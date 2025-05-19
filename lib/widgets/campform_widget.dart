import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:campph/themes/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campph/services/camp_service.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CampFormWidget extends StatefulWidget {
  final LatLng? initialLocation;

  const CampFormWidget({super.key, this.initialLocation});

  @override
  State<CampFormWidget> createState() => _CampFormWidgetState();
}

class _CampFormWidgetState extends State<CampFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final List<String> _tags = [
    'Public',
    'Private',
    'River',
    'Beach',
    'Lake',
    'Mountain',
    'Woods',
    'Glamping',
  ];
  final Set<String> _selectedTags = {};

  late LatLng? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation;
  }

  void _toggleTag(String tag) {
    setState(() {
      if (tag == 'Public') _selectedTags.remove('Private');
      if (tag == 'Private') _selectedTags.remove('Public');

      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else {
        _selectedTags.add(tag);
      }
    });
  }

  Widget _buildTagButton(String tag) {
    final isSelected = _selectedTags.contains(tag);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      child: ChoiceChip(
        label: Text(tag),
        selected: isSelected,
        onSelected: (_) => _toggleTag(tag),
        selectedColor: AppColors.darkGreen,
        backgroundColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? Colors.transparent : Colors.grey.shade400,
          ),
        ),
      ),
    );
  }

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

  void _showSuccessSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Camp saved successfully!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double fieldWidth = MediaQuery.of(context).size.width * 0.85;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 20,
        left: 20,
        right: 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Add Camp Info',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 20),

            if (_selectedLocation != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Selected Location:\nLat: ${_selectedLocation!.latitude.toStringAsFixed(5)}, '
                  'Lng: ${_selectedLocation!.longitude.toStringAsFixed(5)}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    width: fieldWidth,
                    child: TextFormField(
                      controller: _nameController,
                      validator:
                          (value) =>
                              (value == null || value.isEmpty)
                                  ? 'Camp name is required.'
                                  : null,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color(0xFFF0F0F0),
                        border: OutlineInputBorder(),
                        labelText: 'Camp Name',
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: fieldWidth,
                    child: TextFormField(
                      controller: _descriptionController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color(0xFFF0F0F0),
                        border: OutlineInputBorder(),
                        labelText: 'Description',
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        'Tags',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 4,
                    runSpacing: 0,
                    children: _tags.map(_buildTagButton).toList(),
                  ),
                  const SizedBox(height: 30),

                  SizedBox(
                    width: fieldWidth,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (_selectedLocation == null) return;

                          if (!_selectedTags.contains('Public') &&
                              !_selectedTags.contains('Private')) {
                            _showErrorFlushbar(
                              'Please select either "Public" or "Private" as Camp Type.',
                            );
                            return;
                          }

                          final user = FirebaseAuth.instance.currentUser;
                          if (user == null) {
                            _showErrorFlushbar(
                              'You must be logged in to save a camp.',
                            );
                            return;
                          }

                          try {
                            await CampFirestoreService().saveCampData(
                              location: _selectedLocation!,
                              name: _nameController.text.trim(),
                              description: _descriptionController.text.trim(),
                              tags: _selectedTags,
                              ownerId: user.uid, // <-- Pass ownerId
                            );

                            if (mounted) {
                              _showSuccessSnackbar();

                              await Future.delayed(
                                const Duration(milliseconds: 500),
                              );
                              Navigator.pop(context);
                            }
                          } catch (e) {
                            _showErrorFlushbar('Error saving camp. Try again.');
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.darkGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Save Camp',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
