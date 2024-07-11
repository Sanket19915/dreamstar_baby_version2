import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:dream_baby/shared/helper/app_label.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final String? imagePath;
  final bool? imageOnLeftSide;
  final Color? textColor;
  final Color? backgroundColor; // New
  final Color? activeButtonColor;
  final Color? borderColor;
  final double? borderWidth;
  final double? height;
  final double? minWidth;
  final EdgeInsetsGeometry? padding;
  final double? elevation;
  final VoidCallback? onPressed;
  final bool? isEnabled;
  final bool? isLoading;
  final TextStyle? textStyle;
  final double? borderRadius;
  final Color? hoverColor;

  const CustomButton({
    super.key,
    this.text,
    this.icon,
    this.imagePath,
    this.textColor,
    this.backgroundColor = AppColors.primaryColor, // New
    this.borderColor = AppColors.primaryColor,
    this.activeButtonColor = AppColors.primaryColor,
    this.borderWidth,
    this.height,
    this.minWidth,
    this.padding,
    this.elevation,
    this.onPressed,
    this.hoverColor,
    this.isEnabled = true,
    this.isLoading = false,
    this.imageOnLeftSide = true,
    this.textStyle,
    this.borderRadius = 10,
  });

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return isIOS
        ? _buildCupertinoButton(context)
        : _buildMaterialButton(context);
  }

  Widget _buildCupertinoButton(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    const double minHeight = 42.0;

    return Container(
      height: (screenSize.height * 0.050).clamp(minHeight, double.infinity),
      width: screenSize.width * 0.877,
      decoration: BoxDecoration(
        color: isEnabled! ? activeButtonColor : backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius!),
        border: Border.all(color: borderColor ?? AppColors.primaryColor),
      ),
      child: CupertinoButton(
        onPressed: isEnabled! ? onPressed : null,
        borderRadius: BorderRadius.circular(10),
        padding: padding ??
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        minSize: minWidth,
        pressedOpacity: .1,
        child: _buildButtonContent(),
      ),
    );
  }

  Widget _buildMaterialButton(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    const double minHeight = 42.0;
    const double minWidth = 322.0;

    return MaterialButton(
      hoverColor: hoverColor,
      hoverElevation: hoverColor != null ? 0 : null,
      disabledColor: backgroundColor,
      onPressed: isEnabled! ? onPressed : null,
      color: isEnabled! ? activeButtonColor : backgroundColor,
      textColor: textColor,
      shape: RoundedRectangleBorder(
        side: BorderSide(
            color: borderColor ?? AppColors.primaryColor,
            width: borderWidth ?? 0),
        borderRadius: BorderRadius.circular(borderRadius!),
      ),
      elevation: elevation ?? 0,
      height: (height ?? screenSize.height * 0.050)
          .clamp(minHeight, double.infinity),
      minWidth: (screenSize.width * 0.877).clamp(minWidth, double.infinity),
      padding: padding ??
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: _buildButtonContent(),
    );
  }

  Widget _buildButtonContent() {
    final List<Widget> children = [];

    if (imagePath != null && imageOnLeftSide!) {
      children.add(
        Image.asset(
          imagePath!,
          width: 22,
          height: 22,
        ),
      );
      children.add(
        const SizedBox(width: 8.0),
      );
    }

    if (text != null) {
      if (isLoading == null || !isLoading!) {
        children.add(
          Text(
            text!,
            style: textStyle ?? CustomLabels.body3BlackTextStyle(),
          ),
        );
      } else {
        children.add(
          const CircularProgressIndicator(),
        );
      }
    }

    if (imagePath != null && !imageOnLeftSide!) {
      children.add(
        Image.asset(
          imagePath!,
          width: 22,
          height: 22,
        ),
      );
      children.add(
        const SizedBox(width: 8.0),
      );
    }

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}
