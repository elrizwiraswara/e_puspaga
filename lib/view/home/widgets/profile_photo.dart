import 'package:app_image/app_image.dart';
import 'package:flutter/material.dart';

import '../../../app/themes/app_assets.dart';
import '../../../app/themes/app_colors.dart';

class ProfilePhoto extends StatelessWidget {
  final double size;
  final String? imgUrl;
  final Function()? onChangeImage;

  const ProfilePhoto({
    super.key,
    required this.size,
    required this.imgUrl,
    this.onChangeImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppColors.blackLv5,
        shape: BoxShape.circle,
      ),
      child: Stack(
        children: [
          SizedBox(
            width: size,
            height: size,
            child: ClipOval(
              child: AppImage(
                image: imgUrl ?? AppAssets.user,
                imgProvider: imgUrl != null
                    ? ImgProvider.networkImage
                    : ImgProvider.assetImage,
              ),
            ),
          ),
          onChangeImage != null
              ? Positioned(
                  right: 4,
                  bottom: 4,
                  child: GestureDetector(
                    onTap: onChangeImage,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: AppColors.tangerineLv1,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(3, 3),
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        color: AppColors.white,
                        size: 12,
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
