# ⚡ QUICK START - 10 Minuten Setup

## 🎯 Was du brauchst
- Flutter SDK (https://flutter.dev/docs/get-started/install)
- Android Studio oder VS Code
- Ein Android-Gerät oder Emulator

## 1️⃣ Flutter verifizieren
```bash
flutter doctor
```
Wenn alles grün → nächster Schritt. Falls nicht, Errors beheben.

## 2️⃣ Projekt klonen
```bash
cd navigation_app
flutter pub get
```

## 3️⃣ Dateistruktur überprüfen

Diese Dateien müssen vorhanden sein:
- ✅ `lib/main.dart`
- ✅ `lib/providers/navigation_provider.dart`
- ✅ `lib/screens/home_screen.dart`
- ✅ `lib/screens/navigation_screen.dart`
- ✅ `lib/services/gpx_service.dart`
- ✅ `lib/models/route_data.dart`
- ✅ `pubspec.yaml`

Falls nicht alle Ordner existieren:
```bash
mkdir -p lib/{providers,screens,services,models}
# Und Dateien einfügen
```

## 4️⃣ Device/Emulator vorbereiten

### Android Emulator:
```bash
flutter emulators --launch <emulator-name>
```

### Oder echtes Device:
```bash
adb devices
```

## 5️⃣ App starten
```bash
flutter run
```

Warte bis die App lädt (erste Kompilierung dauert ~2 Minuten).

## 6️⃣ Route testen

1. App öffnet sich → Home Screen mit "GPX-DATEI LADEN"
2. Klick auf den Button
3. Wähle `Orpund_-__Dotzigen__35_4_km_.gpx`
4. Navigation startet automatisch! 🎉

## 🗺️ Navigation
- Großer Pfeil = nächste Richtung
- Oben: verbleibende km + Geschwindigkeit
- Sprachanweisungen: "Leicht rechts", etc.
- 🗺 = Map an/aus
- ■ = Stop

---

## ❓ Häufige Probleme

### "flutter: Befehl nicht gefunden"
```bash
# Flutter zum PATH hinzufügen
export PATH="$PATH:$HOME/flutter/bin"
```

### "Build Failed"
```bash
flutter clean
flutter pub get
flutter run
```

### "GPS funktioniert nicht"
- Im Emulator: Extended controls → Location → Custom location setzen
- Oder echtes Device verwenden
- GPS braucht ein paar Sekunden zum Lock

### "Keine Sprachanweisungen"
- Device-Lautstärke überprüfen
- Text-to-Speech System Language auf Deutsch stellen

### "Map wird nicht angezeigt"
- Ist Internet-Verbindung aktiv?
- Ist der Emulator mit Internet verbunden?

---

## 📱 Nächste Schritte

Nach erfolgreichem Test:

1. **APK bauen** (für Installation auf echtem Phone):
   ```bash
   flutter build apk --release
   ```

2. **Eigene Routen**:
   - Von BRouter exportieren (GPX Format)
   - In der App laden

3. **Anpassungen**:
   - Farben? Siehe `lib/main.dart` ThemeData
   - Sprache? Siehe `lib/providers/navigation_provider.dart` Zeile ~60
   - Font-Größen? Siehe `lib/screens/navigation_screen.dart`

---

## 🔍 Struktur verstehen

```
App startet
    ↓
main.dart (Theme & Provider Setup)
    ↓
HomeScreen (GPX-Datei laden)
    ↓
NavigationProvider (GPS & Logic)
    ↓
NavigationScreen (Anzeige)
```

Die Logik ist in `NavigationProvider` → von dort aus alle Updates.

---

## 🎨 Anpassungen

### Sprache auf Englisch?
In `lib/providers/navigation_provider.dart` Zeile 37:
```dart
await flutterTts.setLanguage("en-US");
```

### Andere Karten?
In `lib/screens/navigation_screen.dart` TileLayer:
```dart
urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
```

### Größere Schrift?
In `lib/screens/navigation_screen.dart` displayLarge:
```dart
fontSize: 120, // statt 100
```

---

## 🚀 Release Build

Wenn alles funktioniert:
```bash
flutter build apk --release
```

APK ist dann hier:
```
build/app/outputs/apk/release/app-release.apk
```

Diese Datei kannst du auf jedes Android-Handy installieren!

---

**🎉 Du bist startklar!** 

Los geht's → `flutter run`
