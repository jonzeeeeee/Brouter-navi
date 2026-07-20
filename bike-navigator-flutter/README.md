# 🚴 BIKE NAVIGATOR - Minimalistische Navigations-App

Eine Swift, minimalistisch gestaltete Navigations-App für Fahrräder mit Schwarz-Weiß-Design, Sprachanweisungen und GPS-Tracking.

## 📋 Features

✅ **GPX-Route Import** - Laden Sie Routen von BRouter oder anderen Quellen  
✅ **GPS Navigation** - Echtzeit-Positionsverfolgung  
✅ **Sprachanweisungen** - Deutsche Text-to-Speech Anweisungen  
✅ **Minimales Design** - Großer Text, Schwarz-Weiß, leicht lesbar  
✅ **Sperrbildschirm-Modus** - Navigation läuft auch mit gesperrtem Bildschirm  
✅ **Offline-Kartendarstellung** - OpenStreetMap Karten mit Graustufen  

## 🛠️ Installation

### Voraussetzungen
- Flutter 3.0+ SDK
- Android Studio oder VS Code mit Flutter-Extension
- Physical Device oder Emulator mit GPS-Unterstützung

### Setup

1. **Clone/Create das Projekt:**
```bash
cd navigation_app
flutter pub get
```

2. **Android Permissions konfigurieren** (AndroidManifest.xml):
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.INTERNET" />
```

3. **iOS Permissions konfigurieren** (Info.plist):
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Wird für Navigation benötigt</string>
```

4. **Kompilieren und ausführen:**
```bash
flutter run
```

## 📱 Nutzung

### Route laden
1. App öffnen
2. Button "GPX-DATEI LADEN" drücken
3. GPX-Datei auswählen (z.B. von BRouter exportierte Route)
4. Navigation startet automatisch

### Navigation
- **Großer Text oben**: Verbleibende Distanz und aktuelle Geschwindigkeit
- **Großer Pfeil in der Mitte**: Nächste Richtungsänderung
- **"in X km"**: Entfernung bis zur Richtungsänderung
- **Sprachanweisungen**: Werden automatisch in Deutsch angesagt

### Steuerung
- **🗺 Symbol**: Map an/aus (für Sperrbildschirm-Navigation)
- **■ Symbol**: Navigation beenden

## 🗺️ Mit BRouter verwenden

1. Öffne https://brouter.de/brouter-web/
2. Zeichne deine Route
3. Klick "Route exportieren"
4. Wähle **GPX-Format**
5. Speichere die Datei
6. Öffne BIKE NAVIGATOR und lade die GPX-Datei

## 🎨 Design-Merkmale

```
┌─────────────────────────────┐
│  30.5 km      45.2 km/h     │  ← Abstand & Geschwindigkeit
│                             │
│                             │
│                      ↗       │  ← Nächster Richtungswechsel
│                             │
│                   in 1.2 km  │  ← Entfernung
│                             │
│         🗺        ■          │  ← Kontrollen
└─────────────────────────────┘
```

- **Schwarz-Weiß**: Keine Ablenkung, einfacher lesbar
- **Große Fonts**: Lesbar während der Fahrt
- **Minimale Elemente**: Nur essenzielle Informationen

## 🔊 Sprachanweisungen

Die App gibt automatisch Deutsche Anweisungen:
- "↑ Geradeaus"
- "↗ Leicht rechts"
- "→ Rechts"
- "↘ Scharf rechts"
- "⟲ Kehrturn"

## 📊 Technologie-Stack

- **Flutter** - Cross-Platform-Framework
- **Provider** - State Management
- **flutter_map** - Kartendarstellung
- **flutter_tts** - Text-to-Speech
- **geolocator** - GPS-Zugriff
- **latlong2** - Koordinaten-Berechnung

## ⚙️ Konfiguration

### Sprache ändern
In `lib/providers/navigation_provider.dart`:
```dart
await flutterTts.setLanguage("en-US"); // Für Englisch
await flutterTts.setLanguage("de-DE"); // Für Deutsch
```

### Sprachgeschwindigkeit anpassen
```dart
await flutterTts.setSpeechRate(0.85); // 0.5 bis 2.0
```

### GPS Update-Frequenz
In `startNavigation()`:
```dart
distanceFilter: 5, // Update alle 5 Meter
```

## 🚀 Build & Deployment

### APK für Android erstellen:
```bash
flutter build apk --release
```

### App Bundle für Play Store:
```bash
flutter build appbundle --release
```

## 📝 Lizenz

MIT License - Kostenlos verwendbar und modifizierbar

## 🐛 Troubleshooting

**GPS funktioniert nicht:**
- Location Services aktivieren
- App Berechtigungen in den Android-Einstellungen prüfen
- Im Freien testen (GPS funktioniert nicht in geschlossenen Räumen)

**Kein Ton bei Sprachanweisungen:**
- System-Volume überprüfen
- Text-to-Speech Engine auf dem Gerät installiert?
- Im Android-Settings unter "Text-to-Speech" nachschauen

**Map wird nicht angezeigt:**
- Internetverbindung prüfen
- Tile-Proxy in der Datei überprüfen

## 📞 Support

Für Probleme oder Fragen:
1. Logs überprüfen: `flutter logs`
2. Device neu starten
3. App neu bauen: `flutter clean && flutter pub get && flutter run`

---

**Happy Cycling! 🚴** 🗺️
