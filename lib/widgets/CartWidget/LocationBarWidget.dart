import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../utils/colors.dart';

class LocationBarWidget extends StatefulWidget {
  const LocationBarWidget({Key? key}) : super(key: key);

  @override
  _LocationBarWidgetState createState() => _LocationBarWidgetState();
}

class _LocationBarWidgetState extends State<LocationBarWidget> {
  String userLocation = '';

  @override
  void initState() {
    super.initState();
    getCurrentLocationApp();
  }

  Future<void> getCurrentLocationApp() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Location permissions denied.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("Location permissions are permanently denied.");
      return;
    }

    // Get the current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      userLocation = "${position.latitude}, ${position.longitude}";
    });
    print("Current location: $userLocation");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: successColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.location_on,
              color: successColor,
              size: 24,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Deliver to",
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: "Urbanist-Medium",
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  userLocation.isNotEmpty
                      ? userLocation
                      : "Fetching location...",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: "Urbanist-Bold",
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey[600]),
        ],
      ),
    );
  }
}
