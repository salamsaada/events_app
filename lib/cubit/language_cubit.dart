import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(LanguageInitial()) {
    getSavedLanguage();
  }

  String _languageCode = 'ar';
  String get languageCode => _languageCode;

  void toggleLanguage() async {
    _languageCode = _languageCode == 'ar' ? 'en' : 'ar';

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', _languageCode);

    emit(LanguageChanged(_languageCode));
  }

  void setLanguage(String code) async {
    _languageCode = code;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', _languageCode);

    emit(LanguageChanged(_languageCode));
  }

  void getSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _languageCode = prefs.getString('languageCode') ?? 'ar';
    emit(LanguageChanged(_languageCode));
  }
}
