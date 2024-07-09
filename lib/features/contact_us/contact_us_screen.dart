import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Contact Us',
          style: TextStyle(
              fontWeight: FontWeight.w600, color: AppColors.mainColor),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 110),
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
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
              SizedBox(height: 20),
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
                            final whatsappUrl = 'https://wa.me/918446164585';
                            if (await canLaunch(whatsappUrl)) {
                              await launch(whatsappUrl);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Could not open WhatsApp')),
                              );
                            }
                          },
                        ),
                        Divider(),
                        ContactItem(
                          icon: Icons.phone,
                          text: '+918446164585',
                          onTap: () async {
                            final phoneUrl = 'tel:+918446164585';
                            if (await canLaunch(phoneUrl)) {
                              await launch(phoneUrl);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Could not make the call')),
                              );
                            }
                          },
                        ),
                        Divider(),
                        ContactItem(
                          icon: Icons.web,
                          text: 'www.dreambaby.in',
                          onTap: () async {
                            final websiteUrl = 'https://www.dreambaby.in';
                            if (await canLaunch(websiteUrl)) {
                              await launch(websiteUrl);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('Could not open the website')),
                              );
                            }
                          },
                        ),
                        Divider(),
                        ContactItem(
                          icon: Icons.email,
                          text: 'nehal@yopmail.com',
                          onTap: () async {
                            final emailUrl = 'mailto:nehal@yopmail.com';
                            if (await canLaunch(emailUrl)) {
                              await launch(emailUrl);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
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
            SizedBox(width: 20),
            Expanded(
              child: Text(
                text,
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
