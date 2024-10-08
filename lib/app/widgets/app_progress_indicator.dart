import 'package:flutter/material.dart';

import '../themes/app_colors.dart';
import '../themes/app_text_style.dart';

//App Progress Indicator

class AppProgressIndicator extends StatelessWidget {
  final Color? color;
  final Color? textColor;
  const AppProgressIndicator({
    super.key,
    this.color = AppColors.blackLv2,
    this.textColor = AppColors.blackLv2,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: color),
          const SizedBox(height: 14),
          Text(
            'Mohon tunggu',
            style: AppTextStyle.bold(
              size: 10,
              color: textColor,
            ),
          )
        ],
      ),
    );
  }
}
