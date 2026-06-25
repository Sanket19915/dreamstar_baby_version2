import 'dart:io';

import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:flutter/material.dart';

class ProfileAvatarPicker extends StatelessWidget {
  final File? image;
  final VoidCallback onTap;
  final double size;

  const ProfileAvatarPicker({
    super.key,
    required this.image,
    required this.onTap,
    this.size = 100,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondaryTextColor.withValues(alpha: 0.25),
                border: Border.all(
                  color: AppColors.secondaryTextColor.withValues(alpha: 0.4),
                  width: 1.5,
                ),
                image: image != null
                    ? DecorationImage(
                        image: FileImage(image!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
            ),
            if (image == null)
              Icon(
                Icons.add_photo_alternate_outlined,
                size: size * 0.36,
                color: AppColors.whiteColor,
              )
            else
              Positioned(
                right: 4,
                bottom: 4,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.edit_outlined,
                    color: AppColors.whiteColor,
                    size: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
