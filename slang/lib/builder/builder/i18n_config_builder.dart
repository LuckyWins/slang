import 'package:slang/builder/model/build_config.dart';
import 'package:slang/builder/model/i18n_config.dart';
import 'package:slang/builder/model/interface.dart';

class I18nConfigBuilder {
  static I18nConfig build({
    required String baseName,
    required BuildConfig buildConfig,
    required List<Interface> interfaces,
  }) {
    return I18nConfig(
      baseName: baseName,
      baseLocale: buildConfig.baseLocale,
      fallbackStrategy: buildConfig.fallbackStrategy,
      outputFormat: buildConfig.outputFormat,
      localeHandling: buildConfig.localeHandling,
      flutterIntegration: buildConfig.flutterIntegration,
      translateVariable: buildConfig.translateVar,
      enumName: buildConfig.enumName,
      translationClassVisibility: buildConfig.translationClassVisibility,
      renderFlatMap: buildConfig.renderFlatMap,
      renderTimestamp: buildConfig.renderTimestamp,
      contexts: buildConfig.contexts,
      interface: interfaces,
      imports: buildConfig.imports,
    );
  }
}
