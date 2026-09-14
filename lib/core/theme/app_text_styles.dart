import 'package:flutter/widgets.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';

/// Typography tokens. No fontFamily is set, so the platform's system font is
/// used (SF Pro on Apple devices, Roboto on Android and web) until the client
/// provides brand fonts.
abstract final class AppTextStyles {
  static const display = TextStyle(
    fontSize: 28,
    height: 1.2,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.4,
    color: AppColors.textPrimary,
  );

  static const title = TextStyle(
    fontSize: 20,
    height: 1.25,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const subtitle = TextStyle(
    fontSize: 16,
    height: 1.3,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const body = TextStyle(
    fontSize: 14,
    height: 1.4,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const bodyStrong = TextStyle(
    fontSize: 14,
    height: 1.35,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const bodySecondary = TextStyle(
    fontSize: 14,
    height: 1.4,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const label = TextStyle(
    fontSize: 12,
    height: 1.2,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const caption = TextStyle(
    fontSize: 12,
    height: 1.3,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const price = TextStyle(
    fontSize: 15,
    height: 1.2,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const button = TextStyle(
    fontSize: 15,
    height: 1.2,
    fontWeight: FontWeight.w600,
    color: AppColors.onPrimary,
  );

  static const badge = TextStyle(
    fontSize: 11,
    height: 1,
    fontWeight: FontWeight.w700,
    color: AppColors.onPrimary,
  );
}
