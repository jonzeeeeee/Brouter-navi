# 🚀 Installationsanleitung - BIKE NAVIGATOR

## Phase 1: Vorbereitung

### 1.1 Flutter SDK installieren
Falls nicht vorhanden:

```bash
# macOS / Linux
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# Windows
# Downloade von: https://flutter.dev/docs/get-started/install/windows
# Und füge zum PATH hinzu
```

Verifizieren:
```bash
flutter --version
```

### 1.2 Android Studio / Emulator vorbereiten
```bash
flutter doctor
```

Sollte alles grün sein. Falls nicht:
```bash
flutter doctor --android-licenses
# Und alle Lizenzen bestätigen
```

## Phase 2: Projekt-Setup

### 2.1 Projektstruktur erstellen
```bash
# Option A: Vorhandenes Projekt verwenden
cd /path/to/navigation_app

# Option B: Neues Projekt erstellen
flutter create bike_navigator
cd bike_navigator
```

### 2.2 Dependencies installieren
```bash
flutter pub get
```

Falls Fehler:
```bash
flutter clean
flutter pub get
```

## Phase 3: Dateistruktur einrichten

Stelle sicher, dass folgende Ordner existieren:

```
navigation_app/
├── lib/
│   ├── main.dart
│   ├── providers/
│   │   └── navigation_provider.dart
│   ├── services/
│   │   └── gpx_service.dart
│   ├── screens/
│   │   ├── home_screen.dart
│   │   └── navigation_screen.dart
│   └── models/
│       └── route_data.dart
├── android/
│   └── app/src/main/
│       └── AndroidManifest.xml
├── pubspec.yaml
└── README.md
```

## Phase 4: Android-Konfiguration

### 4.1 AndroidManifest.xml bearbeiten
`android/app/src/main/AndroidManifest.xml`

Die wichtigsten Permissions sind bereits eingetragen (GPS, Internet, Wake Lock).

### 4.2 Build.gradle aktualisieren (optional)
`android/app/build.gradle`

```gradle
android {
    compileSdkVersion 33
    
    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 33
    }
}
```

### 4.3 Gradle Version (falls nötig)
`android/build.gradle`

```gradle
dependencies {
    classpath 'com.android.tools.build:gradle:7.3.1'
}
```

## Phase 5: iOS-Konfiguration (optional)

### 5.1 Info.plist bearbeiten
`ios/Runner/Info.plist`

Füge folgende Zeilen vor dem `</dict>` hinzu:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Wird für Navigation mit GPS benötigt</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>Wird für Fahrrad-Navigation benötigt</string>
<key>UIRequiredDeviceCapabilities</key>
<array>
    <string>gps</string>
</array>
```

## Phase 6: Erste Testfahrt

### 6.1 Emulator/Device vorbereiten
```bash
# Device auflisten
flutter devices

# Spezifisches Device auswählen
flutter run -d <device-id>
```

### 6.2 Im Debug-Modus starten
```bash
flutter run
```

### 6.3 Alternativen starten
```bash
# Mit Release-Optimierungen
flutter run --release

# Mit Logs
flutter run -v
```

## Phase 7: GPX-Route testen

### 7.1 Test-Route vorbereiten
Du hast bereits eine Beispiel-Route:
`Orpund_-__Dotzigen__35_4_km_.gpx`

### 7.2 Route auf Device übertragen
```bash
# Android File Transfer (macOS)
adb push Orpund_-__Dotzigen__35_4_km_.gpx /sdcard/Download/

# Oder manuell über File Explorer
```

### 7.3 Erste Navigation
1. App öffnen
2. "GPX-DATEI LADEN" drücken
3. Die Datei aus Downloads wählen
4. Navigation startet

## Phase 8: Lokale GPX-Dateien laden

Falls du Dateien lokal in der App speichern möchtest:

```bash
# In Android-Emulator:
adb shell
cd /sdcard/Android/data/com.example.bike_navigator/files
```

Oder in der App ein Dateisystem hinzufügen:

```dart
import 'package:path_provider/path_provider.dart';

final directory = await getApplicationDocumentsDirectory();
final gpxFile = File('${directory.path}/route.gpx');
```

## Phase 9: Build & Deployment

### 9.1 APK erzeugen (für Installation)
```bash
flutter build apk --release
```

Die APK wird unter `build/app/outputs/apk/release/app-release.apk` erstellt.

### 9.2 App Bundle (für Play Store)
```bash
flutter build appbundle --release
```

### 9.3 Installation auf Device
```bash
flutter install
# oder
adb install -r build/app/outputs/apk/release/app-release.apk
```

## Phase 10: Troubleshooting

### Problem: "flutter: command not found"
```bash
export PATH="$PATH:/Users/username/flutter/bin"
# (pfad anpassen)
```

### Problem: Android SDK fehlt
```bash
flutter config --android-sdk-path=/path/to/android/sdk
```

### Problem: Build schlägt fehl
```bash
flutter clean
cd android && ./gradlew clean
cd ..
flutter pub get
flutter run
```

### Problem: GPS funktioniert nicht im Emulator
- Emulator-Settings öffnen
- Location: "High Accuracy" einstellen
- Auf "..." klicken unter "Virtual sensors"
- "Allow ... to access this device's location" aktivieren

### Problem: Keine Sprachanweisungen
- Text-to-Speech Engine installiert?
- Android Settings → "Text-to-Speech Output" überprüfen
- Test: `flutter run` und in `main.dart`:
```dart
FlutterTts tts = FlutterTts();
await tts.speak("Hallo");
```

### Problem: Karte wird nicht angezeigt
- Internet-Verbindung prüfen
- OSM Tile Server erreichbar?
- In Emulator: Network settings überprüfen

## Phase 11: Optimierungen

### 11.1 Performance
```dart
// In navigation_provider.dart
positionStream = Geolocator.getPositionStream(
  locationSettings: const LocationSettings(
    accuracy: LocationAccuracy.best,
    distanceFilter: 5, // ← erhöhen für weniger Updates
  ),
)
```

### 11.2 Batterie sparen
- GPS Accuracy auf `LocationAccuracy.good` setzen
- `distanceFilter` auf 10-20 Meter erhöhen
- Map-Updates reduzieren

### 11.3 Speicher optimieren
- alte Karten-Cache clearen
- in `flutter_map` Tile-Cache begrenzen

## Phase 12: Weitere Features hinzufügen

### Offline-Karten
```yaml
dependencies:
  flutter_map_tile_caching: ^6.0.0
```

### Höhen-Profil
```yaml
dependencies:
  charts_flutter: ^0.12.0
```

### Waypoints
```dart
// In GPX Service erweitern
final wpts = document.findAllElements('wpt');
```

---

**🎉 Glückwunsch! Die App sollte jetzt laufen!**

Für Fragen: Siehe README.md oder die Flutter-Docs unter flutter.dev
