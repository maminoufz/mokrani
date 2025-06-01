import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/archive_item.dart';
import '../services/archive_service.dart';
import '../providers/language_provider.dart';
import '../extensions/string_extensions.dart';

class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({super.key});

  @override
  State<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  List<ArchiveItem> _allItems = [];
  List<ArchiveItem> _filteredItems = [];
  bool _isLoading = true;
  String _searchQuery = '';
  ArchiveItemType? _selectedType;
  ArchivePeriod? _selectedPeriod;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadArchiveItems();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadArchiveItems() async {
    setState(() => _isLoading = true);
    try {
      final items = await ArchiveService.getAllItems();
      setState(() {
        _allItems = items;
        _filteredItems = items;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading archive: $e')),
        );
      }
    }
  }

  void _filterItems() {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final languageCode = languageProvider.locale.languageCode;

    setState(() {
      _filteredItems = _allItems.where((item) {
        // Search filter
        bool matchesSearch = true;
        if (_searchQuery.isNotEmpty) {
          final title = item.getTitle(languageCode).toLowerCase();
          final description = item.getDescription(languageCode).toLowerCase();
          final tags = item.tags.join(' ').toLowerCase();
          matchesSearch = title.contains(_searchQuery.toLowerCase()) ||
                         description.contains(_searchQuery.toLowerCase()) ||
                         tags.contains(_searchQuery.toLowerCase());
        }

        // Type filter
        bool matchesType = _selectedType == null || item.type == _selectedType;

        // Period filter
        bool matchesPeriod = _selectedPeriod == null || item.period == _selectedPeriod;

        return matchesSearch && matchesType && matchesPeriod;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'archive'.tr(context),
          style: GoogleFonts.playfairDisplay(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'all_items'.tr(context)),
            Tab(text: 'featured'.tr(context)),
            Tab(text: 'search'.tr(context)),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildAllItemsTab(colorScheme),
                _buildFeaturedTab(colorScheme),
                _buildSearchTab(colorScheme),
              ],
            ),
    );
  }

  Widget _buildAllItemsTab(ColorScheme colorScheme) {
    return Column(
      children: [
        _buildFilterRow(colorScheme),
        Expanded(
          child: _buildItemGrid(_filteredItems, colorScheme),
        ),
      ],
    );
  }

  Widget _buildFeaturedTab(ColorScheme colorScheme) {
    final featuredItems = _allItems.where((item) => item.isFeatured).toList();
    return _buildItemGrid(featuredItems, colorScheme);
  }

  Widget _buildSearchTab(ColorScheme colorScheme) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'search_archive'.tr(context),
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                        _filterItems();
                      },
                    )
                  : null,
            ),
            onChanged: (value) {
              setState(() => _searchQuery = value);
              _filterItems();
            },
          ),
        ),
        _buildFilterRow(colorScheme),
        Expanded(
          child: _buildItemGrid(_filteredItems, colorScheme),
        ),
      ],
    );
  }

  Widget _buildFilterRow(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<ArchiveItemType?>(
              value: _selectedType,
              decoration: InputDecoration(
                labelText: 'filter_by_type'.tr(context),
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: [
                DropdownMenuItem<ArchiveItemType?>(
                  value: null,
                  child: Text('all_types'.tr(context)),
                ),
                ...ArchiveItemType.values.map((type) {
                  final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
                  final languageCode = languageProvider.locale.languageCode;
                  return DropdownMenuItem<ArchiveItemType?>(
                    value: type,
                    child: Text(_getTypeDisplayName(type, languageCode)),
                  );
                }),
              ],
              onChanged: (value) {
                setState(() => _selectedType = value);
                _filterItems();
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButtonFormField<ArchivePeriod?>(
              value: _selectedPeriod,
              decoration: InputDecoration(
                labelText: 'filter_by_period'.tr(context),
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: [
                DropdownMenuItem<ArchivePeriod?>(
                  value: null,
                  child: Text('all_periods'.tr(context)),
                ),
                ...ArchivePeriod.values.map((period) {
                  final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
                  final languageCode = languageProvider.locale.languageCode;
                  return DropdownMenuItem<ArchivePeriod?>(
                    value: period,
                    child: Text(_getPeriodDisplayName(period, languageCode)),
                  );
                }),
              ],
              onChanged: (value) {
                setState(() => _selectedPeriod = value);
                _filterItems();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemGrid(List<ArchiveItem> items, ColorScheme colorScheme) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.archive_outlined,
              size: 64,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'no_items_found'.tr(context),
              style: GoogleFonts.montserrat(
                fontSize: 16,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildArchiveCard(item, colorScheme);
      },
    );
  }

  Widget _buildArchiveCard(ArchiveItem item, ColorScheme colorScheme) {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final languageCode = languageProvider.locale.languageCode;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _showItemDetails(item),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  image: item.imageUrl != null
                      ? DecorationImage(
                          image: AssetImage(item.imageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                  color: item.imageUrl == null ? colorScheme.surfaceContainerHighest : null,
                ),
                child: item.imageUrl == null
                    ? Icon(
                        _getTypeIcon(item.type),
                        size: 48,
                        color: colorScheme.primary,
                      )
                    : null,
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.getTitle(languageCode),
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.getPeriodName(languageCode),
                      style: GoogleFonts.montserrat(
                        fontSize: 10,
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (item.isFeatured) ...[
                      const SizedBox(height: 4),
                      Icon(
                        Icons.star,
                        size: 16,
                        color: Colors.amber,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showItemDetails(ArchiveItem item) {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final languageCode = languageProvider.locale.languageCode;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (item.imageUrl != null)
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    image: DecorationImage(
                      image: AssetImage(item.imageUrl!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item.getTitle(languageCode),
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Chip(
                            label: Text(item.getTypeName(languageCode)),
                            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                          ),
                          const SizedBox(width: 8),
                          Chip(
                            label: Text(item.getPeriodName(languageCode)),
                            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Flexible(
                        child: SingleChildScrollView(
                          child: Text(
                            item.getDescription(languageCode),
                            style: GoogleFonts.montserrat(fontSize: 14),
                          ),
                        ),
                      ),
                      if (item.historicalDate != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          'Historical Date: ${item.historicalDate!.year}',
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                      if (item.tags.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: item.tags.map((tag) => Chip(
                            label: Text(tag),
                            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                          )).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('close'.tr(context)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getTypeIcon(ArchiveItemType type) {
    switch (type) {
      case ArchiveItemType.document:
        return Icons.description;
      case ArchiveItemType.image:
        return Icons.image;
      case ArchiveItemType.video:
        return Icons.video_library;
      case ArchiveItemType.audio:
        return Icons.audio_file;
      case ArchiveItemType.artifact:
        return Icons.museum;
      case ArchiveItemType.manuscript:
        return Icons.auto_stories;
      case ArchiveItemType.map:
        return Icons.map;
      case ArchiveItemType.photograph:
        return Icons.photo;
    }
  }

  String _getTypeDisplayName(ArchiveItemType type, String languageCode) {
    switch (type) {
      case ArchiveItemType.document:
        return languageCode == 'fr' ? 'Document' : languageCode == 'ar' ? 'وثيقة' : 'Document';
      case ArchiveItemType.image:
        return languageCode == 'fr' ? 'Image' : languageCode == 'ar' ? 'صورة' : 'Image';
      case ArchiveItemType.video:
        return languageCode == 'fr' ? 'Vidéo' : languageCode == 'ar' ? 'فيديو' : 'Video';
      case ArchiveItemType.audio:
        return languageCode == 'fr' ? 'Audio' : languageCode == 'ar' ? 'صوت' : 'Audio';
      case ArchiveItemType.artifact:
        return languageCode == 'fr' ? 'Artefact' : languageCode == 'ar' ? 'قطعة أثرية' : 'Artifact';
      case ArchiveItemType.manuscript:
        return languageCode == 'fr' ? 'Manuscrit' : languageCode == 'ar' ? 'مخطوطة' : 'Manuscript';
      case ArchiveItemType.map:
        return languageCode == 'fr' ? 'Carte' : languageCode == 'ar' ? 'خريطة' : 'Map';
      case ArchiveItemType.photograph:
        return languageCode == 'fr' ? 'Photographie' : languageCode == 'ar' ? 'صورة فوتوغرافية' : 'Photograph';
    }
  }

  String _getPeriodDisplayName(ArchivePeriod period, String languageCode) {
    switch (period) {
      case ArchivePeriod.prehistoric:
        return languageCode == 'fr' ? 'Préhistorique' : languageCode == 'ar' ? 'ما قبل التاريخ' : 'Prehistoric';
      case ArchivePeriod.ancient:
        return languageCode == 'fr' ? 'Antique' : languageCode == 'ar' ? 'العصور القديمة' : 'Ancient';
      case ArchivePeriod.roman:
        return languageCode == 'fr' ? 'Romain' : languageCode == 'ar' ? 'الروماني' : 'Roman';
      case ArchivePeriod.islamic:
        return languageCode == 'fr' ? 'Islamique' : languageCode == 'ar' ? 'الإسلامي' : 'Islamic';
      case ArchivePeriod.ottoman:
        return languageCode == 'fr' ? 'Ottoman' : languageCode == 'ar' ? 'العثماني' : 'Ottoman';
      case ArchivePeriod.colonial:
        return languageCode == 'fr' ? 'Colonial' : languageCode == 'ar' ? 'الاستعماري' : 'Colonial';
      case ArchivePeriod.independence:
        return languageCode == 'fr' ? 'Indépendance' : languageCode == 'ar' ? 'الاستقلال' : 'Independence';
      case ArchivePeriod.modern:
        return languageCode == 'fr' ? 'Moderne' : languageCode == 'ar' ? 'الحديث' : 'Modern';
    }
  }
}
