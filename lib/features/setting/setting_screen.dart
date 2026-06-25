import 'dart:io';

import 'package:dream_baby/core/config/api_config.dart';
import 'package:dream_baby/core/errors/api_exception.dart';
import 'package:dream_baby/core/network/api_client.dart';
import 'package:dream_baby/core/storage/profile_cache.dart';
import 'package:dream_baby/features/setting/screens/privacy_policy_screen.dart';
import 'package:dream_baby/features/setting/screens/termsnconditions_screen.dart';
import 'package:dream_baby/router/routes.dart';
import 'package:dream_baby/services/auth_services.dart';
import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:dream_baby/shared/helper/app_images.dart';
import 'package:dream_baby/shared/widget/loading_overlay.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
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
    if (!await AuthService.hasSession()) {
      if (mounted) {
        setState(() => isLoading = false);
        context.go(Routes.login);
      }
      return;
    }

    try {
      final data = await ApiClient.get(ApiConfig.profile, authenticated: true);
      if (mounted) {
        setState(() {
          userProfile = data;
          userId = (data['id'] as num?)?.toInt();
          isLoading = false;
        });
        await ProfileCache.save(data);
      }
    } on ApiException catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        Fluttertoast.showToast(msg: e.message);
        if (e.statusCode == 401) {
          await AuthService.logout();
          if (mounted) context.go(Routes.login);
        }
      }
    } catch (_) {
      if (mounted) {
        setState(() => isLoading = false);
        Fluttertoast.showToast(msg: 'Failed to load profile');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () => context.pop(true),
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.black, size: 22),
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
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImages.bg),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  _buildProfileAvatar(),
                  const SizedBox(height: 32),
                  _buildSettingsCard(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileAvatar() {
    const size = 108.0;
    final pic = userProfile['profile_pic']?.toString();
    final hasPic = pic != null && pic.isNotEmpty && pic != 'null';

    final ImageProvider avatarImage;
    if (hasPic) {
      avatarImage = NetworkImage(ApiConfig.storageUrl(pic));
    } else {
      avatarImage = const AssetImage(AppImages.propic);
    }

    return GestureDetector(
      onTap: isLoading
          ? null
          : () {
              context.push(Routes.EditProfileScreen, extra: userProfile).then((_) {
                fetchUserProfile();
              });
            },
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
                border: Border.all(
                    color: Colors.black.withValues(alpha: 0.12), width: 1.5),
                image: DecorationImage(
                  image: avatarImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              right: 2,
              bottom: 2,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: AppColors.mainColor.withValues(alpha: 0.2)),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.edit_outlined,
                  size: 17,
                  color: AppColors.mainColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildSettingOption('Privacy Policy', Icons.privacy_tip_outlined, () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()),
            );
          }),
          const Divider(height: 1, indent: 56),
          _buildSettingOption('Terms & Conditions', Icons.description_outlined,
              () async {
            final pdfPath = await _loadPdfFromAsset();
            if (!mounted) return;
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => TermsAndConditionsScreen(pdfPath: pdfPath),
              ),
            );
          }),
          const Divider(height: 1, indent: 56),
          _buildSettingOption('Delete my account', Icons.delete_outline, () {
            _showDeleteConfirmationDialog();
          }),
          const Divider(height: 1, indent: 56),
          _buildSettingOption('Logout', Icons.logout, () async {
            try {
              await FirebaseAuth.instance.signOut();
              await AuthService.logout();
              if (mounted) context.go(Routes.login);
            } catch (_) {}
          }),
        ],
      ),
    );
  }

  Widget _buildSettingOption(String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: () {
        if (title == 'Logout') {
          _showLogoutConfirmationDialog(onTap);
        } else {
          onTap();
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          leading: Icon(icon, color: AppColors.mainColor, size: 24),
          title: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios_rounded,
            color: AppColors.mainColor,
            size: 16,
          ),
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
                child: const Text("Cancel", style: TextStyle(color: Colors.black)),
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
    if (userId == null || !await AuthService.hasSession()) return;

    try {
      await ApiClient.delete(
        ApiConfig.deleteAccountForUser(userId!),
        authenticated: true,
      );
      await AuthService.logout();
      if (mounted) context.go(Routes.login);
    } catch (e) {
      if (!mounted) return;
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
