// bell, safari, yurt, dome, canvas-a-frame tent

class Units {
    
  final bool groundSleeping;

  Units({required this.groundSleeping});

  int guests = 3;

  int sleepingPad = 3;

  int bed = 3;

  int pillows = 3;

  int blanket = 3;

  int restroom = 1;

}

class CampgroundData {
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

  CampgroundData({
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
  });

}
