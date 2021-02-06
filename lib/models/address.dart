import 'dart:io';

import 'package:flutter/foundation.dart';

class PlaceLocation {
  final String latitude;
  final String longitude;
  final String address;

  const PlaceLocation({
    @required this.latitude,
    @required this.longitude,
    this.address,
  });
  factory PlaceLocation.fromMap(Map data) {
    return PlaceLocation(
        latitude: data['latitude'] ?? '',
      longitude: data['longitude'] ?? '',
      address: data['address'] ?? '',
    );
  }
}


