import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/services/firebase/auth/auth_service.dart';
import '../../../app/services/locator/locator.dart';
import '../../../app/themes/app_colors.dart';
import '../../../app/themes/app_text_style.dart';
import '../../../app/widgets/app_dialog.dart';
import '../../../app/widgets/app_outlined_button.dart';
import '../../../view_model/profile_view_model.dart';
import '../../profile/edit_profile_view.dart';
import 'profile_photo.dart';

class ProfileCard extends StatelessWidget {
  final bool expand;
  const ProfileCard({super.key, this.expand = false});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(builder: (context, model, _) {
      return Container(
        constraints: expand
            ? null
            : const BoxConstraints(
                maxWidth: 356,
              ),
        child: AppOutlinedButton(
          height: null,
          padding: const EdgeInsets.all(32),
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ProfilePhoto(
                    size: 60,
                    imgUrl: model.user.imageUrl,
                    onChangeImage: () {
                      final navigator = Navigator.of(context);
                      model.onTapEditPhoto(navigator);
                    },
                  ),
                  const SizedBox(width: 18),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Halo!',
                        style: AppTextStyle.medium(size: 14),
                      ),
                      Text(
                        model.user.name ?? '(Tanpa nama)',
                        style: AppTextStyle.bold(size: 20),
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(height: 32),
              model.user.role == 0
                  ? const SizedBox.shrink()
                  : editProfileButton(context),
              signOutButton(context),
            ],
          ),
        ),
      );
    });
  }

  Widget editProfileButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          EditProfileView.routeName,
          arguments: false,
        );
      },
      child: Container(
        color: Colors.transparent,
        margin: const EdgeInsets.only(bottom: 18),
        child: Row(
          children: [
            const Icon(
              Icons.person,
              color: AppColors.tangerineLv1,
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              'Edit Profile',
              style: AppTextStyle.bold(
                size: 14,
                color: AppColors.tangerineLv1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget signOutButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppDialog.showDialog(
          title: 'Sign Out',
          text: 'Apakah Anda yakin ingin keluar akun?',
          leftButtonText: 'Batal',
          rightButtonText: 'Keluar',
          onTapRightButton: () async {
            final navigator = Navigator.of(context);
            final auth = locator<AuthService>();

            await auth.signOut(navigator);
          },
        );
      },
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: [
            const Icon(
              Icons.exit_to_app,
              color: AppColors.tangerineLv1,
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              'Sign Out',
              style: AppTextStyle.bold(
                size: 14,
                color: AppColors.tangerineLv1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
