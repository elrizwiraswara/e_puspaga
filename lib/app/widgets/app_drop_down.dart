import 'package:flutter/material.dart';

import '../themes/app_colors.dart';
import '../themes/app_text_style.dart';

class AppDropDown extends StatelessWidget {
  final dynamic selectedValue;
  final List<DropdownMenuItem<dynamic>> dropdownItems;
  final Function(dynamic) onChanged;
  final bool enabled;
  final String? labelText;
  final double borderRadius;

  const AppDropDown({
    super.key,
    this.selectedValue,
    required this.dropdownItems,
    required this.onChanged,
    this.enabled = true,
    this.labelText,
    this.borderRadius = 4.0,
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
                  style: AppTextStyle.bold(size: 12),
                ),
              )
            : const SizedBox.shrink(),
        DropdownButtonFormField<dynamic>(
          value: selectedValue,
          onChanged: onChanged,
          items: dropdownItems,
          style: AppTextStyle.semibold(size: 14),
          icon: enabled
              ? const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.blackLv2,
                  size: 22,
                )
              : const SizedBox.shrink(),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          decoration: InputDecoration(
            enabled: enabled,
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(borderRadius),
              ),
              borderSide: const BorderSide(
                width: 0.5,
                color: AppColors.blackLv3,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(borderRadius),
              ),
              borderSide: const BorderSide(
                width: 0.5,
                color: AppColors.blackLv3,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(borderRadius),
              ),
              borderSide: const BorderSide(
                width: 0.5,
                color: AppColors.blackLv3,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(borderRadius),
              ),
              borderSide: const BorderSide(
                width: 0.5,
                color: AppColors.blackLv3,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
