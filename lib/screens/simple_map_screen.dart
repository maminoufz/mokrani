import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/historical_site.dart';
import '../services/historical_sites_data.dart';
import '../extensions/string_extensions.dart';
import '../providers/language_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SimpleMapScreen extends StatefulWidget {
  const SimpleMapScreen({super.key});

  @override
  State<SimpleMapScreen> createState() => _SimpleMapScreenState();
}

class _SimpleMapScreenState extends State<SimpleMapScreen> {
  List<HistoricalSite> _allSites = [];
  List<HistoricalSite> _filteredSites = [];
  String _selectedRegion = 'all_regions';
  String _selectedEra = 'all_eras';
  bool _isLoading = true;
  bool _showFilters = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadHistoricalSites();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadHistoricalSites() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate loading
      _allSites = HistoricalSitesData.getAllSites();
      _filteredSites = List.from(_allSites);
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading historical sites: $e');
      setState(() {
        _isLoading = false;
      });
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
    });
  }

  Future<void> _getDirections(HistoricalSite site) async {
    final url = 'https://www.google.com/maps/dir/?api=1&destination=${site.latitude},${site.longitude}';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
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
                color: colorScheme.onSurface.withValues(alpha: 0.3),
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

                    // Location info
                    Row(
                      children: [
                        Icon(Icons.location_on, color: colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          '${site.latitude.toStringAsFixed(4)}, ${site.longitude.toStringAsFixed(4)}',
                          style: Theme.of(context).textTheme.bodyMedium,
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'historical_sites_map'.tr(context),
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
          : Column(
              children: [
                // Search bar
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => _filterSites(),
                    decoration: InputDecoration(
                      hintText: 'search_sites'.tr(context),
                      prefixIcon: Icon(Icons.search, color: colorScheme.primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHighest,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),

                // Filter panel
                if (_showFilters)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16),
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

                // Sites list
                Expanded(
                  child: _filteredSites.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_off,
                                size: 64,
                                color: colorScheme.onSurface.withValues(alpha: 0.5),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'no_items_found'.tr(context),
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredSites.length,
                          itemBuilder: (context, index) {
                            final site = _filteredSites[index];
                            final languageCode = Provider.of<LanguageProvider>(context).locale.languageCode;
                            
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: colorScheme.primaryContainer,
                                  child: Icon(
                                    _getSiteIcon(site.type),
                                    color: colorScheme.primary,
                                  ),
                                ),
                                title: Text(
                                  site.getName(languageCode),
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(site.era),
                                    Text(
                                      site.getDescription(languageCode).length > 80
                                          ? '${site.getDescription(languageCode).substring(0, 80)}...'
                                          : site.getDescription(languageCode),
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                                trailing: IconButton(
                                  onPressed: () => _getDirections(site),
                                  icon: const Icon(Icons.directions),
                                ),
                                onTap: () => _showSiteDetails(site),
                              ),
                            );
                          },
                        ),
                ),

                // Sites count
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    '${_filteredSites.length} ${'sites'.tr(context)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
    );
  }

  IconData _getSiteIcon(String siteType) {
    switch (siteType) {
      case SiteType.fortress:
        return Icons.castle;
      case SiteType.mosque:
        return Icons.mosque;
      case SiteType.archaeological:
        return Icons.museum;
      case SiteType.museum:
        return Icons.account_balance;
      case SiteType.monument:
        return Icons.account_balance;
      default:
        return Icons.location_on;
    }
  }
}
