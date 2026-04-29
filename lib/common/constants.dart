import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const String BASE_IMAGE_URL = 'https://image.tmdb.org/t/p/w500';
const String BASE_BACKDROP_URL = 'https://image.tmdb.org/t/p/w780';

// colors
const Color kRichBlack = Color(0xFF0B0B0F);
const Color kBackgroundSecondary = Color(0xFF121218);
const Color kSurfaceCard = Color(0xFF1A1A22);
const Color kAccentRed = Color(0xFFE50914);
const Color kAccentPressed = Color(0xFFB20710);
const Color kMikadoYellow = Color(0xFFF5C451);
const Color kTextPrimary = Color(0xFFF5F5F5);
const Color kTextSecondary = Color(0xFFB9BBC6);
const Color kBorderSubtle = Color(0xFF2A2A35);
const Color kError = Color(0xFFCF6679);

const Color kOxfordBlue = kBackgroundSecondary;
const Color kPrussianBlue = kAccentRed;
const Color kDavysGrey = kTextSecondary;
const Color kGrey = kBorderSubtle;

// text style
final TextStyle kHeading5 = GoogleFonts.poppins(
  fontSize: 24,
  fontWeight: FontWeight.w600,
  color: kTextPrimary,
);
final TextStyle kHeading6 = GoogleFonts.poppins(
  fontSize: 18,
  fontWeight: FontWeight.w600,
  color: kTextPrimary,
);
final TextStyle kSubtitle = GoogleFonts.poppins(
  fontSize: 14,
  fontWeight: FontWeight.w500,
  color: kTextSecondary,
);
final TextStyle kBodyText = GoogleFonts.poppins(
  fontSize: 13,
  fontWeight: FontWeight.w400,
  color: kTextSecondary,
);

// text theme
final kTextTheme = TextTheme(
  headlineMedium: kHeading5,
  headlineSmall: kHeading6,
  labelMedium: kSubtitle,
  bodyMedium: kBodyText,
  bodySmall: kBodyText.copyWith(fontSize: 12),
  titleLarge: kHeading5,
  titleMedium: kHeading6,
  titleSmall: kSubtitle,
);

const kDrawerTheme = DrawerThemeData(
  backgroundColor: kBackgroundSecondary,
);

const kColorScheme = ColorScheme(
  primary: kAccentRed,
  secondary: kMikadoYellow,
  secondaryContainer: kSurfaceCard,
  surface: kRichBlack,
  error: kError,
  onPrimary: kTextPrimary,
  onSecondary: kRichBlack,
  onSurface: kTextPrimary,
  onError: kTextPrimary,
  brightness: Brightness.dark,
);
