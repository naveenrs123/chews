# chews

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application that follows the
[simple app state management
tutorial](https://flutter.dev/docs/development/data-and-backend/state-mgmt/simple).

For help getting started with Flutter development, view the
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Assets

The `assets` directory houses images, fonts, and any other files you want to
include with your application.

The `assets/images` directory contains [resolution-aware
images](https://flutter.dev/docs/development/ui/assets-and-images#resolution-aware).

## Localization

This project generates localized messages based on arb files found in
the `lib/src/localization` directory.

To support additional languages, please visit the tutorial on
[Internationalizing Flutter
apps](https://flutter.dev/docs/development/accessibility-and-localization/internationalization)

## Firebase
Instructions can be found [here](https://firebase.google.com/docs/flutter/setup).

### Authentication
- https://firebase.google.com/docs/auth/flutter/start

### Emulators
- https://firebase.google.com/docs/emulator-suite
- https://firebase.google.com/docs/emulator-suite/connect_auth

### Cloud Functions
Instructions [here](https://firebase.google.com/docs/functions/get-started?gen=2nd#python_3)
1. Install `firebase-tools`
2. Run `firebase login` if not already logged in
3. Install latest Python
    * NOTE: runtime defaults to python3.12, but WSL uses 3.11 latest. We still have to figure this out, but for now we add `"runtime": "python3[x]"` to firebase.json, where `x` is either 11 (WSL) or 12 (Linux, Mac).
4. In the `functions` directory, run `. venv/bin/activate && python[n] -m pip install -r requirements.txt'` (whatever your python command is, e.g. `python3.11`)
5. Run `firebase emulators:start`

## APIs

### Google Places API

**Endpoints**
- https://developers.google.com/maps/documentation/places/web-service/text-search
  - Find places based on a text search query. Data returned is controlled by a field mask.
- https://developers.google.com/maps/documentation/places/web-service/nearby-search
  - Find places based on a specific location. Data returned is controlled by a field mask and can include/exclude certain types of places.
- https://developers.google.com/maps/documentation/places/web-service/place-details
  - Fetch details about a place specified by a given place ID. Data returned is controlled by a field mask. Place IDs can be cached and refreshed at no cost.
- https://developers.google.com/maps/documentation/places/web-service/place-photos
  - Fetch a photo identified by name for a specific place. Need to specify the name and at least one of `maxHeightPx` and `maxWidthPx`.

**Reference**
- https://developers.google.com/maps/documentation/places/web-service/place-types
- https://developers.google.com/maps/documentation/places/web-service/data-fields

**Policies**
- https://developers.google.com/maps/documentation/places/web-service/policies
