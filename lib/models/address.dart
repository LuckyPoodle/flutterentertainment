import 'dart:io';

import 'package:flutter/foundation.dart';

class PlaceLocation {
  final String latitude;
  final String longitude;
  final String address;

  const PlaceLocation({
    this.latitude,
    this.longitude,
    this.address,
  });
  factory PlaceLocation.fromMap(Map data) {
    return PlaceLocation(
        latitude: data['latitude'] ?? '',
      longitude: data['longitude'] ?? '',
      address: data['address'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }

}


