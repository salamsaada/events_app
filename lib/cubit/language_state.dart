part of 'language_cubit.dart';

abstract class LanguageState {}

class LanguageInitial extends LanguageState {}

class LanguageChanged extends LanguageState {
  final String languageCode;

  LanguageChanged(this.languageCode);
}
