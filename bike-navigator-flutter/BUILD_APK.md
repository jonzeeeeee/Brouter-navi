# 📦 APK bauen über GitHub Actions (ohne lokale Installation)

Diese Anleitung baut die fertige `app-release.apk` in der Cloud. Du brauchst
nur einen kostenlosen GitHub-Account – kein Flutter, kein Android-SDK auf
deinem Rechner.

---

## Schritt 1 – GitHub-Account & Repository

1. Falls noch nicht vorhanden: Account auf https://github.com anlegen.
2. Oben rechts auf **+ → New repository**.
3. Name z. B. `bike-navigator`, **Private** oder **Public** ist egal.
4. **Create repository**.

## Schritt 2 – Projekt hochladen

**Variante A – im Browser (einfachste):**
1. Im leeren Repo auf **uploading an existing file** klicken.
2. Den kompletten Inhalt des Ordners `bike-navigator-flutter` per
   Drag-and-Drop hineinziehen (inklusive des versteckten Ordners
   `.github/` – im Browser-Upload einfach alle Dateien mit auswählen).
3. Unten **Commit changes**.

> Wichtig: Der Ordner `.github/workflows/build-apk.yml` **muss** mit hoch –
> das ist die Bauanleitung. Falls dein Datei-Explorer versteckte Ordner
> ausblendet, blende sie ein (macOS: `Cmd+Shift+.`, Windows: „Versteckte
> Elemente" im Explorer aktivieren).

**Variante B – mit Git (wenn du Git kennst):**
```bash
cd bike-navigator-flutter
git init
git add .
git commit -m "Bike Navigator"
git branch -M main
git remote add origin https://github.com/DEIN-NAME/bike-navigator.git
git push -u origin main
```

## Schritt 3 – Build starten

Der Build startet **automatisch** nach dem Hochladen. Falls nicht:
1. Im Repo auf den Reiter **Actions**.
2. Links **Build Android APK** wählen.
3. Rechts **Run workflow → Run workflow**.

## Schritt 4 – Fortschritt beobachten

1. Reiter **Actions** → laufenden Build anklicken.
2. Nach ~5–10 Minuten ist er fertig.
   - ✅ Grüner Haken = APK ist fertig.
   - ❌ Rotes X = Fehler (siehe unten).

## Schritt 5 – APK herunterladen

1. Auf den fertigen (grünen) Build-Lauf klicken.
2. Unten im Abschnitt **Artifacts** liegt `bike-navigator-apk`.
3. Herunterladen → es ist eine ZIP-Datei → entpacken →
   darin liegt `app-release.apk`.

## Schritt 6 – Auf dem Android-Handy installieren

1. `app-release.apk` aufs Handy übertragen (USB, E-Mail an sich selbst,
   Cloud, …).
2. Datei antippen → Android fragt nach Erlaubnis für
   „Unbekannte Quellen / Aus dieser Quelle installieren" → erlauben.
3. Installieren → öffnen → **GPX-Datei laden** → deine BRouter-Route wählen.

---

## ⚠️ Wenn der Build fehlschlägt (rotes X)

Das ist beim ersten Versuch nicht unwahrscheinlich – der Code wurde nie
kompiliert. So kommst du an die Fehlermeldung:

1. Reiter **Actions** → den fehlgeschlagenen Lauf öffnen.
2. Den Schritt mit dem roten X aufklappen (meist **Build APK** oder
   **Dependencies**).
3. Die letzten ~20 Zeilen mit der Fehlermeldung kopieren.
4. Schick sie mir – dann sage ich dir die genaue Korrektur, du änderst
   die betroffene Datei im Repo (Bleistift-Symbol → editieren → commit),
   und der Build läuft von selbst neu.

Typische Erstfehler sind Versionskonflikte bei Paketen oder ein
API-Detail – beides schnell behebbar.

---

## 🔧 Was die Pipeline technisch macht

Die Datei `.github/workflows/build-apk.yml`:
1. richtet Java 17 + Flutter 3.24 ein,
2. erzeugt das fehlende Android-Projektgerüst (`flutter create`),
3. fügt die Standort-/Internet-/WakeLock-Berechtigungen ins Manifest ein,
4. lädt die Abhängigkeiten (`flutter pub get`),
5. baut `flutter build apk --release`,
6. stellt die APK als Download-Artefakt bereit.

Die Release-APK wird mit dem Debug-Schlüssel signiert und ist damit direkt
installierbar. Für eine Veröffentlichung im Play Store bräuchtest du später
einen eigenen Signatur-Schlüssel – für den Eigengebrauch reicht das so.
