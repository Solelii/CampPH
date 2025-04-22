
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
import 'package:campph/widgets/campgroundsheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:campph/data_class/data_class.dart';


class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  
  bool _isSheetOpen = false;

  late double _currentZoom;

  @override
  void initState() {
    super.initState();
    _currentZoom = 7.0;
  }

  void _toggleSheet() {
    setState(() {
      _isSheetOpen = true;
    });
  }

  void _closeSheet() {
    setState(() {
      _isSheetOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(  
            initialCenter: LatLng(13.41, 122.56),
            initialZoom: _currentZoom,
            onPositionChanged: (MapPosition position, bool hasGesture) {
              setState(() {
                _currentZoom = position.zoom ?? _currentZoom;
              });
            },
            onTap: (_, __) {
              if (_isSheetOpen) {
                _closeSheet();
              }
            }
          ),
          children: [
            /*

              {s} = subdomain
              {z} = zoom level
              {x} = x-coordinate
              {y} = y-coordinate

            */
            TileLayer(
              urlTemplate: "https://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c'],
            ),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top,
                  left: 15,
                  right: 15,
                ),
                child: SearchAnchor(
                  builder: (BuildContext context, SearchController controller) {
                    return SearchBar(
                      controller: controller,
                      padding: const WidgetStatePropertyAll<EdgeInsets>(
                        EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                      onTap: () {
                        controller.openView();
                      },
                      onChanged: (_) {
                        controller.openView();
                      },
                      leading: const Icon(Icons.location_on),
                      hintText: 'Search here',
                      textStyle: WidgetStateProperty.all(
                        const TextStyle(color: AppColors.gray),
                      ),
                    );
                  },
                  suggestionsBuilder: (BuildContext context, SearchController controller) {
                    return List<ListTile>.generate(5, (int index) {
                      final String item = 'item $index';
                      return ListTile(
                        title: Text(item),
                        onTap: () {
                          setState(() {
                            controller.closeView(item);
                          });
                        },
                      );
                    });
                  },
                ),
              ),
            ),
            //temp
            MarkerLayer(
              markers: [
                Marker(
                  width: 40,
                  height: 40,
                  point: LatLng(13.41, 122.56),
                  child: GestureDetector(
                    onTap: (){
                      if (_isSheetOpen){
                        _closeSheet();
                      }else{
                        _toggleSheet();
                      }
                    },
                    child: Image.asset(
                      'assets/images/markers/woods_public.png',
                      fit: BoxFit.contain,
                    ),
                  )
                ),
              ],
            ),
            if(_isSheetOpen)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                bottom: _isSheetOpen ? 0 : -MediaQuery.of(context).size.height * 0.5,
                left: 0,
                right: 0,
                child: CampgroundSheet(
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
                ),
              )
            ],
        )
      ],
    );
  }
}

                

