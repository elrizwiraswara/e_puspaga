import 'package:flutter/material.dart';

import '../themes/app_colors.dart';
import '../themes/app_text_style.dart';

class AppOutlinedButton extends StatelessWidget {
  final double? width;
  final double? height;
  final double? fontSize;
  final Color borderColor;
  final double borderRadius;
  final EdgeInsets padding;
  final bool enable;
  final Color buttonColor;
  final Color textColor;
  final String? text;
  final Widget? child;
  final Alignment alignment;
  final Function()? onTap;

  const AppOutlinedButton({
    super.key,
    this.width,
    this.height = 48,
    this.fontSize,
    this.borderColor = AppColors.blackLv3,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.borderRadius = 4,
    this.enable = true,
    this.buttonColor = AppColors.blackLv6,
    this.textColor = AppColors.blackLv1,
    this.text,
    this.child,
    this.alignment = Alignment.center,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        onTap: enable ? onTap : null,
        splashColor: Colors.black.withOpacity(0.06),
        splashFactory: InkRipple.splashFactory,
        highlightColor: enable ? AppColors.blackLv4 : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
        child: Ink(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            color: enable ? buttonColor : Colors.white,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              width: 0.5,
              color: borderColor,
            ),
          ),
          child: Align(
            alignment: alignment,
            child: child ??
                Text(
                  text ?? '',
                  style: AppTextStyle.bold(
                    size: fontSize ?? (height != null ? (height! / 3) : 12),
                    color: textColor,
                  ),
                ),
          ),
        ),
      ),
    );
  }
}
