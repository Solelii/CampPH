
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

import 'package:camph/themes/app_colors.dart';
import 'package:camph/widgets/campgroundsheet.dart';
import 'package:flutter/material.dart';
import 'package:camph/widgets/search.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';


class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  
  bool _isSheetOpen = false;

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
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 100),
        child: Padding(
          padding: const EdgeInsets.only(top: 30, left: 15, right: 15),
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
              /*

                To be replaced recently searched campsites

              */
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
          )
        ),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(13.41, 122.56),
          initialZoom: 7.0,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
        ],
      )
    );
  }
}

//   @override
//   Widget build(BuildContext context) {
// // Stack is a widget that let's you stack widgets upon another widget

//     return Stack(
//       children: [

// // Gesture detector is a gesture detector. it detects gestures, and let's you decide what to do with the info. in this case, it should've closed the draggable
// //scrollable sheet, but there are still problems not fixed.

//       GestureDetector(
//         onTap: _closeSheet,
//         child: Container(
//           decoration: BoxDecoration(
//             color: Color.fromARGB(0, 0, 0, 0)
//           ),
//         ),
//       ),
//       // Location Icon <temporary>
//       Positioned(
//         top: 200,
//         left: 150,
//         child: IconButton(
//           icon: Icon(Icons.location_on, color: Colors.red, size: 40),
//           onPressed: _toggleSheet,
//         ),
//       ),
//       // Draggable Scrollable Sheet <temporary>
//       if(_isSheetOpen)
//         CampgroundSheet(
//           name: "Camp Kawayan",
//           isPublic: true,
//           rating: 4.5,
//           location: "123 Tondo, Manila",
//           socialMediaLink: "facebook.com/campkawayan",
//           phoneNumber: "+63 912 345 6789",
//           firePit: true,
//           restroom: true,
//           petsAllowed: true,
//           picnicTable: true,
//           signal: false,
//           shower: true,
//           tapWater: true,
//           firstAid: false,
//           security: true,
//           bikingTrails: true,
//           hikingTrails: true,
//           store: false,
//           foodServices: true,
//           lakesOrRiver: true,
//           electricity: false,
//           wifi: false, 
//           closeSheet: _closeSheet,
//       )
//     ],
// );
//  }

  // @override
  // Widget build1(BuildContext context){

  //   return Scaffold(
  //     appBar: SearchBarApp(),
  //     body: Stack(

  //     ),
  //   )

  // }
