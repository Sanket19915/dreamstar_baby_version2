import 'dart:convert';
import 'dart:io';

import 'package:dream_baby/features/auth/screens/login.dart';
import 'package:dream_baby/features/setting/screens/faq_screen.dart';
import 'package:dream_baby/features/setting/screens/privacy_policy_screen.dart';
import 'package:dream_baby/features/setting/screens/termsnconditions_screen.dart';
import 'package:dream_baby/router/routes.dart';
import 'package:dream_baby/services/auth_services.dart';
import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:dream_baby/shared/helper/app_images.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Map<String, dynamic> userProfile = {}; // Holds fetched user profile data
  int? userId; // Stores the user ID for delete API
  bool isLoading = true; // Loading state flag

  @override
  void initState() {
    super.initState();
    fetchUserProfile(); // Fetch user profile data on screen initialization
  }

  Future<void> fetchUserProfile() async {
    try {
      var token = await AuthService.getToken();

      // Check if the token is empty
      if (token == null || token.isEmpty) {
        // Handle the case where token is blank
        setState(() {
          isLoading = false;
        });
        return;
      }

      var url = Uri.parse('http://dreambaby.pro/api/profile');
      var response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      // Print response for debugging

      if (response.statusCode == 200) {
        var contentType = response.headers['content-type'];
        if (contentType != null && contentType.contains('application/json')) {
          var data = json.decode(response.body);
          setState(() {
            userProfile = data;
            userId = data['id']; // Store user ID for delete API
            isLoading =
                false; // Set loading state to false after data is fetched
          });
        } else {
          Fluttertoast.showToast(msg: "Something went wrong");
          // Handle non-JSON response
          setState(() {
            isLoading = false; // Set loading state to false
          });
        }
      } else {
        // Handle error
        setState(() {
          isLoading = false; // Set loading state to false
        });
      }
    } catch (e) {
      // Handle error
      setState(() {
        isLoading = false; // Set loading state to false
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 24,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(
            color: AppColors.mainColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: height,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppImages.bg),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 110),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      height: height * 0.2,
                      width: width * 0.5,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(AppImages.propic),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.edit,
                                color: AppColors.mainColor),
                            onPressed: !(isLoading)
                                ? () {
                                    context.push(
                                      Routes.EditProfileScreen,
                                      extra:
                                          userProfile, // Pass userProfile data
                                    );
                                  }
                                : () {},
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildSettingOption('FAQ', Icons.question_answer, () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FAQScreen(),
                      ),
                    );
                  }),
                  _buildSettingOption('Privacy Policy', Icons.privacy_tip, () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PrivacyPolicyScreen(),
                      ),
                    );
                  }),
                  _buildSettingOption('Terms & Conditions', Icons.description,
                      () async {
                    String pdfPath = await _loadPdfFromAsset();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TermsAndConditionsScreen(
                          pdfPath: pdfPath,
                        ),
                      ),
                    );
                  }),
                  _buildSettingOption('Delete my account', Icons.delete, () {
                    _showDeleteConfirmationDialog();
                  }),
                  _buildSettingOption('Logout', Icons.logout, () async {
                    try {
                      await FirebaseAuth.instance.signOut();
                      await AuthService.deleteToken();
                      SessionManager().clearSession(); // Clear session data
                      context.go(Routes.login);
                    } catch (e) {
                      // Handle error as needed
                    }
                  }),
                ],
              ),
            ),
          ),
          if (isLoading)
            const Padding(
              padding: EdgeInsets.only(top: 100),
              child: LinearProgressIndicator(),
            ), // Show LinearProgressIndicator while loading
        ],
      ),
    );
  }

  Widget _buildSettingOption(String title, IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: InkWell(
        onTap: () {
          if (title == 'Logout') {
            _showLogoutConfirmationDialog(onTap);
          } else {
            onTap();
          }
        },
        child: ListTile(
          leading: Icon(icon, color: AppColors.mainColor),
          title: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          trailing:
              const Icon(Icons.arrow_forward_ios, color: AppColors.mainColor),
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog(VoidCallback logoutAction) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: AlertDialog(
            title: const Center(child: Text("Logout")),
            content: const Text("Are you sure you want to logout?"),
            elevation: 5,
            alignment: Alignment.center,
            actionsPadding: const EdgeInsets.only(right: 20),
            actions: <Widget>[
              TextButton(
                child:
                    const Text("Cancel", style: TextStyle(color: Colors.black)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text("Logout",
                    style: TextStyle(color: AppColors.mainColor)),
                onPressed: () {
                  logoutAction();
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Account"),
          content: const Text("Are you sure you want to delete your account?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Delete"),
              onPressed: () {
                _deleteAccount();
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAccount() async {
    try {
      var token = await AuthService.getToken(); // Retrieve token from storage

      // Check if the token is empty
      if (token == null || token.isEmpty) {
        // Handle the case where token is blank
        return;
      }

      if (userId == null) {
        // Handle the case where user ID is not available
        return;
      }

      var url =
          Uri.parse('http://dreambaby.pro/api/auth/delete-account/$userId');
      var response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      // Print response for debugging

      if (response.statusCode == 200) {
        // Account deleted successfully
        // Handle any UI changes or navigations as needed
        // Example: Navigate to login screen after deletion
        context.go(Routes.login);
      } else {
        // Handle error
        // Example: Show error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete account: ${response.reasonPhrase}'),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      // Handle error
      // Example: Show error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting account: $e'),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  Future<String> _loadPdfFromAsset() async {
    final ByteData data = await rootBundle
        .load('assets/pdf/tnc.pdf'); // Replace with your PDF asset path
    final Directory tempDir = await getTemporaryDirectory();
    final File tempFile = File('${tempDir.path}/sample.pdf');
    await tempFile.writeAsBytes(data.buffer.asUint8List(), flush: true);
    return tempFile.path;
  }
}
