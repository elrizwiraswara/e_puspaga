import 'package:flutter/material.dart';

import '../themes/app_colors.dart';
import '../themes/app_text_style.dart';

class AppFilledButton extends StatelessWidget {
  final double? width;
  final double? height;
  final double? fontSize;
  final EdgeInsets padding;
  final bool enable;
  final Color buttonColor;
  final Color disabledButtonColor;
  final Color disabledTextColor;
  final Color textColor;
  final String text;
  final Function() onTap;

  const AppFilledButton({
    super.key,
    this.width,
    this.height = 48,
    this.fontSize,
    this.padding = const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
    this.enable = true,
    this.buttonColor = AppColors.orangeLv1,
    this.disabledButtonColor = AppColors.blackLv2,
    this.disabledTextColor = Colors.white,
    this.textColor = Colors.white,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        onTap: enable ? onTap : null,
        splashColor: Colors.black.withOpacity(0.06),
        splashFactory: InkRipple.splashFactory,
        highlightColor: enable ? Colors.black12 : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
        child: Ink(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            color: enable ? buttonColor : disabledButtonColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              text,
              style: AppTextStyle.bold(
                size: fontSize ?? (height != null ? height! / 3 : 12),
                color: enable ? textColor : disabledTextColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
