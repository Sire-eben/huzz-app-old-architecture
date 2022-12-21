import 'package:google_fonts/google_fonts.dart';
import "package:flutter/material.dart";

class AppColors {
  AppColors._();
  static const Color lightbackgroundColor = Color(0xffE6F4F2);
  static const Color orangeBorderColor = Color(0xFFEF6500);
  static const Color primaryColor = Color(0xff07A58E);
  static const Color backgroundColor = Color(0xff07A58E);
  static const Color secondbgColor = Color(0xff0D8372);
  static const Color orangeColor = Color(0xffF4D8C4);
  static const Color whiteColor = Color(0xffffffff);
  static const Color blackColor = Color(0xff000000);
  static const Color purpleColor = Color(0xff881583);
  static const Color hintColor = Color(0xffC4C4C4);
  static const Color wineColor = Color(0xffC82525);
  static const Color blueColor = Color(0xff0065D3);
  static const Color lightblueColor = Color(0xff56718E);
  static const Color brownColor = Color(0xffA0616A);
  static const Color error = Color(0xffEF6500);
}

class AppThemes {
  AppThemes._();

  static TextStyle style12PriBold = GoogleFonts.inter(
    color: Color(0xff07A58E),
    fontStyle: FontStyle.normal,
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

  static ThemeData _baseTheme(BuildContext context) => ThemeData(
        fontFamily: Fonts.primary,
        primaryColor: AppColors.primaryColor,
        indicatorColor: AppColors.primaryColor,
        scaffoldBackgroundColor: AppColors.whiteColor,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.white),
            backgroundColor: MaterialStateProperty.all(AppColors.primaryColor),
            elevation: MaterialStateProperty.all(0),
            padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(
                vertical: Insets.xs,
                horizontal: Insets.md,
              ),
            ),
            shadowColor: MaterialStateProperty.all(Colors.transparent),
            shape: MaterialStateProperty.all(
              const RoundedRectangleBorder(
                borderRadius: Corners.xsBorder,
              ),
            ),
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primaryColor,
          unselectedItemColor: AppColors.primaryColor.withOpacity(0.8),
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
        ),
        iconTheme: const IconThemeData(
          color: AppColors.primaryColor,
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.primaryColor,
        ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontSize: 16,
            color: Colors.black,
            // fontWeight: FontWeight.w700,
            fontFamily: Fonts.primary,
          ),
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: AppColors.whiteColor,
          elevation: 0.0,
          centerTitle: false,
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: AppColors.primaryColor,
          textTheme: ButtonTextTheme.accent,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          fillColor: Colors.white,
          contentPadding:
              EdgeInsets.symmetric(vertical: Insets.sm, horizontal: 10.0),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.primaryColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryColor),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.error),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(),
          ),
          labelStyle: TextStyle(color: AppColors.primaryColor),
          hintStyle: TextStyle(color: AppColors.primaryColor),
        ),
      );

  static ThemeData defaultTheme(BuildContext context) =>
      _baseTheme(context).copyWith(brightness: Brightness.light);
}

class Fonts {
  static const primary = "primary_font";
}

class Insets {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double bottomOffset = 64;
}

class Shadows {
  static bool enabled = true;

  static double get mRadius => 8;

  static List<BoxShadow> m(Color color, [double? opacity = 0]) {
    return [
      BoxShadow(
        color: color.withOpacity(opacity ?? .03),
        blurRadius: mRadius,
        spreadRadius: mRadius / 2,
        offset: const Offset(1, 0),
      ),
      BoxShadow(
        color: color.withOpacity(opacity ?? .04),
        blurRadius: mRadius / 2,
        spreadRadius: mRadius / 4,
        offset: const Offset(1, 0),
      )
    ];
  }

  static List<BoxShadow> get universal => [
        BoxShadow(
            color: const Color(0xff333333).withOpacity(.15),
            spreadRadius: 0,
            blurRadius: 10),
      ];
  static List<BoxShadow> get small => [
        BoxShadow(
            color: const Color(0xff333333).withOpacity(.15),
            spreadRadius: 0,
            blurRadius: 3,
            offset: const Offset(0, 1)),
      ];
}

class Corners {
  static const Radius xsRadius = Radius.circular(Insets.xs);
  static const BorderRadius xsBorder = BorderRadius.all(xsRadius);

  static const Radius smRadius = Radius.circular(Insets.sm);
  static const BorderRadius smBorder = BorderRadius.all(smRadius);

  static const Radius mdRadius = Radius.circular(Insets.md);
  static const BorderRadius mdBorder = BorderRadius.all(mdRadius);

  static const Radius lgRadius = Radius.circular(Insets.lg);
  static const BorderRadius lgBorder = BorderRadius.all(lgRadius);

  static const Radius xlRadius = Radius.circular(50);
  static const BorderRadius xlBorder = BorderRadius.all(xlRadius);

  static const Radius zRadius = Radius.circular(0);
  static const BorderRadius zBorder = BorderRadius.zero;
}

class FontSizes {
  static const double xs = 9;
  static const double sm = 13;
  static const double md = 15;
  static const double lg = 18;
}

class IconSizes {
  static const double xs = 15;
  static const double sm = 18;
  static const double md = 24;
  static const double lg = 32;
}

class TextStyles {
  ///h3
  static const TextStyle h1 =
      TextStyle(fontSize: 24, fontWeight: FontWeight.w700);

  ///h2
  static const TextStyle h2 =
      TextStyle(fontSize: 32, fontWeight: FontWeight.w700);

  ///big-title
  static const TextStyle h3 =
      TextStyle(fontSize: 20, fontWeight: FontWeight.w700);

  static const TextStyle h4 =
      TextStyle(fontSize: 18, fontWeight: FontWeight.w700);

  static const TextStyle h5 =
      TextStyle(fontSize: 13, fontWeight: FontWeight.w700);

  ///title
  static const TextStyle t1 =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w700);

  ///paragraph
  static const TextStyle t2 = TextStyle(
      fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xff1D1E25));

  ///small-text
  static const TextStyle t3 = TextStyle(
      fontSize: 12, fontWeight: FontWeight.w400, color: Color(0xff808D9E));

  ///big-button
  static const TextStyle b1 =
      TextStyle(fontWeight: FontWeight.w700, fontSize: 14);

  ///small-button
  static const TextStyle b2 =
      TextStyle(fontWeight: FontWeight.w600, fontSize: 12);
}
