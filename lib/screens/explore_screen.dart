import 'package:campph/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:campph/widgets/campform_widget.dart';
import 'package:campph/services/camp_service.dart';
import 'package:campph/widgets/campgroundsheet.dart';
import 'package:campph/services/bookmark_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ExploreScreen extends StatefulWidget {
  final Map<String, dynamic>? campToOpen;

  const ExploreScreen({super.key, this.campToOpen});

  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final MapController _mapController = MapController();

  bool _isSheetOpen = false;
  bool _isAddingCamp = false;
  late double _currentZoom;
  LatLng? _selectedLocation;
  final CampFirestoreService _campService = CampFirestoreService();
  final BookmarkService _bookmarkService = BookmarkService();
  List<Map<String, dynamic>> _camps = [];

  final LatLng _initialCenter = LatLng(13.41, 122.56);

  @override
  void initState() {
    super.initState();
    _currentZoom = 7.0;
    _selectedLocation = _initialCenter;
    _listenToCamps();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.campToOpen != null) {
        _centerMapOnCamp(widget.campToOpen!);
        _showCampDetails(widget.campToOpen!);
      }
    });
  }

  void _listenToCamps() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    _campService.getAllCamps().listen((camps) {
      if (!mounted) return;

      final filteredCamps =
          camps.where((camp) {
            final isPublic = camp['CampType'] == 'Public';
            final isOwner = camp['ownerId'] == currentUser.uid;
            return isPublic || isOwner;
          }).toList();

      setState(() {
        _camps = filteredCamps;
      });
    });
  }

  bool _hasWaterFeature(List<dynamic> features) {
    return features.any(
      (feature) => ['River', 'Beach', 'Lake'].contains(feature),
    );
  }

  String _getMarkerImage(Map<String, dynamic> camp) {
    final isPublic = camp['CampType'] == 'Public';
    final features = List<String>.from(camp['CampFeatures'] ?? []);

    if (features.contains('Glamping')) {
      return 'assets/images/markers/glamping.png';
    }
    if (_hasWaterFeature(features)) {
      return isPublic
          ? 'assets/images/markers/water_public.png'
          : 'assets/images/markers/water_private.png';
    }
    if (features.contains('Woods')) {
      return isPublic
          ? 'assets/images/markers/woods_public.png'
          : 'assets/images/markers/woods_private.png';
    }

    return isPublic
        ? 'assets/images/markers/woods_public.png'
        : 'assets/images/markers/woods_private.png';
  }

  Future<void> _showCampFormBottomSheet() async {
    if (_selectedLocation == null || !mounted) return;

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

  Future<void> _showCampDetails(Map<String, dynamic> camp) async {
    if (!mounted) return;
    setState(() => _isSheetOpen = true);

    String campId = camp['id'];
    bool isBookmarked = await _bookmarkService.isCampBookmarked(campId);

    if (!mounted) return;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => CampgroundSheet(
            name: camp['CampName'],
            isPublic: camp['CampType'] == 'Public',
            rating: 0.0,
            numOfPWRate: 0,
            address:
                "Location: ${camp['location'].latitude}, ${camp['location'].longitude}",
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
            isBookmarked: isBookmarked,
            campId: campId,
            closeSheet: () {
              Navigator.of(context).pop();
            },
          ),
    );

    if (mounted) {
      setState(() => _isSheetOpen = false);
    }
  }

  void _centerMapOnCamp(Map<String, dynamic> camp) {
    final LatLng point = camp['location'] as LatLng;
    // Animate or move the map center to the camp location and zoom in if you want
    _mapController.move(point, 12.0); // zoom level 12 for close-up
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
        GestureDetector(
          onTap: () {
            if (_isSheetOpen) {
              Navigator.of(context).pop();
              setState(() => _isSheetOpen = false);
            }
          },
          child: FlutterMap(
            mapController: _mapController,
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
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: [
                  ..._camps.map(
                    (camp) => Marker(
                      point: camp['location'] as LatLng,
                      width: 40,
                      height: 40,
                      child: GestureDetector(
                        onTap: () {
                          _centerMapOnCamp(camp);
                          _showCampDetails(camp);
                        },
                        child: Image.asset(
                          _getMarkerImage(camp),
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ),
                  ),
                  if (_isAddingCamp && _selectedLocation != null)
                    Marker(
                      point: _selectedLocation!,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.location_pin,
                        size: 40,
                        color: Colors.green,
                      ),
                    ),
                ],
              ),
            ],
          ),
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
