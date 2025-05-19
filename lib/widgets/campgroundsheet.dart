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

class _CampgroundSheetState extends State<CampgroundSheet> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildImageGrid() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 2),
        Expanded(
          child: Column(
            children: [
              Container(
                height: 99,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Container(
                height: 99,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAmenityItem(IconData icon, String label, bool isAvailable) {
    return Opacity(
      opacity: isAvailable ? 1.0 : 0.5,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.body2,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAmenitiesGrid() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _buildAmenityItem(Icons.outdoor_grill, 'Grill', widget.outdoorGrill),
        _buildAmenityItem(Icons.local_fire_department, 'Fire Pit', widget.firePitOrBonfire),
        _buildAmenityItem(Icons.cabin, 'Tent Rental', widget.tentRental),
        _buildAmenityItem(Icons.beach_access, 'Hammock', widget.hammockRental),
        _buildAmenityItem(Icons.shower, 'Shower', widget.soap),
        _buildAmenityItem(Icons.power, 'Power', widget.powerSource),
        _buildAmenityItem(Icons.water_drop, 'Water', widget.drinkingOrWashingWater),
        _buildAmenityItem(Icons.pets, 'Pets Allowed', widget.petsAllowed),
        _buildAmenityItem(Icons.local_drink, 'Drinks', widget.drinksAllowed),
        _buildAmenityItem(Icons.medical_services, 'First Aid', widget.firstAidKit),
        _buildAmenityItem(Icons.security, 'Security', widget.securityCameras),
        _buildAmenityItem(Icons.accessible, 'PWD Friendly', widget.pwdFriendly),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.25,
      minChildSize: 0.15,
      maxChildSize: 0.95,
      snap: true,
      snapSizes: const [0.25, 0.5, 0.95],
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Draggable header area
              GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (scrollController.position.pixels <= 0) {
                    scrollController.jumpTo(0);
                    scrollController.position.moveTo(
                      scrollController.position.pixels - details.delta.dy,
                    );
                  }
                },
                onVerticalDragEnd: (details) {
                  if (scrollController.position.pixels <= 0 && 
                      details.primaryVelocity! > 300) {
                    widget.closeSheet();
                  }
                },
                child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: [
                      // Drag handle
                      Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            // Title and bookmark
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.name,
                                    style: AppTextStyles.header2,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.bookmark_border),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                            // Rating
                            Row(
                              children: [
                                Text(
                                  widget.rating.toString(),
                                  style: AppTextStyles.subtext1,
                                ),
                                const SizedBox(width: 8),
                                Row(
                                  children: List.generate(
                                    5,
                                    (index) => Icon(
                                      Icons.star,
                                      size: 16,
                                      color: index < widget.rating
                                          ? AppColors.yellow
                                          : AppColors.gray,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "(${widget.numOfPWRate})",
                                  style: AppTextStyles.subtext1,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Scrollable content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    const SizedBox(height: 16),
                    // Quick actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildQuickAction(Icons.directions, 'Directions'),
                        _buildQuickAction(Icons.save, 'Save'),
                        _buildQuickAction(Icons.share, 'Share'),
                        _buildQuickAction(Icons.photo_camera, 'Add photo'),
                      ],
                    ),
                    const Divider(height: 32),

                    // Images
                    _buildImageGrid(),
                    const SizedBox(height: 24),

                    // Location and contact info
                    _buildInfoTile(Icons.location_on, widget.address),
                    if (widget.phoneNumber.isNotEmpty)
                      _buildInfoTile(Icons.phone, widget.phoneNumber),
                    if (widget.socialMediaLink.isNotEmpty)
                      _buildInfoTile(Icons.link, widget.socialMediaLink),
                    const Divider(height: 32),

                    // Description
                    Text('About', style: AppTextStyles.header2),
                    const SizedBox(height: 8),
                    Text(
                      widget.description,
                      style: AppTextStyles.body1,
                    ),
                    const SizedBox(height: 24),

                    // Natural features
                    Text('Natural Features', style: AppTextStyles.header2),
                    const SizedBox(height: 8),
                    Text(
                      widget.naturalFeature,
                      style: AppTextStyles.body1,
                    ),
                    const SizedBox(height: 24),

                    // Amenities
                    Text('Amenities', style: AppTextStyles.header2),
                    const SizedBox(height: 16),
                    _buildAmenitiesGrid(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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