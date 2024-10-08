import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_text_style.dart';

class AppTheme {
  AppTheme._();

  static ThemeData appTheme() {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.white,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.orangeLv1,
        onPrimary: AppColors.blackLv1,
        secondary: AppColors.tangerineLv2,
        onSecondary: AppColors.blackLv2,
        error: AppColors.redLv1,
        onError: AppColors.white,
        surface: AppColors.blackLv5,
        onSurface: AppColors.blackLv1,
        shadow: Colors.black.withOpacity(0.06),
      ),
      hintColor: AppColors.blackLv2,
      fontFamily: 'Montserrat',
      primaryColor: AppColors.createMaterialColor(AppColors.orangeLv1),
      primarySwatch: AppColors.createMaterialColor(AppColors.orangeLv1),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      iconTheme: const IconThemeData(
        color: AppColors.blackLv1,
        size: 18,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.blackLv3,
        thickness: 0.5,
        space: 36,
      ),
      appBarTheme: AppBarTheme(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        shadowColor: AppColors.blackLv3,
        titleTextStyle: AppTextStyle.semibold(size: 18),
        titleSpacing: 0,
      ),
    );
  }
}
