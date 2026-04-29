import 'package:ditonton/common/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('color scheme and text theme are configured', () {
    expect(BASE_IMAGE_URL, 'https://image.tmdb.org/t/p/w500');
    expect(kRichBlack, const Color(0xFF0B0B0F));
    expect(kOxfordBlue, const Color(0xFF121218));
    expect(kPrussianBlue, const Color(0xFFE50914));
    expect(kMikadoYellow, const Color(0xFFF5C451));
    expect(kColorScheme.primary, kAccentRed);
    expect(kDrawerTheme.backgroundColor, isNotNull);
  });
}
