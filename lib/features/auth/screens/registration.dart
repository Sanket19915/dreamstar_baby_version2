import 'dart:io';
import 'package:dream_baby/features/auth/screens/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:dream_baby/router/routes.dart';
import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dream_baby/shared/widget/custom_button.dart';
import 'package:dream_baby/shared/widget/custom_textfield.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  RegistrationScreenState createState() => RegistrationScreenState();
}

class RegistrationScreenState extends State<RegistrationScreen> {
  File? _image;
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  DateTime? _dob;
  DateTime? _dom;
  DateTime? _edd;

  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);

    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
      }
    });
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Registration successful!'), // Your success message
        duration: Duration(seconds: 2), // Adjust the duration as needed
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, DateTime? initialDate,
      Function(DateTime) onDateSelected) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      onDateSelected(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appPinkLight,
      appBar: AppBar(
        backgroundColor: AppColors.appPinkLight,
        title: RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: 'Dream',
                style: TextStyle(
                  color: Colors.black45, // Change this to your desired color
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(
                text: 'Baby',
                style: TextStyle(
                  color: Colors.pink, // Change this to your desired color
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Center(
                child: GestureDetector(
                  onTap: () => _showImagePicker(context),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _image != null ? FileImage(_image!) : null,
                    child:
                        _image == null ? const Icon(Icons.add_a_photo) : null,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Full Name',
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              CustomTextField(
                hintText: 'Enter Full Name',
                inputType: CustomTextInputType.text,
                controller: _fullNameController,
                textInputAction: TextInputAction.next,
                autoFocus: true,
                borderColor: AppColors.secondaryTextColor,
              ),
              const SizedBox(height: 20),
              const Text(
                'Email',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              CustomTextField(
                hintText: 'Enter Email',
                controller: _emailController,
                inputType: CustomTextInputType.email,
                textInputAction: TextInputAction.next,
                borderColor: AppColors.secondaryTextColor,
              ),
              const SizedBox(height: 20),
              const Text(
                'Phone Number',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              CustomTextField(
                hintText: 'Enter Phone Number',
                controller: _phoneController,
                inputType: CustomTextInputType.number,
                textInputAction: TextInputAction.next,
                borderColor: AppColors.secondaryTextColor,
              ),
              const SizedBox(height: 20),
              _buildDateField(
                labelText: 'Date of Birth',
                date: _dob,
                onTap: () => _selectDate(context, _dob, (date) {
                  setState(() {
                    _dob = date;
                  });
                }),
              ),
              const SizedBox(height: 20),
              _buildDateField(
                labelText: 'Date of Marriage',
                date: _dom,
                onTap: () => _selectDate(context, _dom, (date) {
                  setState(() {
                    _dom = date;
                  });
                }),
              ),
              const SizedBox(height: 20),
              _buildDateField(
                labelText: 'Expected Due Date',
                date: _edd,
                onTap: () => _selectDate(context, _edd, (date) {
                  setState(() {
                    _edd = date;
                  });
                }),
              ),
              const SizedBox(height: 20),
              const Text(
                'Password',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              CustomTextField(
                hintText: 'Enter Password',
                controller: _passwordController,
                inputType: CustomTextInputType.password,
                obscureText: true,
                textInputAction: TextInputAction.next,
                borderColor: AppColors.secondaryTextColor,
              ),
              const SizedBox(height: 20),
              const Text(
                'Confirm Password',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              CustomTextField(
                hintText: 'Confirm Password',
                controller: _confirmPasswordController,
                inputType: CustomTextInputType.password,
                textInputAction: TextInputAction.done,
                borderColor: AppColors.secondaryTextColor,
                obscureText: true,
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Register Now',
                onPressed: () {
                  _showSuccessMessage();
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: "Already have an account? ",
                    style: const TextStyle(color: Colors.black45),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Login here',
                        style: const TextStyle(
                          color: AppColors.primaryColor,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            context.go(Routes.login);
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showImagePicker(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Take a photo'),
                onTap: () {
                  _getImage(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
                onTap: () {
                  _getImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

Widget _buildDateField(
    {required String labelText, DateTime? date, required VoidCallback onTap}) {
  final dateFormat = DateFormat('yyyy-MM-dd');
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        labelText,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 10),
      TextFormField(
        readOnly: true,
        onTap: onTap,
        controller: date != null
            ? TextEditingController(text: dateFormat.format(date))
            : null,
        decoration: const InputDecoration(
          hintText: 'Select Date',
          suffixIcon: Icon(Icons.calendar_today),
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
      ),
    ],
  );
}
