import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatelessWidget {
  Future<bool> launchUrl(Uri uri) async {
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Contact Us',
          style: TextStyle(
              fontWeight: FontWeight.w600, color: AppColors.mainColor),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 110),
        height: height,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.png'), // Your background image
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Lottie Animation
              Lottie.asset(
                'assets/images/lottie.json', // Your Lottie animation file
                width: 300,
                height: 250,
                fit: BoxFit.scaleDown,
              ),
              const SizedBox(height: 20),
              // Contact Information
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        ContactItem(
                          icon: Icons.chat,
                          text: 'Chat with Us',
                          onTap: () async {
                            final whatsappUrl =
                                Uri.parse('https://wa.me/917030962300');
                            if (await canLaunchUrl(whatsappUrl)) {
                              await launchUrl(whatsappUrl);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Could not open WhatsApp')),
                              );
                            }
                          },
                        ),
                        const Divider(),
                        ContactItem(
                          icon: Icons.phone,
                          text: '+917030962300',
                          onTap: () async {
                            final phoneUrl = Uri.parse('tel:+917030962300');
                            if (await launchUrl(phoneUrl)) {
                              await launchUrl(phoneUrl);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Could not make the call')),
                              );
                            }
                          },
                        ),
                        const Divider(),
                        ContactItem(
                          icon: Icons.web,
                          text: 'www.dreamstarbaby.in',
                          onTap: () async {
                            final websiteUrl =
                                Uri.parse('https://www.dreamstarbaby.in');
                            if (await canLaunchUrl(websiteUrl)) {
                              await launchUrl(websiteUrl);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Could not open the website')),
                              );
                            }
                          },
                        ),
                        const Divider(),
                        ContactItem(
                          icon: Icons.email,
                          text: 'contact@sonalijainjayaswal.com',
                          onTap: () async {
                            final emailUrl = Uri.parse(
                                'mailto:contact@sonalijainjayaswal.com');
                            if (await canLaunchUrl(emailUrl)) {
                              await launchUrl(emailUrl);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Could not send the email')),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContactItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function() onTap;

  const ContactItem({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          children: [
            Icon(icon, size: 30, color: Colors.black),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
