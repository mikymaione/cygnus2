/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cygnus2/utility/commons.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:location/location.dart';
import 'package:nominatim_geocoding/nominatim_geocoding.dart';

class LocationService {
  //
  final _location = Location();

  Future<GeoFirePoint> getCurrentLocation() async {
    try {
      return await _getCurrentLocationGeoFirePoint();
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<GeoFirePoint> _getCurrentLocationGeoFirePoint() async {
    final l = await _getCurrentLocation();

    if (l.latitude != null && l.longitude != null) {
      return GeoFirePoint(GeoPoint(
        l.latitude!,
        l.longitude!,
      ));
    } else {
      throw Exception('Non posso accedere alla posizione');
    }
  }

  Future<LocationData> _getCurrentLocation() async {
    final enabled = await _location.serviceEnabled();

    if (enabled) {
      Commons.printIfInDebug('GPS service is enabled');
    } else {
      final serviceOk = await _location.requestService();

      if (serviceOk) {
        Commons.printIfInDebug('GPS service has been enabled');

        final permission = await _location.requestPermission();

        switch (permission) {
          case PermissionStatus.granted:
          case PermissionStatus.grantedLimited:
            break;

          case PermissionStatus.denied:
          case PermissionStatus.deniedForever:
            throw Exception('Hai rifiutato di utlizzare il servizio GPS');
        }
      } else {
        throw Exception('Il servizio GPS risulta disabilitato');
      }
    }

    return await _location.getLocation();
  }

  Future<Address?> addressByGeoPoint(GeoPoint? p) async {
    if (p != null) {
      final coordinate = Coordinate(latitude: p.latitude, longitude: p.longitude);

      try {
        final geocoding = await NominatimGeocoding.to.reverseGeoCoding(coordinate);

        return geocoding.address;
      } catch (e) {
        Commons.printIfInDebug(e);
      }
    }

    return null;
  }
}
