/* Authored by: Khurt Dilanco
  Company: Blue Team
  Project: Project CampH
  Feature: [CMPH-002] Explore Screen
  Description: 

  This is the first screen that the user will see. Immediately, the user will be able to view the nearest campsite.

  Objectives:

    Integrate Google Maps in Flutter (Using google_maps_flutter package)

    Add Search Bar at the top (TextField or AppBar)

    Add Current Location Button (Use geolocator for location access)

    Implement Floating Action Button (FAB) for adding places/reviews

    Decide whether to keep or remove Search Area Feature

 */

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

  // The initial center of the map
  final LatLng _initialCenter = LatLng(13.41, 122.56);

  @override
  void initState() {
    super.initState();
    _currentZoom = 7.0;
    _selectedLocation = _initialCenter; // Initialize selected location
  }

  void _showCampFormBottomSheet() {
    if (_selectedLocation == null) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => CampFormWidget(initialLocation: _selectedLocation),
    );
  }

  void _startAddingCamp() {
    setState(() {
      _isAddingCamp = true;
      _selectedLocation =
          _initialCenter; // or current center from map controller if available
    });
  }

  void _cancelAddingCamp() {
    setState(() {
      _isAddingCamp = false;
      _selectedLocation = null;
    });
  }

  void _saveCamp() {
    if (_selectedLocation != null) {
      _showCampFormBottomSheet();
      setState(() {
        _isAddingCamp = false;
      });
    } else {
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

/*
  CampgroundSheet(
    name: "Camp Kawayan",
    isPublic: true,
    rating: 4.5,
    numOfPWRate: 10,
    address: "123 Tondo, Manila",
    socialMediaLink: "facebook.com/campkawayan",
    phoneNumber: "+63 912 345 6789", 
    description: '''
      Nestled at the base of Mt. Kalinawan, Luntian Campgrounds offers a serene escape from the bustle of city life. Wake up to a sea of clouds and fall asleep under a blanket of stars.

      Each campsite includes a fire pit, shared toilet and shower facilities, and access to scenic hiking trails.

      For sleeping, guests may choose between primitive tent camping or our cozy furnished bell tents with queen-sized beds and solar-powered lights.

      Ideal for couples, solo adventurers, and weekend warriors looking for a mix of raw nature and light comfort.

      Nearby attractions include Kalinawan Falls, Bato Viewing Deck, and the Bayan Farmers Market (15 mins drive).
  ''', 
    naturalFeature: 'MountainRiverWoods', 
    imageUrls: ['a'], 
    isGlampingSite: false, 
    typeOfShelter: ['BellTent'], 
    listOfUnitsAndAmenities: [
      Units(
        groundSleeping: true
      )
      ..guests = 2
      ..pillows = 2
      ..blanket = 1
      ..restroom = 0
    ],
    
    outdoorGrill: true,
    firePitOrBonfire: true,
    tentRental: true,
    hammockRental: true,

    soap: false,
    hairDryer: false,
    bathrobeOrTowel: false,
    bidet: false,

    privateAccess: false,
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

    rules: [
      "1. Respect quiet hours from 10:00 PM to 6:00 AM.",
      "2. Campfires are allowed only in designated fire pits. Please put them out completely before leaving.",
      "3. Keep the campsite clean — use trash bins or pack out all waste.",
      "4. Pets are welcome but must be leashed at all times.",
      "5. Do not disturb local wildlife or remove plants from the area.",
      "6. Alcohol is permitted, but please drink responsibly and avoid excessive noise.",
      "7. Use shared facilities responsibly and leave them clean for the next camper.",
      "8. Park only in designated parking areas to avoid damaging natural vegetation.",
      "9. Unauthorized loud music or parties are not allowed.",
      "10. Follow instructions from campsite staff at all times."
    ],
    visibility: true,
    // ignore: void_checks
    closeSheet: false,
  )
*/
