import 'package:slang/builder/utils/regex_utils.dart';
import 'package:test/test.dart';

void main() {
  group('fileWithLocaleRegex', () {
    RegExp regex = RegexUtils.fileWithLocaleRegex;

    test('strings_en', () {
      RegExpMatch? match = regex.firstMatch('strings_en');
      expect(match?.group(1), 'strings'); // base name
      expect(match?.group(2), 'en'); // language
      expect(match?.group(3), null);
      expect(match?.group(4), null);
    });

    test('strings_en_US', () {
      RegExpMatch? match = regex.firstMatch('strings_en_US');
      expect(match?.group(1), 'strings'); // base name
      expect(match?.group(2), 'en');
      expect(match?.group(3), null);
      expect(match?.group(4), 'US');
    });

    test('translations_en-US', () {
      RegExpMatch? match = regex.firstMatch('translations_en-US');
      expect(match?.group(1), 'translations'); // base name
      expect(match?.group(2), 'en');
      expect(match?.group(3), null);
      expect(match?.group(4), 'US');
    });

    test('strings_zh-Hant-TW', () {
      RegExpMatch? match = regex.firstMatch('strings_zh-Hant-TW');
      expect(match?.group(1), 'strings'); // base name
      expect(match?.group(2), 'zh');
      expect(match?.group(3), 'Hant');
      expect(match?.group(4), 'TW');
    });

    test('strings_CN', () {
      RegExpMatch? match = regex.firstMatch('strings_CN');
      expect(match, null);
    });
  });

  group('localeRegex', () {
    RegExp regex = RegexUtils.localeRegex;

    test('en', () {
      RegExpMatch? match = regex.firstMatch('en');
      expect(match?.group(1), 'en');
    });

    test('en_US', () {
      RegExpMatch? match = regex.firstMatch('en_US');
      expect(match?.group(1), 'en');
      expect(match?.group(3), 'US');
    });

    test('en-US', () {
      RegExpMatch? match = regex.firstMatch('en-US');
      expect(match?.group(1), 'en');
      expect(match?.group(3), 'US');
    });

    test('zh-Hant-TW', () {
      RegExpMatch? match = regex.firstMatch('zh-Hant-TW');
      expect(match?.group(1), 'zh');
      expect(match?.group(2), 'Hant');
      expect(match?.group(3), 'TW');
    });
  });

  group('baseFileRegex', () {
    RegExp regex = RegexUtils.baseFileRegex;

    test('strings', () {
      RegExpMatch? match = regex.firstMatch('strings');
      expect(match?.group(1), 'strings');
    });

    test('translations', () {
      RegExpMatch? match = regex.firstMatch('translations');
      expect(match?.group(1), 'translations');
    });

    test('strings_', () {
      RegExpMatch? match = regex.firstMatch('strings_');
      expect(match?.group(1), null);
    });
  });

  group('attributeRegex', () {
    RegExp regex = RegexUtils.attributeRegex;

    test('String title', () {
      RegExpMatch? match = regex.firstMatch('String title');
      expect(match?.group(1), 'String');
      expect(match?.group(3), null);
      expect(match?.group(4), 'title');
      expect(match?.group(5), null);
    });

    test('String? title', () {
      RegExpMatch? match = regex.firstMatch('String? title');
      expect(match?.group(1), 'String');
      expect(match?.group(3), isNotNull);
      expect(match?.group(4), 'title');
      expect(match?.group(5), null);
    });

    test('String title(a,b,c)', () {
      RegExpMatch? match = regex.firstMatch('String title(a,b,c)');
      expect(match?.group(1), 'String');
      expect(match?.group(3), null);
      expect(match?.group(4), 'title');
      expect(match?.group(5), '(a,b,c)');
    });

    test('Map<String,Page>? pages(count)', () {
      RegExpMatch? match = regex.firstMatch('Map<String,Page>? pages(count)');
      expect(match?.group(1), 'Map<String,Page>');
      expect(match?.group(3), isNotNull);
      expect(match?.group(4), 'pages');
      expect(match?.group(5), '(count)');
    });
  });

  group('genericRegex', () {
    RegExp regex = RegexUtils.genericRegex;

    test('List<String>', () {
      RegExpMatch? match = regex.firstMatch('List<String>');
      expect(match?.group(1), 'String');
    });

    test('List<List<String>>', () {
      RegExpMatch? match = regex.firstMatch('List<List<String>>');
      expect(match?.group(1), 'List<String>');
    });

    test('List<List<String>', () {
      RegExpMatch? match = regex.firstMatch('List<List<String>');
      expect(match?.group(1), 'List<String');
    });
  });

  group('paramHintRegex', () {
    RegExp regex = RegexUtils.paramHintRegex;

    test('some_key', () {
      RegExpMatch? match = regex.firstMatch('some_key');
      expect(match, null);
    });

    test('some_key(abc)', () {
      RegExpMatch? match = regex.firstMatch('some_key(abc)');
      expect(match?.group(1), 'abc');
    });

    test('myKey(cool_parameter)', () {
      RegExpMatch? match = regex.firstMatch('myKey(cool_parameter)');
      expect(match?.group(1), 'cool_parameter');
    });

    test('my key(cool_parameter)', () {
      RegExpMatch? match = regex.firstMatch('my key(cool_parameter)');
      expect(match, null);
    });
  });

  group('arbComplexNode', () {
    RegExp regex = RegexUtils.arbComplexNode;

    test('single plural', () {
      RegExpMatch? match = regex.firstMatch('{count,plural,abc{aa}}');
      expect(match?.group(1), 'count');
      expect(match?.group(2), 'plural');
      expect(match?.group(3), 'abc{aa}');
    });

    test('with spaces', () {
      RegExpMatch? match = regex.firstMatch('{count, plural,  abc{aa}}');
      expect(match?.group(1), 'count');
      expect(match?.group(2), ' plural');
      expect(match?.group(3), '  abc{aa}');
    });

    test('content has commas', () {
      RegExpMatch? match =
          regex.firstMatch('{count, plural, abc{a,a,} =efg{bb}}');
      expect(match?.group(1), 'count');
      expect(match?.group(2), ' plural');
      expect(match?.group(3), ' abc{a,a,} =efg{bb}');
    });
  });

  group('arbComplexNodeContent', () {
    RegExp regex = RegexUtils.arbComplexNodeContent;

    test('plain', () {
      RegExpMatch? match = regex.firstMatch('aa{bb}');
      expect(match?.group(1), 'aa');
      expect(match?.group(2), 'bb');
    });

    test('with equals', () {
      RegExpMatch? match = regex.firstMatch('=aa{bb}');
      expect(match?.group(1), '=aa');
      expect(match?.group(2), 'bb');
    });

    test('with parameters', () {
      RegExpMatch? match = regex.firstMatch('=aa{bb {hello} yeah {hi}}');
      expect(match?.group(1), '=aa');
      expect(match?.group(2), 'bb {hello} yeah {hi}');
    });
  });
}
