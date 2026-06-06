import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/localization/app_localizations.dart';

enum AppLanguage {
  english('en'),
  amharic('am'),
  tigrigna('ti'),
  oromo('om');

  final String code;
  const AppLanguage(this.code);

  String get displayName {
    switch (this) {
      case AppLanguage.english: return 'English';
      case AppLanguage.amharic: return 'አማርኛ';
      case AppLanguage.tigrigna: return 'ትግርኛ';
      case AppLanguage.oromo: return 'Afaan Oromoo';
    }
  }
}

class LanguageNotifier extends StateNotifier<AppLanguage> {
  LanguageNotifier() : super(AppLanguage.english) {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final idx = prefs.getInt('app_language_index');
    if (idx != null && idx >= 0 && idx < AppLanguage.values.length) {
      state = AppLanguage.values[idx];
    }
  }

  Future<void> setLanguage(AppLanguage language) async {
    state = language;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('app_language_index', language.index);
  }
}

final languageProvider = StateNotifierProvider<LanguageNotifier, AppLanguage>((ref) {
  return LanguageNotifier();
});

final localizationsProvider = Provider<AppLocalizations>((ref) {
  return AppLocalizations(ref.watch(languageProvider));
});
