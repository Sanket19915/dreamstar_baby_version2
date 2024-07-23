import 'package:dream_baby/shared/helper/app_images.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AmazonLinkWidget extends StatelessWidget {
  final double height;
  final double width;

  const AmazonLinkWidget(
      {super.key, required this.height, required this.width});

  Future<void> _launchAmazon() async {
    const amazonAppUrl = 'com.amazon.mobile.shopping://www.amazon.com';
    const amazonWebUrl = 'https://www.amazon.com';

    if (await canLaunchUrl(Uri.parse(amazonAppUrl))) {
      await launchUrl(Uri.parse(amazonAppUrl));
    } else if (await canLaunchUrl(Uri.parse(amazonWebUrl))) {
      await launchUrl(Uri.parse(amazonWebUrl));
    } else {
      throw 'Could not launch Amazon';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // onTap: _launchAmazon,
      child: Container(
        height: height * 0.150,
        width: width,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(AppImages.productPic), fit: BoxFit.cover),
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
      ),
    );
  }
}
