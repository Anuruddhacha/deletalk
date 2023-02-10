

import 'package:app1/models/language_model.dart';

class AppConstants{


static const String COUNTRY_CODE = "country_code";
static const String LANGUAGE_CODE = "language_code";


static List<LanguageModel> languages = [
LanguageModel(imgUrl: "en.png", languageName: "English", languageCode: "en", countryCode: "US"),
LanguageModel(imgUrl: "ko.png", languageName: "Korean", languageCode: "ko", countryCode: "KR")
];






}