import 'dart:async';
import 'dart:io';

import 'package:locale_gen/locale_gen.dart';
import 'package:path/path.dart';

import 'src/icapps_translation_downloader.dart';
import 'src/params.dart';

const programName = 'icapps_translations';

Future<void> main(List<String> args) async {
  final params = Params(programName);

  await Future.wait(params.languages
      .map((language) async =>
          IcappsTranslationDownloader.fetchJson(params, language))
      .toList());

  final localeFolder =
      Directory(join(Directory.current.path, params.localeAssetsDir));
  if (!localeFolder.existsSync()) {
    print('${params.localeAssetsDir} folder does not yet exist.');
    print('Creating folder...');
    localeFolder.createSync(recursive: true);
  }

  final useLocaleFiles = params.apiKey == null || params.apiKey.isEmpty;

  if (useLocaleFiles) {
    final path = join(Directory.current.path, localeAssetsDir, '${params.defaultLanguage}.json');
    final file = File(path);

    await file.readAsString()
        .then((fileContents) => json.decode(fileContents))
        .then((translations) {
          defaultTranslations = translations;
        });
  } else {
    await Future.wait(params.languages.map((language) async => _buildJson(language, useLocaleFiles)).toList());
  }

  createLocalizationKeysFile();
  createLocalizationFile();
  createLocalizationDelegateFile();
  print('Done!!!');
  LocaleGenWriter.write(params);
}
