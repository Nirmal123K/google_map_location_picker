import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:collection/collection.dart';

/// The result returned after completing location selection.
class LocationResult {
  /// The human readable name of the location. This is primarily the
  /// name of the road. But in cases where the place was selected from Nearby
  /// places list, we use the <b>name</b> provided on the list item.
  String address; // or road

  /// Google Maps place ID
  String placeId;

  /// Latitude/Longitude of the selected location.
  LatLng latLng;

  LocationResult({this.latLng, this.address, this.placeId});

  @override
  String toString() {
    return 'LocationResult{address: $address, latLng: $latLng, placeId: $placeId}';
  }
}

/// The result returned after completing location selection.
class NewLocationResult {
  final String formatedAddress;

  final List<AddressComponent> addressComponents;

  /// Google Maps place ID
  final String placeId;

  /// Latitude/Longitude of the selected location.
  final LatLng latLng;

  NewLocationResult({
    @required this.formatedAddress,
    this.addressComponents = const [],
    @required this.placeId,
    @required this.latLng,
  });

  String get country {
    return this
        .addressComponents
        .firstWhereOrNull(
            (address) => address.types.any((type) => type == 'country'))
        ?.longName;
  }

  String get state {
    return this
        .addressComponents
        .firstWhereOrNull((address) =>
            address.types.any((type) => type == 'administrative_area_level_1'))
        ?.longName;
  }

  String get district {
    return this
        .addressComponents
        .firstWhereOrNull((address) =>
            address.types.any((type) => type == 'administrative_area_level_2'))
        ?.longName;
  }

  String get city {
    return this
        .addressComponents
        .firstWhereOrNull(
            (address) => address.types.any((type) => type == 'locality'))
        ?.longName;
  }

  String get postalCode {
    return this
        .addressComponents
        .firstWhereOrNull(
            (address) => address.types.any((type) => type == 'postal_code'))
        ?.longName;
  }

  LocationResult toLocationResult() {
    return LocationResult(
      address: this.formatedAddress,
      latLng: this.latLng,
      placeId: this.placeId,
    );
  }
}

class AddressComponent {
  final String longName;
  final String shortName;
  final List<String> types;

  AddressComponent({
    @required this.longName,
    @required this.shortName,
    @required this.types,
  });

  AddressComponent copyWith({
    String longName,
    String shortName,
    List<String> types,
  }) {
    return AddressComponent(
      longName: longName ?? this.longName,
      shortName: shortName ?? this.shortName,
      types: types ?? this.types,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'long_name': longName,
      'short_name': shortName,
      'types': types,
    };
  }

  factory AddressComponent.fromMap(Map<String, dynamic> map) {
    return AddressComponent(
      longName: map['long_name'],
      shortName: map['short_name'],
      types: List<String>.from(map['types']),
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressComponent.fromJson(String source) =>
      AddressComponent.fromMap(json.decode(source));

  @override
  String toString() =>
      'AddressComponent(longName: $longName, shortName: $shortName, types: $types)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AddressComponent &&
        other.longName == longName &&
        other.shortName == shortName &&
        listEquals(other.types, types);
  }

  @override
  int get hashCode => longName.hashCode ^ shortName.hashCode ^ types.hashCode;
}
