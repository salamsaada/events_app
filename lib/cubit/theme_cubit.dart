import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeInitial()) {
    getSavedTheme();
  }

  bool _isDark = true; 
  bool get isDark => _isDark;

  void toggleTheme() async {
    _isDark = !_isDark;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', _isDark);
    
    emit(ThemeChanged(_isDark));
  }

  void getSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool('isDark') ?? true; 
    emit(ThemeChanged(_isDark));
  }
}