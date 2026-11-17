import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

bool _registered = false;

/// Adds the licences of the bundled fonts (SIL OFL 1.1 for Literata, Mona
/// Sans and Monaspace, Apache 2.0 for Material Symbols) to the app's licence
/// page. Call once in `main()`; further calls do nothing.
void registerHorizontLicenses() {
  if (_registered) return;
  _registered = true;
  LicenseRegistry.addLicense(() async* {
    final ofl = await rootBundle.loadString('packages/horizont/fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(const [
      'Literata',
      'Mona Sans',
      'Monaspace',
    ], ofl);
    final symbols = await rootBundle.loadString(
      'packages/horizont/fonts/MaterialSymbols-LICENSE.txt',
    );
    yield LicenseEntryWithLineBreaks(const ['Material Symbols'], symbols);
  });
}
