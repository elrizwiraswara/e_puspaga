import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../themes/app_colors.dart';
import '../themes/app_text_style.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final bool enabled;
  final bool autofocus;
  final bool obscureText;
  final double fontSize;
  final int? minLines;
  final int maxLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? hintText;
  final String? labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final EdgeInsets contentPadding;
  final Color fillColor;
  final Color disabledFillColor;
  final Function(String text)? onChanged;
  final Function(String text)? onSubmitted;
  final Function()? onEditingComplete;
  final Function()? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final bool showCounter;
  final bool showBorder;

  const AppTextField({
    super.key,
    this.controller,
    this.enabled = true,
    this.autofocus = false,
    this.obscureText = false,
    this.fontSize = 14,
    this.minLines,
    this.maxLines = 1,
    this.maxLength,
    this.keyboardType,
    this.textInputAction,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 16,
    ),
    this.fillColor = AppColors.blackLv5,
    this.disabledFillColor = Colors.white,
    this.onSubmitted,
    this.onChanged,
    this.onEditingComplete,
    this.onTap,
    this.inputFormatters,
    this.showCounter = false,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        labelText != null && labelText != ''
            ? Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  labelText!,
                  style: AppTextStyle.bold(size: fontSize - 2),
                ),
              )
            : const SizedBox.shrink(),
        GestureDetector(
          onTap: onTap,
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            onEditingComplete: onEditingComplete,
            onSubmitted: onSubmitted,
            enabled: enabled,
            style: AppTextStyle.semibold(size: fontSize),
            cursorColor: AppColors.blackLv1,
            cursorWidth: 1.5,
            autofocus: autofocus,
            obscureText: obscureText,
            minLines: minLines,
            maxLines: maxLines,
            maxLength: maxLength,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              counterText: showCounter ? null : '',
              isDense: true,
              filled: true,
              fillColor: enabled ? fillColor : disabledFillColor,
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              hintText: hintText,
              hintStyle: AppTextStyle.medium(
                size: fontSize,
                color: AppColors.blackLv2,
              ),
              contentPadding: contentPadding,
              focusedBorder: showBorder
                  ? const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4.0),
                      ),
                      borderSide: BorderSide(
                        width: 1,
                        color: AppColors.blackLv3,
                      ),
                    )
                  : InputBorder.none,
              enabledBorder: showBorder
                  ? const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4.0),
                      ),
                      borderSide: BorderSide(
                        width: 0.5,
                        color: AppColors.blackLv3,
                      ),
                    )
                  : InputBorder.none,
              disabledBorder: showBorder
                  ? const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4.0),
                      ),
                      borderSide: BorderSide(
                        width: 0.5,
                        color: AppColors.blackLv3,
                      ),
                    )
                  : InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
