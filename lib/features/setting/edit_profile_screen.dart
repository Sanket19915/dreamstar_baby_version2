// edit_profile_screen.dart

import 'dart:io';

import 'package:dream_baby/core/config/api_config.dart';
import 'package:dream_baby/core/network/api_client.dart';
import 'package:dream_baby/services/auth_services.dart';
import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:dream_baby/shared/helper/app_images.dart';
import 'package:dream_baby/shared/helper/app_label.dart';
import 'package:dream_baby/shared/widget/custom_button.dart';
import 'package:dream_baby/shared/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../auth/screens/more_details.dart';

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userProfile;

  const EditProfileScreen({
    super.key,
    required this.userProfile,
  });

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController eddController;
  // final TextEditingController passwordController = TextEditingController();
  // final TextEditingController confirmPasswordController =
  //     TextEditingController();

  File? _profileImage;
  DateTime? selectedDate;

  bool isLoading = false;
  bool isFirstNameValid = false;
  bool isLastNameValid = false;
  bool isPhoneValid = false;
  bool isEmailValid = false;
  bool isPasswordValid = false;
  bool isConfirmPasswordValid = false;
  DetailType selectType = DetailType.EDD;
  bool isSelected = true;
  bool get isFormValid {
    return isFirstNameValid && isLastNameValid && isPhoneValid && isEmailValid
        // &&
        //     ((_profileImage?.path.isNotEmpty ?? false) ||
        //         widget.userProfile['profile_pic'] != null)
        //  &&
        // isPasswordValid &&
        // isConfirmPasswordValid
        ;
  }

  bool get _hasEddOrLmp {
    final eed = widget.userProfile['eed']?.toString().trim();
    final lmp = widget.userProfile['lmp']?.toString().trim();
    return (eed != null && eed.isNotEmpty && eed != 'null') ||
        (lmp != null && lmp.isNotEmpty && lmp != 'null');
  }

  String? get _eddOrLmpFieldKey {
    final eed = widget.userProfile['eed']?.toString().trim();
    if (eed != null && eed.isNotEmpty && eed != 'null') return 'eed';
    return 'lmp';
  }

  @override
  void initState() {
    super.initState();
    // Initialize controllers with user profile data
    firstNameController =
        TextEditingController(text: widget.userProfile['first_name']);
    lastNameController =
        TextEditingController(text: widget.userProfile['last_name']);
    phoneController = TextEditingController(text: widget.userProfile['phone_no']);
    eddController = TextEditingController(
        text: widget.userProfile["eed"] ?? widget.userProfile["lmp"]);

    emailController = TextEditingController(text: widget.userProfile['email']);
    if (firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        emailController.text.isNotEmpty) {
      isFirstNameValid = true;
      isLastNameValid = true;
      isPhoneValid = true;
      isEmailValid = true;
    }
  }

  Future<void> _selectDate(
    BuildContext context,
  ) async {
    widget.userProfile["eed"];
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate:
          // widget.userProfile["eed"] != null
          //     ? DateTime.now()
          //     :
          DateTime.now().subtract(const Duration(days: 280)),
      lastDate:
          // widget.userProfile["lmp"] != null
          //     ? DateTime.now()
          //     :
          DateTime.now().add(const Duration(days: 280)),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        eddController.text = DateFormat('yyyy-MM-dd').format(selectedDate!);
      });
    }
  }

  void validateFirstName(String value) {
    setState(() {
      isFirstNameValid = value.isNotEmpty;
    });
  }

  void validateLastName(String value) {
    setState(() {
      isLastNameValid = value.isNotEmpty;
    });
  }

  void validatePhone(String value) {
    setState(() {
      isPhoneValid = RegExp(r'^\d{10}$').hasMatch(value);
    });
  }

  void validateEmail(String value) {
    setState(() {
      isEmailValid = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value);
    });
  }

  void validatePassword(String value) {
    setState(() {
      isPasswordValid = value.length >= 6;
    });
  }

  // void validateConfirmPassword(String value) {
  //   setState(() {
  //     isConfirmPasswordValid = value == passwordController.text;
  //   });
  // }

  String? firstNameValidator(String? value, BuildContext? context) {
    validateFirstName(value ?? '');
    return isFirstNameValid ? null : 'First name is required';
  }

  String? lastNameValidator(String? value, BuildContext? context) {
    validateLastName(value ?? '');
    return isLastNameValid ? null : 'Last name is required';
  }

  String? phoneValidator(String? value, BuildContext? context) {
    validatePhone(value ?? '');
    return isPhoneValid ? null : 'Enter a valid phone number';
  }

  String? emailValidator(String? value, BuildContext? context) {
    validateEmail(value ?? '');
    return isEmailValid ? null : 'Enter a valid email address';
  }

  String? passwordValidator(String? value, BuildContext? context) {
    validatePassword(value ?? '');
    return isPasswordValid ? null : 'Password must be at least 6 characters';
  }

  // String? confirmPasswordValidator(String? value, BuildContext? context) {
  //   validateConfirmPassword(value ?? '');
  //   return isConfirmPasswordValid ? null : 'Passwords do not match';
  // }

  Future<void> _pickImage() async {
    widget.userProfile["profile_pic"] = null;
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final fileSize = await file.length();
      const maxSizeInBytes = 2048 * 1024; // 2048 kilobytes

      if (fileSize > maxSizeInBytes) {
        Fluttertoast.showToast(msg: "Profile pic must not be greater than 2MB.");
      } else {
        setState(() {
          _profileImage = file;
        });
      }
    }
  }

  Map<String, String> _profileFields() {
    final fields = <String, String>{
      'first_name': firstNameController.text,
      'last_name': lastNameController.text,
    };
    if (_eddOrLmpFieldKey != null) {
      fields[_eddOrLmpFieldKey!] = eddController.text;
    }
    return fields;
  }

  Future<void> _saveProfileWithoutImage() async {
    if (!await AuthService.hasSession()) return;

    try {
      setState(() => isLoading = true);
      final response = await ApiClient.postMultipart(
        ApiConfig.updateProfile,
        _profileFields(),
        authenticated: true,
      );
      Fluttertoast.showToast(
          msg: response['message']?.toString() ?? 'Profile updated');
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: ${e.toString()}');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _saveProfile() async {
    if (!await AuthService.hasSession()) return;

    try {
      setState(() => isLoading = true);
      final files = <http.MultipartFile>[];
      if (_profileImage != null) {
        files.add(
          await http.MultipartFile.fromPath('profile_pic', _profileImage!.path),
        );
      }

      final response = await ApiClient.postMultipart(
        ApiConfig.updateProfile,
        _profileFields(),
        files: files,
        authenticated: true,
      );
      Fluttertoast.showToast(
          msg: response['message']?.toString() ?? 'Profile updated');
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: ${e.toString()}');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: true,
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
          'Edit Profile',
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
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppImages.bg),
                fit: BoxFit.cover,
              ),
            ),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 110),
                    GestureDetector(
                        onTap: _pickImage,
                        child: widget.userProfile["profile_pic"] == null
                            ? CircleAvatar(
                                radius: 50,
                                backgroundColor: AppColors.secondaryTextColor,
                                backgroundImage: _profileImage != null
                                    ? FileImage(_profileImage!)
                                    : null,
                                child: _profileImage == null
                                    ? const Icon(Icons.add_a_photo,
                                        color: Colors.white, size: 50)
                                    : null,
                              )
                            : CircleAvatar(
                                radius: 50,
                                backgroundColor: AppColors.secondaryTextColor,
                                backgroundImage: NetworkImage(
                                  ApiConfig.storageUrl(
                                    widget.userProfile['profile_pic']?.toString(),
                                  ),
                                ),
                              )),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.only(left: 5),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'First Name',
                        style: GoogleFonts.poppins(
                          color: AppColors.blackColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    CustomTextField(
                      autoValidate: AutovalidateMode.onUserInteraction,
                      hintText: 'First Name',
                      controller: firstNameController,
                      textInputAction: TextInputAction.next,
                      borderColor: AppColors.secondaryTextColor,
                      inputType: CustomTextInputType.text,
                      validator: firstNameValidator,
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.only(left: 5),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Last Name',
                        style: GoogleFonts.poppins(
                          color: AppColors.blackColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    CustomTextField(
                      autoValidate: AutovalidateMode.onUserInteraction,
                      hintText: 'Last Name',
                      controller: lastNameController,
                      textInputAction: TextInputAction.next,
                      borderColor: AppColors.secondaryTextColor,
                      inputType: CustomTextInputType.text,
                      validator: lastNameValidator,
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.only(left: 5),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Phone No',
                        style: GoogleFonts.poppins(
                          color: AppColors.blackColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    CustomTextField(
                      autoValidate: AutovalidateMode.onUserInteraction,
                      hintText: 'Phone Number',
                      //enabled: false,
                      controller: phoneController,
                      readOnly: true,
                      backGroundColor: AppColors.greyTextColor,
                      textInputAction: TextInputAction.next,
                      borderColor: AppColors.secondaryTextColor,
                      inputType: CustomTextInputType.number,
                      validator: phoneValidator,
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.only(left: 5),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Email ID',
                        style: GoogleFonts.poppins(
                          color: AppColors.blackColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    CustomTextField(
                      autoValidate: AutovalidateMode.onUserInteraction,
                      hintText: 'Email',
                      controller: emailController,
                      textInputAction: TextInputAction.next,
                      borderColor: AppColors.secondaryTextColor,
                      inputType: CustomTextInputType.email,
                      validator: emailValidator,
                    ),
                    const SizedBox(height: 10),

                    Container(
                      padding: const EdgeInsets.only(left: 5),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'EDD or LMP',
                        style: GoogleFonts.poppins(
                          color: AppColors.blackColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    CustomTextField(
                      autoValidate: AutovalidateMode.disabled,
                      hintText: 'EDD or LMP',
                      onTap: _hasEddOrLmp
                          ? null
                          : () {
                              _selectDate(context);
                            },

                      controller: eddController,
                      // readOnly: !_hasEddOrLmp,
                      backGroundColor: _hasEddOrLmp ? AppColors.greyTextColor : null,
                      borderColor: AppColors.secondaryTextColor,
                      inputType: CustomTextInputType.text,
                    ),
                    const SizedBox(height: 6),
                    if (_hasEddOrLmp)
                      Text(
                        'Please reach out to Admin to change the Dates here!',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w500),
                      ),

                    const SizedBox(height: 15),
                    // CustomTextField(
                    //   autoValidate: AutovalidateMode.onUserInteraction,
                    //   hintText: 'Password',
                    //   controller: passwordController,
                    //   textInputAction: TextInputAction.next,
                    //   obscureText: true,
                    //   borderColor: AppColors.secondaryTextColor,
                    //   inputType: CustomTextInputType.password,
                    //   validator: passwordValidator,
                    // ),
                    // const SizedBox(height: 10),
                    // CustomTextField(
                    //   autoValidate: AutovalidateMode.onUserInteraction,
                    //   hintText: 'Confirm Password',
                    //   controller: confirmPasswordController,
                    //   textInputAction: TextInputAction.done,
                    //   obscureText: true,
                    //   borderColor: AppColors.secondaryTextColor,
                    //   inputType: CustomTextInputType.password,
                    //   validator: confirmPasswordValidator,
                    // ),
                    const SizedBox(height: 20),
                    CustomButton(
                      text: 'Save',
                      isEnabled: isFormValid,
                      borderColor: isFormValid
                          ? AppColors.primaryColor
                          : AppColors.secondaryTextColor.withValues(alpha: .5),
                      backgroundColor: isFormValid
                          ? AppColors.primaryColor
                          : AppColors.secondaryTextColor.withValues(alpha: .5),
                      textStyle: CustomLabels.body3GreyTextStyle(
                        fontSize: 16,
                        color: AppColors.whiteColor,
                      ),
                      onPressed: isFormValid
                          ? _profileImage == null
                              //&& widget.userProfile["profile_pic"] == null
                              ? _saveProfileWithoutImage
                              : _saveProfile
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.5),
                child: const Center(
                  child: SpinKitThreeInOut(
                    color: AppColors.primaryColor,
                    size: 40.0,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
