import 'package:camph/screens/campgroundsheet.dart';
import 'package:flutter/material.dart';

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
    return Stack(
      children: [
        GestureDetector(
          onTap: _closeSheet,
          child: Container(color: Colors.greenAccent),
        ),
        // Location Icon <temporary>
        Positioned(
          top: 200,
          left: 150,
          child: IconButton(
            icon: Icon(Icons.location_on, color: Colors.red, size: 40),
            onPressed: _toggleSheet,
          ),
        ),
        // Draggable Scrollable Sheet <temporary>
        if (_isSheetOpen)
          CampgroundSheet(
            name: "Camp Kawayan",
            isPublic: true,
            rating: 4.5,
            location: "123 Tondo, Manila",
            socialMediaLink: "facebook.com/campkawayan",
            phoneNumber: "+63 912 345 6789",
            firePit: true,
            restroom: true,
            petsAllowed: true,
            picnicTable: true,
            signal: false,
            shower: true,
            tapWater: true,
            firstAid: false,
            security: true,
            bikingTrails: true,
            hikingTrails: true,
            store: false,
            foodServices: true,
            lakesOrRiver: true,
            electricity: false,
            wifi: false, 
            closeSheet: _closeSheet,
        )
      ],
    );
  }
}
