import 'package:flutter/material.dart';

/// 应用颜色定义
class AppColors {
  // 主色调
  static const Color primary = Color(0xFF2196F3);
  static const Color primaryDark = Color(0xFF1976D2);
  static const Color primaryLight = Color(0xFFBBDEFB);
  
  // 辅助色
  static const Color secondary = Color(0xFF03DAC6);
  static const Color secondaryDark = Color(0xFF018786);
  static const Color secondaryLight = Color(0xFFB2DFDB);
  
  // 背景色
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F5F5);
  
  // 文字颜色
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSecondary = Color(0xFF000000);
  static const Color onBackground = Color(0xFF212121);
  static const Color onSurface = Color(0xFF212121);
  
  // 文字颜色变体
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
  static const Color textDisabled = Color(0xFF9E9E9E);
  
  // 状态颜色
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
  
  // 边框颜色
  static const Color border = Color(0xFFE0E0E0);
  static const Color borderFocus = Color(0xFF2196F3);
  static const Color borderError = Color(0xFFF44336);
  
  // 阴影颜色
  static const Color shadow = Color(0x1F000000);
  static const Color shadowLight = Color(0x0F000000);
  
  // 分割线颜色
  static const Color divider = Color(0xFFE0E0E0);
  
  // 输入框颜色
  static const Color inputFill = Color(0xFFF5F5F5);
  static const Color inputBorder = Color(0xFFE0E0E0);
  static const Color inputFocusBorder = Color(0xFF2196F3);
  static const Color inputErrorBorder = Color(0xFFF44336);
  
  // 按钮颜色
  static const Color buttonPrimary = Color(0xFF2196F3);
  static const Color buttonSecondary = Color(0xFFE0E0E0);
  static const Color buttonDisabled = Color(0xFFBDBDBD);
  
  // 卡片颜色
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardShadow = Color(0x1F000000);
  
  // 覆盖层颜色
  static const Color overlay = Color(0x80000000);
  static const Color overlayLight = Color(0x40000000);
  
  // 透明度变体
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }
  
  // 获取颜色的浅色版本
  static Color getLightColor(Color color) {
    return Color.lerp(color, Colors.white, 0.8) ?? color;
  }
  
  // 获取颜色的深色版本
  static Color getDarkColor(Color color) {
    return Color.lerp(color, Colors.black, 0.2) ?? color;
  }
}
