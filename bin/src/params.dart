import 'dart:io';

import 'package:locale_gen/locale_gen.dart';

class Params extends LocaleGenParams {
  static const ENV_API_KEY = 'API_KEY_ICAPPS_TRANSLATIONS';

  String? apiKey;

  Params(String programName) : super(programName);

  @override
  void configure(config) {
    super.configure(config);
    apiKey = config['api_key'];

    if (apiKey == null || apiKey?.isEmpty == true) {
      final envVars = Platform.environment;
      apiKey = envVars[ENV_API_KEY];
    }

    final YamlList yamlList = config['languages'];
    if (yamlList == null || yamlList.isEmpty) {
      throw Exception(
          "At least 1 language should be added to the 'languages' section in the pubspec.yaml\n"
          '$icappsTranslationsYaml'
          "  languages: ['en']");
    }

    languages = yamlList.map((item) => item.toString()).toList();
    if (languages == null || languages.isEmpty) {
      throw Exception(
          "At least 1 language should be added to the 'languages' section in the pubspec.yaml\n"
          '$icappsTranslationsYaml'
          "  languages: ['en']");
    }

    defaultLanguage = config['default_language'];
    if (defaultLanguage == null) {
      if (languages.contains('en')) {
        defaultLanguage = 'en';
      } else {
        defaultLanguage = languages[0];
      }
    }
    if (!languages.contains(defaultLanguage)) {
      throw Exception('default language is not included in the languages list');
    }

    localeAssetsDir = config['locale_assets_path'];
    localeAssetsDir ??= defaultAssetsDir;
    if (!localeAssetsDir.endsWith('/')) {
      localeAssetsDir += '/';
    }

    assetsDir = config['assets_path'];
    assetsDir ??= defaultAssetsDir;
    if (!assetsDir.endsWith('/')) {
      assetsDir += '/';
    }
  }
}
