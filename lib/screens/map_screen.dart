import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/historical_site.dart';
import '../services/historical_sites_data.dart';
import '../extensions/string_extensions.dart';
import '../providers/language_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  Set<Marker> _markers = {};
  List<HistoricalSite> _allSites = [];
  List<HistoricalSite> _filteredSites = [];
  String _selectedRegion = 'all_regions';
  String _selectedEra = 'all_eras';
  MapType _currentMapType = MapType.normal;
  bool _isLoading = true;
  bool _showFilters = false;
  final TextEditingController _searchController = TextEditingController();

  // Algeria center coordinates
  static const LatLng _algeriaCenter = LatLng(28.0339, 1.6596);

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _initializeMap() async {
    await _loadHistoricalSites();
    await _getCurrentLocation();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadHistoricalSites() async {
    try {
      _allSites = HistoricalSitesData.getAllSites();
      _filteredSites = List.from(_allSites);
      // Don't create markers here, wait for the widget to be built
    } catch (e) {
      debugPrint('Error loading historical sites: $e');
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final permission = await Permission.location.request();
      if (permission.isGranted) {
        _currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  void _createMarkers() {
    if (!mounted) return;

    try {
      final languageCode = Provider.of<LanguageProvider>(context, listen: false).locale.languageCode;

      _markers = _filteredSites.map((site) {
        return Marker(
          markerId: MarkerId(site.id),
          position: LatLng(site.latitude, site.longitude),
          icon: _getMarkerIcon(site.type),
          infoWindow: InfoWindow(
            title: site.getName(languageCode),
            snippet: site.getDescription(languageCode).length > 100
                ? '${site.getDescription(languageCode).substring(0, 100)}...'
                : site.getDescription(languageCode),
            onTap: () => _showSiteDetails(site),
          ),
          onTap: () => _onMarkerTapped(site),
        );
      }).toSet();
    } catch (e) {
      debugPrint('Error creating markers: $e');
      _markers = {};
    }
  }

  BitmapDescriptor _getMarkerIcon(String siteType) {
    switch (siteType) {
      case SiteType.fortress:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      case SiteType.mosque:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      case SiteType.archaeological:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
      case SiteType.museum:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
      case SiteType.monument:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta);
      default:
        return BitmapDescriptor.defaultMarker;
    }
  }

  void _onMarkerTapped(HistoricalSite site) {
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(site.latitude, site.longitude),
        15.0,
      ),
    );
  }

  void _showSiteDetails(HistoricalSite site) {
    final languageCode = Provider.of<LanguageProvider>(context, listen: false).locale.languageCode;
    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Site name
                    Text(
                      site.getName(languageCode),
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Site type and era
                    Row(
                      children: [
                        Chip(
                          label: Text(site.type),
                          backgroundColor: colorScheme.primaryContainer,
                        ),
                        const SizedBox(width: 8),
                        Chip(
                          label: Text(site.era),
                          backgroundColor: colorScheme.secondaryContainer,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Description
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          site.getDescription(languageCode),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _getDirections(site),
                            icon: const Icon(Icons.directions),
                            label: Text('get_directions'.tr(context)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close),
                            label: Text('close'.tr(context)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getDirections(HistoricalSite site) async {
    final url = 'https://www.google.com/maps/dir/?api=1&destination=${site.latitude},${site.longitude}';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _filterSites() {
    final languageCode = Provider.of<LanguageProvider>(context, listen: false).locale.languageCode;

    setState(() {
      _filteredSites = _allSites.where((site) {
        bool matchesRegion = _selectedRegion == 'all_regions' || site.region == _selectedRegion;
        bool matchesEra = _selectedEra == 'all_eras' || site.era == _selectedEra;
        bool matchesSearch = _searchController.text.isEmpty ||
            site.getName(languageCode).toLowerCase().contains(_searchController.text.toLowerCase()) ||
            site.getDescription(languageCode).toLowerCase().contains(_searchController.text.toLowerCase());

        return matchesRegion && matchesEra && matchesSearch;
      }).toList();

      _createMarkers();
    });
  }

  void _goToMyLocation() async {
    if (_currentPosition != null && _mapController != null) {
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          15.0,
        ),
      );
    } else {
      await _getCurrentLocation();
      if (_currentPosition != null && _mapController != null) {
        await _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            15.0,
          ),
        );
      }
    }
  }

  void _changeMapType() {
    setState(() {
      switch (_currentMapType) {
        case MapType.normal:
          _currentMapType = MapType.satellite;
          break;
        case MapType.satellite:
          _currentMapType = MapType.terrain;
          break;
        case MapType.terrain:
          _currentMapType = MapType.normal;
          break;
        default:
          _currentMapType = MapType.normal;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'interactive_map'.tr(context),
          style: GoogleFonts.playfairDisplay(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
            icon: Icon(
              _showFilters ? Icons.filter_list_off : Icons.filter_list,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: colorScheme.primary),
                  const SizedBox(height: 16),
                  Text(
                    'loading_map'.tr(context),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                // Google Map
                GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                    // Create markers after map is ready
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _createMarkers();
                      if (mounted) {
                        setState(() {});
                      }
                    });
                  },
                  initialCameraPosition: const CameraPosition(
                    target: _algeriaCenter,
                    zoom: 6.0,
                  ),
                  markers: _markers,
                  mapType: _currentMapType,
                  myLocationEnabled: false, // Disable to avoid permission issues
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                ),

                // Search bar
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) => _filterSites(),
                      decoration: InputDecoration(
                        hintText: 'search_sites'.tr(context),
                        prefixIcon: Icon(Icons.search, color: colorScheme.primary),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                ),

                // Filter panel
                if (_showFilters)
                  Positioned(
                    top: 80,
                    left: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'filter_by_region'.tr(context),
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 8),
                          DropdownButton<String>(
                            value: _selectedRegion,
                            isExpanded: true,
                            onChanged: (value) {
                              setState(() {
                                _selectedRegion = value!;
                              });
                              _filterSites();
                            },
                            items: [
                              DropdownMenuItem(
                                value: 'all_regions',
                                child: Text('all_regions'.tr(context)),
                              ),
                              ...HistoricalSitesData.getRegions().map((region) {
                                return DropdownMenuItem(
                                  value: region,
                                  child: Text(region),
                                );
                              }),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'filter_by_era'.tr(context),
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 8),
                          DropdownButton<String>(
                            value: _selectedEra,
                            isExpanded: true,
                            onChanged: (value) {
                              setState(() {
                                _selectedEra = value!;
                              });
                              _filterSites();
                            },
                            items: [
                              DropdownMenuItem(
                                value: 'all_eras',
                                child: Text('all_eras'.tr(context)),
                              ),
                              ...HistoricalSitesData.getEras().map((era) {
                                return DropdownMenuItem(
                                  value: era,
                                  child: Text(era),
                                );
                              }),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                // Floating action buttons
                Positioned(
                  bottom: 100,
                  right: 16,
                  child: Column(
                    children: [
                      FloatingActionButton(
                        heroTag: "location",
                        onPressed: _goToMyLocation,
                        backgroundColor: colorScheme.primaryContainer,
                        child: Icon(
                          Icons.my_location,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      FloatingActionButton(
                        heroTag: "map_type",
                        onPressed: _changeMapType,
                        backgroundColor: colorScheme.secondaryContainer,
                        child: Icon(
                          _getMapTypeIcon(),
                          color: colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Sites count indicator
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_filteredSites.length} ${'sites'.tr(context)}',
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  IconData _getMapTypeIcon() {
    switch (_currentMapType) {
      case MapType.normal:
        return Icons.map;
      case MapType.satellite:
        return Icons.satellite_alt;
      case MapType.terrain:
        return Icons.terrain;
      default:
        return Icons.map;
    }
  }
}