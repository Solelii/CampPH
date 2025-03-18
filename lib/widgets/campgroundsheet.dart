import 'package:flutter/material.dart';

class CampgroundSheet extends StatefulWidget {
  
  final void closeSheet;

  final String name;
  final bool isPublic;
  final double rating;

  final String location;
  final String socialMediaLink;
  final String phoneNumber;

  final bool firePit;
  final bool restroom;
  final bool petsAllowed;
  final bool picnicTable;
  final bool signal;
  final bool shower;
  final bool tapWater;
  final bool firstAid;
  final bool security;
  final bool bikingTrails;
  final bool hikingTrails;
  final bool store;
  final bool foodServices;
  final bool lakesOrRiver;
  final bool electricity;
  final bool wifi;

  const CampgroundSheet({
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
    required this.wifi, this.closeSheet, 
  });

  @override
  State<CampgroundSheet> createState() => _CampgroundSheetState();
}

class _CampgroundSheetState extends State<CampgroundSheet> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.0,
      maxChildSize: 1.0,
      builder: (context, scrollController) {
        return  Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            controller: scrollController,
            padding: EdgeInsets.all(16),
            children: [
              // Drag Handle
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 10),

              Text(widget.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,)),

              // Public / Private Status
              Row(
                children: [
                  Text(widget.isPublic ? "Public Campground" : "Private Campground"),
                ],
              ),
              SizedBox(height: 10),

              // Rating
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber),
                  Text("${widget.rating}"),
                ],
              ),
              SizedBox(height: 10),

              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 4.5),
                    child: Container(
                      color: const Color(0xFFD9D9D9),
                      child: SizedBox(height: 203, width: 204.5),
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        color: const Color(0xFFD9D9D9),
                        child: SizedBox(height: 100, width: 130),
                      ),

                      SizedBox(height: 4.5),
                      
                      Container(
                        color: const Color(0xFFD9D9D9),
                        child: SizedBox(height: 100, width: 130),
                      )
                    ],
                  )
                ],
              ),

              Divider(),

              // Location and Contact
              _infoTile(Icons.location_on, widget.location),

              Divider(),
              
              _infoTile(Icons.phone, widget.phoneNumber),

              Divider(),

              _infoTile(Icons.link, widget.socialMediaLink),

              Divider(),

              // Features / Amenities
              Text("Features", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Wrap(
                spacing: 10,
                runSpacing: 5,
                children: [
                  _feature("Fire Pit", widget.firePit),
                  _feature("Restroom", widget.restroom),
                  _feature("Pets Allowed", widget.petsAllowed),
                  _feature("Picnic Table", widget.picnicTable),
                  _feature("Signal", widget.signal),
                  _feature("Shower", widget.shower),
                  _feature("Tap Water", widget.tapWater),
                  _feature("First Aid", widget.firstAid),
                  _feature("Security", widget.security),
                  _feature("Biking Trails", widget.bikingTrails),
                  _feature("Hiking Trails", widget.hikingTrails),
                  _feature("Store", widget.store),
                  _feature("Food Services", widget.foodServices),
                  _feature("Lakes/River", widget.lakesOrRiver),
                  _feature("Electricity", widget.electricity),
                  _feature("WiFi", widget.wifi),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _infoTile(IconData icon, String text) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(text),
    );
  }

  Widget _feature(String label, bool available) {
    return Chip(
      label: Text(label),
      backgroundColor: available ? Colors.green[200] : Colors.grey[300],
    );
  }
}