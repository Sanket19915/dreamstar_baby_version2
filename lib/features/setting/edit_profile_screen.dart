// edit_profile_screen.dart

import 'dart:convert';
import 'dart:io';

import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:dream_baby/shared/helper/app_images.dart';
import 'package:dream_baby/shared/helper/app_label.dart';
import 'package:dream_baby/shared/widget/custom_button.dart';
import 'package:dream_baby/shared/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../router/routes.dart';
import '../../services/auth_services.dart';

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userProfile;

  const EditProfileScreen({super.key, required this.userProfile});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
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

  bool get isFormValid {
    return isFirstNameValid && isLastNameValid && isPhoneValid && isEmailValid
        //  &&
        // isPasswordValid &&
        // isConfirmPasswordValid
        ;
  }

  @override
  void initState() {
    super.initState();
    // Initialize controllers with user profile data
    firstNameController =
        TextEditingController(text: widget.userProfile['first_name']);
    lastNameController =
        TextEditingController(text: widget.userProfile['last_name']);
    phoneController =
        TextEditingController(text: widget.userProfile['phone_no']);
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
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
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _profileImage = File(pickedFile.path);
      }
    });
  }

  Future<void> _saveProfile() async {
    try {
      setState(() {
        isLoading = true;
      });
      var token = await AuthService.getToken();
      var request = http.MultipartRequest(
          'POST', Uri.parse('http://dreambaby.pro/api/update-profile'))
        ..fields.addAll({
          'first_name': firstNameController.text,
          'last_name': lastNameController.text,
          'phone_no': phoneController.text,
          'email': emailController.text,
        })
        ..headers.addAll({
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        })
        ..files.add(await http.MultipartFile.fromPath(
            'profile_pic', _profileImage?.path ?? ""));
      var response = await request.send();
      var jsonData = await http.Response.fromStream(response);
      Map<String, dynamic>? finalResponse;
      if (response.statusCode == 200) {
        finalResponse = jsonDecode(jsonData.body) as Map<String, dynamic>;

        Fluttertoast.showToast(msg: finalResponse["message"]);
        context.go(Routes.home);
      } else {
        Fluttertoast.showToast(msg: "Something went wrong");
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
    // Handle save profile logic
    print('Profile saved');
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
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.secondaryTextColor,
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : null,
                        child: _profileImage == null
                            ? const Icon(Icons.add_a_photo,
                                color: Colors.white, size: 50)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 20),
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
                    CustomTextField(
                      autoValidate: AutovalidateMode.onUserInteraction,
                      hintText: 'Phone Number',
                      controller: phoneController,
                      textInputAction: TextInputAction.next,
                      borderColor: AppColors.secondaryTextColor,
                      inputType: CustomTextInputType.number,
                      validator: phoneValidator,
                    ),
                    const SizedBox(height: 10),
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
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: AbsorbPointer(
                        child: CustomTextField(
                          autoValidate: AutovalidateMode.disabled,
                          hintText:
                              'EDD or LMP', // Change as per your requirement
                          controller: TextEditingController(
                            text: selectedDate != null
                                ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                                : '2024-07-09',
                          ),
                          borderColor: AppColors.secondaryTextColor,
                          inputType: CustomTextInputType.text,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const SizedBox(height: 10),
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
                          : AppColors.secondaryTextColor.withOpacity(.5),
                      backgroundColor: isFormValid
                          ? AppColors.primaryColor
                          : AppColors.secondaryTextColor.withOpacity(.5),
                      textStyle: CustomLabels.body3GreyTextStyle(
                        fontSize: 16,
                        color: AppColors.whiteColor,
                      ),
                      onPressed: isFormValid ? _saveProfile : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
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
