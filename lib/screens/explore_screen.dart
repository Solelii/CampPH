import 'package:camph/widgets/campgroundsheet.dart';
import 'package:flutter/material.dart';


class SearchBarApp extends StatefulWidget {
  const SearchBarApp({super.key});

  @override
  State<SearchBarApp> createState() => _SearchBarAppState();
}

class _SearchBarAppState extends State<SearchBarApp> {
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = ThemeData(useMaterial3: true);
    return MaterialApp(
      theme: themeData,
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
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
                leading: const Icon(Icons.search),
                trailing: <Widget>[
                  Tooltip(
                    message: 'Filter',
                    child: IconButton(
                      onPressed: () {
                        debugPrint('filter button pressed');
                      },
                      icon: const Icon(Icons.filter_alt_outlined),
                      selectedIcon: const Icon(Icons.filter_alt),
                    ),
                  ),
                ],
              );
            },
            suggestionsBuilder: (
              BuildContext context,
              SearchController controller,
            ) {
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
    );
  }
}

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
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(0, 0, 0, 0)
              ),
            ),
          ),
          SearchBarApp(),
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
          if(_isSheetOpen)
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
