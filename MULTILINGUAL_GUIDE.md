# ShetiMitra Multilingual Implementation Guide

## Overview
Your ShetiMitra application now has full multilingual support for **English**, **Hindi**, and **Marathi**. The implementation uses Flutter's built-in localization system with custom state management for persistent language selection.

## System Components

### 1. **AppLocalizations** (`lib/l10n/app_localizations.dart`)
The core localization class that manages all translations for three supported languages:
- **English (en)**
- **Hindi (hi)**
- **Marathi (mr)**

**Key Methods:**
- `t(String key)` - Translates a key to the current language
- `format(String key, Map<String, String> values)` - Translates with parameter replacement
- `languageName(String languageCode)` - Gets the localized name of a language
- `cropName(String key)` - Gets localized crop names
- `serviceName(String key)` - Gets localized service names

### 2. **AppLocaleController** (`lib/l10n/app_localizations.dart`)
Manages the app's current locale and persistence:
- Extends `ChangeNotifier` for reactive state updates
- Persists language choice to `SharedPreferences` with key `app_locale`
- Automatically loads saved language preference on app startup
- Updates UI immediately when language changes

**Key Methods:**
- `load()` - Loads saved language preference
- `setLocale(Locale locale)` - Sets new language and saves to preferences

### 3. **AppLocaleScope** (`lib/l10n/app_localizations.dart`)
InheritedWidget that provides `AppLocaleController` throughout the widget tree.

**Usage:**
```dart
final controller = AppLocaleScope.of(context);
await controller.setLocale(const Locale('hi'));
```

### 4. **LanguageMenuButton** (`lib/widgets/language_menu_button.dart`)
A reusable popup menu button for quick language switching. Appears in:
- Onboarding Page
- Login Page
- Home Page
- Profile Page

### 5. **LanguageSettingsPage** (`lib/pages/language_settings_page.dart`)
A dedicated full-screen language selection page with:
- Visual radio button style selection
- Language name in English and native script
- Information card explaining that changes are instant
- Beautiful UI with rounded borders and checkmarks

## How to Use

### For End Users

#### Option 1: Quick Language Selection
Click the language icon (🌐) in the app bar of any page to see a popup menu with all three languages.

#### Option 2: Dedicated Settings Page
Navigate to Profile → Language to access the full language settings page with a more detailed interface.

### For Developers

#### Using Translations in Code

```dart
import 'package:shetimitra/l10n/app_localizations.dart';

// In a widget's build method:
final l10n = AppLocalizations.of(context);

Text(l10n.t('welcomeTitle'))  // "Welcome to ShetiMitra" or translations
Text(l10n.t('greeting'))      // "Hello Hitesh" or translations
```

#### With String Formatting

```dart
final l10n = AppLocalizations.of(context);
final message = l10n.format('orderPrefix', {'id': '12345'});
// Returns: "Order: 12345" (or translation)
```

#### Getting Localized Property Names

```dart
final l10n = AppLocalizations.of(context);
l10n.cropName('cropWheat')      // "Wheat" or translation
l10n.serviceName('serviceSeeds') // "Seeds" or translation
```

#### Programmatically Changing Language

```dart
final controller = AppLocaleScope.of(context);
await controller.setLocale(const Locale('mr')); // Switch to Marathi
```

## Adding New Translations

### To add a new translatable string:

1. **Open** `lib/l10n/app_localizations.dart`

2. **Add to English section** (finds line starting with `'en': {`):
```dart
'myNewKey': 'My English Text',
```

3. **Add to Hindi section** (finds line starting with `'hi': {`):
```dart
'myNewKey': 'मेरा हिंदी पाठ',
```

4. **Add to Marathi section** (finds line starting with `'mr': {`):
```dart
'myNewKey': 'माझा मराठी मजकूर',
```

5. **Use in code**:
```dart
final l10n = AppLocalizations.of(context);
Text(l10n.t('myNewKey'))
```

### Existing Translation Keys

Over 150 translations are already included for:
- UI Labels (appName, language, etc.)
- OnBoarding screens
- Login/Authentication
- Navigation tabs
- Weather information
- Crop types
- Services
- Shopping/Products
- Orders and Payments
- Farming tools
- And much more!

## Supported Locales

```dart
const supportedLocales = [
  Locale('en'),  // English
  Locale('hi'),  // Hindi
  Locale('mr'),  // Marathi
];
```

## Persistence

The selected language is automatically saved to the device and will be remembered:
- Stored in SharedPreferences with key: `app_locale`
- Loaded automatically when the app starts
- Updated whenever user changes language

## Architecture

```
User Selects Language
        ↓
LanguageMenuButton / LanguageSettingsPage
        ↓
AppLocaleScope.setLocale()
        ↓
AppLocaleController.setLocale()
        ↓
Save to SharedPreferences + notify listeners
        ↓
AnimatedBuilder in MainApp rebuilds with new locale
        ↓
AppLocalizations.of(context) uses new locale
        ↓
UI updates instantly with translations
```

## Key Features

✅ **Three Languages**: English, Hindi, Marathi
✅ **Persistent Selection**: User's choice saved automatically
✅ **Instant Updates**: UI updates immediately without restart
✅ **150+ Translations**: Comprehensive strings for entire app
✅ **Easy to Extend**: Simple key-value structure
✅ **Multiple Access Points**: AppBar button, Settings page, Onboarding
✅ **Native Script Support**: Proper Unicode support for Devanagari script
✅ **No External Dependencies**: Built with Flutter's native localization

## Troubleshooting

### Language doesn't persist after app restart?
- Ensure SharedPreferences dependency is in pubspec.yaml ✓
- Check that `AppLocaleController.load()` is called in main.dart initState ✓

### Translations showing key instead of text?
- Verify the key exists in all three language sections
- Check for typos in the key name
- Ensure proper string quotes and commas

### App doesn't update when changing language?
- The app should update instantly due to AnimatedBuilder
- If not, check that MainApp is properly wrapped with AppLocaleScope
- Verify AppLocaleController notifyListeners() is called ✓

## Next Steps

1. **Test language switching** on all pages using the language icon
2. **Review all existing strings** in app_localizations.dart
3. **Add any missing translations** using the guide above
4. **Test on different devices** to ensure consistency
5. **Consider RTL support** if needed in future (currently LTR only)

## File Locations

- Main localization: `lib/l10n/app_localizations.dart`
- Language menu button: `lib/widgets/language_menu_button.dart`
- Language settings page: `lib/pages/language_settings_page.dart`
- Main app file: `lib/main.dart`
- Pubspec dependencies: `pubspec.yaml`

## Performance Notes

- Language switching is instant (no network calls)
- Translations are all stored in-memory
- No significant performance impact
- SharedPreferences caches the selection
- App rebuilds only the necessary widgets

---

**Status**: ✅ Fully Implemented and Ready to Use

For questions or issues, refer to this guide or the inline code comments.
