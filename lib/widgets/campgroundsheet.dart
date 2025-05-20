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
import 'package:campph/services/bookmark_service.dart';

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
  final bool isBookmarked;
  final String campId;

  const CampgroundSheet({
    super.key,
    required this.name,
    required this.isPublic,
    required this.rating,
    required this.numOfPWRate,
    required this.address,
    required this.socialMediaLink,
    required this.phoneNumber,
    required this.description,
    required this.naturalFeature,
    required this.imageUrls,
    required this.isGlampingSite,
    required this.typeOfShelter,
    required this.listOfUnitsAndAmenities,
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
    required this.rules,
    required this.visibility,
    required this.closeSheet,
    required this.isBookmarked,
    required this.campId,
  });

  @override
  State<CampgroundSheet> createState() => _CampgroundSheetState();
}

class _CampgroundSheetState extends State<CampgroundSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isDescriptionExpanded = false;
  // Sheet controller to manage snap points
  DraggableScrollableController? _sheetController;
  // Current snap position
  double _currentSnap = 0.25; // Start at peek view
  late bool _isBookmarked;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _sheetController = DraggableScrollableController();
    _isBookmarked = widget.isBookmarked;
  }

  Future<void> _toggleBookmark() async {
    await BookmarkService().toggleBookmark(widget.campId);
    setState(() {
      _isBookmarked = !_isBookmarked;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _sheetController?.dispose();
    super.dispose();
  }

  void _snapTo(double snap) {
    _sheetController?.animateTo(
      snap,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() => _currentSnap = snap);
  }

  Widget _buildImageGrid() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Row(
        children: [
          // Large image on the left (2/3 width)
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.only(right: 2),
              color: Colors.grey[300],
              child:
                  widget.imageUrls.isNotEmpty
                      ? Image.network(widget.imageUrls[0], fit: BoxFit.cover)
                      : const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),
            ),
          ),
          // Two smaller images on the right (1/3 width)
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 2),
                    color: Colors.grey[300],
                    child:
                        widget.imageUrls.length > 1
                            ? Image.network(
                              widget.imageUrls[1],
                              fit: BoxFit.cover,
                            )
                            : const Center(
                              child: Icon(
                                Icons.image_not_supported,
                                size: 30,
                                color: Colors.grey,
                              ),
                            ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.grey[300],
                    child:
                        widget.imageUrls.length > 2
                            ? Image.network(
                              widget.imageUrls[2],
                              fit: BoxFit.cover,
                            )
                            : const Center(
                              child: Icon(
                                Icons.image_not_supported,
                                size: 30,
                                color: Colors.grey,
                              ),
                            ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenityTile(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 24, color: AppColors.black),
        const SizedBox(height: 4),
        Text(label, style: AppTextStyles.body2, textAlign: TextAlign.center),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity! > 500) {
          widget.closeSheet();
        } else {
          // Determine which snap point to go to based on velocity and current position
          if (_currentSnap < 0.6) {
            if (details.primaryVelocity! > 0) {
              _snapTo(0.25); // Snap to peek
            } else {
              _snapTo(0.6); // Snap to half
            }
          } else {
            if (details.primaryVelocity! > 0) {
              _snapTo(0.6); // Snap to half
            } else {
              _snapTo(0.95); // Snap to full
            }
          }
        }
      },
      child: DraggableScrollableSheet(
        initialChildSize: 0.25,
        minChildSize: 0.15,
        maxChildSize: 0.95,
        controller: _sheetController,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Peek view (always visible)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.name,
                              style: AppTextStyles.header2,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              _isBookmarked
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                              color: _isBookmarked ? AppColors.darkGreen : null,
                            ),
                            onPressed: _toggleBookmark,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "${widget.rating}",
                            style: AppTextStyles.subtext1,
                          ),
                          const SizedBox(width: 4),
                          ...List.generate(
                            5,
                            (i) => Icon(
                              Icons.star,
                              size: 16,
                              color:
                                  i < widget.rating
                                      ? AppColors.yellow
                                      : AppColors.gray,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "(${widget.numOfPWRate})",
                            style: AppTextStyles.subtext1,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Expanded content (visible when sheet is dragged up)
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: EdgeInsets.zero,
                    children: [
                      _buildImageGrid(),
                      TabBar(
                        controller: _tabController,
                        labelColor: AppColors.black,
                        unselectedLabelColor: AppColors.gray,
                        tabs: const [Tab(text: 'ABOUT'), Tab(text: 'REVIEWS')],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            // ABOUT tab
                            ListView(
                              padding: const EdgeInsets.all(16),
                              children: [
                                // Site Description
                                const Text(
                                  'Site Description',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.description,
                                      maxLines:
                                          _isDescriptionExpanded ? null : 3,
                                      overflow:
                                          _isDescriptionExpanded
                                              ? null
                                              : TextOverflow.ellipsis,
                                      style: AppTextStyles.body1,
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          _isDescriptionExpanded =
                                              !_isDescriptionExpanded;
                                        });
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            _isDescriptionExpanded
                                                ? 'Less'
                                                : 'More',
                                            style: TextStyle(
                                              color: AppColors.darkGreen,
                                            ),
                                          ),
                                          Icon(
                                            _isDescriptionExpanded
                                                ? Icons.keyboard_arrow_up
                                                : Icons.keyboard_arrow_down,
                                            color: AppColors.darkGreen,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 32),

                                // Contact & Location
                                const Text(
                                  'Contact & Location',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ListTile(
                                  leading: const Icon(Icons.location_on),
                                  title: Text(widget.address),
                                  contentPadding: EdgeInsets.zero,
                                ),
                                if (widget.phoneNumber.isNotEmpty)
                                  ListTile(
                                    leading: const Icon(Icons.phone),
                                    title: Text(widget.phoneNumber),
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                if (widget.socialMediaLink.isNotEmpty)
                                  ListTile(
                                    leading: const Icon(Icons.chat),
                                    title: const Text('Contact via WhatsApp'),
                                    contentPadding: EdgeInsets.zero,
                                    onTap: () {},
                                  ),
                                const Divider(height: 32),

                                // Amenities
                                const Text(
                                  'Amenities',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                GridView.count(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  crossAxisCount: 4,
                                  mainAxisSpacing: 16,
                                  crossAxisSpacing: 16,
                                  children: [
                                    if (widget.drinksAllowed)
                                      _buildAmenityTile(
                                        Icons.local_bar,
                                        'Camping Fire\nallowed',
                                      ),
                                    if (widget.petsAllowed)
                                      _buildAmenityTile(
                                        Icons.pets,
                                        'Pets Allowed',
                                      ),
                                    _buildAmenityTile(
                                      Icons.table_restaurant,
                                      'Picnic Table',
                                    ),
                                    _buildAmenityTile(Icons.waves, 'Fishing'),
                                    if (widget.powerSource)
                                      _buildAmenityTile(Icons.power, 'Signal'),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                OutlinedButton(
                                  onPressed: () {},
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                      color: AppColors.darkGreen,
                                    ),
                                  ),
                                  child: Text(
                                    'Show all amenities',
                                    style: TextStyle(
                                      color: AppColors.darkGreen,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // REVIEWS tab
                            const Center(child: Text('Reviews coming soon')),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
