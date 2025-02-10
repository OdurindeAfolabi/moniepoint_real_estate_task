import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:moniepoint_task/presentation/app.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key, this.darkMapStyle});
  final String? darkMapStyle;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with SingleTickerProviderStateMixin {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  final MapController _mapController = MapController();
  late AnimationController _animationController;
  bool _isExpanded = true;
  String? _darkMapStyle;

  final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(6.4579452785805325, 3.4712005553582084),
    zoom: 18,
  );

  @override
  void initState() {
    super.initState();
    // _loadMapStyles();
    _animationController = AnimationController(
      vsync: this,
      duration: 700.ms,
      reverseDuration: 500.ms,
    );
    _animationController.addStatusListener((listener) {
      if (listener == AnimationStatus.dismissed) {
        _setExpandedFalse();
      } else {
        _setExpandedTrue();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Future _loadMapStyles() async {
  //   _darkMapStyle = await rootBundle.loadString(ImagesPaths.darkModeMap);
  //   setState(() {});
  // }

  void _setExpandedFalse() {
    setState(() {
      _isExpanded = false;
    });
  }

  void _setExpandedTrue() {
    setState(() {
      _isExpanded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // FlutterMap
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              onMapReady: () {
                WidgetsBinding.instance.addPostFrameCallback((_) {});
              },
              onTap: (pos, latLng) {},
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                userAgentPackageName: 'com.jvec.app',
              ),
            ],
          ),

          // Extended FAB Button
          const ExtendedRightFabBTN(),

          // Left icons in column
          Positioned(
            left: 30,
            bottom: context.sizeHeight(0.11),
            child: OverlayDialog(animationController: _animationController),
          ),

          // Search Bar
          const SearchBarWidget(),

          // Markers
          ListOfMarkersWidget(isExpanded: _isExpanded),
        ],
      ),
    );
  }
}
