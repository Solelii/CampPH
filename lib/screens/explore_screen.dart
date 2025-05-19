import 'package:campph/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:campph/widgets/campform_widget.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  bool _isSheetOpen = false;
  bool _isAddingCamp = false;
  late double _currentZoom;
  LatLng? _selectedLocation;

  final LatLng _initialCenter = LatLng(13.41, 122.56);

  @override
  void initState() {
    super.initState();
    _currentZoom = 7.0;
    _selectedLocation = _initialCenter;
  }

  Future<void> _showCampFormBottomSheet() async {
    if (_selectedLocation == null || !mounted) return;

    // Open the bottom sheet and wait until it's closed
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => CampFormWidget(initialLocation: _selectedLocation),
    );

    // Optional: when sheet is dismissed, ensure widget is still mounted
    if (mounted) {
      setState(() => _isSheetOpen = false);
    }
  }

  void _startAddingCamp() {
    if (!mounted) return;
    setState(() {
      _isAddingCamp = true;
      _selectedLocation = _initialCenter;
    });
  }

  void _cancelAddingCamp() {
    if (!mounted) return;
    setState(() {
      _isAddingCamp = false;
      _selectedLocation = null;
    });
  }

  void _saveCamp() {
    if (_selectedLocation != null) {
      _showCampFormBottomSheet();
      if (!mounted) return;
      setState(() {
        _isAddingCamp = false;
        _isSheetOpen = true;
      });
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a location on the map")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(
            initialCenter: _initialCenter,
            initialZoom: _currentZoom,
            onPositionChanged: (MapPosition position, bool hasGesture) {
              if (!mounted) return;
              setState(() {
                _currentZoom = position.zoom ?? _currentZoom;
                if (_isAddingCamp) {
                  _selectedLocation = position.center;
                }
              });
            },
            onTap: (_, __) {
              if (_isSheetOpen && mounted) {
                setState(() => _isSheetOpen = false);
              }
            },
          ),
          children: [
            TileLayer(
              urlTemplate:
                  "https://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c'],
            ),
          ],
        ),

        if (_isAddingCamp)
          Center(
            child: Icon(Icons.location_pin, size: 50, color: Colors.redAccent),
          ),

        Positioned(
          bottom: 20,
          right: 20,
          child:
              _isAddingCamp
                  ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FloatingActionButton(
                        heroTag: 'cancel',
                        backgroundColor: Colors.grey,
                        onPressed: _cancelAddingCamp,
                        child: const Icon(Icons.close),
                      ),
                      const SizedBox(width: 10),
                      FloatingActionButton(
                        heroTag: 'save',
                        backgroundColor: AppColors.darkGreen,
                        onPressed: _saveCamp,
                        child: const Icon(Icons.check),
                      ),
                    ],
                  )
                  : FloatingActionButton(
                    backgroundColor: AppColors.darkGreen,
                    onPressed: _startAddingCamp,
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
        ),
      ],
    );
  }
}
