import 'package:slang/builder/builder/build_config_builder.dart';
import 'package:slang/builder/decoder/json_decoder.dart';
import 'package:slang/builder/generator_facade.dart';
import 'package:slang/builder/model/i18n_locale.dart';
import 'package:slang/builder/model/translation_map.dart';
import 'package:test/test.dart';

import '../../util/build_config_utils.dart';
import '../../util/resources_utils.dart';

void main() {
  late String input;
  late String buildYaml;
  late String expectedOutput;

  setUp(() {
    input = loadResource('main/json_simple.json');
    buildYaml = loadResource('main/build_config.yaml');
    expectedOutput = loadResource('main/expected_no_locale_handling.output');
  });

  test('no locale handling', () {
    final result = GeneratorFacade.generate(
      buildConfig: BuildConfigBuilder.fromYaml(buildYaml)!.copyWith(
        renderLocaleHandling: false,
      ),
      baseName: 'translations',
      translationMap: TranslationMap()
        ..addTranslations(
          locale: I18nLocale.fromString('en'),
          translations: JsonDecoder().decode(input),
        ),
    );

    expect(result.joinAsSingleOutput(), expectedOutput);
  });
}
