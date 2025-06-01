# Interactive Map Setup Instructions

## Google Maps API Key Setup

To use the interactive map feature in the Turathna app, you need to set up a Google Maps API key.

### Step 1: Get a Google Maps API Key

1. Go to the [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Enable the following APIs:
   - Maps SDK for Android
   - Maps SDK for iOS (if you plan to build for iOS)
   - Places API (optional, for enhanced location features)

4. Go to "Credentials" and create a new API key
5. Restrict the API key to your app's package name for security

### Step 2: Configure Android

1. Open `android/app/src/main/AndroidManifest.xml`
2. Replace `YOUR_GOOGLE_MAPS_API_KEY_HERE` with your actual API key:

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_ACTUAL_API_KEY_HERE" />
```

### Step 3: Configure iOS (if building for iOS)

**✅ iOS configuration is already completed! Just replace the API key.**

1. Open `ios/Runner/AppDelegate.swift`
2. Replace `YOUR_GOOGLE_MAPS_API_KEY_HERE` with your actual API key:
```swift
GMSServices.provideAPIKey("YOUR_ACTUAL_API_KEY_HERE")
```

**Note:** The iOS deployment target has been updated to iOS 14.0 to support Google Maps Flutter plugin, and location permissions have been added to Info.plist.

### Step 4: Test the Map

1. Run `flutter pub get` to ensure all dependencies are installed
2. Build and run the app
3. Navigate to the menu and select "Interactive Map"
4. The map should load with historical sites marked across Algeria

## Features

The interactive map includes:

- **Historical Sites**: Markers for major historical sites across Algeria
- **Search**: Search for specific sites by name
- **Filters**: Filter sites by region and historical era
- **Site Details**: Tap markers to view detailed information
- **Directions**: Get directions to any historical site
- **Map Types**: Switch between normal, satellite, and terrain views
- **Location**: Find your current location on the map

## Troubleshooting

### Map not loading
- Verify your API key is correct
- Ensure the Maps SDK for Android is enabled in Google Cloud Console
- Check that your app's package name is added to the API key restrictions

### Location not working
- Grant location permissions when prompted
- Ensure location services are enabled on your device
- Check that location permissions are properly configured in AndroidManifest.xml

### Markers not appearing
- Verify the historical sites data is loading correctly
- Check the console for any error messages
- Ensure the map has finished loading before markers are added

## Historical Sites Included

The map features major historical sites across Algeria including:

- **Bordj El Mokrani** - Ottoman fortress and symbol of resistance
- **Djemila** - UNESCO World Heritage Roman ruins
- **Casbah of Algiers** - UNESCO World Heritage medina
- **Timgad** - Roman colonial town ("Pompeii of Africa")
- **Tipaza** - Phoenician, Roman, and early Christian ruins
- **Great Mosque of Tlemcen** - Historic Almoravid mosque
- **Al Qal'a of Beni Hammad** - First capital of the Hammadid dynasty
- **M'Zab Valley (Ghardaïa)** - Five fortified cities built by the Mozabites

## Adding More Sites

To add more historical sites to the map:

1. Open `lib/services/historical_sites_data.dart`
2. Add new `HistoricalSite` objects to the `getAllSites()` method
3. Include coordinates, descriptions in multiple languages, and metadata
4. The new sites will automatically appear on the map with appropriate markers

## Customization

You can customize the map by:

- Modifying marker colors and icons in `_getMarkerIcon()` method
- Adding new site types in the `SiteType` class
- Updating historical eras in the `HistoricalEra` class
- Adding new regions in the `AlgerianRegion` class
- Customizing the map theme and styling
