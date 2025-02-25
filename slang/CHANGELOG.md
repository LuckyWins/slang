## 2.6.1

- fix: remove `const` if rich text has links

## 2.6.0

- feat: render context enum values as is, instead of forcing to camel case
- feat: add additional lint ignores to generated file
- fix: generate correct ordinal (plural) call
- fix: handle rich texts containing linked translations

## 2.5.0

- feat: add extension method shorthand (e.g. `context.tr.someKey.anotherKey`)
- feat: add `LocaleSettings.getLocaleStream` to keep track of every locale change
- feat: return more specific `TextSpan` instead of `InlineSpan` for rich texts

## 2.4.1

- fix: do not export `package:flutter/widgets.dart`

## 2.4.0

- feat: allow external enums for context feature (add `generate_enum` and `imports` config)
- feat: add default context parameter name (`default_parameter`)
- feat: add export statement in generated file to avoid imports of extension methods

## 2.3.1

- fix: add missing fallback for flat map if configured

## 2.3.0

- feat: use tight version for `slang_flutter` and `slang_build_runner`
- fix: throw error if base locale not found
- fix: `TranslationProvider` should use current locale
- fix: use more strict locale regex to avoid false-positives when detecting locale of directory name

## 2.2.0

- feat: locale can be moved from file name to directory name (e.g. `i18n/fr/page1_fr.i18n.json` to `i18n/fr/page1.i18n.json`)

## 2.1.0

- feat: add `slang.yaml` support which has less boilerplate than `build.yaml`
- fix: move internal `build.yaml` to correct package

## 2.0.0

**Transition to a federated package structure**

- **Breaking:** rebranding to `slang`
- **Breaking:** add `slang_build_runner`, `slang_flutter` depending on your use case
- **Breaking:** remove `output_file_pattern` (was deprecated)
- feat: dart-only support (`flutter_integration: false`)
- feat: multiple package support
- feat: RichText support

Thanks to [@fzyzcjy](https://github.com/fzyzcjy).

You can read the detailed migration guide [here](https://github.com/Tienisto/slang/blob/master/slang/MIGRATION.md).
