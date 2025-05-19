/* Authored by: Khurt Dilanco
  Company: Blue Team
  Project: Project CampH
  Feature: [CMPH-004] Draggable Scrollable Sheet
  Description: 

  This sheet displays the information about the camping site.

  Objectives:

    Implement clickable map markers (Marker in google_maps_flutter)

    Create Sliding Card UI (Use DraggableScrollableSheet)

    Add Overview Content (name, images, reviews, etc.)

    Implement smooth sliding animation

    Design Two Tabs (About & Reviews) using TabBar
    
 */


import 'package:campph/themes/app_colors.dart';
import 'package:campph/themes/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:campph/data_class/data_class.dart';

class CampgroundSheet extends StatefulWidget {

  /*

    camping ground info to be fetched
    may kulang pa na param for review, etc.
    basta si info ni

  */
  
  final void Function() closeSheet;

  final String name;
  final bool isPublic;
  final double rating;
  final int numOfPWRate;

  final String address;
  final String socialMediaLink;
  final String phoneNumber;
  final String description;

  final String naturalFeature;

  final List<String> imageUrls;

  final bool isGlampingSite;

  final List<String> typeOfShelter;

  final List<Units> listOfUnitsAndAmenities;

  final bool outdoorGrill;
  final bool firePitOrBonfire;
  final bool tentRental;
  final bool hammockRental;

  final bool soap;
  final bool hairDryer;
  final bool bathrobeOrTowel;
  final bool bidet;

  final bool privateAccess;
  final bool emergencyCallSystem;
  final bool guardsAvailable;
  final bool firstAidKit;
  final bool securityCameras;
  final bool pwdFriendly;

  final bool powerSource;
  final bool electricFan;
  final bool airConditioning;
  final bool drinkingOrWashingWater;

  final bool drinksAllowed;
  final bool petsAllowed;

  final List<String> rules;

  final bool visibility;

  const CampgroundSheet({
    super.key,

    // Campsite general info

    required this.name,
    required this.isPublic,
    required this.rating,
    required this.numOfPWRate,
    required this.address,
    required this.socialMediaLink,
    required this.phoneNumber,
    required this.description,

    // Natural features nearby

    required this.naturalFeature,

    // Pictures

    required this.imageUrls,

    // Campsite or Glampsite

    required this.isGlampingSite,

    // Types of shelters (bell tent, safari tent, etc.)

    required this.typeOfShelter,

    // Units and amenities

    required this.listOfUnitsAndAmenities,

    // Amenities

    required this.outdoorGrill,
    required this.firePitOrBonfire,
    required this.tentRental,
    required this.hammockRental,

    required this.soap,
    required this.hairDryer,
    required this.bathrobeOrTowel,
    required this.bidet,

    required this.privateAccess,
    required this.emergencyCallSystem,
    required this.guardsAvailable,
    required this.firstAidKit,
    required this.securityCameras,
    required this.pwdFriendly,

    required this.powerSource,
    required this.electricFan,
    required this.airConditioning,
    required this.drinkingOrWashingWater,

    required this.drinksAllowed,
    required this.petsAllowed,

    // Rules for campers
    
    required this.rules,

    // Visibility

    required this.visibility,

    required this.closeSheet,

  });

  @override
  State<CampgroundSheet> createState() => _CampgroundSheetState();
}

class _CampgroundSheetState extends State<CampgroundSheet> {
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity! > 500) {
          // If dragged down fast enough, close the sheet
          widget.closeSheet();
        }
      },
      child: DraggableScrollableSheet(
        initialChildSize: 0.25,
        minChildSize: 0.15,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.white2,
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

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.name, style: AppTextStyles.header2),
                    //temp, add functionality to replace icon with .bookmark only when the campsite is saved
                    Icon(
                      Icons.bookmark_border,
                      color: AppColors.black
                    )
                  ],
                ),

                SizedBox(height: 10),

                Row(
                  children: 
                  [
                    Text("${widget.rating}", style: AppTextStyles.subtext1),

                    SizedBox(width: 10),

                    for (int i = 0; i < 5; i++)
                      if (widget.rating > i)
                        Icon(
                          Icons.star, 
                          color: AppColors.yellow,
                          size: 16
                        )
                      else
                        Icon(
                          Icons.star, 
                          color: AppColors.gray,
                          size: 16
                        )
                      ,

                    SizedBox(width: 10),

                    Text("(${widget.numOfPWRate})", style: AppTextStyles.subtext1)

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

                        // A box used for alignment

                        SizedBox(height: 4.5),
                        
                        Container(
                          color: const Color(0xFFD9D9D9),
                          child: SizedBox(height: 100, width: 130),
                        )
                      ],
                    )
                  ],
                ),

                // Basically a divider ----------------------------------

                Divider(),

                // Location and Contact

                Divider(),

                // Features / Amenities
                Text("Features", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                // Wrap(
                //   spacing: 10,
                //   runSpacing: 5,
                //   children: [
                //     _feature("Fire Pit", widget.firePit),
                //     _feature("Restroom", widget.restroom),
                //     _feature("Pets Allowed", widget.petsAllowed),
                //     _feature("Picnic Table", widget.picnicTable),
                //     _feature("Signal", widget.signal),
                //     _feature("Shower", widget.shower),
                //     _feature("Tap Water", widget.tapWater),
                //     _feature("First Aid", widget.firstAid),
                //     _feature("Security", widget.security),
                //     _feature("Biking Trails", widget.bikingTrails),
                //     _feature("Hiking Trails", widget.hikingTrails),
                //     _feature("Store", widget.store),
                //     _feature("Food Services", widget.foodServices),
                //     _feature("Lakes/River", widget.lakesOrRiver),
                //     _feature("Electricity", widget.electricity),
                //     _feature("WiFi", widget.wifi),
                //   ],
                // ),
              ],
            ),
          );
        },
      )
    );
  }

  Widget _buildQuickAction(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.darkGreen),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.body2.copyWith(color: AppColors.darkGreen),
        ),
      ],
    );
  }

  Widget _buildInfoTile(IconData icon, String text) {
    return ListTile(
      leading: Icon(icon, color: AppColors.darkGreen),
      title: Text(text, style: AppTextStyles.body1),
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }
}