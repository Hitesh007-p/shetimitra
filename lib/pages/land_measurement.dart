// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math' as math;
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:intl/intl.dart';

class LandMeasurementPage extends StatefulWidget {
  const LandMeasurementPage({super.key});

  @override
  LandMeasurementPageState createState() => LandMeasurementPageState();
}

class LandMeasurementPageState extends State<LandMeasurementPage> {
  late GoogleMapController _mapController;
  final List<LatLng> _polygonPoints = [];
  final Set<Polygon> _polygons = {};
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  LatLng? _currentLocation;
  bool _isLoading = true;
  bool _isSatelliteView = true;
  String _unitSystem = 'metric';
  double _totalDistance = 0;
  final ScreenshotController _screenshotController = ScreenshotController();
  final NumberFormat _formatter = NumberFormat.decimalPattern();
  static const double _maxSatelliteZoom = 20.0;
  static const double _minSatelliteZoom = 16.0;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw "स्थान सेवा अक्षम आहेत";

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw "Location permission denied";
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw "Location permission permanently denied";
      }

      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });
    } catch (e) {
      _showErrorSnackBar(e.toString());
      setState(() => _isLoading = false);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void _addPoint(LatLng point) {
    setState(() {
      _polygonPoints.add(point);
      _markers.add(Marker(
        markerId: MarkerId('marker_${_polygonPoints.length}'),
        position: point,
        draggable: true,
        consumeTapEvents: false,
        onDragEnd: (newPosition) =>
            _updatePoint(_polygonPoints.length - 1, newPosition),
      ));
      _updatePolygon();
      _updatePolyline();
    });
  }

  void _updatePoint(int index, LatLng newPosition) {
    if (index < 0 || index >= _polygonPoints.length) return;
    setState(() {
      _polygonPoints[index] = newPosition;
      _updatePolygon();
      _updatePolyline();
    });
  }

  void _updatePolygon() {
    _polygons.clear();
    if (_polygonPoints.length >= 3) {
      _polygons.add(Polygon(
        polygonId: const PolygonId("farm_area"),
        points: _polygonPoints,
        strokeWidth: 2,
        strokeColor: Colors.blue,
        fillColor: Colors.blue.withOpacity(0.3),
      ));
    }
  }

  void _updatePolyline() {
    _polylines.clear();
    if (_polygonPoints.length >= 2) {
      final polylinePoints = List<LatLng>.from(_polygonPoints)
        ..add(_polygonPoints.first);
      _polylines.add(Polyline(
        polylineId: const PolylineId("perimeter"),
        points: polylinePoints,
        color: Colors.red,
        width: 3,
      ));
      _calculatePerimeter();
    }
  }

  void _calculatePerimeter() {
    _totalDistance = 0;
    for (int i = 0; i < _polygonPoints.length; i++) {
      final j = (i + 1) % _polygonPoints.length;
      _totalDistance +=
          _calculateDistance(_polygonPoints[i], _polygonPoints[j]);
    }
  }

  double _calculateDistance(LatLng point1, LatLng point2) {
    const earthRadius = 6371000.0;
    final lat1 = _degreesToRadians(point1.latitude);
    final lon1 = _degreesToRadians(point1.longitude);
    final lat2 = _degreesToRadians(point2.latitude);
    final lon2 = _degreesToRadians(point2.longitude);
    final dLat = lat2 - lat1;
    final dLon = lon2 - lon1;
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1) *
            math.cos(lat2) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    return earthRadius * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  }

  double _degreesToRadians(double degrees) {
    return degrees * (math.pi / 180);
  }

  double _calculateArea(List<LatLng> points) {
    if (points.length < 3) return 0.0;
    double area = 0;
    for (int i = 0; i < points.length; i++) {
      final current = points[i];
      final next = points[(i + 1) % points.length];
      final avgLat = (current.latitude + next.latitude) / 2;
      final metersPerDegLat =
          111132.92 - 559.82 * math.cos(2 * avgLat * math.pi / 180);
      final metersPerDegLon = 111412.84 * math.cos(avgLat * math.pi / 180);
      area += (current.longitude *
              metersPerDegLon *
              next.latitude *
              metersPerDegLat) -
          (next.longitude *
              metersPerDegLon *
              current.latitude *
              metersPerDegLat);
    }
    return area.abs() / 2;
  }

  String _formatArea(double area) {
    if (_unitSystem == 'metric') {
      return area < 10000
          ? '${_formatter.format(area)} m²'
          : '${_formatter.format(area / 10000)} hectares';
    }
    final acres = area / 4046.86;
    return '${_formatter.format(acres)} acres';
  }

  String _formatDistance(double distance) {
    if (_unitSystem == 'metric') {
      return distance < 1000
          ? '${_formatter.format(distance)} m'
          : '${_formatter.format(distance / 1000)} km';
    }
    final feet = distance * 3.28084;
    return feet < 5280
        ? '${_formatter.format(feet)} ft'
        : '${_formatter.format(feet / 5280)} miles';
  }

  void _resetMeasurements() => setState(() {
        _polygonPoints.clear();
        _markers.clear();
        _polygons.clear();
        _polylines.clear();
        _totalDistance = 0;
      });

  Future<void> _shareResults() async {
    if (_polygonPoints.length < 3) {
      _showErrorSnackBar("शेअर करण्यापूर्वी पूर्ण क्षेत्र चिन्हांकित करा");
      return;
    }
    try {
      final image = await _screenshotController.capture();
      if (image == null) throw "स्क्रीनशॉट कॅप्चर करण्यात अयशस्वी";

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/measurement.png');
      await file.writeAsBytes(image);

      final area = _calculateArea(_polygonPoints);
      await Share.shareXFiles([XFile(file.path)],
          text: 'Land Measurement Results\n'
              'Area: ${_formatArea(area)}\n'
              'Perimeter: ${_formatDistance(_totalDistance)}');
    } catch (e) {
      _showErrorSnackBar("Sharing error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("जमीन मोजणी"),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareResults,
          ),
        ],
      ),
      body: _buildMapContent(),
      floatingActionButton: _buildSpeedDial(),
    );
  }

  Widget _buildMapContent() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_currentLocation == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("स्थान अनुपलब्ध"),
            ElevatedButton(
              onPressed: _getCurrentLocation,
              child: const Text("पुन्हा प्रयत्न करा"),
            ),
          ],
        ),
      );
    }

    return Screenshot(
      controller: _screenshotController,
      child: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentLocation!,
              zoom: _isSatelliteView ? _minSatelliteZoom : 16,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
              if (_isSatelliteView) {
                _mapController.setMapType(MapType.hybrid);
                _mapController
                    .moveCamera(CameraUpdate.zoomTo(_minSatelliteZoom));
              }
            },
            polygons: _polygons,
            markers: _markers,
            polylines: _polylines,
            onTap: _addPoint,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            mapType: _isSatelliteView ? MapType.hybrid : MapType.normal,
            minMaxZoomPreference: MinMaxZoomPreference(
                _isSatelliteView ? _minSatelliteZoom : 10.0,
                _isSatelliteView ? _maxSatelliteZoom : 20.0),
            tiltGesturesEnabled: _isSatelliteView,
            rotateGesturesEnabled: _isSatelliteView,
          ),
          _buildInfoCard(),
          Positioned(
            right: 16,
            bottom: 100,
            child: Column(
              children: [
                FloatingActionButton(
                  mini: true,
                  heroTag: 'zoom_in',
                  onPressed: () =>
                      _mapController.animateCamera(CameraUpdate.zoomIn()),
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  mini: true,
                  heroTag: 'zoom_out',
                  onPressed: () =>
                      _mapController.animateCamera(CameraUpdate.zoomOut()),
                  child: const Icon(Icons.remove),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Positioned(
      top: 16,
      left: 16,
      right: 16,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("बिंदू: ${_polygonPoints.length}"),
                  TextButton.icon(
                    icon: Icon(_unitSystem == 'metric'
                        ? Icons.straighten
                        : Icons.square_foot),
                    label:
                        Text(_unitSystem == 'metric' ? 'मेट्रिक' : 'इंपीरियल'),
                    onPressed: () => setState(() => _unitSystem =
                        _unitSystem == 'metric' ? 'imperial' : 'metric'),
                  ),
                ],
              ),
              if (_polygonPoints.length >= 3) ...[
                const SizedBox(height: 8),
                Text(
                    "क्षेत्रफळ: ${_formatArea(_calculateArea(_polygonPoints))}"),
                Text("परिमिती: ${_formatDistance(_totalDistance)}"),
              ],
            ],
          ),
        ),
      ),
    );
  }

  SpeedDial _buildSpeedDial() {
    return SpeedDial(
      icon: Icons.menu,
      activeIcon: Icons.close,
      children: [
        _buildSpeedDialChild(
          icon: Icons.map,
          label: _isSatelliteView ? 'नकाशा दृश्य' : 'सेटेलाइट',
          onTap: () => _toggleMapType(),
        ),
        _buildSpeedDialChild(
          icon: Icons.undo,
          label: 'पूर्ववत करा',
          onTap: () => setState(() {
            if (_polygonPoints.isNotEmpty) {
              _polygonPoints.removeLast();
              _markers.removeWhere((m) =>
                  m.markerId.value == 'marker_${_polygonPoints.length + 1}');
              _updatePolygon();
              _updatePolyline();
            }
          }),
        ),
        _buildSpeedDialChild(
          icon: Icons.delete,
          label: 'साफ करा',
          onTap: () => showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("सर्व मोजमापे काढून टाकायची?"),
              actions: [
                TextButton(
                  onPressed: Navigator.of(context).pop,
                  child: const Text("रद्द करा"),
                ),
                TextButton(
                  onPressed: () {
                    _resetMeasurements();
                    Navigator.of(context).pop();
                  },
                  child: const Text("साफ करा"),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  SpeedDialChild _buildSpeedDialChild({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return SpeedDialChild(
      child: Icon(icon),
      label: label,
      onTap: onTap,
    );
  }

  void _toggleMapType() {
    setState(() {
      _isSatelliteView = !_isSatelliteView;
      _mapController
          .setMapType(_isSatelliteView ? MapType.hybrid : MapType.normal);
      if (_isSatelliteView) {
        _mapController.moveCamera(CameraUpdate.zoomTo(_minSatelliteZoom));
      }
    });
  }
}

extension on GoogleMapController {
  void setMapType(MapType mapType) {}
}
