import 'package:flutter/material.dart';

class CampgroundSheet extends StatefulWidget {


// Peek state

// Place details

  final String name;
  final bool isPublic;
  final double rating;
  
// Expanded state

// Location and contact info

  final String location;
  final String socialMediaLink;
  final String phoneNumber;

// Features/amenities

  final bool firePit;
  final bool restroom;
  final bool petsAllowed;
  final bool picnicTable;
  final bool signal;
  final bool shower;
  final bool tapWater;
  final bool firstAid;
  final bool security; // Campground staff, gated areas, and/or patrols
  final bool bikingTrails;
  final bool hikingTrails;
  final bool store;
  final bool foodServices;
  final bool lakesOrRiver;
  final bool electricity;
  final bool wifi;

  const CampgroundSheet(
      {
        super.key, 
        required this.name, 
        required this.isPublic, 
        required this.rating, 
        required this.location, 
        required this.socialMediaLink, 
        required this.phoneNumber, 
        required this.firePit, 
        required this.restroom, 
        required this.petsAllowed, 
        required this.picnicTable, 
        required this.signal, 
        required this.shower, 
        required this.tapWater, 
        required this.firstAid, 
        required this.security, 
        required this.bikingTrails, 
        required this.hikingTrails, 
        required this.store, 
        required this.foodServices, 
        required this.lakesOrRiver, 
        required this.electricity,
        required this.wifi
      }
    );

  @override
  State<StatefulWidget> createState() => _CampgroundSheetState();

}


/*

  DraggableScrollableSheet(
      builder: (context, scrollController){
        return SingleChildScrollView(
          
        )
      }
    )

*/

class _CampgroundSheetState extends State<CampgroundSheet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Draggable Scrollable Sheet')),
      body: Stack(
        children: [
          Center(child: Text('Main Content Goes Here')),
          DraggableScrollableSheet(
            initialChildSize: 0.2,  // Default size (20% of screen height)
            minChildSize: 0.1,       // Minimum size (10% of screen height)
            maxChildSize: 0.8,       // Maximum size (80% of screen height)
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black26)],
                ),
                child: ListView(
                  controller: scrollController, // Enables scrolling
                  children: List.generate(30, (index) => ListTile(
                    title: Text('Item $index'),
                  )),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
