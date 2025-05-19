import 'package:campph/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:campph/widgets/campform_widget.dart';
import 'package:campph/services/camp_service.dart';
import 'package:campph/widgets/campgroundsheet.dart';

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
  final CampFirestoreService _campService = CampFirestoreService();
  List<Map<String, dynamic>> _camps = [];
  PersistentBottomSheetController? _bottomSheetController;

  final LatLng _initialCenter = LatLng(13.41, 122.56);

  @override
  void initState() {
    super.initState();
    _currentZoom = 7.0;
    _selectedLocation = _initialCenter; // Initialize selected location
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

    if (mounted) {
      setState(() => _isSheetOpen = false);
    }
  }

  void _showCampDetails(Map<String, dynamic> camp) {
    if (_bottomSheetController != null) {
      _bottomSheetController!.close();
      _bottomSheetController = null;
      setState(() => _isSheetOpen = false);
      return;
    }

    setState(() => _isSheetOpen = true);
    _bottomSheetController = showBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => CampgroundSheet(
        name: camp['CampName'],
        isPublic: camp['CampType'] == 'Public',
        rating: 0.0,
        numOfPWRate: 0,
        address: "Location: ${camp['location'].latitude}, ${camp['location'].longitude}",
        socialMediaLink: "",
        phoneNumber: "",
        description: camp['CampDescription'],
        naturalFeature: camp['CampFeatures'].join(', '),
        imageUrls: [],
        isGlampingSite: camp['CampFeatures'].contains('Glamping'),
        typeOfShelter: [],
        listOfUnitsAndAmenities: [],
        outdoorGrill: false,
        firePitOrBonfire: false,
        tentRental: false,
        hammockRental: false,
        soap: false,
        hairDryer: false,
        bathrobeOrTowel: false,
        bidet: false,
        privateAccess: camp['CampType'] == 'Private',
        emergencyCallSystem: false,
        guardsAvailable: false,
        firstAidKit: false,
        securityCameras: false,
        pwdFriendly: false,
        powerSource: false,
        electricFan: false,
        airConditioning: false,
        drinkingOrWashingWater: false,
        drinksAllowed: false,
        petsAllowed: false,
        rules: [],
        visibility: true,
        closeSheet: () {
          _bottomSheetController?.close();
          _bottomSheetController = null;
          setState(() => _isSheetOpen = false);
        },
      ),
    );

    _bottomSheetController!.closed.then((_) {
      _bottomSheetController = null;
      if (mounted) {
        setState(() => _isSheetOpen = false);
      }
    });
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
              setState(() {
                _currentZoom = position.zoom ?? _currentZoom;
                if (_isAddingCamp) {
                  _selectedLocation = position.center;
                }
              });
            },
            onTap: (_, __) {
              if (_isSheetOpen) {
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
            // Your markers here...
          ],
        ),

        if (_isAddingCamp)
          Center(
            child: Icon(Icons.location_pin, size: 50, color: Colors.redAccent),
          ),

        // Your other UI components (SearchBar, sheets) ...
        Positioned(
          bottom: 20,
          right: 20,
          child: _isAddingCamp
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
