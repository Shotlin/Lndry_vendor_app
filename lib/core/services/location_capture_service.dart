import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';

/// Base type for failures during [LocationCaptureService.captureCurrentLocation].
sealed class LocationCaptureException implements Exception {
  const LocationCaptureException(this.message);
  final String message;

  @override
  String toString() => message;
}

class LocationServiceOffException extends LocationCaptureException {
  const LocationServiceOffException()
      : super('Please enable location services to continue.');
}

class LocationPermissionDeniedException extends LocationCaptureException {
  const LocationPermissionDeniedException()
      : super('Location permission is required to detect your shop address.');
}

class LocationPermissionDeniedForeverException extends LocationCaptureException {
  const LocationPermissionDeniedForeverException()
      : super('Location permission is permanently denied. Please enable it '
            'from app settings.');
}

class ReverseGeocodeFailedException extends LocationCaptureException {
  const ReverseGeocodeFailedException()
      : super('Could not determine your address from this location.');
}

/// A GPS position resolved into a usable, human-readable address.
class CapturedLocation {
  const CapturedLocation({
    required this.latitude,
    required this.longitude,
    required this.line1,
    required this.formattedAddress,
    required this.city,
    required this.state,
    required this.pincode,
  });

  final double latitude;
  final double longitude;
  final String line1;
  final String formattedAddress;
  final String city;
  final String state;
  final String pincode;

  static final RegExp _pincodeRegExp = RegExp(r'^[1-9][0-9]{5}$');

  bool get isUsable => line1.isNotEmpty && _pincodeRegExp.hasMatch(pincode);
}

/// Detects the device's current GPS location and resolves it to a usable
/// address via reverse geocoding. Ported from `Lndry_app`'s
/// `LocationCaptureService` — same proven chain, no dependency on a
/// rendered map (the Maps SDK API key is unconfigured in this dev
/// environment), used by the vendor onboarding wizard's Shop Location step.
class LocationCaptureService {
  const LocationCaptureService();

  Future<CapturedLocation> captureCurrentLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationServiceOffException();
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      throw const LocationPermissionDeniedForeverException();
    }
    if (permission == LocationPermission.denied) {
      throw const LocationPermissionDeniedException();
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    List<geocoding.Placemark> places;
    try {
      places = await geocoding.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
    } catch (_) {
      throw const ReverseGeocodeFailedException();
    }
    if (places.isEmpty) {
      throw const ReverseGeocodeFailedException();
    }

    final place = places.first;

    final city = _firstNonEmpty([
      place.locality,
      place.subAdministrativeArea,
      place.administrativeArea,
      place.subLocality,
    ]);
    final state = _firstNonEmpty([
      place.administrativeArea,
      place.subAdministrativeArea,
      place.country,
    ]);
    final line1 = _firstNonEmpty([
      place.name,
      place.street,
      place.subLocality,
    ]);
    final formattedAddress = [
      place.name,
      place.street,
      place.subLocality,
      place.locality,
      place.administrativeArea,
    ].where((part) => part != null && part.trim().isNotEmpty).join(', ');
    final pincode = place.postalCode?.trim() ?? '';

    final captured = CapturedLocation(
      latitude: position.latitude,
      longitude: position.longitude,
      line1: line1,
      formattedAddress: formattedAddress,
      city: city,
      state: state,
      pincode: pincode,
    );

    if (!captured.isUsable) {
      throw const ReverseGeocodeFailedException();
    }

    return captured;
  }

  static String _firstNonEmpty(List<String?> candidates) {
    for (final c in candidates) {
      if (c != null && c.trim().isNotEmpty) return c.trim();
    }
    return '';
  }
}

final locationCaptureServiceProvider = Provider<LocationCaptureService>(
  (ref) => const LocationCaptureService(),
);
